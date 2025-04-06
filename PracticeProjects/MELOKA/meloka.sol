// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// // Import OpenZeppelin contracts using GitHub URLs (for Remix)
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.9/contracts/token/ERC20/ERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.9/contracts/token/ERC20/extensions/ERC20Capped.sol";

// // Interface for MELOKA Stock
// interface IMELOKAStock {
//     function issueStock(address to, uint256 amount, uint256 lockTime) external; 
//     function payDividend() external payable;
//     function createProposal(string calldata description, uint256 duration) external;
//     function vote(uint256 proposalId, bool voteYes) external;
//     function executeProposal(uint256 proposalId) external;
    
//     // View functions
//     function getAvailableBalance(address owner) external view returns (uint256);
//     function getLockedBalance(address owner) external view returns (uint256);
//     function getAllLocksForAddress(address owner) external view returns (uint256[] memory amounts, uint256[] memory releaseTimes);
//     function getProposalDetails(uint256 proposalId) external view returns (
//         string memory description,
//         uint256 voteCountYes,
//         uint256 voteCountNo,
//         uint256 endTime,
//         bool executed
//     );
//     function getDividendHistory() external view returns (
//         uint256[] memory amounts,
//         uint256[] memory totalSupplies,
//         uint256[] memory timestamps
//     );
//     function getAdmins() external view returns (address[] memory);
//     function _name() external view returns (string memory);
//     function _symbol() external view  returns (string memory);
//     function _decimals() external view  returns (uint8);
//     function _totalSupply() external view  returns (uint256);
//     function _balanceOf(address account) external view  returns (uint256);
//     function _transfer(address to, uint256 value) external returns (bool);
    
//     // Events
//     event StockIssued(address indexed to, uint256 amount, uint256 lockTime);
//     event DividendPaid(address indexed to, uint256 amount);
//     event DividendCreated(address indexed admin, uint256 amount, uint256 snapshotId);
//     event ProposalCreated(uint256 indexed proposalId, string description, uint256 endTime);
//     event Voted(address indexed voter, uint256 indexed proposalId, bool vote, uint256 weight);
//     event ProposalExecuted(uint256 indexed proposalId, uint256 votesYes, uint256 votesNo);
//     event AdminAdded(address indexed admin);
//     event AdminRemoved(address indexed admin);
//     event RequiredSignaturesChanged(uint256 oldValue, uint256 newValue);
//     event StockUnlocked(address indexed owner, uint256 amount);
// }

// contract MELOKAStock is ERC20Capped, IMELOKAStock {
//     // Admin management
//     mapping(address => bool) public admins;
//     address[] private adminList;
//     uint256 public adminCount;
//     uint256 public requiredSignatures;

//     // Locked balances
//     struct Lock {
//         uint256 amount;
//         uint256 releaseTime;
//     }
//     mapping(address => Lock[]) private lockedBalances;
    
//     // Dividend system
//     struct DividendSnapshot {
//         uint256 amount;
//         uint256 totalSupplyAtSnapshot;
//         uint256 timestamp;
//     }
//     DividendSnapshot[] public dividendSnapshots;
//     mapping(address => uint256) public lastClaimedSnapshot;
//     mapping(address => uint256) public claimedDividends;
    
//     // Governance
//     struct Proposal {
//         string description;
//         uint256 voteCountYes;
//         uint256 voteCountNo;
//         uint256 endTime;
//         bool executed;
//         mapping(address => bool) hasVoted;
//     }
//     Proposal[] private proposals;
    
//     // Modifiers
//     modifier onlyAdmin() {
//         require(admins[msg.sender], "MELOKAStock: caller is not an admin");
//         _;
//     }
    
//     modifier proposalExists(uint256 proposalId) {
//         require(proposalId < proposals.length, "MELOKAStock: proposal does not exist");
//         _;
//     }
    
//     constructor(uint256 initialSupply, uint256 capAmount, uint256 requiredSigs) 
//         ERC20("MELOKA Stock", "MLK") 
//         ERC20Capped(capAmount * 10**decimals())
//     {
//         require(requiredSigs > 0, "MELOKAStock: required signatures must be positive");
        
