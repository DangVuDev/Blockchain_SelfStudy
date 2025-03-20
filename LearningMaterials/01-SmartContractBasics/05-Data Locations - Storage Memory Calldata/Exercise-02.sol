// Challenge 2: Memory-Only Sorting Algorithm

// Objective:

// Implement an in-memory sorting algorithm without using storage.

// Requirements:

// Create a function sortArray(uint256[] memory arr) that sorts an array in ascending order.

// Return the sorted array while ensuring no data is stored persistently.

// Propose an optimal sorting algorithm to minimize gas fees.   


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ArraySorter {
    function sortArray(uint256[] memory arr) 
        internal 
        pure 
        returns (uint256[] memory) 
    {
        if (arr.length <= 1) {
            return arr;
        }

        // Giới hạn độ dài mảng để kiểm soát gas
        require(arr.length <= 100, "Array too large");

        // Tạo mảng tạm để merge
        uint256[] memory temp = new uint256[](arr.length);
        
        // Sử dụng assembly để merge sort
        assembly {
            let len := mload(arr)
            let dataPtr := add(arr, 32)    // Con trỏ tới dữ liệu arr
            let tempPtr := add(temp, 32)   // Con trỏ tới dữ liệu temp
            
            // Sao chép arr sang temp ban đầu
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                mstore(add(tempPtr, mul(i, 32)), mload(add(dataPtr, mul(i, 32))))
            }
            
            // Merge Sort với bước tăng dần
            for { let step := 1 } lt(step, len) { step := mul(step, 2) } {
                for { let left := 0 } lt(left, len) { left := add(left, mul(step, 2)) } {
                    let mid := add(left, step)
                    let right := add(left, mul(step, 2))
                    if gt(mid, len) { mid := len }
                    if gt(right, len) { right := len }
                    
                    // Merge hai đoạn [left, mid) và [mid, right)
                    let i := left
                    let j := mid
                    let k := left
                    
                    for {} and(lt(i, mid), lt(j, right)) { k := add(k, 1) } {
                        let a := mload(add(tempPtr, mul(i, 32)))
                        let b := mload(add(tempPtr, mul(j, 32)))
                        // So sánh và g chọn giá trị nhỏ hơn
                        if lt(a, b) {
                            mstore(add(dataPtr, mul(k, 32)), a)
                            i := add(i, 1)
                        }
                        if iszero(lt(a, b)) {
                            mstore(add(dataPtr, mul(k, 32)), b)
                            j := add(j, 1)
                        }
                    }
                    
                    // Copy phần còn lại của [left, mid)
                    for {} lt(i, mid) { i := add(i, 1) } {
                        mstore(add(dataPtr, mul(k, 32)), mload(add(tempPtr, mul(i, 32))))
                        k := add(k, 1)
                    }
                    
                    // Copy phần còn lại của [mid, right)
                    for {} lt(j, right) { j := add(j, 1) } {
                        mstore(add(dataPtr, mul(k, 32)), mload(add(tempPtr, mul(j, 32))))
                        k := add(k, 1)
                    }
                    
                    // Sao chép ngược lại từ arr sang temp cho bước tiếp theo
                    for { let x := left } lt(x, right) { x := add(x, 1) } {
                        mstore(add(tempPtr, mul(x, 32)), mload(add(dataPtr, mul(x, 32))))
                    }
                }
            }
        }
        
        return arr;
    }
    
    function isSorted(uint256[] memory arr) 
        internal 
        pure 
        returns (bool) 
    {
        if (arr.length <= 1) return true;
        
        assembly {
            let dataPtr := add(arr, 32)
            let len := mload(arr)
            
            for { let i := 0 } lt(i, sub(len, 1)) { i := add(i, 1) } {
                let a := mload(add(dataPtr, mul(i, 32)))
                let b := mload(add(dataPtr, mul(add(i, 1), 32)))
                if gt(a, b) {
                    return(0, 0) // false
                }
            }
        }
        return true;
    }
}