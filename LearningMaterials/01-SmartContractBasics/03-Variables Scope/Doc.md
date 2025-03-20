# Variable Scope in Solidity

## Introduction
In Solidity, **variable scope** defines where a variable can be accessed or modified within a smart contract. Understanding variable scope is crucial for writing efficient, secure, and well-structured smart contracts. There are three main types of variables in Solidity:

1. **Local Variables**
2. **State Variables**
3. **Global Variables**

---

## 1. Local Variables
### Definition
Local variables are **declared inside functions** and exist only during the execution of that function. They **are not stored on the blockchain**, which makes them gas-efficient.

### Example
```solidity
pragma solidity ^0.8.0;

contract LocalExample {
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 sum = a + b; // Local variable
        return sum;
    }
}
```
🔹 The variable `sum` exists only within the `add` function and is destroyed after execution.

---

## 2. State Variables
### Definition
State variables are **declared outside functions** and are **stored permanently on the blockchain**. They retain their values between function calls.

### Example
```solidity
pragma solidity ^0.8.0;

contract StateExample {
    uint256 public totalSupply; // State variable

    function mint(uint256 amount) public {
        totalSupply += amount;
    }
}
```
🔹 The variable `totalSupply` persists even after the function execution.

---

## 3. Global Variables
### Definition
Global variables provide **information about the blockchain and transaction context**. These variables are **predefined in Solidity** and accessible without declaration.

### Common Global Variables
| Variable          | Description                   |
|----------         |-------------                  |
| `msg.sender`      | Address of the function caller |
| `block.timestamp` | Timestamp of the current block |
| `block.number`    | Current block number          |
| `tx.gasprice`     | Gas price of the transaction  |

### Example
```solidity
pragma solidity ^0.8.0;

contract GlobalExample {
    function getBlockInfo() public view returns (uint256, address) {
        return (block.number, msg.sender);
    }
}
```
🔹 `block.number` provides the current block number, and `msg.sender` returns the caller’s address.

---

## Summary
| Type | Declared | Storage | Lifetime | Example |
|------|---------|---------|----------|---------|
| **Local** | Inside function | Not stored | Temporary | `uint sum = a + b;` |
| **State** | Outside function | Blockchain | Permanent | `uint totalSupply;` |
| **Global** | Built-in | Blockchain | Dynamic | `msg.sender`, `block.timestamp` |

Mastering **variable scope** helps optimize gas fees and enhances security in Solidity smart contracts. 🚀

