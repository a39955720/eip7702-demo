# EIP-7702 Local Demo: Batch Approve and Transfer in One Transaction

This project demonstrates how to use [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702) to temporarily upgrade an EOA into a smart account, enabling atomic batch execution in a single transaction. This allows use cases like approve followed immediately by transfer, or approve followed by a Uniswap-style swap, all within one transaction. The workflow runs entirely on a local Foundry anvil network.

## Quick Start

1. Clone the repository

   ```
   git clone https://github.com/a39955720/eip7702-demo
   cd eip7702-demo
   ```

2. Start a local anvil node with the Prague/Pectra hardfork enabled

   ```
   anvil --hardfork prague
   ```

3. Install dependencies

   ```
   forge install foundry-rs/forge-std OpenZeppelin/openzeppelin-contracts
   ```

4. Build and run the tests

   ```
   forge build
   forge test -vvv
   ```

   The tests demonstrate that an EOA can complete both approve and transfer or approve and Uniswap-like swap operations in a single EIP-7702 type-4 transaction.

## Project Structure and How It Works

- `src/BatchApproveTransfer.sol`: Minimal contract that enables batch execution of multiple contract calls through an EIP-7702 delegated EOA.
- `src/MockERC20.sol`: Mock ERC20 contract for demonstration and testing.
- `src/MockUniswapRouter.sol`: Mock Uniswap-like router contract, allowing a swap via `exactInputSingle`. The router will call `transferFrom` on a token, simulating a real Uniswap pool interaction.
- `test/BatchApproveTransfer.t.sol`: Core test file where an EOA (Alice) becomes a temporary smart account using EIP-7702 delegation, then executes approve plus transfer or approve plus swap in a single transaction.
- The process uses the Foundry cheatcode `vm.signAndAttachDelegation` to enable temporary delegation.

## References

- [QuickNode EIP-7702 Guide](https://www.quicknode.com/guides/ethereum-development/smart-contracts/eip-7702-smart-accounts)

---
