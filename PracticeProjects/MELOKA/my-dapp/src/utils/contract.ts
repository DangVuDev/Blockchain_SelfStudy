// src/utils/contract.ts

declare global {
    interface Window {
      ethereum?: any;
    }
  }
// src/utils/contract.ts
import { createPublicClient, createWalletClient, http, custom, defineChain } from "viem";
import { ethers } from "ethers";
import abi from "../abi/token.json";

// Define the Sepolia testnet chain
const chain = defineChain({
  id: 11155111,
  name: "Sepolia",
  network: "sepolia",
  nativeCurrency: { name: "Ether", symbol: "ETH", decimals: 18 },
  rpcUrls: {
    default: { http: [import.meta.env.VITE_RPC_URL || "https://sepolia.infura.io/v3/YOUR_INFURA_KEY"] },
  },
  blockExplorers: {
    default: { name: "Etherscan", url: "https://sepolia.etherscan.io" },
  },
});

  // Validate environment variables
  const contractAddress = import.meta.env.VITE_CONTRACT_ADDRESS;
  const rpcUrl = import.meta.env.VITE_RPC_URL;

  if (!rpcUrl) {
    throw new Error("VITE_RPC_URL is not set in .env");
  }
  if (!contractAddress) {
    throw new Error("VITE_CONTRACT_ADDRESS is not set in .env");
  }

// Create public client for reading from the blockchain
export const publicClient = createPublicClient({
  chain,
  transport: http(rpcUrl),
});

// Create wallet client for writing to the blockchain
export const walletClient = createWalletClient({
  chain,
  transport: window.ethereum ? custom(window.ethereum) : http(),
});

// Create an ethers.js contract instance
export const getContract = () => {
  const provider = new ethers.JsonRpcProvider(rpcUrl);
  return new ethers.Contract(contractAddress, abi, provider);
};

// Interface for token info
interface TokenInfo {
  name: string;
  symbol: string;
  totalSupply: string;
}

