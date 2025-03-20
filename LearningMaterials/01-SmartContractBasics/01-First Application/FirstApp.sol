// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Counter {
    int256 private count;
    // Function to increment count by 1
    function increment() public {
        ++count;
    }
    // Function to decrement count by 1
    function decrement() public {
        ++count;
    }
    //Function to view value of count.
    function viewCountValue() public view returns(int256){
        return count;
    }
}