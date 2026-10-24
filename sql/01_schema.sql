-- ============================================================
-- 01_schema.sql  –  DDL: Tạo bảng hệ thống Quản lý Bán hàng
-- HQTCSDL: MySQL
-- ============================================================

CREATE DATABASE IF NOT EXISTS QuanLyBanHang
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE QuanLyBanHang;

-- 1. Danh mục sản phẩm
CREATE TABLE DanhMuc (
    maDanhMuc   INT           AUTO_INCREMENT PRIMARY KEY,
    tenDanhMuc  VARCHAR(100)  NOT NULL UNIQUE,
    moTa        TEXT
);

-- 2. Nhà cung cấp
CREATE TABLE NhaCungCap (
    maNCC        INT           AUTO_INCREMENT PRIMARY KEY,
    tenNCC       VARCHAR(150)  NOT NULL,
    diaChi       VARCHAR(255),
    soDienThoai  VARCHAR(15)   NOT NULL UNIQUE,
    email        VARCHAR(100)  UNIQUE
);

-- 3. Sản phẩm
CREATE TABLE SanPham (
    maSanPham   INT            AUTO_INCREMENT PRIMARY KEY,
    tenSanPham  VARCHAR(150)   NOT NULL,
    maDanhMuc   INT            NOT NULL,
    maNCC       INT            NOT NULL,
    giaBan      DECIMAL(15,2)  NOT NULL CHECK (giaBan > 0),
    soLuongTon  INT            NOT NULL DEFAULT 0 CHECK (soLuongTon >= 0),
    donVi       VARCHAR(30)    NOT NULL DEFAULT 'cái',
    CONSTRAINT fk_sp_danhmuc FOREIGN KEY (maDanhMuc) REFERENCES DanhMuc(maDanhMuc),
    CONSTRAINT fk_sp_ncc     FOREIGN KEY (maNCC)     REFERENCES NhaCungCap(maNCC)
);

-- 4. Khách hàng
CREATE TABLE KhachHang (
    maKH         INT           AUTO_INCREMENT PRIMARY KEY,
    hoTen        VARCHAR(100)  NOT NULL,
    soDienThoai  VARCHAR(15)   NOT NULL UNIQUE,
    email        VARCHAR(100)  UNIQUE,
    diaChi       VARCHAR(255),
    ngayDangKy   DATE          NOT NULL DEFAULT (CURRENT_DATE)
);

-- 5. Nhân viên
CREATE TABLE NhanVien (
    maNV         INT           AUTO_INCREMENT PRIMARY KEY,
    hoTen        VARCHAR(100)  NOT NULL,
    chucVu       VARCHAR(50)   NOT NULL DEFAULT 'Nhân viên',
    soDienThoai  VARCHAR(15)   NOT NULL UNIQUE,
    email        VARCHAR(100)  UNIQUE,
    matKhau      VARCHAR(255)  NOT NULL DEFAULT '',
    ngayVaoLam   DATE          NOT NULL
);

-- 6. Hóa đơn
CREATE TABLE HoaDon (
    maHD        INT            AUTO_INCREMENT PRIMARY KEY,
    maKH        INT            NOT NULL,
    maNV        INT            NOT NULL,
    ngayLap     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    trangThai   ENUM('Chờ xử lý','Đang giao','Hoàn thành','Đã hủy')
                               NOT NULL DEFAULT 'Chờ xử lý',
    ghiChu      TEXT,
    CONSTRAINT fk_hd_kh FOREIGN KEY (maKH) REFERENCES KhachHang(maKH),
    CONSTRAINT fk_hd_nv FOREIGN KEY (maNV) REFERENCES NhanVien(maNV)
);

-- 7. Chi tiết hóa đơn  (bảng N-N giữa HoaDon và SanPham)
CREATE TABLE ChiTietHoaDon (
    maHD        INT            NOT NULL,
    maSanPham   INT            NOT NULL,
    soLuong     INT            NOT NULL CHECK (soLuong > 0),
    donGia      DECIMAL(15,2)  NOT NULL CHECK (donGia > 0),
    giamGia     DECIMAL(5,2)   NOT NULL DEFAULT 0 CHECK (giamGia BETWEEN 0 AND 100),
    PRIMARY KEY (maHD, maSanPham),
    CONSTRAINT fk_cthd_hd FOREIGN KEY (maHD)      REFERENCES HoaDon(maHD),
    CONSTRAINT fk_cthd_sp FOREIGN KEY (maSanPham)  REFERENCES SanPham(maSanPham)
);
