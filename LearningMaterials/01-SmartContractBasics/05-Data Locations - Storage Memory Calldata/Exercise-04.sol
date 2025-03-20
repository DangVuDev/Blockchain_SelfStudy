//  Challenge 4: Hybrid Data Management in Smart Contracts

// Objective:

// Develop a contract that efficiently stores user data and retrieves specific information without unnecessary gas costs.

// Requirements:

// Define a struct User containing string name and uint256 balance.

// Store User objects in a mapping(uint256 => User) private users.

// Implement addUser(uint256 id, string calldata name, uint256 balance) to add new users.

// Implement getUserName(uint256 id) external view returns (string memory) without using excessive storage operations.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HybridDataManager {
    // Struct để lưu thông tin user
    struct User {
        string name;
        uint256 balance;
    }
    
    // Mapping private để lưu trữ users
    mapping(uint256 => User) private users;
    
    // Sự kiện khi thêm user
    event UserAdded(uint256 indexed id, string name, uint256 balance);
    
    /**
     * @dev Thêm một user mới vào mapping
     * @param id ID duy nhất của user
     * @param name Tên của user (calldata để tiết kiệm gas)
     * @param balance Số dư của user
     */
    function addUser(uint256 id, string calldata name, uint256 balance) 
        external 
    {
        // Kiểm tra xem ID đã tồn tại chưa (tùy chọn)
        require(bytes(users[id].name).length == 0, "User ID already exists");
        
        // Ghi dữ liệu vào mapping
        users[id] = User(name, balance);
        
        // Phát sự kiện
        emit UserAdded(id, name, balance);
    }
    
    /**
     * @dev Lấy tên của user dựa trên ID
     * @param id ID của user
     * @return Tên của user (memory)
     */
    function getUserName(uint256 id) 
        external 
        view 
        returns (string memory) 
    {
        // Trả về trực tiếp từ storage, không ghi hay sao chép thừa
        return users[id].name;
    }
    
    // Hàm tiện ích để lấy toàn bộ thông tin user (tùy chọn)
    function getUser(uint256 id) 
        external 
        view 
        returns (string memory name, uint256 balance) 
    {
        User storage user = users[id];
        return (user.name, user.balance);
    }
}