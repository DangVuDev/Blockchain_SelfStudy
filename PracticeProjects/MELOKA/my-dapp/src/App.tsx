import React, { useState } from "react";
import DatePicker from "react-datepicker";
import {
  getTokenInfo,
  getBalance,
  getAvailableBalance,
  getLockedBalance,
  getAllLocksForAddress,
  getProposalDetails,
  getDividendHistory,
  getAdmins,
  sendToken,
  issueToken,
  createProposal,
  vote,
  executeProposal,
  payDividend,
} from "./utils/contract";
import "./App.css";
import "react-datepicker/dist/react-datepicker.css";

const App: React.FC = () => {
  const [address, setAddress] = useState<string>("");
  const [amount, setAmount] = useState<string>("");
  const [lockTime, setLockTime] = useState<string>("");
  const [proposalId, setProposalId] = useState<string>("");
  const [description, setDescription] = useState<string>("");
  const [duration, setDuration] = useState<Date | null>(null);
  const [voteYes, setVoteYes] = useState<boolean>(true);

  const [tokenInfo, setTokenInfo] = useState<{ name: string; symbol: string; totalSupply: string } | null>(null);
  const [balance, setBalance] = useState<string>("");
  const [availableBalance, setAvailableBalance] = useState<string>("");
  const [lockedBalance, setLockedBalance] = useState<string>("");
  const [locks, setLocks] = useState<{ amounts: string[]; times: string[] } | null>(null);
  const [proposalDetails, setProposalDetails] = useState<[string, string, string, string, boolean] | null>(null);
  const [dividendHistory, setDividendHistory] = useState<{ times: string[]; amounts: string[]; rates: string[] } | null>(null);
  const [admins, setAdmins] = useState<string[]>([]);
  const [sendTokenResult, setSendTokenResult] = useState<string>("");
  const [issueTokenResult, setIssueTokenResult] = useState<string>("");
  const [createProposalResult, setCreateProposalResult] = useState<string>("");
  const [voteResult, setVoteResult] = useState<string>("");
  const [executeProposalResult, setExecuteProposalResult] = useState<string>("");
  const [payDividendResult, setPayDividendResult] = useState<string>("");

  const handleError = (err: any) => err.message;

  const fetchTokenInfo = async () => {
    try {
      const info = await getTokenInfo();
      setTokenInfo(info);
    } catch (err) {
      setTokenInfo({ name: handleError(err), symbol: "", totalSupply: "" });
    }
  };

  const fetchBalance = async () => {
    try {
      const bal = await getBalance(address);
      setBalance(bal.toString());
    } catch (err) {
      setBalance(handleError(err));
    }
  };

  const fetchAvailableBalance = async () => {
    try {
      const bal = await getAvailableBalance(address);
      setAvailableBalance(bal.toString());
    } catch (err) {
      setAvailableBalance(handleError(err));
    }
  };

  const fetchLockedBalance = async () => {
    try {
      const bal = await getLockedBalance(address);
      setLockedBalance(bal.toString());
    } catch (err) {
      setLockedBalance(handleError(err));
    }
  };

  const fetchAllLocks = async () => {
    try {
      const [amounts, times] = await getAllLocksForAddress(address);
      setLocks({ amounts: amounts.map(String), times: times.map(String) });
    } catch (err) {
      setLocks({ amounts: [handleError(err)], times: [] });
    }
  };

  const fetchProposalDetails = async () => {
    try {
      const [desc, yesVotes, noVotes, deadline, executed] = await getProposalDetails(proposalId);
      setProposalDetails([desc, yesVotes.toString(), noVotes.toString(), deadline.toString(), executed]);
    } catch (err) {
      setProposalDetails([handleError(err), "", "", "", false]);
    }
  };

  const fetchDividendHistory = async () => {
    try {
      const [times, amounts, rates] = await getDividendHistory();
      setDividendHistory({
        times: times.map(String),
        amounts: amounts.map(String),
        rates: rates.map(String),
      });
    } catch (err) {
      setDividendHistory({ times: [handleError(err)], amounts: [], rates: [] });
    }
  };

  const fetchAdmins = async () => {
    try {
      const adminsList = await getAdmins();
      setAdmins(adminsList);
    } catch (err) {
      setAdmins([handleError(err)]);
    }
  };

  const handleSendToken = async () => {
    try {
      const txHash = await sendToken(address, BigInt(amount));
      setSendTokenResult(`Success: ${txHash}`);
    } catch (err) {
      setSendTokenResult(handleError(err));
    }
  };

  const handleIssueToken = async () => {
    try {
      const txHash = await issueToken(address, BigInt(amount), BigInt(lockTime));
      setIssueTokenResult(`Success: ${txHash}`);
    } catch (err) {
      setIssueTokenResult(handleError(err));
    }
  };

  const handleCreateProposal = async () => {
    try {
      if (!duration) {
        setCreateProposalResult("Error: Please select a duration");
        return;
      }

      // Lấy thời gian hiện tại (Unix timestamp, đơn vị giây)
      const currentTime = Math.floor(Date.now() / 1000);
      
      // Chuyển duration từ Date sang Unix timestamp (giây)
      const deadline = Math.floor(duration.getTime() / 1000);
      
      // Tính durationInSeconds là khoảng cách từ hiện tại đến deadline
      const durationInSeconds = deadline > currentTime ? deadline - currentTime : 0;
      
      if (durationInSeconds <= 0) {
        setCreateProposalResult("Error: Please select a future time");
        return;
      }

      const txHash = await createProposal(description, durationInSeconds.toString());
      setCreateProposalResult(`Success: ${txHash}`);
    } catch (err) {
      setCreateProposalResult(handleError(err));
    }
  };

  const handleVote = async () => {
    try {
      const txHash = await vote(BigInt(proposalId), voteYes);
      setVoteResult(`Success: ${txHash}`);
    } catch (err) {
      setVoteResult(handleError(err));
    }
  };

  const handleExecuteProposal = async () => {
    try {
      const txHash = await executeProposal(BigInt(proposalId));
      setExecuteProposalResult(`Success: ${txHash}`);
    } catch (err) {
      setExecuteProposalResult(handleError(err));
    }
  };

  const handlePayDividend = async () => {
    try {
      const txHash = await payDividend(BigInt(amount));
      setPayDividendResult(`Success: ${txHash}`);
    } catch (err) {
      setPayDividendResult(handleError(err));
    }
  };

  return (
    <div className="app">
      <header className="app-header">
        <h1>Blockchain Testing Dashboard</h1>
        <p>Interact with your smart contract seamlessly</p>
      </header>
      <main className="grid">
        {/* Read Functions */}
        <section className="card">
          <h2>Get Token Info</h2>
          <button onClick={fetchTokenInfo}>Fetch Info</button>
          {tokenInfo && (
            <div className="result-box">
              <p><strong>Name:</strong> {tokenInfo.name}</p>
              <p><strong>Symbol:</strong> {tokenInfo.symbol}</p>
              <p><strong>Total Supply:</strong> {tokenInfo.totalSupply}</p>
            </div>
          )}
        </section>

        <section className="card">
          <h2>Get Balance</h2>
          <input
            type="text"
            placeholder="Enter address"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
          />
          <button onClick={fetchBalance}>Check Balance</button>
          {balance && <div className="result-box"><p><strong>Balance:</strong> {balance}</p></div>}
        </section>

        <section className="card">
          <h2>Get Available Balance</h2>
          <input
            type="text"
            placeholder="Enter address"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
          />
          <button onClick={fetchAvailableBalance}>Check</button>
          {availableBalance && <div className="result-box"><p><strong>Available:</strong> {availableBalance}</p></div>}
        </section>

        <section className="card">
          <h2>Get Locked Balance</h2>
          <input
            type="text"
            placeholder="Enter address"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
          />
          <button onClick={fetchLockedBalance}>Check</button>
          {lockedBalance && <div className="result-box"><p><strong>Locked:</strong> {lockedBalance}</p></div>}
        </section>

        <section className="card">
          <h2>Get All Locks</h2>
          <input
            type="text"
            placeholder="Enter address"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
          />
          <button onClick={fetchAllLocks}>Fetch Locks</button>
          {locks && (
            <div className="result-box">
              {locks.amounts.map((amt, i) => (
                <p key={i}><strong>Lock {i + 1}:</strong> {amt} (Time: {locks.times[i] || "N/A"})</p>
              ))}
            </div>
          )}
        </section>

        <section className="card">
          <h2>Get Proposal Details</h2>
          <input
            type="text"
            placeholder="Proposal ID"
            value={proposalId}
            onChange={(e) => setProposalId(e.target.value)}
          />
          <button onClick={fetchProposalDetails}>Fetch</button>
          {proposalDetails && (
            <div className="result-box">
              <p><strong>Description:</strong> {proposalDetails[0]}</p>
              <p><strong>Yes Votes:</strong> {proposalDetails[1]}</p>
              <p><strong>No Votes:</strong> {proposalDetails[2]}</p>
              <p><strong>Deadline:</strong> {proposalDetails[3]}</p>
              <p><strong>Executed:</strong> {proposalDetails[4] ? "Yes" : "No"}</p>
            </div>
          )}
        </section>

        <section className="card">
          <h2>Get Dividend History</h2>
          <button onClick={fetchDividendHistory}>Fetch History</button>
          {dividendHistory && (
            <div className="result-box">
              {dividendHistory.times.map((time, i) => (
                <p key={i}><strong>Time {time}:</strong> {dividendHistory.amounts[i]} ETH (Rate: {dividendHistory.rates[i]})</p>
              ))}
            </div>
          )}
        </section>

        <section className="card">
          <h2>Get Admins</h2>
          <button onClick={fetchAdmins}>Fetch Admins</button>
          {admins.length > 0 && (
            <div className="result-box">
              {admins.map((admin, i) => <p key={i}><strong>Admin {i + 1}:</strong> {admin}</p>)}
            </div>
          )}
        </section>

        {/* Write Functions */}
        <section className="card">
          <h2>Send Token</h2>
          <input
            type="text"
            placeholder="To Address"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
          />
          <input
            type="text"
            placeholder="Amount"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
          />
          <button onClick={handleSendToken}>Send</button>
          {sendTokenResult && <div className="result-box"><p>{sendTokenResult}</p></div>}
        </section>

        <section className="card">
          <h2>Issue Token</h2>
          <input
            type="text"
            placeholder="Address"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
          />
          <input
            type="text"
            placeholder="Amount"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
          />
          <input
            type="text"
            placeholder="Lock Time"
            value={lockTime}
            onChange={(e) => setLockTime(e.target.value)}
          />
          <button onClick={handleIssueToken}>Issue</button>
          {issueTokenResult && <div className="result-box"><p>{issueTokenResult}</p></div>}
        </section>

        <section className="card">
          <h2>Create Proposal</h2>
          <input
            type="text"
            placeholder="Description"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
          />
          <DatePicker
            selected={duration}
            onChange={(date: Date | null) => setDuration(date)}
            showTimeSelect
            dateFormat="Pp"
            placeholderText="Select deadline"
            minDate={new Date()} // Giới hạn không chọn thời gian trong quá khứ
            className="date-picker"
          />
          <button onClick={handleCreateProposal}>Create</button>
          {createProposalResult && <div className="result-box"><p>{createProposalResult}</p></div>}
        </section>

        <section className="card">
          <h2>Vote</h2>
          <input
            type="text"
            placeholder="Proposal ID"
            value={proposalId}
            onChange={(e) => setProposalId(e.target.value)}
          />
          <select value={voteYes.toString()} onChange={(e) => setVoteYes(e.target.value === "true")}>
            <option value="true">Yes</option>
            <option value="false">No</option>
          </select>
          <button onClick={handleVote}>Vote</button>
          {voteResult && <div className="result-box"><p>{voteResult}</p></div>}
        </section>

        <section className="card">
          <h2>Execute Proposal</h2>
          <input
            type="text"
            placeholder="Proposal ID"
            value={proposalId}
            onChange={(e) => setProposalId(e.target.value)}
          />
          <button onClick={handleExecuteProposal}>Execute</button>
          {executeProposalResult && <div className="result-box"><p>{executeProposalResult}</p></div>}
        </section>

        <section className="card">
          <h2>Pay Dividend</h2>
          <input
            type="text"
            placeholder="Amount (ETH)"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
          />
          <button onClick={handlePayDividend}>Pay</button>
          {payDividendResult && <div className="result-box"><p>{payDividendResult}</p></div>}
        </section>
      </main>
    </div>
  );
};

export default App;