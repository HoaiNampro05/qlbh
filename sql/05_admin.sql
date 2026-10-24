-- ============================================================
-- 05_admin.sql  –  Phân quyền, Index, Transaction
-- ============================================================

USE QuanLyBanHang;

-- ---- Index ---------------------------------------------------
-- Tăng tốc tìm kiếm hóa đơn theo khách hàng và ngày lập
CREATE INDEX idx_hoadon_makh    ON HoaDon(maKH);
CREATE INDEX idx_hoadon_ngaylap ON HoaDon(ngayLap);
-- Tìm sản phẩm theo danh mục
CREATE INDEX idx_sanpham_danhmuc ON SanPham(maDanhMuc);
-- Tìm khách hàng theo số điện thoại (đã UNIQUE nhưng thêm để rõ ràng)
CREATE INDEX idx_khachhang_sdt   ON KhachHang(soDienThoai);

-- ---- Phân quyền ---------------------------------------------
-- Tạo user cho ứng dụng (chỉ đọc/ghi dữ liệu, không thay đổi schema)
CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY 'App@123456';
GRANT SELECT, INSERT, UPDATE, DELETE ON QuanLyBanHang.* TO 'app_user'@'localhost';

-- Tạo user báo cáo (chỉ đọc)
CREATE USER IF NOT EXISTS 'report_user'@'localhost' IDENTIFIED BY 'Report@123456';
GRANT SELECT ON QuanLyBanHang.* TO 'report_user'@'localhost';

FLUSH PRIVILEGES;

-- ---- Ví dụ Transaction: Tạo hóa đơn mới an toàn ------------
/*
START TRANSACTION;

INSERT INTO HoaDon (maKH, maNV, trangThai)
VALUES (1, 2, 'Chờ xử lý');

SET @newHD = LAST_INSERT_ID();

INSERT INTO ChiTietHoaDon (maHD, maSanPham, soLuong, donGia, giamGia)
VALUES (@newHD, 1, 1, 33990000, 0);

-- Kiểm tra tồn kho sau khi trigger chạy
SELECT soLuongTon FROM SanPham WHERE maSanPham = 1;

COMMIT;
-- Nếu có lỗi: ROLLBACK;
*/
