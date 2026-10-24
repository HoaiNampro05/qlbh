# ERD – Quản lý Bán hàng

```mermaid
erDiagram
    DanhMuc {
        int maDanhMuc PK
        varchar tenDanhMuc
        text moTa
    }
    NhaCungCap {
        int maNCC PK
        varchar tenNCC
        varchar diaChi
        varchar soDienThoai
        varchar email
    }
    SanPham {
        int maSanPham PK
        varchar tenSanPham
        int maDanhMuc FK
        int maNCC FK
        decimal giaBan
        int soLuongTon
        varchar donVi
    }
    KhachHang {
        int maKH PK
        varchar hoTen
        varchar soDienThoai
        varchar email
        varchar diaChi
        date ngayDangKy
    }
    NhanVien {
        int maNV PK
        varchar hoTen
        varchar chucVu
        varchar soDienThoai
        varchar email
        varchar matKhau
        date ngayVaoLam
    }
    HoaDon {
        int maHD PK
        int maKH FK
        int maNV FK
        datetime ngayLap
        enum trangThai
        text ghiChu
    }
    ChiTietHoaDon {
        int maHD FK
        int maSanPham FK
        int soLuong
        decimal donGia
        decimal giamGia
    }

    DanhMuc    ||--o{ SanPham        : "phân loại"
    NhaCungCap ||--o{ SanPham        : "cung cấp"
    KhachHang  ||--o{ HoaDon         : "đặt hàng"
    NhanVien   ||--o{ HoaDon         : "lập"
    HoaDon     ||--o{ ChiTietHoaDon  : "gồm"
    SanPham    ||--o{ ChiTietHoaDon  : "có trong"
```


## Các thực thể và thuộc tính

### DanhMuc
- **maDanhMuc** (PK)
- tenDanhMuc (UNIQUE, NOT NULL)
- moTa

### NhaCungCap
- **maNCC** (PK)
- tenNCC (NOT NULL)
- diaChi
- soDienThoai (UNIQUE, NOT NULL)
- email (UNIQUE)

### SanPham
- **maSanPham** (PK)
- tenSanPham (NOT NULL)
- *maDanhMuc* (FK → DanhMuc)
- *maNCC* (FK → NhaCungCap)
- giaBan (NOT NULL, > 0)
- soLuongTon (DEFAULT 0, ≥ 0)
- donVi

### KhachHang
- **maKH** (PK)
- hoTen (NOT NULL)
- soDienThoai (UNIQUE, NOT NULL)
- email (UNIQUE)
- diaChi
- ngayDangKy

### NhanVien
- **maNV** (PK)
- hoTen (NOT NULL)
- chucVu
- soDienThoai (UNIQUE, NOT NULL)
- email (UNIQUE)
- ngayVaoLam

### HoaDon
- **maHD** (PK)
- *maKH* (FK → KhachHang)
- *maNV* (FK → NhanVien)
- ngayLap
- trangThai (ENUM)
- ghiChu

### ChiTietHoaDon  ← bảng N-N
- **maHD** (PK, FK → HoaDon)
- **maSanPham** (PK, FK → SanPham)
- soLuong (NOT NULL, > 0)
- donGia (NOT NULL, > 0)
- giamGia (0–100)

---

## Quan hệ

| Từ | Quan hệ | Đến |
|---|---|---|
| DanhMuc | 1 – N | SanPham |
| NhaCungCap | 1 – N | SanPham |
| KhachHang | 1 – N | HoaDon |
| NhanVien | 1 – N | HoaDon |
| HoaDon | N – N (qua ChiTietHoaDon) | SanPham |

---

## Sơ đồ dạng text

```
DanhMuc ──< SanPham >── NhaCungCap
               │
               │ (qua ChiTietHoaDon)
               │
KhachHang ──< HoaDon >── NhanVien
```

---

## Lược đồ quan hệ

- DanhMuc(**maDanhMuc**, tenDanhMuc, moTa)
- NhaCungCap(**maNCC**, tenNCC, diaChi, soDienThoai, email)
- SanPham(**maSanPham**, tenSanPham, _maDanhMuc_, _maNCC_, giaBan, soLuongTon, donVi)
- KhachHang(**maKH**, hoTen, soDienThoai, email, diaChi, ngayDangKy)
- NhanVien(**maNV**, hoTen, chucVu, soDienThoai, email, ngayVaoLam)
- HoaDon(**maHD**, _maKH_, _maNV_, ngayLap, trangThai, ghiChu)
- ChiTietHoaDon(**_maHD_**, **_maSanPham_**, soLuong, donGia, giamGia)

---

## Chuẩn hóa 3NF

Tất cả bảng đều đạt 3NF:
- 1NF: Mỗi ô chứa giá trị nguyên tử, có khóa chính.
- 2NF: Các bảng có khóa ghép (ChiTietHoaDon) – mọi thuộc tính phụ thuộc đầy đủ vào khóa chính ghép.
- 3NF: Không có phụ thuộc bắc cầu (không có A→B→C nơi B không phải khóa).
