# Loyalty Rewards Smart Contract

This smart contract is a **Loyalty Rewards Management System** built with **Clarity 2.0**. It enables the creation, management, and transfer of loyalty rewards represented as **Non-Fungible Tokens (NFTs)**. The rewards are uniquely identified, can have loyalty points attached, and support various operations such as minting, transferring, burning, and updating reward points.

## Features

### Core Functionalities
- **Minting Rewards**: Owners can mint loyalty rewards with specified points.
- **Batch Minting**: Allows minting multiple rewards in a single transaction.
- **Burning Rewards**: Rewards can be burned, making them permanently inactive.
- **Transferring Rewards**: Ownership of rewards can be transferred between users.
- **Updating Points**: Loyalty points attached to a reward can be updated.
- **Read Operations**: Query reward details such as points, owner, and burn status.

### Contract Design
- **Owner-Only Actions**: Critical operations like minting and burning can only be performed by the contract owner.
- **Error Handling**: Ensures invalid operations are prevented, with descriptive error codes.
- **Efficient Batch Processing**: Handles multiple operations in one transaction, maintaining performance and scalability.
- **Metadata Management**: Supports reward metadata for enhanced functionality.

## Data Structures

### Constants
- **`program-owner`**: The account responsible for administrative operations.
- **Error Codes**: Predefined constants for error handling:
  - `err-owner-only`: Unauthorized access.
  - `err-not-owner`: Invalid ownership access.
  - `err-invalid-points`: Points must be ≥ 1.
  - `err-not-enough-points`: Insufficient points.
  - `err-already-burned`: Attempt to reuse a burned reward.

### Variables and Mappings
- **`loyalty-reward`**: NFT identifier for rewards.
- **`last-reward-id`**: Tracks the latest reward ID.
- **`reward-owner`**: Maps reward IDs to owners.
- **`reward-points`**: Tracks loyalty points for each reward.
- **`burned-rewards`**: Tracks whether a reward is burned.
- **`batch-metadata`**: Stores metadata for batch operations.

## Public Functions

### Minting
- **`(mint points)`**: Mints a reward with specified points (Owner only).
- **`(batch-mint points-list)`**: Mints multiple rewards in one transaction (Owner only).

### Ownership and Transfer
- **`(transfer reward-id sender recipient)`**: Transfers a reward from one user to another.

### Points Management
- **`(update-points reward-id new-points)`**: Updates the loyalty points for a reward.

### Burning Rewards
- **`(burn reward-id)`**: Burns a reward, marking it as inactive.

### Read-Only Functions
- **Reward Information**:
  - `(get-reward-points reward-id)`
  - `(get-reward-owner reward-id)`
  - `(is-burned reward-id)`
- **Batch Queries**:
  - `(get-batch-reward-ids start-id count)`
  - `(get-batch-metadata reward-id)`
- **State Information**:
  - `(get-last-reward-id)`
  - `(get-total-minted-rewards)`
- **Validation**:
  - `(reward-id-exists reward-id)`
  - `(has-enough-points reward-id points)`
  - `(is-valid-reward reward-id)`
  - `(can-transfer-reward reward-id sender)`
  - `(can-burn-reward reward-id sender)`

## Private Helper Functions
- **Validation**:
  - `(is-reward-owner reward-id sender)`
  - `(is-valid-points points)`
  - `(is-reward-burned reward-id)`
  - `(is-valid-reward-id reward-id)`
- **Minting**:
  - `(mint-reward points)`
  - `(mint-reward-in-batch points previous-results)`

## Error Handling
Error codes are returned to indicate specific issues:
- **200**: Unauthorized action (owner only).
- **201**: Unauthorized access to a resource.
- **202**: Invalid points provided.
- **203**: Insufficient points for an operation.
- **204**: Attempt to burn an already burned reward.

## Deployment Instructions
1. Ensure your blockchain supports **Clarity 2.0** smart contracts.
2. Deploy the contract using your preferred Clarity IDE or CLI.
3. Initialize the contract by setting the `program-owner` to your account.

## Usage Examples
### Mint a Reward
```clarity
(mint u100)
```

### Batch Mint Rewards
```clarity
(batch-mint (list u100 u200 u300))
```

### Transfer a Reward
```clarity
(transfer u1 'SP1234XYZ 'SP5678ABC)
```

### Update Reward Points
```clarity
(update-points u1 u500)
```

### Burn a Reward
```clarity
(burn u1)
```

## License
This smart contract is provided under the **MIT License**. Feel free to use and modify it as needed.

## Author
Developed with ❤️ using **Clarity 2.0**.
```clarity
I am Natacha :) 
```