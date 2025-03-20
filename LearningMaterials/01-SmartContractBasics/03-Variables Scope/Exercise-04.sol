// 4. Combining Local, State, and Global Variables (Expert Level)
// 📌 Task:
// Develop a comprehensive smart contract called CompleteVariableExample, which integrates local, state, and global variables.

// 🔹 Requirements:

// Declare a state variable owner to store the contract deployer’s address.
// Implement a function storeTempData(uint256 data) that:
// Uses a local variable to store data.
// Returns the stored value but does not modify any state variables.
// Implement a function getBlockchainInfo() that:
// Returns block.timestamp, block.number, and msg.sender using global variables.
// The owner should be assigned as msg.sender when the contract is deployed.
// 🚀 Goal: Learn to combine all three types of variables in a real-world Solidity contract.