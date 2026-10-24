"""
app.py  –  Flask web app Quản lý Bán hàng
pip install flask mysql-connector-python
"""

from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector
from mysql.connector import Error
from functools import wraps

app = Flask(__name__)
app.secret_key = "quanlybanhang_secret_2025"
app.jinja_env.globals["enumerate"] = enumerate

DB_CONFIG = {
    "host":     "localhost",
    "user":     "app_user",
    "password": "App@123456",
    "database": "QuanLyBanHang",
    "charset":  "utf8mb4",
}

def get_db():
    return mysql.connector.connect(**DB_CONFIG)

def query(sql, params=(), one=False, commit=False):
    conn = get_db()
    cur = conn.cursor(dictionary=True)
    cur.execute(sql, params)
    if commit:
        conn.commit()
        result = cur.lastrowid
    else:
        result = cur.fetchone() if one else cur.fetchall()
    cur.close(); conn.close()
    return result

# ── Auth helpers ────────────────────────────────────────────
def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if not session.get("nv_id"):
            return redirect(url_for("login"))
        return f(*args, **kwargs)
    return decorated

def role_required(*roles):
    """Chỉ cho phép các chức vụ trong danh sách roles."""
    def decorator(f):
        @wraps(f)
        def decorated(*args, **kwargs):
            if not session.get("nv_id"):
                return redirect(url_for("login"))
            if session.get("nv_chuc") not in roles:
                flash("Bạn không có quyền thực hiện thao tác này!", "danger")
                return redirect(url_for("index"))
            return f(*args, **kwargs)
        return decorated
    return decorator

# ── Đăng nhập ────────────────────────────────────────────────
@app.route("/login", methods=["GET", "POST"])
def login():
    if session.get("nv_id"):
        return redirect(url_for("index"))
    error = None
    if request.method == "POST":
        sdt = request.form.get("soDienThoai", "").strip()
        pw  = request.form.get("matKhau", "").strip()
        nv  = query("SELECT * FROM NhanVien WHERE soDienThoai=%s", (sdt,), one=True)
        if nv and pw == nv["matKhau"]:
            session["nv_id"]   = nv["maNV"]
            session["nv_ten"]  = nv["hoTen"]
            session["nv_chuc"] = nv["chucVu"]
            return redirect(url_for("index"))
        error = "Số điện thoại hoặc mật khẩu không đúng."
    return render_template("login.html", error=error)

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))

# ── Dashboard ────────────────────────────────────────────────
@app.route("/")
@login_required
def index():
    so_kh  = query("SELECT COUNT(*) AS n FROM KhachHang", one=True)["n"]
    so_sp  = query("SELECT COUNT(*) AS n FROM SanPham", one=True)["n"]
    so_hd  = query("SELECT COUNT(*) AS n FROM HoaDon", one=True)["n"]
    doanh_thu = query("""
        SELECT COALESCE(SUM(ct.soLuong*ct.donGia*(1-ct.giamGia/100)),0) AS dt
        FROM HoaDon hd JOIN ChiTietHoaDon ct ON hd.maHD=ct.maHD
        WHERE hd.trangThai='Hoàn thành'""", one=True)["dt"]
    top_sp = query("""
        SELECT sp.tenSanPham, SUM(ct.soLuong) AS tong
        FROM ChiTietHoaDon ct
        JOIN SanPham sp ON ct.maSanPham=sp.maSanPham
        JOIN HoaDon  hd ON ct.maHD=hd.maHD
        WHERE hd.trangThai='Hoàn thành'
        GROUP BY sp.maSanPham, sp.tenSanPham
        ORDER BY tong DESC LIMIT 5""")
    return render_template("index.html",
        so_kh=so_kh, so_sp=so_sp, so_hd=so_hd,
        doanh_thu=doanh_thu, top_sp=top_sp)

# ── Khách hàng ───────────────────────────────────────────────
@app.route("/khachhang")
@login_required
def khachhang():
    kw = request.args.get("q", "")
    if kw:
        rows = query("""SELECT * FROM KhachHang
                        WHERE hoTen LIKE %s OR soDienThoai LIKE %s
                        ORDER BY hoTen""", (f"%{kw}%", f"%{kw}%"))
    else:
        rows = query("SELECT * FROM KhachHang ORDER BY maKH DESC")
    return render_template("khachhang.html", rows=rows, kw=kw)

