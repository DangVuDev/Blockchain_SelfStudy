// Exercise 5: Enum and Conditional Logic
// 💡 Objective: Learn to use enums for state management in Solidity.

// Requirements:
// Create a contract named OrderManager.
// Define an enum called OrderStatus with values: Pending, Shipped, Delivered, Cancelled.
// Create a struct called Order with:
// uint256 id
// OrderStatus status
// Implement a mapping(uint256 => Order) to store orders.
// Implement a function createOrder(uint256 id) that initializes an order with Pending status.
// Implement a function updateOrderStatus(uint256 id, OrderStatus newStatus) to change the order’s status.
// Implement a function getOrderStatus(uint256 id) to return the status of an order.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract OrderManager {
     /// @dev Sự kiện khi tạo đơn hàng mới
    event OrderCreated(uint256 indexed id);

    /// @dev Sự kiện khi cập nhật trạng thái đơn hàng
    event OrderStatusUpdated(uint256 indexed id, OrderStatus newStatus);

    /// @dev Sự kiện khi xóa đơn hàng
    event OrderDeleted(uint256 indexed id);

    /// @notice Trạng thái của đơn hàng
    enum OrderStatus {
        Pending,   // Đơn hàng đang chờ xử lý
        Shipped,   // Đơn hàng đã được giao đi
        Delivered, // Đơn hàng đã giao thành công
        Cancelled  // Đơn hàng bị hủy
    }

    /// @dev Lưu trạng thái đơn hàng theo ID
    mapping(uint256 => OrderStatus) private orders;

    /// @dev Kiểm tra xem ID có tồn tại không
    mapping(uint256 => bool) private orderExists;

    /// @notice Tạo một đơn hàng mới
    /// @param id ID duy nhất của đơn hàng
    function createOrder(uint256 id) public {
        require(!orderExists[id], "Order ID already exists.");
        
        orderExists[id] = true;
        orders[id] = OrderStatus.Pending;

        emit OrderCreated(id);
    }

    /// @notice Cập nhật trạng thái đơn hàng
    /// @param id ID của đơn hàng
    /// @param newStatus Trạng thái mới của đơn hàng
    function updateOrderStatus(uint256 id, OrderStatus newStatus) public {
        require(orderExists[id], "Order ID does not exist.");
        
        orders[id] = newStatus;

        emit OrderStatusUpdated(id, newStatus);
    }

    /// @notice Xóa đơn hàng
    /// @param id ID của đơn hàng cần xóa
    function removeOrder(uint256 id) public {
        require(orderExists[id], "Order ID does not exist.");

        delete orderExists[id];
        delete orders[id];

        emit OrderDeleted(id);
    }

    /// @notice Lấy trạng thái của đơn hàng
    /// @param id ID của đơn hàng
    /// @return Trạng thái hiện tại của đơn hàng
    function getOrderStatus(uint256 id) public view returns (OrderStatus) {
        require(orderExists[id], "Order ID does not exist.");
        return orders[id];
    }

}