// 1. Advanced Constant Usage (Hard)
// 📌 Task:
// Create a smart contract GasOptimizedMath that leverages constants for gas efficiency.

// 🔹 Requirements:

// Declare two uint256 constants:
// MULTIPLIER = 10**18
// DIVISOR = 1_000
// Implement a function calculate(uint256 amount) that:
// Multiplies amount by MULTIPLIER.
// Divides the result by DIVISOR.
// Returns the final computed value.
// 🚀 Goal: Learn how constants optimize gas costs by preventing unnecessary storage access.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract GasOptimizedMath
{
    uint256 public constant  MULTIPLIER = 10**18;
    uint256 public constant  DIVISOR = 1_000;

    function calculate(uint256 amount) external pure returns (uint256 result) {
        assembly {
            let product := mul(amount, MULTIPLIER)
            result := div(product, DIVISOR)
        }
    }

}