@app.route("/khachhang/them", methods=["POST"])
@login_required
def them_kh():
    try:
        query("INSERT INTO KhachHang (hoTen,soDienThoai,email,diaChi) VALUES (%s,%s,%s,%s)",
              (request.form["hoTen"], request.form["soDienThoai"],
               request.form.get("email") or None, request.form.get("diaChi") or None),
              commit=True)
        flash("Đã thêm khách hàng!", "success")
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
    return redirect(url_for("khachhang"))

@app.route("/khachhang/sua/<int:id>", methods=["POST"])
@login_required
def sua_kh(id):
    try:
        query("UPDATE KhachHang SET hoTen=%s,soDienThoai=%s,email=%s,diaChi=%s WHERE maKH=%s",
              (request.form["hoTen"], request.form["soDienThoai"],
               request.form.get("email") or None, request.form.get("diaChi") or None, id),
              commit=True)
        flash("Đã cập nhật khách hàng!", "success")
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
    return redirect(url_for("khachhang"))

@app.route("/khachhang/xoa/<int:id>")
@login_required
def xoa_kh(id):
    if query("SELECT COUNT(*) AS n FROM HoaDon WHERE maKH=%s", (id,), one=True)["n"] > 0:
        flash("Không thể xóa: khách hàng đã có hóa đơn!", "danger")
    else:
        query("DELETE FROM KhachHang WHERE maKH=%s", (id,), commit=True)
        flash("Đã xóa khách hàng.", "success")
    return redirect(url_for("khachhang"))

# ── Sản phẩm ────────────────────────────────────────────────
@app.route("/sanpham")
@login_required
def sanpham():
    kw = request.args.get("q", "")
    sql_base = """SELECT sp.*, dm.tenDanhMuc, ncc.tenNCC
                  FROM SanPham sp
                  JOIN DanhMuc dm ON sp.maDanhMuc=dm.maDanhMuc
                  JOIN NhaCungCap ncc ON sp.maNCC=ncc.maNCC"""
    rows = query(sql_base + " WHERE sp.tenSanPham LIKE %s ORDER BY sp.maSanPham DESC",
                 (f"%{kw}%",)) if kw else query(sql_base + " ORDER BY sp.maSanPham DESC")
    danhmucs = query("SELECT * FROM DanhMuc ORDER BY tenDanhMuc")
    nccs     = query("SELECT * FROM NhaCungCap ORDER BY tenNCC")
    return render_template("sanpham.html", rows=rows, danhmucs=danhmucs, nccs=nccs, kw=kw)

@app.route("/sanpham/them", methods=["POST"])
@role_required("Quản lý")
def them_sp():
    try:
        query("""INSERT INTO SanPham (tenSanPham,maDanhMuc,maNCC,giaBan,soLuongTon,donVi)
                 VALUES (%s,%s,%s,%s,%s,%s)""",
              (request.form["tenSanPham"], request.form["maDanhMuc"], request.form["maNCC"],
               request.form["giaBan"], request.form["soLuongTon"],
               request.form.get("donVi") or "cái"), commit=True)
        flash("Đã thêm sản phẩm!", "success")
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
    return redirect(url_for("sanpham"))

@app.route("/sanpham/sua/<int:id>", methods=["POST"])
@role_required("Quản lý")
def sua_sp(id):
    try:
        query("""UPDATE SanPham SET tenSanPham=%s,maDanhMuc=%s,maNCC=%s,
                 giaBan=%s,soLuongTon=%s,donVi=%s WHERE maSanPham=%s""",
              (request.form["tenSanPham"], request.form["maDanhMuc"], request.form["maNCC"],
               request.form["giaBan"], request.form["soLuongTon"],
               request.form.get("donVi") or "cái", id), commit=True)
        flash("Đã cập nhật sản phẩm!", "success")
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
    return redirect(url_for("sanpham"))

@app.route("/sanpham/xoa/<int:id>")
@role_required("Quản lý")
def xoa_sp(id):
    if query("SELECT COUNT(*) AS n FROM ChiTietHoaDon WHERE maSanPham=%s", (id,), one=True)["n"] > 0:
        flash("Không thể xóa: sản phẩm đã có trong hóa đơn!", "danger")
    else:
        query("DELETE FROM SanPham WHERE maSanPham=%s", (id,), commit=True)
        flash("Đã xóa sản phẩm.", "success")
    return redirect(url_for("sanpham"))

