## Deployed Contracts

Network: Ethereum Sepolia
CropBatch Contract: 0x4a91808637A2186b0e24d854bd8Db7D2d75b8F38
Deployed At: 2026-02-05

# Blockchain Module – Supply Chain Event Ledger

## Purpose

This module provides an immutable, verifiable record of physical supply-chain events using blockchain.

---

## What This Module DOES

- Records lifecycle events of crop batches
- Ensures events are append-only and tamper-proof
- Enables auditability and traceability

---

## What This Module DOES NOT Do

- Pricing
- Costs
- Payments
- Inventory management
- ML predictions
- Business rules
- Decision making
- Frontend interaction

---

## On-Chain Data Model

### Core Entity: CropBatch

Stored on-chain:
- batchId (uint256)
- farmerId (string)
- cropType (string)
- location (string)
- timestamp (uint256)
- lifecycleState (enum)

Not stored on-chain:
- Prices
- Quantities
- Sensor data
- Predictions
- Buyer details

---

## Lifecycle Events

| Event | Meaning |
|-----|--------|
| Harvested | Crop accepted from farmer |
| Stored | Entered warehouse |
| Transported | Left warehouse |
| ArrivedAtMarket | Reached buyer / market |

Events are append-only and immutable.

---

## Repository Structure

```
blockchain/
├── abi/
│   └── CropBatchRegistry.json
├── deployments/
│   └── addresses.json
├── contracts/
├── scripts/
├── test/
└── README.md
```

Backend requires only:
- abi/CropBatchRegistry.json
- deployments/addresses.json

---

## Backend Integration

### Load Contract

```ts
import { ethers } from "ethers";
import abi from "./blockchain/abi/CropBatchRegistry.json";
import addresses from "./blockchain/deployments/addresses.json";

const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const contract = new ethers.Contract(
  addresses.testnet,
  abi,
  signer
);
```

---

### Write Events

```ts
await contract.recordHarvest(
  1,
  "FARMER_001",
  "Tomato",
  "Punjab"
);

await contract.recordStored(1, "Warehouse_A");
await contract.recordTransported(1, "Truck_12");
await contract.recordArrivedAtMarket(1, "Delhi Market");
```

---

### Read Events

```ts
contract.on("Harvested", (batchId, farmerId, cropType, location, timestamp) => {
  // update database or cache
});
```

---

## State Reconstruction

Backend can rebuild system state by replaying blockchain events.

---

## Security

- Private keys must never be exposed to frontend
- Blockchain interaction must occur only through backend

---

## Design Principle

Blockchain proves what happened.  
Backend decides what to do about it.

---

## Ownership

Maintained by the Blockchain / Web3 team.
