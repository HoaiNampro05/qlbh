-- ============================================================
-- 03_queries.sql  –  10 câu truy vấn nghiệp vụ
-- ============================================================

USE QuanLyBanHang;

-- Q1: Danh sách hóa đơn kèm tên khách hàng và nhân viên (JOIN)
SELECT hd.maHD,
       kh.hoTen      AS khachHang,
       nv.hoTen      AS nhanVien,
       hd.ngayLap,
       hd.trangThai
FROM HoaDon hd
JOIN KhachHang kh ON hd.maKH = kh.maKH
JOIN NhanVien  nv ON hd.maNV = nv.maNV
ORDER BY hd.ngayLap DESC;

-- Q2: Doanh thu theo từng tháng (GROUP BY)
SELECT YEAR(hd.ngayLap)  AS nam,
       MONTH(hd.ngayLap) AS thang,
       SUM(ct.soLuong * ct.donGia * (1 - ct.giamGia / 100)) AS doanhThu
FROM HoaDon hd
JOIN ChiTietHoaDon ct ON hd.maHD = ct.maHD
WHERE hd.trangThai = 'Hoàn thành'
GROUP BY nam, thang
ORDER BY nam, thang;

-- Q3: Top 5 sản phẩm bán chạy nhất (GROUP BY + HAVING + JOIN)
SELECT sp.maSanPham,
       sp.tenSanPham,
       SUM(ct.soLuong) AS tongSoLuongBan
FROM ChiTietHoaDon ct
JOIN SanPham sp ON ct.maSanPham = sp.maSanPham
JOIN HoaDon  hd ON ct.maHD = hd.maHD
WHERE hd.trangThai = 'Hoàn thành'
GROUP BY sp.maSanPham, sp.tenSanPham
HAVING tongSoLuongBan > 0
ORDER BY tongSoLuongBan DESC
LIMIT 5;

-- Q4: Doanh thu theo từng nhân viên (GROUP BY + JOIN)
SELECT nv.maNV,
       nv.hoTen,
       COUNT(DISTINCT hd.maHD) AS soHoaDon,
       SUM(ct.soLuong * ct.donGia * (1 - ct.giamGia / 100)) AS doanhThu
FROM NhanVien nv
JOIN HoaDon         hd ON nv.maNV  = hd.maNV
JOIN ChiTietHoaDon  ct ON hd.maHD  = ct.maHD
WHERE hd.trangThai = 'Hoàn thành'
GROUP BY nv.maNV, nv.hoTen
ORDER BY doanhThu DESC;

-- Q5: Khách hàng chưa từng mua hàng (truy vấn con NOT IN)
SELECT maKH, hoTen, soDienThoai
FROM KhachHang
WHERE maKH NOT IN (
    SELECT DISTINCT maKH FROM HoaDon
);

-- Q6: Sản phẩm có tồn kho dưới mức trung bình (truy vấn con)
SELECT maSanPham, tenSanPham, soLuongTon
FROM SanPham
WHERE soLuongTon < (SELECT AVG(soLuongTon) FROM SanPham)
ORDER BY soLuongTon;

-- Q7: Chi tiết từng hóa đơn kèm thành tiền (JOIN nhiều bảng)
SELECT hd.maHD,
       kh.hoTen        AS khachHang,
       sp.tenSanPham,
       ct.soLuong,
       ct.donGia,
       ct.giamGia,
       ROUND(ct.soLuong * ct.donGia * (1 - ct.giamGia / 100), 0) AS thanhTien
FROM HoaDon hd
JOIN KhachHang     kh ON hd.maKH     = kh.maKH
JOIN ChiTietHoaDon ct ON hd.maHD     = ct.maHD
JOIN SanPham       sp ON ct.maSanPham = sp.maSanPham
ORDER BY hd.maHD;

-- Q8: Doanh thu theo danh mục sản phẩm (GROUP BY + HAVING)
SELECT dm.tenDanhMuc,
       SUM(ct.soLuong * ct.donGia * (1 - ct.giamGia / 100)) AS doanhThu
FROM DanhMuc dm
JOIN SanPham        sp ON dm.maDanhMuc  = sp.maDanhMuc
JOIN ChiTietHoaDon  ct ON sp.maSanPham  = ct.maSanPham
JOIN HoaDon         hd ON ct.maHD       = hd.maHD
WHERE hd.trangThai = 'Hoàn thành'
GROUP BY dm.tenDanhMuc
HAVING doanhThu > 0
ORDER BY doanhThu DESC;

-- Q9: Khách hàng có tổng chi tiêu cao nhất (truy vấn con + JOIN)
SELECT kh.hoTen,
       kh.soDienThoai,
       tongTien.tongChiTieu
FROM KhachHang kh
JOIN (
    SELECT hd.maKH,
           SUM(ct.soLuong * ct.donGia * (1 - ct.giamGia / 100)) AS tongChiTieu
    FROM HoaDon hd
    JOIN ChiTietHoaDon ct ON hd.maHD = ct.maHD
    WHERE hd.trangThai = 'Hoàn thành'
    GROUP BY hd.maKH
) tongTien ON kh.maKH = tongTien.maKH
ORDER BY tongTien.tongChiTieu DESC
LIMIT 10;

-- Q10: Hóa đơn có giá trị lớn hơn giá trị trung bình tất cả hóa đơn (truy vấn con)
SELECT hd.maHD,
       kh.hoTen AS khachHang,
       hd.ngayLap,
       SUM(ct.soLuong * ct.donGia * (1 - ct.giamGia / 100)) AS tongTien
FROM HoaDon hd
JOIN KhachHang     kh ON hd.maKH     = kh.maKH
JOIN ChiTietHoaDon ct ON hd.maHD     = ct.maHD
WHERE hd.trangThai = 'Hoàn thành'
GROUP BY hd.maHD, kh.hoTen, hd.ngayLap
HAVING tongTien > (
    SELECT AVG(giatri)
    FROM (
        SELECT hd2.maHD,
               SUM(ct2.soLuong * ct2.donGia * (1 - ct2.giamGia / 100)) AS giatri
        FROM HoaDon hd2
        JOIN ChiTietHoaDon ct2 ON hd2.maHD = ct2.maHD
        WHERE hd2.trangThai = 'Hoàn thành'
        GROUP BY hd2.maHD
    ) sub
)
ORDER BY tongTien DESC;
