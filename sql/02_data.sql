-- ============================================================
-- 02_data.sql  –  Dữ liệu mẫu (~20-30 bản ghi mỗi bảng)
-- ============================================================

USE QuanLyBanHang;

-- ---- DanhMuc (8 bản ghi) ------------------------------------
INSERT INTO DanhMuc (tenDanhMuc, moTa) VALUES
('Điện thoại',      'Điện thoại di động các loại'),
('Máy tính',        'Laptop, PC, máy tính bảng'),
('Phụ kiện',        'Tai nghe, sạc, cáp, ốp lưng'),
('Màn hình',        'Màn hình máy tính'),
('Thiết bị mạng',   'Router, switch, modem'),
('Âm thanh',        'Loa, tai nghe cao cấp'),
('Máy ảnh',         'Máy ảnh DSLR, mirrorless, action cam'),
('Đồng hồ thông minh', 'Smartwatch, vòng đeo tay thông minh');

-- ---- NhaCungCap (10 bản ghi) --------------------------------
INSERT INTO NhaCungCap (tenNCC, diaChi, soDienThoai, email) VALUES
('Apple Vietnam',        'Tầng 10, 35 Nguyễn Huệ, Q.1, TP.HCM',     '02812345601', 'contact@apple.vn'),
('Samsung Electronics',  '2 Hai Bà Trưng, Hoàn Kiếm, Hà Nội',        '02412345602', 'info@samsung.vn'),
('Xiaomi Vietnam',       '50 Cầu Giấy, Cầu Giấy, Hà Nội',            '02412345603', 'support@xiaomi.vn'),
('Dell Technologies',    '72 Lê Thánh Tôn, Q.1, TP.HCM',             '02812345604', 'dell@dell.vn'),
('Asus Vietnam',         '15 Duy Tân, Cầu Giấy, Hà Nội',             '02412345605', 'asus@asus.vn'),
('Sony Vietnam',         '8 Hoàng Diệu, Q.4, TP.HCM',                '02812345606', 'sony@sony.vn'),
('Logitech Vietnam',     '20 Bạch Đằng, Hải Châu, Đà Nẵng',          '02362345607', 'logi@logi.vn'),
('TP-Link Vietnam',      '33 Trần Phú, Hà Đông, Hà Nội',             '02412345608', 'tplink@tplink.vn'),
('Canon Vietnam',        '5 Nguyễn Văn Trỗi, Q.Phú Nhuận, TP.HCM',  '02812345609', 'canon@canon.vn'),
('Garmin Vietnam',       '99 Võ Văn Tần, Q.3, TP.HCM',               '02812345610', 'garmin@garmin.vn');