//         admins[msg.sender] = true;
//         adminList.push(msg.sender);
//         adminCount = 1;
//         requiredSignatures = requiredSigs;
        
//         _mint(msg.sender, initialSupply * 10**decimals());
        
//         emit AdminAdded(msg.sender);
//     }
    
//     // Admin management functions
//     function addAdmin(address newAdmin) external onlyAdmin {
//         require(newAdmin != address(0), "MELOKAStock: invalid address");
//         require(!admins[newAdmin], "MELOKAStock: already an admin");
        
//         admins[newAdmin] = true;
//         adminList.push(newAdmin);
//         adminCount++;
        
//         emit AdminAdded(newAdmin);
//     }
    
//     function removeAdmin(address admin) external onlyAdmin {
//         require(adminCount > requiredSignatures, "MELOKAStock: too few admins left");
//         require(admins[admin], "MELOKAStock: not an admin");
//         require(admin != msg.sender, "MELOKAStock: cannot remove self");
        
//         admins[admin] = false;
        
//         // Remove from adminList
//         for (uint256 i = 0; i < adminList.length; i++) {
//             if (adminList[i] == admin) {
//                 adminList[i] = adminList[adminList.length - 1];
//                 adminList.pop();
//                 break;
//             }
//         }
        
//         adminCount--;
//         emit AdminRemoved(admin);
//     }
    
//     function changeRequiredSignatures(uint256 newRequiredSignatures) external onlyAdmin {
//         require(newRequiredSignatures > 0, "MELOKAStock: must be positive");
//         require(newRequiredSignatures <= adminCount, "MELOKAStock: exceeds admin count");
        
//         uint256 oldValue = requiredSignatures;
//         requiredSignatures = newRequiredSignatures;
        
//         emit RequiredSignaturesChanged(oldValue, newRequiredSignatures);
//     }
    
//     // Stock management functions
//     function issueStock(address to, uint256 amount, uint256 lockTime) external override onlyAdmin {
//         require(to != address(0), "MELOKAStock: invalid address");
//         uint256 stockAmount = amount * 10**decimals();
        
//         _mint(to, stockAmount);
        
//         if (lockTime > 0) {
//             // Lock the newly minted stock
//             lockedBalances[to].push(Lock(stockAmount, block.timestamp + lockTime));
            
//             // Emit specific locked stock issuance event
//             emit StockIssued(to, stockAmount, lockTime);
//         } else {
//             emit StockIssued(to, stockAmount, 0);
//         }
//     }
    
//     // Override transfer functions to check for locked balances
//     function _beforeTokenTransfer(address from, address to, uint256 amount) 
//         internal 
//         override(ERC20) 
//     {
//         super._beforeTokenTransfer(from, to, amount);
        
//         // Skip check for minting (from == address(0)) or burning (to == address(0))
//         if (from != address(0) && to != address(0)) {
//             processExpiredLocks(from); // Process expired locks before checking balance
//             require(getAvailableBalance(from) >= amount, "MELOKAStock: transfer amount exceeds unlocked balance");
//         }
//     }
    
//     // Process expired locks before checking balance
//     function processExpiredLocks(address owner) public {
//         Lock[] storage locks = lockedBalances[owner];
//         uint256 i = 0;
        
//         while (i < locks.length) {
//             if (block.timestamp >= locks[i].releaseTime) {
//                 emit StockUnlocked(owner, locks[i].amount);
                
//                 // Remove the lock by replacing with the last one and popping
//                 locks[i] = locks[locks.length - 1];
//                 locks.pop();
//             } else {
//                 i++;
//             }
//         }
//     }
    
//     // Dividend functions
//     function payDividend() external payable override onlyAdmin {
//         require(msg.value > 0, "MELOKAStock: no funds sent");
//         require(totalSupply() > 0, "MELOKAStock: no tokens in circulation");
        
