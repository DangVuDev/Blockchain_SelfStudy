// Exercise 4: Fixed-Size and Dynamic Arrays
// 💡 Objective: Work with different types of Solidity arrays.

// Requirements:
// Create a contract named ArrayManager.
// Declare:
// A uint8[5] fixed-size array
// A uint256[] dynamic array
// Implement a function setFixedArray(uint8 index, uint8 value) to modify a specific index of the fixed-size array. Ensure the index is within bounds.
// Implement a function addToDynamicArray(uint256 value) to push values into the dynamic array.
// Implement a function getFixedArray() to return all values of the fixed-size array.
// Implement a function getDynamicArray() to return all values of the dynamic array.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ArrayManager{
    uint8[5] public fixed_array;
    uint256[] public dynamic_array;

    function setFixedArray(uint8 index, uint8 value) public {
        require(index < 5, "Index out of bounds");
        //Dùng assembly để tối ưu gas feefee
        assembly {
            let pointer := fixed_array.slot
            let position := add(pointer,index)
            sstore(position,value)
        }
    }
    /// @notice Thêm một phần tử vào mảng động
    /// @param value Giá trị cần thêm vào mảng
    function addToDynamicArray(uint256 value) public {
        dynamic_array.push(value);
    }
   
    function getFixedArray() public view returns (uint8[5] memory) {
        return fixed_array;
    }
    
    function getDynamicArray() public view returns (uint256[] memory) {
        return dynamic_array;
    }
}