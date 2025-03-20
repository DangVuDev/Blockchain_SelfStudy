# Constants and Immutable in Solidity

## Introduction
In Solidity, `constant` and `immutable` are two keywords used to define variables that do not change after their initial assignment. These keywords help optimize gas usage and improve contract security.

### 1. **Constants**
- Declared using the `constant` keyword.
- Must be assigned a value at the time of declaration.
- Values are stored in the contract’s bytecode (not in storage), reducing gas costs.
- Typically used for fixed values like token names, decimals, or mathematical constants.

#### **Example:**
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ConstantExample {
    uint256 public constant MAX_SUPPLY = 1000000; // Fixed token supply
}
```

### 2. **Immutable**
- Declared using the `immutable` keyword.
- Must be assigned a value in the constructor.
- Cannot be changed after deployment.
- Uses less gas than regular state variables.

#### **Example:**
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ImmutableExample {
    address public immutable OWNER;
    
    constructor() {
        OWNER = msg.sender; // Set at deployment, cannot change later
    }
}
```

---

## **4 Solidity Challenges (Increasing Difficulty)**

### **1. Basic Level (Constants)**
📌 **Task:** Create a smart contract `MathConstants` that defines and returns the value of Pi (`3.1415926535`) as a `constant`.

🔹 **Requirements:**
- Define a `constant` variable `PI`.
- Implement a function `getPi()` that returns `PI`.

🚀 **Goal:** Learn how to declare and use constant values.

---

### **2. Intermediate Level (Immutable)**
📌 **Task:** Create a smart contract `ContractDeployer` that stores the deployer’s address as `immutable` and allows querying it.

🔹 **Requirements:**
- Declare an `immutable` variable `DEPLOYER`.
- Assign it in the constructor.
- Implement a function `getDeployer()` to return `DEPLOYER`.

🚀 **Goal:** Understand how to set values in the constructor and prevent future modification.

---

### **3. Advanced Level (Combining Constants & Immutable)**
📌 **Task:** Create a contract `TokenInfo` that stores a token’s name (`constant`), symbol (`constant`), and owner (`immutable`).

🔹 **Requirements:**
- Define `constant` variables `TOKEN_NAME` and `TOKEN_SYMBOL`.
- Define an `immutable` variable `OWNER` assigned in the constructor.
- Implement a function `getTokenDetails()` that returns all three values.

🚀 **Goal:** Apply both `constant` and `immutable` for efficiency and security.

---

### **4. Expert Level (Gas Optimization Challenge)**
📌 **Task:** Optimize gas usage in a smart contract that requires storing a constant tax rate (`constant`) and the deployer’s address (`immutable`).

🔹 **Requirements:**
- Declare `constant` variable `TAX_RATE` (e.g., `5%`).
- Declare `immutable` variable `DEPLOYER`.
- Implement a function `calculateTax(uint256 amount)` that returns `amount * TAX_RATE / 100`.
- Implement a function `getDeployer()` that returns `DEPLOYER`.

🚀 **Goal:** Understand how `constant` and `immutable` reduce gas consumption in smart contracts.

---

## **Conclusion**
Using `constant` and `immutable` helps optimize Solidity smart contracts by reducing gas costs and enforcing immutability. These concepts are essential for writing efficient and secure blockchain applications.

