# Mô tả bài toán – Quản lý Bán hàng

## 1. Bối cảnh

Một cửa hàng kinh doanh thiết bị điện tử (điện thoại, laptop, phụ kiện...) cần một hệ thống quản lý để theo dõi sản phẩm, khách hàng, nhân viên bán hàng và các đơn hàng phát sinh hằng ngày.

---

## 2. Các nghiệp vụ chính

### NV1 – Quản lý danh mục và sản phẩm
- Cửa hàng phân loại sản phẩm theo danh mục (Điện thoại, Laptop, Phụ kiện...).
- Mỗi sản phẩm thuộc một danh mục và được cung cấp bởi một nhà cung cấp.
- Hệ thống theo dõi giá bán và số lượng tồn kho của từng sản phẩm.
- Khi bán hàng, tồn kho tự động giảm theo số lượng đã bán.

### NV2 – Quản lý khách hàng
- Khách hàng được đăng ký với họ tên, số điện thoại (duy nhất), email và địa chỉ.
- Lưu ngày đăng ký để phục vụ các chương trình khách hàng thân thiết.

### NV3 – Quản lý nhân viên
- Mỗi nhân viên có chức vụ (Quản lý, Nhân viên, Kế toán...) và ngày vào làm.
- Nhân viên chịu trách nhiệm lập hóa đơn cho khách.

### NV4 – Lập hóa đơn bán hàng
- Khi khách mua hàng, nhân viên tạo một hóa đơn gắn với khách hàng đó.
- Mỗi hóa đơn có thể chứa nhiều sản phẩm với số lượng và đơn giá tại thời điểm bán.
- Hỗ trợ chiết khấu (%) trên từng dòng sản phẩm.
- Hóa đơn có trạng thái: Chờ xử lý → Đang giao → Hoàn thành / Đã hủy.

### NV5 – Theo dõi tồn kho
- Sau mỗi đơn hàng, số lượng tồn kho tự động cập nhật qua trigger.
- Hệ thống cảnh báo sản phẩm có tồn kho thấp hơn mức trung bình.

### NV6 – Báo cáo và thống kê
- Doanh thu theo tháng, theo nhân viên, theo danh mục sản phẩm.
- Top sản phẩm bán chạy.
- Top khách hàng chi tiêu nhiều nhất.
- Hóa đơn có giá trị cao hơn trung bình.

---

## 3. Các quy tắc nghiệp vụ

| # | Quy tắc |
|---|---------|
| R1 | Giá bán sản phẩm phải lớn hơn 0 |
| R2 | Số lượng tồn kho không được âm |
| R3 | Số lượng trong chi tiết hóa đơn phải ≥ 1 |
| R4 | Chiết khấu nằm trong khoảng 0% – 100% |
| R5 | Số điện thoại của khách hàng và nhân viên phải duy nhất |
| R6 | Không được xóa khách hàng đã có hóa đơn |
| R7 | Mỗi hóa đơn phải có ít nhất một khách hàng và một nhân viên phụ trách |

---

## 4. Sơ đồ luồng nghiệp vụ chính (Lập hóa đơn)

```
Khách hàng đến mua
        │
        ▼
Nhân viên kiểm tra tồn kho sản phẩm
        │
        ▼
Tạo hóa đơn (trạng thái: Chờ xử lý)
        │
        ▼
Thêm các sản phẩm vào chi tiết hóa đơn
        │
        ▼
Trigger tự động trừ tồn kho
        │
        ▼
Cập nhật trạng thái → Đang giao → Hoàn thành
```
