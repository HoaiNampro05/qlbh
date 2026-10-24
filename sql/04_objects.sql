-- ============================================================
-- 04_objects.sql  –  View, Stored Procedure, Trigger
-- ============================================================

USE QuanLyBanHang;

-- ============================================================
-- VIEW 1: Tổng hợp hóa đơn (maHD, khách, nhân viên, tổng tiền)
-- ============================================================
CREATE OR REPLACE VIEW v_TongHopHoaDon AS
SELECT hd.maHD,
       hd.ngayLap,
       kh.hoTen                                                          AS tenKhachHang,
       kh.soDienThoai                                                    AS sdtKhachHang,
       nv.hoTen                                                          AS tenNhanVien,
       hd.trangThai,
       COUNT(ct.maSanPham)                                               AS soSanPham,
       SUM(ct.soLuong * ct.donGia * (1 - ct.giamGia / 100))             AS tongTien
FROM HoaDon hd
JOIN KhachHang     kh ON hd.maKH     = kh.maKH
JOIN NhanVien      nv ON hd.maNV     = nv.maNV
JOIN ChiTietHoaDon ct ON hd.maHD     = ct.maHD
GROUP BY hd.maHD, hd.ngayLap, kh.hoTen, kh.soDienThoai, nv.hoTen, hd.trangThai;

-- ============================================================
-- VIEW 2: Thống kê tồn kho theo danh mục
-- ============================================================
CREATE OR REPLACE VIEW v_TonKhoTheoDanhMuc AS
SELECT dm.maDanhMuc,
       dm.tenDanhMuc,
       COUNT(sp.maSanPham)   AS soLoaiSanPham,
       SUM(sp.soLuongTon)    AS tongTonKho,
       MIN(sp.giaBan)        AS giaNhoNhat,
       MAX(sp.giaBan)        AS giaCaoNhat,
       AVG(sp.giaBan)        AS giaTrungBinh
FROM DanhMuc dm
LEFT JOIN SanPham sp ON dm.maDanhMuc = sp.maDanhMuc
GROUP BY dm.maDanhMuc, dm.tenDanhMuc;

-- ============================================================
-- STORED PROCEDURE: Lấy lịch sử mua hàng của khách
-- ============================================================
DELIMITER $$

CREATE PROCEDURE sp_LichSuMuaHang(IN p_maKH INT)
BEGIN
    SELECT hd.maHD,
           hd.ngayLap,
           sp.tenSanPham,
           ct.soLuong,
           ct.donGia,
           ct.giamGia,
           ROUND(ct.soLuong * ct.donGia * (1 - ct.giamGia / 100), 0) AS thanhTien,
           hd.trangThai
    FROM HoaDon hd
    JOIN ChiTietHoaDon ct ON hd.maHD     = ct.maHD
    JOIN SanPham       sp ON ct.maSanPham = sp.maSanPham
    WHERE hd.maKH = p_maKH
    ORDER BY hd.ngayLap DESC;
END$$

DELIMITER ;

-- ============================================================
-- TRIGGER: Cập nhật tồn kho khi thêm chi tiết hóa đơn
-- ============================================================
DELIMITER $$

CREATE TRIGGER trg_CapNhatTonKho
AFTER INSERT ON ChiTietHoaDon
FOR EACH ROW
BEGIN
    UPDATE SanPham
    SET soLuongTon = soLuongTon - NEW.soLuong
    WHERE maSanPham = NEW.maSanPham;
END$$

DELIMITER ;
