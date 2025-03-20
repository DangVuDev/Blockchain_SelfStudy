// 2. State Variables & Blockchain Storage (Intermediate Level)
// 📌 Task:
// Create a smart contract called StateVarExample with the following functionalities:

// 🔹 Requirements:

// Declare a state variable uint256 public totalSupply to track the total token supply.
// Implement a function mintTokens(uint256 amount) that increases totalSupply.
// Implement a function burnTokens(uint256 amount) that decreases totalSupply.
// Ensure burnTokens() does not allow totalSupply to go below 0 (use require).
// 🚀 Goal: Learn how state variables store data permanently on the blockchain.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract StateVarExample{
    address public owner;
    uint256 public totalSupply;

    event TokensMinted(address indexed owner, uint256 amount);
    event TokensBurned(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    constructor() {
        owner = msg.sender; // ✅ Gán luôn cho người triển khai hợp đồng
    }

    function mintTokens(uint256 amount) public onlyOwner {
        totalSupply += amount;
        emit TokensMinted(msg.sender, amount); // ✅ Thêm event
    }

    function burnTokens(uint256 amount) public onlyOwner {
        require(amount <= totalSupply, "Burn amount exceeds total supply."); // ✅ Bổ sung thông báo lỗi rõ ràng
        totalSupply -= amount;
        emit TokensBurned(msg.sender, amount); // ✅ Thêm event
    }
}