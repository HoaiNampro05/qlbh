# ĐỀ BÀI TẬP DỰ ÁN
**Môn học:** Database Design and Management

---

## 1. Mục tiêu
Mỗi nhóm xây dựng một cơ sở dữ liệu cho một bài toán thực tế, từ thiết kế đến cài đặt và kết nối với một chương trình đơn giản.

---

## 2. Hình thức
- **Nhóm:** Nhiều nhất 5 sinh viên.
- **Hệ quản trị CSDL:** MySQL hoặc PostgreSQL.
- **Đề tài:** Chọn một trong các gợi ý dưới đây hoặc tự đề xuất (giảng viên duyệt).

| STT | Đề tài |
| :---: | :--- |
| 1 | Quản lý thư viện |
| 2 | Quản lý bán hàng |
| 3 | Quản lý đăng ký học phần |
| 4 | Quản lý phòng khám |
| 5 | Quản lý khách sạn |
| 6 | Quản lý ký túc xá |
| 7 | Quản lý tuyển dụng |

---

## 3. Yêu cầu

### Phần 1 – Thiết kế (35%)
- Mô tả ngắn bài toán và các nghiệp vụ chính.
- Vẽ ERD (có quan hệ 1-N và N-N).
- Chuyển sang lược đồ quan hệ, xác định khóa chính, khóa ngoại.
- Chuẩn hóa đến 3NF.

### Phần 2 – Cài đặt (25%)
- **Script tạo bảng:** 6-8 bảng, có `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`.
- **Dữ liệu mẫu:** Khoảng 20-30 bản ghi mỗi bảng, hợp lý, có ý nghĩa.

### Phần 3 – Truy vấn (25%)
- **10 câu truy vấn** phục vụ nghiệp vụ, trong đó có: `JOIN`, `GROUP BY`/`HAVING`, truy vấn con.
- **2 view**, **1 stored procedure**, **1 trigger**.

### Phần 4 – Tích hợp (15%)
- Viết một chương trình nhỏ (Python, Java, C#... tùy chọn) kết nối CSDL và thực hiện thêm, sửa, xóa, tìm kiếm cho ít nhất một bảng chính.

---

## 4. Sản phẩm nộp
- **Báo cáo (10-15 trang):** Thiết kế, các câu truy vấn kèm kết quả, ảnh chụp chương trình, bảng phân công công việc.
- **File SQL:** Tạo bảng, dữ liệu mẫu, truy vấn.
- **Mã nguồn chương trình.**

### Cấu trúc thư mục nộp bài:
```text
TenNhom_DeTai/
├── report.pdf          # Báo cáo (20-40 trang)
├── slides.pdf          # Slide thuyết trình
├── sql/
│   ├── 01_schema.sql   # DDL
│   ├── 02_data.sql     # Dữ liệu mẫu
│   ├── 03_queries.sql  # Truy vấn
│   ├── 04_objects.sql  # View, procedure, function, trigger
│   └── 05_admin.sql    # Phân quyền, index, transaction
├── diagrams/           # ERD, lược đồ quan hệ
├── app/                # Mã nguồn phần tích hợp
└── README.md           # Hướng dẫn cài đặt và chạy
```

---

## 5. Lịch mốc

| Tuần | Nội dung |
| :---: | :--- |
| 3 | Đăng ký nhóm và đề tài |
| 6 | Nộp ERD và lược đồ quan hệ |
| 10 | Nộp sản phẩm và thuyết trình (10 phút + vấn đáp) |

---

## 6. Đánh giá

| Phần | Tỷ trọng |
| :--- | :---: |
| Thiết kế | 35% |
| Cài đặt | 25% |
| Truy vấn | 25% |
| Tích hợp | 15% |

> **Lưu ý:** Điểm cá nhân được điều chỉnh theo mức đóng góp và kết quả vấn đáp. Sao chép bài sẽ nhận 0 điểm.