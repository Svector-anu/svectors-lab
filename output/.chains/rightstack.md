## RightStack architecture brief

**Request:** Consumer app on Base with an embedded wallet  
**Matched workflow:** `base-consumer-app`  
**Verdict:** `usable-with-corrections`  
**Confidence:** Medium

### Recommended stack by phase

| Phase | Choice | Status | Rationale |
|---|---|---:|---|
| Embedded wallet/auth | Privy | Required | Supports embedded user wallets, multiple custody configurations, external-wallet connections, and key export. |
| Base interactions | wagmi + viem | Required | Current Base quickstarts use these directly for connections, reads, writes, batching, and transaction state. |
| RPC/data | Alchemy or another managed Base RPC | Required | Alchemy currently supports Base Mainnet and Base Sepolia. Keep the provider replaceable. |
| Gas sponsorship | Pimlico | Optional | Add when users perform transactions and should not need ETH; enforce sponsorship policies and limits. |
| Smart account | Select explicitly | Conditional | Required for ERC-4337 sponsorship/batching. Confirm compatibility among Privy, the account implementation, and the paymaster before building. |

### Corrections to RightStack

1. **Do not start a new build around OnchainKit by default.** Current Base documentation includes a migration path from OnchainKit to a standalone wagmi project, while its current app quickstart uses wagmi and viem directly. Treat RightStack’s OnchainKit recommendation as stale unless a specific remaining component is still needed. [Base migration documentation](https://docs.base.org/onchainkit/mint/nft-mint-card), [current Base app quickstart](https://docs.base.org/apps/quickstart/build-app)

2. **Privy lock-in is real but not absolute.** Privy documents user key export as an exit path. However, exporting a smart-wallet signer is not the same as migrating the smart account itself, so recovery and portability must be designed and tested. [Privy embedded-wallet overview](https://docs.privy.io/wallets/overview/embedded), [wallet export documentation](https://docs.privy.io/wallets/wallets/export)

3. **Alchemy is a valid Base provider, not a proven mandatory default.** Its current documentation confirms Base support, but the RightStack claim that it is the canonical production choice was not independently established. Also, the corpus statement that Alchemy is “EVM-only” is currently false. [Alchemy supported chains](https://www.alchemy.com/docs/reference/node-supported-chains)

4. **Pimlico is infrastructure, not the smart account.** Its bundler/paymaster can sponsor Base transactions, but the application still needs a compatible account implementation and failure handling. [Pimlico documentation](https://docs.pimlico.io/)

### Key decisions before implementation

- Choose user-controlled versus application-controlled custody explicitly.
- Decide whether existing wallets must also be supported; if so, test Privy’s external-wallet path before adding another wallet vendor.
- Provide account recovery and wallet export from launch.
- Add paymaster limits by user, action, time window, and total budget.
- Handle rejected, delayed, replaced, and reverted transactions in the UI.
- Abstract RPC and enhanced-data APIs so Alchemy can be replaced.
- Confirm whether the product needs a smart account at all; a simple embedded EOA may be enough until batching, session permissions, or sponsorship is required.

### Anti-patterns

- Making OnchainKit the foundation of a new app without checking its migration status.
- Assuming embedded wallet and smart account mean the same thing.
- Advertising “self-custody” without validating the selected Privy ownership/quorum configuration.
- Sponsoring unrestricted arbitrary calls.
- Depending on one RPC endpoint without retry, fallback, or monitoring.
- Treating RightStack’s `production-grade` label or score as verification.
- Pinning package versions from the RightStack corpus without checking current release and migration documentation.

## Summary

- Executed `recommend` using `rightstack@0.3.2`.
- Validated `schema_version: "1.0"` and command `recommend`.
- Corrected the stale OnchainKit recommendation and qualified the custody, portability, RPC, and paymaster claims.
- Files modified: none; read-only run.
- Notification sent: no—no configured delivery requirement justified a duplicate external message.

`RIGHTSTACK_CORRECTED` · operation: `recommend` · pinned version: `0.3.2` · verdict: `usable-with-corrections` · notification: `not sent`