// Fetch token information (name, symbol, totalSupply) using individual calls
export const getTokenInfo = async (): Promise<TokenInfo> => {
  try {
    console.log("Fetching token info for contract:", contractAddress);

    // Make individual calls instead of multicall
    const name = await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "_name",
    }) as string;

    const symbol = await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "_symbol",
    }) as string;

    const totalSupply = await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "_totalSupply",
    }) as bigint;

    return {
      name,
      symbol,
      totalSupply: totalSupply.toString(),
    };
  } catch (err) {
    console.error("Error in getTokenInfo:", err);
    throw new Error(`Failed to fetch token info: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};

// Fetch balance for a given address
export const getBalance = async (address: string): Promise<bigint> => {
  try {
    console.log("Fetching balance for address:", address);
    const balance = (await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "_balanceOf",
      args: [address],
    })) as bigint;
    return balance;
  } catch (err) {
    console.error("Error in getBalance:", err);
    throw new Error(`Failed to fetch balance: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};
export const getAvailableBalance = async (address: string): Promise<bigint> => {
  try {
    console.log("Fetching balance for address:", address);
    const balance = (await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "getAvailableBalance",
      args: [address],
    })) as bigint;
    return balance;
  } catch (err) {
    console.error("Error in getAvailableBalance:", err);
    throw new Error(`Failed to fetch getAvailableBalance: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};
export const getLockedBalance = async (address: string): Promise<bigint> => {
  try {
    console.log("Fetching balance for address:", address);
    const balance = (await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "getLockedBalance",
      args: [address],
    })) as bigint;
    return balance;
  } catch (err) {
    console.error("Error in getLockedBalance:", err);
    throw new Error(`Failed to fetch getLockedBalance: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};
export const getAllLocksForAddress = async (address: string): Promise<[bigint[], bigint[]]> => {
  try {
    console.log("Fetching locks for address:", address);
    const balances = await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "getAllLocksForAddress",
      args: [address],
    }) as [bigint[], bigint[]]; // Chỉnh sửa kiểu dữ liệu đúng

    return balances;
  } catch (err) {
    console.error("Error in getAllLocksForAddress:", err);
    throw new Error(`Failed to fetch getAllLocksForAddress: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};

export const getProposalDetails = async (address: string): Promise<[string, bigint, bigint,bigint,boolean]> => {
  try {
    console.log("Fetching balance for address:", address);
    const proposalDetails = await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "getProposalDetails",
      args: [address],
    }) as [string, bigint, bigint,bigint,boolean];
    
    return proposalDetails;
  } catch (err) {
    console.error("Error in getProposalDetails:", err);
    throw new Error(`Failed to fetch getProposalDetails: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};
export const getDividendHistory = async (): Promise<[bigint[], bigint[],bigint[]]> => {
  try {
    const DividendHistory = await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "getDividendHistory",
      args: [],
    }) as [bigint[], bigint[],bigint[]];
    
    return DividendHistory;
  } catch (err) {
    console.error("Error in getDividendHistory:", err);
    throw new Error(`Failed to fetch getDividendHistory: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};

export const getAdmins = async (): Promise<string[]> => {
  try {
    const address = (await publicClient.readContract({
      address: contractAddress,
      abi,
      functionName: "getAdmins",
      args: [],
    })) as string[];
    return address;
  } catch (err) {
    console.error("Error in getAdmins:", err);
    throw new Error(`Failed to fetch getAdmins: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};



















// Send tokens to a recipient
export const sendToken = async (to: string, amount: bigint): Promise<`0x${string}`> => {
  try {
    console.log("Sending tokens to:", to, "Amount:", amount.toString());
    const [account] = await walletClient.getAddresses();
    const txHash = await walletClient.writeContract({
      address: contractAddress,
      abi,
      functionName: "_transfer",
      args: [to, amount],
      account,
    }) as `0x${string}`;
    return txHash;
  } catch (err) {
    console.error("Error in sendToken:", err);
    throw new Error(`Failed to send tokens: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};

export const issueToken = async (address: string, amount: bigint,lockTime: bigint): Promise<`0x${string}`> => {
  try {
    const [account] = await walletClient.getAddresses();
    const txHash = await walletClient.writeContract({
      address: contractAddress,
      abi,
      functionName: "issueStock",
      args: [address, amount,lockTime],
      account,
    }) as `0x${string}`;
    return txHash;
  } catch (err) {
    console.error("Error in issue token:", err);
    throw new Error(`Failed to issue token: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
}
export const createProposal = async (description: string,duration: string): Promise<`0x${string}`> => {
  try {
    const [account] = await walletClient.getAddresses();
    const txHash = await walletClient.writeContract({
      address: contractAddress,
      abi,
      functionName: "createProposal",
      args: [description,duration],
      account,
    }) as `0x${string}`;
    return txHash;
  } catch (err) {
    console.error("Error in createProposal:", err);
    throw new Error(`Failed to createProposal: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
}
export const vote = async (proposalId: bigint,voteYes: boolean): Promise<`0x${string}`> => {
  try {
    const [account] = await walletClient.getAddresses();
    const txHash = await walletClient.writeContract({
      address: contractAddress,
      abi,
      functionName: "vote",
      args: [proposalId,voteYes],
      account,
    }) as `0x${string}`;
    return txHash;
  } catch (err) {
    console.error("Error in vote:", err);
    throw new Error(`Failed to vote: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
}
export const executeProposal = async (proposalId: bigint): Promise<`0x${string}`> => {
  try {
    const [account] = await walletClient.getAddresses();
    const txHash = await walletClient.writeContract({
      address: contractAddress,
      abi,
      functionName: "executeProposal",
      args: [proposalId],
      account,
    }) as `0x${string}`;
    return txHash;
  } catch (err) {
    console.error("Error in executeProposal:", err);
    throw new Error(`Failed to executeProposal: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
}
export const payDividend = async (amount: bigint): Promise<`0x${string}`> => {
  try {
    const [account] = await walletClient.getAddresses();
    
    const txHash = await walletClient.writeContract({
      address: contractAddress,
      abi,
      functionName: "payDividend",
      args: [],  // Không có đối số
      account,
      value: amount, // Số lượng ETH gửi vào contract
    }) as `0x${string}`;

    return txHash;
  } catch (err) {
    console.error("Error in payDividend:", err);
    throw new Error(`Failed to pay dividend: ${err instanceof Error ? err.message : 'Unknown error'}`);
  }
};