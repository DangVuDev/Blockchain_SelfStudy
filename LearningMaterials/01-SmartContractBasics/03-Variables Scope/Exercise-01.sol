// 1. Local Variables & Function Scope (Beginner Level)
// 📌 Task:
// Create a smart contract called LocalVarExample with a function calculateSum(uint256 a, uint256 b).

// 🔹 Requirements:

// Declare a local variable to store the sum of a and b.
// The sum should not be stored on the blockchain.
// If the sum exceeds 100, return 100; otherwise, return the sum.
// 🚀 Goal: Understand how local variables work and why they are not stored on the blockchain.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract LocalVarExample{
    function calculateSum(uint256 a, uint256 b) public pure returns (uint256 sum) {
        require(a <= 100 && b <= 100, "Numbers must be 100 or less."); 
        
        assembly {
            sum := add(a, b)
        }

        if (sum > 100) {
            return 100;
        }
        return sum;
    } 
}