-- ---- SanPham (25 bản ghi) -----------------------------------
INSERT INTO SanPham (tenSanPham, maDanhMuc, maNCC, giaBan, soLuongTon, donVi) VALUES
('iPhone 15 Pro Max 256GB',       1, 1, 33990000, 50, 'chiếc'),
('iPhone 15 128GB',               1, 1, 22990000, 80, 'chiếc'),
('Samsung Galaxy S24 Ultra',      1, 2, 31990000, 45, 'chiếc'),
('Samsung Galaxy A55',            1, 2, 10990000, 120,'chiếc'),
('Xiaomi 14 Pro',                 1, 3, 18990000, 60, 'chiếc'),
('MacBook Pro M3 14 inch',        2, 1, 52990000, 20, 'chiếc'),
('Dell XPS 15 9530',              2, 4, 45990000, 15, 'chiếc'),
('Asus ROG Zephyrus G14',         2, 5, 38990000, 25, 'chiếc'),
('Xiaomi Pad 6 Pro',              2, 3,  9990000, 40, 'chiếc'),
('Tai nghe Sony WH-1000XM5',      3, 6,  8990000, 70, 'chiếc'),
('Tai nghe Apple AirPods Pro 2',  3, 1,  6490000, 90, 'chiếc'),
('Cáp USB-C 1m Anker',            3, 7,   190000,200, 'cái'),
('Ốp lưng iPhone 15 Pro Max',     3, 1,   290000,150, 'cái'),
('Màn hình Dell UltraSharp 27"',  4, 4, 12990000, 30, 'chiếc'),
('Màn hình Asus ProArt 32"',      4, 5, 18990000, 15, 'chiếc'),
('Router TP-Link AX5400',         5, 8,  2490000, 55, 'chiếc'),
('Router TP-Link Deco XE75',      5, 8,  5990000, 35, 'chiếc'),
('Loa Sony SRS-XB43',             6, 6,  3290000, 45, 'chiếc'),
('Loa Logitech Z407',             6, 7,  1490000, 60, 'chiếc'),
('Canon EOS R50',                 7, 9, 19990000, 20, 'chiếc'),
('Sony A7 IV',                    7, 6, 62990000, 10, 'chiếc'),
('Garmin Fenix 7S',               8,10, 18990000, 25, 'chiếc'),
('Samsung Galaxy Watch 6',        8, 2,  7490000, 50, 'chiếc'),
('Apple Watch Series 9 45mm',     8, 1, 11990000, 40, 'chiếc'),
('Xiaomi Smart Band 8',           8, 3,   990000,150, 'chiếc');

-- ---- KhachHang (25 bản ghi) ---------------------------------
INSERT INTO KhachHang (hoTen, soDienThoai, email, diaChi, ngayDangKy) VALUES
('Nguyễn Văn An',    '0901111001', 'an.nv@gmail.com',       '12 Lê Lợi, Q.1, TP.HCM',        '2024-01-10'),
('Trần Thị Bình',    '0901111002', 'binh.tt@gmail.com',     '34 Trần Hưng Đạo, Hà Nội',       '2024-02-15'),
('Lê Văn Cường',     '0901111003', 'cuong.lv@gmail.com',    '56 Nguyễn Trãi, Đà Nẵng',        '2024-03-20'),
('Phạm Thị Dung',    '0901111004', 'dung.pt@gmail.com',     '78 Lý Thường Kiệt, TP.HCM',      '2024-04-05'),
('Hoàng Văn Em',     '0901111005', 'em.hv@gmail.com',       '90 Đinh Tiên Hoàng, Hà Nội',     '2024-04-18'),
('Võ Thị Fương',     '0901111006', 'fuong.vt@gmail.com',    '101 Phan Chu Trinh, Đà Nẵng',    '2024-05-01'),
('Đặng Văn Giang',   '0901111007', 'giang.dv@gmail.com',    '23 Hai Bà Trưng, TP.HCM',        '2024-05-22'),
('Bùi Thị Hoa',      '0901111008', 'hoa.bt@gmail.com',      '45 Lê Duẩn, Hà Nội',             '2024-06-10'),
('Ngô Văn Ích',      '0901111009', 'ich.nv@gmail.com',      '67 Nguyễn Văn Cừ, TP.HCM',       '2024-06-25'),
('Đinh Thị Kim',     '0901111010', 'kim.dt@gmail.com',      '89 Trường Chinh, Hà Nội',        '2024-07-03'),
('Phan Văn Long',    '0901111011', 'long.pv@gmail.com',     '11 Cách Mạng Tháng 8, TP.HCM',   '2024-07-14'),
('Lý Thị Mỹ',        '0901111012', 'my.lt@gmail.com',       '22 Bạch Đằng, Đà Nẵng',          '2024-07-30'),
('Trịnh Văn Nam',    '0901111013', 'nam.tv@gmail.com',      '33 Ngô Gia Tự, Hà Nội',          '2024-08-05'),
('Cao Thị Oanh',     '0901111014', 'oanh.ct@gmail.com',     '44 Lý Nam Đế, TP.HCM',           '2024-08-19'),
('Hồ Văn Phúc',      '0901111015', 'phuc.hv@gmail.com',     '55 Phan Bội Châu, Đà Nẵng',      '2024-09-01'),
('Vũ Thị Quyên',     '0901111016', 'quyen.vt@gmail.com',    '66 Trần Bình Trọng, Hà Nội',     '2024-09-15'),
('Tô Văn Rạng',      '0901111017', 'rang.tv@gmail.com',     '77 Lê Văn Sỹ, TP.HCM',           '2024-09-28'),
('Châu Thị Sen',     '0901111018', 'sen.ct@gmail.com',      '88 Đống Đa, Đà Nẵng',            '2024-10-10'),
('Mạc Văn Thắng',    '0901111019', 'thang.mv@gmail.com',    '99 Kim Mã, Hà Nội',              '2024-10-20'),
('Dương Thị Uyên',   '0901111020', 'uyen.dt@gmail.com',     '100 Đinh Bộ Lĩnh, TP.HCM',      '2024-11-02'),
('Kiều Văn Vinh',    '0901111021', 'vinh.kv@gmail.com',     '111 Võ Thị Sáu, Hà Nội',        '2024-11-15'),
('Liêu Thị Xuân',    '0901111022', 'xuan.lt@gmail.com',     '122 Trần Văn Đang, TP.HCM',      '2024-12-01'),
('Mai Văn Yên',      '0901111023', 'yen.mv@gmail.com',      '133 Đinh Lễ, Hà Nội',            '2024-12-10'),
('Nhan Thị Zung',    '0901111024', 'zung.nt@gmail.com',     '144 Nguyễn Đình Chiểu, TP.HCM',  '2025-01-05'),
('Ông Văn Ân',       '0901111025', 'an2.ov@gmail.com',      '155 Lê Hồng Phong, Đà Nẵng',     '2025-01-20');

