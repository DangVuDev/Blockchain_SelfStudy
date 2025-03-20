// 3. Advanced Fee Management with Constants & Immutables (Expert Level)
// 📌 Task:
// Xây dựng một hợp đồng FeeManager với hệ thống tính phí linh hoạt, sử dụng constants và immutables để tối ưu hóa gas.

// 🔹 Requirements:

// Khai báo hằng số uint256 BASE_FEE = 1000.
// Khai báo biến immutable uint256 dynamicFeeMultiplier được thiết lập trong constructor.
// Thêm một biến immutable uint256 maxFeeCap để giới hạn mức phí tối đa.
// Thêm một mapping để lưu trữ phí ưu đãi (discountedFees) cho từng địa chỉ.
// Cài đặt hàm calculateFee(uint256 amount, address user) với các điều kiện sau:
// Nếu user có trong discountedFees, sử dụng mức phí ưu đãi.
// Tính phí bằng công thức:
// fee =(amount × dynamicFeeMultiplier)/BASE_FEE

 
// Nếu phí tính toán vượt quá maxFeeCap, tự động giảm xuống maxFeeCap.
// Thêm hàm setDiscountedFee(address user, uint256 newFeeMultiplier) (chỉ admin có thể đặt mức phí ưu đãi).
// 🚀 Goal: Hiểu cách constants & immutables hoạt động cùng nhau trong hệ thống tính phí phức tạp.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FeeManager{
    uint256 public constant BASE_FEE = 1000;
    uint256 public immutable dynamicFeeMultiplier;
    uint256 public immutable maxFeeCap;
    address public immutable admin;

    mapping(address => uint256) public discountedFees;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    constructor(uint256 _dynamicFeeMultiplier, uint256 _maxFeeCap) {
        require(_dynamicFeeMultiplier > 0, "Invalid multiplier");
        require(_maxFeeCap > 0, "Invalid fee cap");
        dynamicFeeMultiplier = _dynamicFeeMultiplier;
        maxFeeCap = _maxFeeCap;
        admin = msg.sender;
    }

    function calculateFee(uint256 amount, address user) external view returns (uint256)
    {
        if(discountedFees[user] != 0) {
            return discountedFees[user];
        }
        uint256 fee = (amount * dynamicFeeMultiplier)/BASE_FEE;
        if(fee > maxFeeCap) return maxFeeCap;
        return fee;
    }

    function setDiscountedFee(address user, uint256 newFeeMultiplier) external onlyAdmin {
        require(user != address(0),"");
        require(newFeeMultiplier < dynamicFeeMultiplier, "Discount must be lower");
        discountedFees[user] = newFeeMultiplier;
    }
}