# ── Hóa đơn ─────────────────────────────────────────────────
@app.route("/hoadon")
@login_required
def hoadon():
    # Fix GROUP BY: dùng subquery tính tongTien trước rồi JOIN
    rows = query("""
        SELECT hd.maHD, hd.ngayLap, hd.trangThai,
               kh.hoTen AS tenKH, nv.hoTen AS tenNV,
               COALESCE(t.tongTien, 0) AS tongTien
        FROM HoaDon hd
        JOIN KhachHang kh ON hd.maKH=kh.maKH
        JOIN NhanVien  nv ON hd.maNV=nv.maNV
        LEFT JOIN (
            SELECT maHD, SUM(soLuong*donGia*(1-giamGia/100)) AS tongTien
            FROM ChiTietHoaDon GROUP BY maHD
        ) t ON hd.maHD=t.maHD
        ORDER BY hd.ngayLap DESC""")
    khachhangs = query("SELECT maKH, hoTen, soDienThoai FROM KhachHang ORDER BY hoTen")
    nhanviens  = query("SELECT maNV, hoTen FROM NhanVien ORDER BY hoTen")
    return render_template("hoadon.html", rows=rows,
                           khachhangs=khachhangs, nhanviens=nhanviens)

@app.route("/hoadon/tao", methods=["POST"])
@login_required
def tao_hd():
    """Tạo hóa đơn mới (chưa có sản phẩm), chuyển sang trang thêm sản phẩm."""
    try:
        ma_kh = request.form["maKH"]
        ma_nv = session["nv_id"]
        ghi_chu = request.form.get("ghiChu") or None
        new_id = query(
            "INSERT INTO HoaDon (maKH,maNV,ghiChu) VALUES (%s,%s,%s)",
            (ma_kh, ma_nv, ghi_chu), commit=True)
        flash("Đã tạo hóa đơn! Thêm sản phẩm vào hóa đơn.", "success")
        return redirect(url_for("chi_tiet_hd", id=new_id))
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
        return redirect(url_for("hoadon"))

@app.route("/hoadon/<int:id>")
@login_required
def chi_tiet_hd(id):
    hd = query("""SELECT hd.*, kh.hoTen AS tenKH, kh.soDienThoai, nv.hoTen AS tenNV
                  FROM HoaDon hd
                  JOIN KhachHang kh ON hd.maKH=kh.maKH
                  JOIN NhanVien  nv ON hd.maNV=nv.maNV
                  WHERE hd.maHD=%s""", (id,), one=True)
    ct = query("""SELECT ct.*, sp.tenSanPham,
                  ROUND(ct.soLuong*ct.donGia*(1-ct.giamGia/100),0) AS thanhTien
                  FROM ChiTietHoaDon ct
                  JOIN SanPham sp ON ct.maSanPham=sp.maSanPham
                  WHERE ct.maHD=%s""", (id,))
    tong = sum(r["thanhTien"] for r in ct)
    sanphams = query("""SELECT maSanPham, tenSanPham, giaBan, soLuongTon, donVi
                        FROM SanPham WHERE soLuongTon > 0 ORDER BY tenSanPham""")
    return render_template("chitiet_hd.html", hd=hd, ct=ct, tong=tong, sanphams=sanphams)

@app.route("/hoadon/<int:id>/them-sp", methods=["POST"])
@login_required
def them_sp_vao_hd(id):
    """Thêm sản phẩm vào hóa đơn."""
    try:
        ma_sp   = int(request.form["maSanPham"])
        so_luong = int(request.form["soLuong"])
        giam_gia = float(request.form.get("giamGia") or 0)
        # Lấy giá hiện tại của sản phẩm
        sp = query("SELECT giaBan, soLuongTon FROM SanPham WHERE maSanPham=%s",
                   (ma_sp,), one=True)
        if not sp:
            flash("Sản phẩm không tồn tại!", "danger")
            return redirect(url_for("chi_tiet_hd", id=id))
        if sp["soLuongTon"] < so_luong:
            flash(f"Tồn kho không đủ! Còn {sp['soLuongTon']} sản phẩm.", "danger")
            return redirect(url_for("chi_tiet_hd", id=id))
        # Nếu SP đã có trong HĐ thì cập nhật, chưa có thì thêm mới
        existing = query("SELECT * FROM ChiTietHoaDon WHERE maHD=%s AND maSanPham=%s",
                         (id, ma_sp), one=True)
        if existing:
            query("""UPDATE ChiTietHoaDon SET soLuong=soLuong+%s WHERE maHD=%s AND maSanPham=%s""",
                  (so_luong, id, ma_sp), commit=True)
        else:
            query("""INSERT INTO ChiTietHoaDon (maHD,maSanPham,soLuong,donGia,giamGia)
                     VALUES (%s,%s,%s,%s,%s)""",
                  (id, ma_sp, so_luong, sp["giaBan"], giam_gia), commit=True)
        flash("Đã thêm sản phẩm vào hóa đơn!", "success")
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
    return redirect(url_for("chi_tiet_hd", id=id))

