// Exercise 1: Integer Overflow and Underflow Prevention
// 💡 Objective: Understand how Solidity handles integer operations and prevents overflow/underflow.

// Requirements:
// Create a smart contract called SafeMathTest.
// Declare two uint8 variables: smallNumber and bigNumber.
// Implement a function increaseSmallNumber(uint8 value) that adds value to smallNumber.
// Implement a function decreaseBigNumber(uint8 value) that subtracts value from bigNumber.
// Ensure that overflow and underflow do not occur by using Solidity ^0.8’s built-in safety checks.
// Add a function to retrieve both values.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SafeMathTest{
    error Overflow(); // Khai báo lỗi tùy chỉnh
    error Underflow();

    uint8 public smallNumber;
    uint8 public bigNumber;

    /// @notice Tăng giá trị của `smallNumber` nhưng không được phép tràn số
    /// @param value Giá trị cần cộng vào `smallNumber`
    /// @return Giá trị mới của `smallNumber`
    function increaseSmallNumber(uint8 value) public returns (uint8) {
        uint8 newValue = smallNumber + value;

        // Kiểm tra tràn số
        if (newValue < smallNumber) {
            revert Overflow();
        }

        smallNumber = newValue; // Cập nhật giá trị mới
        return smallNumber;
    }
    
    /// @notice Giảm giá trị của `bigNumber` nhưng không được phép âm
    /// @param value Giá trị cần trừ đi từ `bigNumber`
    /// @return Giá trị mới của `bigNumber`
    function decreaseBigNumber(uint8 value) public returns (uint8) {
        // Kiểm tra underflow (bigNumber không thể nhỏ hơn value)
        if (value > bigNumber) {
            revert Underflow();
        }

        bigNumber -= value; // Cập nhật giá trị mới
        return bigNumber;
    }

    function getVariablesStorageValue() public view returns(uint8 small,uint8 big){
        return (smallNumber,bigNumber);
    }
}