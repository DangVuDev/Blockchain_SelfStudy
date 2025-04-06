//  Challenge 3: Efficient String Comparison via Calldata

// Objective:

// Compare two string values efficiently using calldata.

// Requirements:

// Implement compareStrings(string calldata str1, string calldata str2) external pure returns (bool).

// Optimize for gas efficiency by leveraging keccak256 hashing.

// Ensure the function works for strings of any length without excessive memory allocation.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Comparison
{
    function compareStrings(string calldata str1, string calldata str2) external pure returns (bool)
    {
        return keccak256(abi.encodePacked(str1)) ==keccak256(abi.encodePacked(str2));
    }
}