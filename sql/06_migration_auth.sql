-- ============================================================
-- 06_migration_auth.sql  –  Thêm cột matKhau vào NhanVien
-- Chạy file này sau khi đã chạy 01-05
-- ============================================================

USE QuanLyBanHang;
UPDATE NhanVien SET matKhau = soDienThoai WHERE ID>=1;
