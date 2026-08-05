# Blockchain-Based Secure Certificate Verification System

A simple, working implementation of **Project 1** from the RISE Internship
(Blockchain & Web3 Development) project list.

## What's inside
- `CertificateVerification.sol` — the smart contract (Solidity)
- `index.html` — the web frontend (MetaMask + ethers.js), works by just opening it in a browser
- This README — step-by-step setup

## How it works
1. The **institution (admin)** deploys the contract. The deploying wallet becomes admin.
2. The admin issues a certificate by entering student name, course, and institution.
   The contract generates a unique **Certificate ID** (a hash) and stores the record on-chain.
3. Anyone (an employer, for example) can paste that Certificate ID into the
   verification box and instantly see if it's valid — no wallet or gas fee needed to verify.
4. If a certificate was issued by mistake or found fraudulent, the admin can revoke it.

## Step-by-step setup (about 10 minutes)

### 1. Get test ETH and set up MetaMask
- Install the [MetaMask](https://metamask.io/) browser extension and create a wallet.
- Switch MetaMask's network to **Sepolia** test network (enable "Show test networks" in Settings if needed).
- Get free test ETH from a faucet, e.g. https://sepoliafaucet.com or https://www.alchemy.com/faucets/ethereum-sepolia

### 2. Deploy the smart contract using Remix IDE
1. Go to https://remix.ethereum.org
2. Create a new file, paste in the contents of `CertificateVerification.sol`.
3. Open the **Solidity Compiler** tab → select compiler version `0.8.19` or higher → click **Compile**.
4. Open the **Deploy & Run Transactions** tab.
5. Set **Environment** to `Injected Provider - MetaMask` (this connects Remix to your MetaMask wallet on Sepolia).
6. Click **Deploy** and confirm the transaction in MetaMask.
7. Once deployed, copy the **contract address** shown under "Deployed Contracts".

### 3. Run the frontend
1. Open `index.html` in your browser (just double-click it, or use a local server).
2. Paste the contract address into **Step 1: One-time setup** and click "Save Contract Address".
3. Click **Connect MetaMask** (make sure MetaMask is on Sepolia).
4. As the admin wallet, fill in the **Issue Certificate** form and click issue — confirm the transaction in MetaMask.
5. Copy the generated **Certificate ID** and give it to the certificate holder.
6. Anyone can paste that ID into the **Verify Certificate** box (no wallet needed) to confirm it's genuine.

> Note: `index.html` includes a public RPC fallback (`https://rpc.sepolia.org`) so verification
> works even for visitors without MetaMask installed. If that public endpoint is slow or down,
> you can swap it for a free RPC URL from https://www.infura.io or https://www.alchemy.com.

## Requirements checklist (from the project brief)
- ✅ Smart contract for certificate issuance
- ✅ Unique certificate ID generation (keccak256 hash)
- ✅ Certificate data stored on-chain (immutable)
- ✅ Web interface for verification
- ✅ MetaMask wallet integration
- ✅ Admin-only role for issuing certificates
- ✅ Public verification without needing to trust a central server
- ✅ Deployable on an Ethereum test network (Sepolia)

## Possible extensions
- Store the certificate as an IPFS-hosted PDF and save only its hash on-chain (cheaper + tamper-proof file storage).
- Add a searchable admin dashboard listing all issued certificates (`totalCertificates()` is already exposed).
- Add expiry dates for certificates that need periodic renewal.
