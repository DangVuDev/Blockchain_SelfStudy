// Exercise 2: Struct and Mapping for Token Balances
// 💡 Objective: Practice using structs and mappings to store complex data types.

// Requirements:
// Create a contract named TokenManager.
// Define a struct called TokenBalance with:
// uint256 amount (balance of tokens)
// bool isActive (whether the account is active)
// Create a mapping(address => TokenBalance) to track token balances of different addresses.
// Implement a function deposit() that updates the sender’s token balance and activates the account.
// Implement a function withdraw() that decreases the sender’s balance but ensures they do not withdraw more than they own.
// Implement a function getBalance(address user) to return the user's token balance and status.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract TokenManager{

    event Withdrawal(address indexed user, uint256 amount);

    struct TokenBalance {
        uint256  amount;
        bool  isActive;
    }
    mapping(address => TokenBalance) public tokenManager;
    mapping(address => bool) private userAlreadyExists;

    modifier onlyOwnerToken(){
        require(msg.sender != address(0),"Avali address");
        require(userAlreadyExists[msg.sender] && tokenManager[msg.sender].isActive,"User not exits");
        _;
    }
    /// @notice Khởi tạo số dư token cho người dùng
    function createTokenBalance() public {
        require(!userAlreadyExists[msg.sender], "User already exists");
        userAlreadyExists[msg.sender] = true;
        tokenManager[msg.sender].isActive = true;
    }

    /// @notice Gửi Ether vào hợp đồng
    function deposit() public payable onlyOwnerToken {
        unchecked {
            tokenManager[msg.sender].amount += msg.value;
        }
    }

    /// @notice Rút Ether từ hợp đồng
    /// @param amount Số tiền muốn rút
    function withdraw(uint256 amount) public onlyOwnerToken {
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= tokenManager[msg.sender].amount, "Insufficient balance");

        tokenManager[msg.sender].amount -= amount;
        (bool status,) = payable(msg.sender).call{value: amount}("");
        require(status, "Withdrawal failed");
        emit Withdrawal(msg.sender,amount);
    }

    /// @notice Lấy số dư của người dùng
    function getBalance(address user) public view returns (uint256) {
        require(userAlreadyExists[user], "User does not exist");
        return tokenManager[user].amount;
    }
    
}