//         uint256 snapshotId = dividendSnapshots.length;
        
//         dividendSnapshots.push(DividendSnapshot({
//             amount: msg.value,
//             totalSupplyAtSnapshot: totalSupply(),
//             timestamp: block.timestamp
//         }));
        
//         emit DividendCreated(msg.sender, msg.value, snapshotId);
//     }
    
//     function claimDividend() external {
//         processExpiredLocks(msg.sender);
        
//         uint256 unclaimed = calculateUnclaimedDividend(msg.sender);
//         require(unclaimed > 0, "MELOKAStock: no dividends to claim");
        
//         // Update state before transfer to prevent reentrancy
//         lastClaimedSnapshot[msg.sender] = dividendSnapshots.length;
//         claimedDividends[msg.sender] += unclaimed;
        
//         // Transfer the dividend
//         (bool sent, ) = msg.sender.call{value: unclaimed}("");
//         require(sent, "MELOKAStock: failed to send dividend");
        
//         emit DividendPaid(msg.sender, unclaimed);
//     }
    
//     function calculateUnclaimedDividend(address shareholder) public view returns (uint256) {
//         uint256 unclaimed = 0;
//         uint256 lastSnapshot = lastClaimedSnapshot[shareholder];
//         uint256 currentBalance = balanceOf(shareholder);
        
//         if (currentBalance == 0 || lastSnapshot >= dividendSnapshots.length) {
//             return 0;
//         }
        
//         for (uint256 i = lastSnapshot; i < dividendSnapshots.length; i++) {
//             DividendSnapshot storage snapshot = dividendSnapshots[i];
//             if (snapshot.totalSupplyAtSnapshot > 0) {
//                 unclaimed += (currentBalance * snapshot.amount) / snapshot.totalSupplyAtSnapshot;
//             }
//         }
        
//         return unclaimed;
//     }
    
//     // Governance functions
//     function createProposal(string calldata description, uint256 duration) 
//         external 
//         override 
//         onlyAdmin 
//     {
//         require(bytes(description).length > 0, "MELOKAStock: empty description");
//         require(duration > 0, "MELOKAStock: duration must be positive");
        
//         uint256 endTime = block.timestamp + duration;
//         uint256 proposalId = proposals.length;
        
//         Proposal storage newProposal = proposals.push();
//         newProposal.description = description;
//         newProposal.endTime = endTime;
        
//         emit ProposalCreated(proposalId, description, endTime);
//     }
    
//     function vote(uint256 proposalId, bool voteYes) 
//         external 
//         override 
//         proposalExists(proposalId) 
//     {
//         Proposal storage proposal = proposals[proposalId];
        
//         require(block.timestamp < proposal.endTime, "MELOKAStock: voting ended");
//         require(!proposal.hasVoted[msg.sender], "MELOKAStock: already voted");
        
//         // Process any expired locks first
//         processExpiredLocks(msg.sender);
        
//         uint256 voterBalance = balanceOf(msg.sender);
//         require(voterBalance > 0, "MELOKAStock: no voting power");
        
//         proposal.hasVoted[msg.sender] = true;
        
//         if (voteYes) {
//             proposal.voteCountYes += voterBalance;
//         } else {
//             proposal.voteCountNo += voterBalance;
//         }
        
//         emit Voted(msg.sender, proposalId, voteYes, voterBalance);
//     }
    
//     function executeProposal(uint256 proposalId) 
//         external 
//         override 
//         onlyAdmin 
//         proposalExists(proposalId) 
//     {
//         Proposal storage proposal = proposals[proposalId];
        
//         require(block.timestamp >= proposal.endTime, "MELOKAStock: voting still active");
//         require(!proposal.executed, "MELOKAStock: already executed");
//         require(proposal.voteCountYes > proposal.voteCountNo, "MELOKAStock: proposal rejected");
        
//         proposal.executed = true;
        
//         emit ProposalExecuted(proposalId, proposal.voteCountYes, proposal.voteCountNo);
//     }
    
