# Data Locations - Storage, Memory, and Calldata in Solidity

## 1. Giới thiệu
Solidity có ba loại vị trí dữ liệu chính: `storage`, `memory`, và `calldata`. Việc hiểu rõ cách sử dụng từng loại giúp tối ưu hóa gas và đảm bảo hiệu suất hợp đồng thông minh.

## 2. Storage
- Dữ liệu được lưu trữ **vĩnh viễn** trên blockchain.
- Chi phí lưu trữ cao vì cần ghi trực tiếp vào blockchain.
- Sử dụng cho biến trạng thái (state variables).
- Ví dụ:
  
  ```solidity
  contract Example {
      uint256 public storedData; // Lưu trữ trong storage

      function setStoredData(uint256 _data) public {
          storedData = _data;
      }
  }
  ```

## 3. Memory
- Dữ liệu chỉ tồn tại trong thời gian chạy của hàm (tạm thời).
- Sử dụng cho biến cục bộ (local variables) và các giá trị truyền vào.
- Không mất phí lưu trữ dài hạn.
- Ví dụ:
  
  ```solidity
  contract Example {
      function getDouble(uint256 _num) public pure returns (uint256) {
          uint256 temp = _num * 2; // Lưu trong memory
          return temp;
      }
  }
  ```

## 4. Calldata
- Chỉ áp dụng cho tham số đầu vào của **hàm external**.
- Không thể chỉnh sửa (readonly).
- Hiệu quả về gas vì không sao chép dữ liệu.
- Dùng chủ yếu cho **arrays** hoặc **structs** truyền vào từ bên ngoài.
- Ví dụ:
  
  ```solidity
  contract Example {
      function processCalldataArray(uint256[] calldata numbers) external pure returns (uint256) {
          return numbers.length;
      }
  }
  ```

## 5. So sánh Storage, Memory và Calldata
| Loại         | Tồn tại bao lâu? | Chỉnh sửa được không? | Tốn gas bao nhiêu? | Ứng dụng chính |
|-------------|----------------|----------------|---------------|---------------|
| `storage`   | Vĩnh viễn trên blockchain | Có thể chỉnh sửa | Cao | Biến trạng thái |
| `memory`    | Chỉ tồn tại trong hàm | Có thể chỉnh sửa | Thấp hơn `storage` | Biến cục bộ |
| `calldata`  | Chỉ tồn tại khi gọi hàm | Không thể chỉnh sửa | Hiệu quả nhất | Tham số đầu vào |

---


---

💡 **Ghi nhớ:**
- `storage` dùng cho dữ liệu lâu dài.
- `memory` chỉ dùng tạm thời trong hàm.
- `calldata` giúp tối ưu gas khi xử lý input của hàm external.