@app.route("/hoadon/<int:id>/xoa-sp/<int:sp_id>")
@login_required
def xoa_sp_khoi_hd(id, sp_id):
    query("DELETE FROM ChiTietHoaDon WHERE maHD=%s AND maSanPham=%s",
          (id, sp_id), commit=True)
    flash("Đã xóa sản phẩm khỏi hóa đơn.", "success")
    return redirect(url_for("chi_tiet_hd", id=id))

@app.route("/hoadon/capnhat/<int:id>", methods=["POST"])
@login_required
def capnhat_hd(id):
    query("UPDATE HoaDon SET trangThai=%s WHERE maHD=%s",
          (request.form["trangThai"], id), commit=True)
    flash("Đã cập nhật trạng thái!", "success")
    return redirect(url_for("chi_tiet_hd", id=id))

# ── Nhân viên ────────────────────────────────────────────────
@app.route("/nhanvien")
@role_required("Quản lý")
def nhanvien():

    rows = query("SELECT * FROM NhanVien ORDER BY maNV DESC")
    return render_template("nhanvien.html", rows=rows)

@app.route("/nhanvien/them", methods=["POST"])
@role_required("Quản lý")
def them_nv():
    try:
        mat_khau = request.form.get("matKhau") or request.form["soDienThoai"]
        query("""INSERT INTO NhanVien (hoTen,chucVu,soDienThoai,email,matKhau,ngayVaoLam)
                 VALUES (%s,%s,%s,%s,%s,%s)""",
              (request.form["hoTen"], request.form.get("chucVu") or "Nhân viên",
               request.form["soDienThoai"], request.form.get("email") or None,
               mat_khau, request.form["ngayVaoLam"]), commit=True)
        flash("Đã thêm nhân viên!", "success")
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
    return redirect(url_for("nhanvien"))

@app.route("/nhanvien/sua/<int:id>", methods=["POST"])
@role_required("Quản lý")
def sua_nv(id):
    try:
        query("""UPDATE NhanVien SET hoTen=%s,chucVu=%s,soDienThoai=%s,
                 email=%s,ngayVaoLam=%s WHERE maNV=%s""",
              (request.form["hoTen"], request.form.get("chucVu") or "Nhân viên",
               request.form["soDienThoai"], request.form.get("email") or None,
               request.form["ngayVaoLam"], id), commit=True)
        flash("Đã cập nhật nhân viên!", "success")
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
    return redirect(url_for("nhanvien"))

@app.route("/nhanvien/doi-mat-khau/<int:id>", methods=["POST"])
@role_required("Quản lý")
def doi_mat_khau(id):
    mk_moi = request.form.get("matKhauMoi", "").strip()
    if len(mk_moi) < 6:
        flash("Mật khẩu phải có ít nhất 6 ký tự!", "danger")
    else:
        query("UPDATE NhanVien SET matKhau=%s WHERE maNV=%s", (mk_moi, id), commit=True)
        flash("Đã đổi mật khẩu thành công!", "success")
    return redirect(url_for("nhanvien"))

@app.route("/nhanvien/xoa/<int:id>")
@role_required("Quản lý")
def xoa_nv(id):
    if query("SELECT COUNT(*) AS n FROM HoaDon WHERE maNV=%s", (id,), one=True)["n"] > 0:
        flash("Không thể xóa: nhân viên đã có hóa đơn!", "danger")
    else:
        query("DELETE FROM NhanVien WHERE maNV=%s", (id,), commit=True)
        flash("Đã xóa nhân viên.", "success")
    return redirect(url_for("nhanvien"))

# ── Nhà cung cấp ─────────────────────────────────────────────
@app.route("/nhacungcap")
@login_required
def nhacungcap():
    rows = query("""SELECT ncc.*, COUNT(sp.maSanPham) AS soSanPham
                    FROM NhaCungCap ncc
                    LEFT JOIN SanPham sp ON ncc.maNCC=sp.maNCC
                    GROUP BY ncc.maNCC, ncc.tenNCC, ncc.diaChi, ncc.soDienThoai, ncc.email
                    ORDER BY ncc.maNCC DESC""")
    return render_template("nhacungcap.html", rows=rows)

@app.route("/nhacungcap/them", methods=["POST"])
@role_required("Quản lý")
def them_ncc():
    try:
        query("INSERT INTO NhaCungCap (tenNCC,diaChi,soDienThoai,email) VALUES (%s,%s,%s,%s)",
              (request.form["tenNCC"], request.form.get("diaChi") or None,
               request.form["soDienThoai"], request.form.get("email") or None), commit=True)
        flash("Đã thêm nhà cung cấp!", "success")
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
    return redirect(url_for("nhacungcap"))

