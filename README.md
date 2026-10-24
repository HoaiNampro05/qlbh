# Quản lý Bán hàng – CSDL Project

## Cấu trúc thư mục

```
├── sql/
│   ├── 01_schema.sql   # DDL: tạo database và 7 bảng
│   ├── 02_data.sql     # Dữ liệu mẫu (~25 bản ghi/bảng)
│   ├── 03_queries.sql  # 10 câu truy vấn nghiệp vụ
│   ├── 04_objects.sql  # 2 View, 1 Stored Procedure, 1 Trigger
│   └── 05_admin.sql    # Index, phân quyền, transaction mẫu
├── diagrams/
│   └── ERD.md          # ERD và lược đồ quan hệ (text)
├── app/
│   └── app.py          # Ứng dụng Python CRUD KhachHang
└── README.md
```

## Yêu cầu

- MySQL 8.0+
- Python 3.8+
- `mysql-connector-python`

## Cài đặt và chạy

### 1. Chạy SQL

```bash
mysql -u root -p < sql/01_schema.sql
mysql -u root -p < sql/02_data.sql
mysql -u root -p < sql/03_queries.sql
mysql -u root -p < sql/04_objects.sql
mysql -u root -p < sql/05_admin.sql
```

hoặc chạy các file .sql này trong mysql workbench

### 2. Cài thư viện Python

```bash
pip install mysql-connector-python
```

### 3. Chạy ứng dụng

```bash
python app/app.py
```

> Mặc định app kết nối với user `app_user` / password `App@123456`.  
> Có thể chỉnh trong `app/app.py` phần `DB_CONFIG`.
# qlbh
