// 4. Immutable Upgrade Protection & Role Management (Master Level)
// 📌 Task:
// Tạo một hợp đồng ImmutableUpgrade để bảo vệ nâng cấp hợp đồng, chỉ cho phép admin nâng cấp hợp đồng và cấp quyền truy cập.

// 🔹 Requirements:

// Khai báo immutable address admin, đặt bằng msg.sender trong constructor.
// Khai báo constant bytes32 UPGRADE_TARGET, lưu địa chỉ hợp đồng mới.
// Chỉ admin có thể nâng cấp hợp đồng bằng hàm upgradeContract(address newContract).
// Thêm hệ thống quản lý vai trò:
// mapping(address => bool) isAuthorizedUser: Chỉ những người dùng được cấp phép mới có thể gọi các hàm quan trọng.
// Hàm grantAccess(address user) và revokeAccess(address user).
// Thêm tính năng bảo vệ nhiều lớp:
// Chặn reentrancy bằng modifier nonReentrant().
// Bảo vệ chống tấn công front-running bằng một mã xác nhận (upgradeNonce).
// 🚀 Goal: Bảo vệ hợp đồng khỏi nâng cấp trái phép, quản lý quyền truy cập, và cải thiện bảo mật.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImmutableUpgrade {
    // Admin không thể thay đổi sau khi deploy
    address public immutable admin;
    
    // Constant lưu trữ địa chỉ hợp đồng mới (có thể để trống ban đầu)
    bytes32 public constant UPGRADE_TARGET = 0x0;
    
    // Quản lý người dùng được cấp quyền
    mapping(address => bool) public isAuthorizedUser;
    
    // Biến đếm để chống front-running
    uint256 public upgradeNonce;
    
    // Biến khóa chống reentrancy
    bool private locked;
    
    // Sự kiện
    event ContractUpgraded(address indexed newContract);
    event AccessGranted(address indexed user);
    event AccessRevoked(address indexed user);
    
    // Modifier kiểm tra admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
    
    // Modifier kiểm tra người dùng được cấp quyền
    modifier onlyAuthorized() {
        require(isAuthorizedUser[msg.sender] || msg.sender == admin, 
                "Not authorized to call this function");
        _;
    }
    
    // Modifier chống reentrancy
    modifier nonReentrant() {
        require(!locked, "Reentrant call detected");
        locked = true;
        _;
        locked = false;
    }
    
    // Constructor
    constructor() {
        admin = msg.sender;
        isAuthorizedUser[msg.sender] = true; // Admin tự động được cấp quyền
        upgradeNonce = 0;
    }
    
    // Hàm nâng cấp hợp đồng
    function upgradeContract(address newContract, uint256 nonce) 
        external 
        onlyAdmin 
        nonReentrant 
        returns (bool)
    {
        // Kiểm tra chống front-running
        require(nonce == upgradeNonce, "Invalid nonce");
        
        // Kiểm tra địa chỉ hợp đồng mới hợp lệ
        require(newContract != address(0), "Invalid contract address");
        require(newContract != address(this), "Cannot upgrade to same contract");
        
        // Cập nhật nonce
        upgradeNonce++;
        
        // Phát sự kiện nâng cấp
        emit ContractUpgraded(newContract);
        return true;
    }
    
    // Cấp quyền truy cập cho user
    function grantAccess(address user) 
        external 
        onlyAdmin 
        nonReentrant 
    {
        require(user != address(0), "Invalid address");
        require(!isAuthorizedUser[user], "User already authorized");
        
        isAuthorizedUser[user] = true;
        emit AccessGranted(user);
    }
    
    // Thu hồi quyền truy cập
    function revokeAccess(address user) 
        external 
        onlyAdmin 
        nonReentrant 
    {
        require(user != admin, "Cannot revoke admin access");
        require(isAuthorizedUser[user], "User not authorized");
        
        isAuthorizedUser[user] = false;
        emit AccessRevoked(user);
    }
    
    // Hàm kiểm tra trạng thái hợp đồng (có thể gọi bởi user được cấp quyền)
    function getContractStatus() 
        external 
        view 
        onlyAuthorized 
        returns (address, uint256)
    {
        return (admin, upgradeNonce);
    }
}