@app.route("/nhacungcap/sua/<int:id>", methods=["POST"])
@role_required("Quản lý")
def sua_ncc(id):
    try:
        query("""UPDATE NhaCungCap SET tenNCC=%s,diaChi=%s,soDienThoai=%s,email=%s
                 WHERE maNCC=%s""",
              (request.form["tenNCC"], request.form.get("diaChi") or None,
               request.form["soDienThoai"], request.form.get("email") or None, id), commit=True)
        flash("Đã cập nhật nhà cung cấp!", "success")
    except Error as e:
        flash(f"Lỗi: {e.msg}", "danger")
    return redirect(url_for("nhacungcap"))

@app.route("/nhacungcap/xoa/<int:id>")
@role_required("Quản lý")
def xoa_ncc(id):
    if query("SELECT COUNT(*) AS n FROM SanPham WHERE maNCC=%s", (id,), one=True)["n"] > 0:
        flash("Không thể xóa: nhà cung cấp đang cung cấp sản phẩm!", "danger")
    else:
        query("DELETE FROM NhaCungCap WHERE maNCC=%s", (id,), commit=True)
        flash("Đã xóa nhà cung cấp.", "success")
    return redirect(url_for("nhacungcap"))

# ── Báo cáo ──────────────────────────────────────────────────
@app.route("/baocao")
@role_required("Quản lý", "Kế toán")
def baocao():
    dt_thang = query("""
        SELECT DATE_FORMAT(hd.ngayLap,'%m/%Y') AS thang,
               SUM(ct.soLuong*ct.donGia*(1-ct.giamGia/100)) AS doanhThu
        FROM HoaDon hd JOIN ChiTietHoaDon ct ON hd.maHD=ct.maHD
        WHERE hd.trangThai='Hoàn thành'
          AND hd.ngayLap >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
        GROUP BY DATE_FORMAT(hd.ngayLap,'%Y-%m'), DATE_FORMAT(hd.ngayLap,'%m/%Y')
        ORDER BY DATE_FORMAT(hd.ngayLap,'%Y-%m')""")
    dt_nv = query("""
        SELECT nv.hoTen, COUNT(DISTINCT hd.maHD) AS soHD,
               SUM(ct.soLuong*ct.donGia*(1-ct.giamGia/100)) AS doanhThu
        FROM NhanVien nv
        JOIN HoaDon hd ON nv.maNV=hd.maNV
        JOIN ChiTietHoaDon ct ON hd.maHD=ct.maHD
        WHERE hd.trangThai='Hoàn thành'
        GROUP BY nv.maNV, nv.hoTen ORDER BY doanhThu DESC LIMIT 10""")
    dt_dm = query("""
        SELECT dm.tenDanhMuc,
               SUM(ct.soLuong*ct.donGia*(1-ct.giamGia/100)) AS doanhThu
        FROM DanhMuc dm
        JOIN SanPham sp ON dm.maDanhMuc=sp.maDanhMuc
        JOIN ChiTietHoaDon ct ON sp.maSanPham=ct.maSanPham
        JOIN HoaDon hd ON ct.maHD=hd.maHD
        WHERE hd.trangThai='Hoàn thành'
        GROUP BY dm.maDanhMuc, dm.tenDanhMuc ORDER BY doanhThu DESC""")
    top_kh = query("""
        SELECT kh.hoTen, kh.soDienThoai,
               COUNT(DISTINCT hd.maHD) AS soHD,
               SUM(ct.soLuong*ct.donGia*(1-ct.giamGia/100)) AS tongChiTieu
        FROM KhachHang kh
        JOIN HoaDon hd ON kh.maKH=hd.maKH
        JOIN ChiTietHoaDon ct ON hd.maHD=ct.maHD
        WHERE hd.trangThai='Hoàn thành'
        GROUP BY kh.maKH, kh.hoTen, kh.soDienThoai
        ORDER BY tongChiTieu DESC LIMIT 10""")
    max_dt = max((r["doanhThu"] for r in dt_dm), default=1)
    max_nv = max((r["doanhThu"] for r in dt_nv), default=1)
    return render_template("baocao.html",
        dt_thang=dt_thang, dt_nv=dt_nv, dt_dm=dt_dm,
        top_kh=top_kh, max_dt=max_dt, max_nv=max_nv)

if __name__ == "__main__":
    app.run(debug=True, port=5000)
