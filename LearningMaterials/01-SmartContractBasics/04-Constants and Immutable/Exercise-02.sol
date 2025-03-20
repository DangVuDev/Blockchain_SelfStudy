// 2. Immutable Constructor Logic (Harder)
// 📌 Task:
// Create a contract ImmutableVault that secures an immutable withdrawal limit.

// 🔹 Requirements:

// Declare an immutable variable withdrawLimit.
// Set withdrawLimit inside the constructor.
// Implement a function canWithdraw(uint256 amount) that returns true if amount does not exceed withdrawLimit, otherwise returns false.
// 🚀 Goal: Understand how immutable variables enforce contract constraints once deployed.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ImmutableVault {
    uint256 public immutable withdrawLimit;

    constructor (uint256 _withdrawLimit){
        withdrawLimit = _withdrawLimit;
    }

    function canWithdraw(uint256 amount) public view returns (bool)
    {
        return amount <= withdrawLimit;
    }
}

contract TestImmutableVault {
    ImmutableVault public vault;

    constructor() {
        vault = new ImmutableVault(500); // Giới hạn rút là 500
    }

    function test() public view returns (bool) {
        //return vault.canWithdraw(400); // Trả về true
        return vault.canWithdraw(600); // Trả về false
    }
}