// Challenge 1: Optimized Storage Structure

// Objective:

// Design a contract that efficiently manages a list of users with dynamic balances.

// Implement batch updates without excessive gas costs.

// Requirements:

// Use mapping(address => uint256) for balances.

// Implement a function batchUpdateBalances(address[] calldata users, uint256[] calldata amounts) that updates multiple users’ balances efficiently.

// Optimize gas consumption by minimizing redundant writes to storage.



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract OptimizedStorageStructure
{
    event BalancesUpdated(address indexed user, uint256 newBalance);
    bytes32 immutable hashEvent = 0x0b7e3e2b5d9d4f8e9b1d2e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b;// keccak256("BalancesUpdated(address,uint256)");
    //
    address public admin = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    //
    mapping(address => uint256) public balances;
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }
    function batchUpdateBalances(address[] calldata users, uint256[] calldata amounts) public {

        require(users.length == amounts.length, "Arrays length mismatch");
        require(users.length > 0, "Empty arrays not allowed");
        assembly {
            // Lấy độ dài mảng
            let length := users.length
            
            // Con trỏ tới dữ liệu của users và amounts trong calldata
            let usersPtr := users.offset
            let amountsPtr := amounts.offset
            
            // Vòng lặp qua mảng
            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                // Load user address từ calldata
                let user := calldataload(add(usersPtr, mul(i, 32)))

                if iszero(user) {
                    revert(0, 0) 
                }

                let newAmount := calldataload(add(amountsPtr, mul(i, 32)))
                
                // Tính slot của balances[user] trong storage
                mstore(0, user)
                mstore(32, balances.slot)
                let slot := keccak256(0, 64)
                
                // Load current balance từ storage
                let currentBalance := sload(slot)
                
                if iszero(eq(currentBalance, newAmount)) {
                    sstore(slot, newAmount)
                    mstore(0, newAmount)
                }
            }
        }
    }
    // Hàm tiện ích để kiểm tra balance
    function getBalance(address user) 
        external 
        view 
        returns (uint256) 
    {
        return balances[user];
    }
}