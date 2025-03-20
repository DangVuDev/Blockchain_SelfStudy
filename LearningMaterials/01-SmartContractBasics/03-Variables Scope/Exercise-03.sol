// 3. Global Variables & Blockchain Info (Advanced Level)
// 📌 Task:
// Create a smart contract called GlobalVarExample with a function getBlockInfo() that retrieves blockchain-related data.

// 🔹 Requirements:

// Use global variables to return the following blockchain data:
// block.timestamp (current block timestamp)
// block.number (current block number)
// msg.sender (caller’s address)
// The function should return all three values in a tuple.
// 🚀 Goal: Understand how to access blockchain-specific information using global variables.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract GlobalVarExample{
    event BlockInfoRetrieved(uint256 timestamp, uint256 blockNumber, address sender);

    function getBlockInfo() public view returns (
    uint256 timestamp, 
    uint256 blockNumber, 
    address sender
    ) {
        timestamp = block.timestamp;
        blockNumber = block.number;
        sender = msg.sender;
        return (timestamp,blockNumber,sender);
    }
}