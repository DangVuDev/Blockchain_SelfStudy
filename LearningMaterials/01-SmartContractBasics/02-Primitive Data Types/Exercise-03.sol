// Exercise 3: String Manipulation and Hashing
// 💡 Objective: Learn how to handle string operations and cryptographic hashing in Solidity.

// Requirements:
// Create a contract called StringHasher.
// Implement a function hashString(string memory input) that returns the keccak256 hash of the input string.
// Implement a function compareStrings(string memory str1, string memory str2) that returns true if both strings are identical, false otherwise.
// Implement a function storeMessage(string memory message) that stores the hashed version of the message.
// Add a function verifyMessage(string memory input) that checks if the provided string matches the stored hash.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract StringHasher {
    bytes32 public stringHash;

    /// @notice Băm một chuỗi bằng Keccak256
    /// @param input Chuỗi cần băm
    /// @return Giá trị băm dưới dạng bytes32
    function hashString(string memory input) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(input));
    }

    /// @notice So sánh hai chuỗi bằng cách băm
    /// @param str1 Chuỗi thứ nhất
    /// @param str2 Chuỗi thứ hai
    /// @return true nếu hai chuỗi giống nhau, ngược lại false
    function compareStrings(string memory str1, string memory str2) external pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    event HashStored(address indexed sender, bytes32 hash);

    function storeMessage(string memory message) public {
        stringHash = hashString(message);
        emit HashStored(msg.sender, stringHash);
    }

    /// @notice Kiểm tra xem chuỗi nhập vào có khớp với chuỗi đã lưu hay không
    /// @param input Chuỗi cần kiểm tra
    /// @return true nếu khớp, ngược lại false
    function verifyMessage(string memory input) public view returns (bool) {
        return hashString(input) == stringHash;
    }
}