//     // View functions
//     function getAvailableBalance(address owner) public view override returns (uint256) {
//         uint256 totalLocked = getLockedBalance(owner);
//         return balanceOf(owner) > totalLocked ? balanceOf(owner) - totalLocked : 0;
//     }
    
//     function getLockedBalance(address owner) public view override returns (uint256) {
//         uint256 lockedAmount = 0;
//         Lock[] storage locks = lockedBalances[owner];
        
//         for (uint256 i = 0; i < locks.length; i++) {
//             if (block.timestamp < locks[i].releaseTime) {
//                 lockedAmount += locks[i].amount;
//             }
//         }
        
//         return lockedAmount;
//     }
    
//     function getAllLocksForAddress(address owner) 
//     external 
//     view 
//     override 
//     returns (uint256[] memory amounts, uint256[] memory releaseTimes) 
//     {
//         Lock[] storage locks = lockedBalances[owner];
        
//         amounts = new uint256[](locks.length);
//         releaseTimes = new uint256[](locks.length);
        
//         for (uint256 i = 0; i < locks.length; i++) {
//             amounts[i] = locks[i].amount;
//             releaseTimes[i] = locks[i].releaseTime;
//         }
        
//         return (amounts, releaseTimes);
//     }
        
//     function getProposalDetails(uint256 proposalId) 
//         external 
//         view 
//         override 
//         proposalExists(proposalId)
//         returns (
//             string memory description,
//             uint256 voteCountYes,
//             uint256 voteCountNo,
//             uint256 endTime,
//             bool executed
//         ) 
//     {
//         Proposal storage proposal = proposals[proposalId];
        
//         return (
//             proposal.description,
//             proposal.voteCountYes,
//             proposal.voteCountNo,
//             proposal.endTime,
//             proposal.executed
//         );
//     }
    
//     function hasVoted(uint256 proposalId, address voter) 
//         external 
//         view 
//         proposalExists(proposalId)
//         returns (bool) 
//     {
//         return proposals[proposalId].hasVoted[voter];
//     }
    
//     function getProposalCount() external view returns (uint256) {
//         return proposals.length;
//     }
    
//     function getDividendHistory() 
//         external 
//         view 
//         override
//         returns (
//             uint256[] memory amounts,
//             uint256[] memory totalSupplies,
//             uint256[] memory timestamps
//         ) 
//     {
//         uint256 length = dividendSnapshots.length;
        
//         amounts = new uint256[](length);
//         totalSupplies = new uint256[](length);
//         timestamps = new uint256[](length);
        
//         for (uint256 i = 0; i < length; i++) {
//             DividendSnapshot storage snapshot = dividendSnapshots[i];
//             amounts[i] = snapshot.amount;
//             totalSupplies[i] = snapshot.totalSupplyAtSnapshot;
//             timestamps[i] = snapshot.timestamp;
//         }
        
//         return (amounts, totalSupplies, timestamps);
//     }
    
//     function getDividendSnapshotCount() external view returns (uint256) {
//         return dividendSnapshots.length;
//     }
    
//     function getAdmins() external view returns (address[] memory) {
//         return adminList;
//     }
    
//     function isAdmin(address account) external view returns (bool) {
//         return admins[account];
//     }
//     function _name() public view returns (string memory) {
//         return super.name();
//     }

//     // Returns the symbol of the token
//     function _symbol() public view  returns (string memory) {
//         return super.symbol();
//     }

//     // Returns the number of decimals used to get its user representation
//     function _decimals() public view  returns (uint8) {
//         return super.decimals();
//     }

//     // Returns the total supply of tokens
//     function _totalSupply() public view  returns (uint256) {
//         return super.totalSupply();
//     }

//     // Returns the balance of a specific address
//     function _balanceOf(address account) public view  returns (uint256) {
//         return super.balanceOf(account);
//     }
//     function _transfer(address to, uint256 value) external returns (bool){
//         return super.transfer(to, value);
//     }
    
//     // Allow contract to receive ETH
//     receive() external payable {}
// }