-- ---- NhanVien (10 bản ghi) ----------------------------------
-- matKhau mặc định = soDienThoai (plain text, demo only)
INSERT INTO NhanVien (hoTen, chucVu, soDienThoai, email, matKhau, ngayVaoLam) VALUES
('Nguyễn Minh Tuấn',  'Quản lý',   '0911000001', 'tuan.nm@shop.vn',  '0911000001', '2022-01-01'),
('Trần Thị Lan',      'Nhân viên', '0911000002', 'lan.tt@shop.vn',   '0911000002', '2022-03-15'),
('Lê Quốc Bảo',       'Nhân viên', '0911000003', 'bao.lq@shop.vn',   '0911000003', '2022-06-01'),
('Phạm Ngọc Hân',     'Nhân viên', '0911000004', 'han.pn@shop.vn',   '0911000004', '2023-01-10'),
('Hoàng Khánh Linh',  'Nhân viên', '0911000005', 'linh.hk@shop.vn',  '0911000005', '2023-04-20'),
('Võ Thành Nam',      'Kế toán',   '0911000006', 'nam.vt@shop.vn',   '0911000006', '2023-07-01'),
('Đặng Phương Thảo',  'Nhân viên', '0911000007', 'thao.dp@shop.vn',  '0911000007', '2023-09-15'),
('Bùi Đức Hùng',      'Nhân viên', '0911000008', 'hung.bd@shop.vn',  '0911000008', '2024-01-05'),
('Ngô Thị Thu',       'Nhân viên', '0911000009', 'thu.nt@shop.vn',   '0911000009', '2024-04-01'),
('Đinh Công Sơn',     'Nhân viên', '0911000010', 'son.dc@shop.vn',   '0911000010', '2024-07-15');

-- ---- HoaDon (25 bản ghi) ------------------------------------
INSERT INTO HoaDon (maKH, maNV, ngayLap, trangThai, ghiChu) VALUES
( 1,  2, '2025-01-05 09:00:00', 'Hoàn thành', NULL),
( 2,  3, '2025-01-10 10:30:00', 'Hoàn thành', NULL),
( 3,  4, '2025-01-15 11:00:00', 'Hoàn thành', 'Giao nhanh'),
( 4,  2, '2025-02-01 08:45:00', 'Hoàn thành', NULL),
( 5,  5, '2025-02-10 14:00:00', 'Hoàn thành', NULL),
( 6,  3, '2025-02-20 15:30:00', 'Hoàn thành', NULL),
( 7,  6, '2025-03-05 09:15:00', 'Hoàn thành', NULL),
( 8,  4, '2025-03-12 10:00:00', 'Đã hủy',     'Khách hàng hủy'),
( 9,  7, '2025-03-20 11:30:00', 'Hoàn thành', NULL),
(10,  2, '2025-04-02 13:00:00', 'Hoàn thành', NULL),
(11,  8, '2025-04-15 09:00:00', 'Hoàn thành', NULL),
(12,  3, '2025-04-22 10:45:00', 'Hoàn thành', NULL),
(13,  5, '2025-05-01 08:30:00', 'Hoàn thành', 'Quà tặng'),
(14,  9, '2025-05-10 14:15:00', 'Hoàn thành', NULL),
(15,  4, '2025-05-18 15:00:00', 'Hoàn thành', NULL),
(16,  2, '2025-06-01 09:30:00', 'Hoàn thành', NULL),
(17, 10, '2025-06-10 11:00:00', 'Hoàn thành', NULL),
(18,  3, '2025-06-20 10:00:00', 'Đang giao',  NULL),
(19,  6, '2025-07-05 08:00:00', 'Hoàn thành', NULL),
(20,  5, '2025-07-15 13:30:00', 'Hoàn thành', NULL),
(21,  7, '2025-08-01 09:00:00', 'Hoàn thành', NULL),
(22,  2, '2025-08-10 10:15:00', 'Đang giao',  NULL),
(23,  4, '2025-09-01 14:00:00', 'Chờ xử lý',  NULL),
(24,  8, '2025-09-15 11:30:00', 'Chờ xử lý',  NULL),
(25,  3, '2025-10-01 09:00:00', 'Chờ xử lý',  NULL);

-- ---- ChiTietHoaDon ------------------------------------------
INSERT INTO ChiTietHoaDon (maHD, maSanPham, soLuong, donGia, giamGia) VALUES
( 1,  1, 1, 33990000, 0),
( 1, 11, 1,  6490000, 5),
( 2,  3, 1, 31990000, 0),
( 2, 10, 1,  8990000, 0),
( 3,  6, 1, 52990000, 0),
( 4,  4, 2, 10990000, 0),
( 4, 12, 3,   190000, 0),
( 5,  7, 1, 45990000, 5),
( 6,  2, 1, 22990000, 0),
( 6, 13, 1,   290000, 0),
( 7,  8, 1, 38990000,10),
( 8,  9, 1,  9990000, 0),
( 9, 14, 1, 12990000, 0),
(10,  5, 1, 18990000, 0),
(10, 16, 1,  2490000, 0),
(11, 15, 1, 18990000, 5),
(12, 22, 1, 18990000, 0),
(13, 24, 1, 11990000, 0),
(13, 25, 2,   990000, 0),
(14, 20, 1, 19990000, 0),
(15, 17, 1,  5990000, 0),
(16, 18, 1,  3290000, 0),
(16, 19, 1,  1490000, 0),
(17, 21, 1, 62990000, 0),
(18,  1, 1, 33990000, 3),
(19, 23, 1,  7490000, 0),
(20,  6, 1, 52990000, 8),
(21, 10, 2,  8990000, 0),
(22,  2, 1, 22990000, 0),
(23,  3, 1, 31990000, 0),
(24,  7, 1, 45990000, 0),
(25,  9, 2,  9990000, 0);
