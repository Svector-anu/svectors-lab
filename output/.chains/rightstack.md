ℹ️ RightStack: Base consumer app architecture

## RightStack brief — Base consumer app with embedded wallet

**Request:** `consumer app on base with embedded wallet`  
**Selected workflow:** `base-consumer-app` (Base, MVP). The route matches the requested chain, application type, and embedded-wallet onboarding model. RightStack confidence is 0.65; that is corpus evidence, not independent validation.

### Recommended stack by phase

- **Required — wallet/auth:** Privy as the leading candidate for email/social/passkey onboarding and embedded wallets. Decide first whether accounts are EOAs or smart accounts, whether external wallets must also connect, and what export/recovery/offboarding guarantee users need. If hybrid embedded + external-wallet support is central, evaluate Dynamic before committing.
- **Required — app/contract client:** **wagmi + viem**, with a custom product UI. This corrects RightStack's OnchainKit recommendation: current Base documentation says OnchainKit is no longer maintained and directs apps to standalone wagmi/viem.
- **Required — chain access/data:** Alchemy is a reasonable candidate for dedicated Base RPC and indexed APIs. Keep provider access behind a thin adapter and add an alternate RPC/failover path; do not expose privileged API credentials in the browser.
- **Optional — gasless transactions:** Add Pimlico only if the product requires sponsored user transactions and only after choosing the smart-account implementation. Enforce allowlisted methods, per-user/per-period limits, simulation, monitoring, and a kill switch. Compare against Alchemy's bundler/gas manager to reduce provider count.

### Confidence and assumptions

**Confidence: medium.** Assumes a React/Next.js EVM app, non-crypto-native users, Base mainnet deployment, user-controlled embedded wallets, and at least some onchain writes. Custody/recovery requirements, geography, transaction volume, contract scope, external-wallet support, and whether gas sponsorship is truly needed are unspecified.

### Tradeoffs and anti-patterns

- Privy improves onboarding but creates identity/wallet-infrastructure lock-in; document key control, export, recovery, deletion, and migration before launch.
- A custom wagmi/viem UI requires more product work than a component kit but avoids adopting an unmaintained dependency.
- Alchemy + Pimlico means two operational dependencies; a single Alchemy AA stack may be simpler, while separate vendors can reduce single-vendor coupling only if failover is actually designed.
- Gas sponsorship improves conversion but creates abuse and budget risk. Never deploy an unlimited paymaster policy.
- Do not require a browser wallet for users the product explicitly intends to onboard through an embedded wallet. Do not use browser auth SDKs for server signing. Do not hardcode wallet addresses or conflate RPC/data APIs with account-abstraction products.

### Verify against primary docs before coding

1. Privy's current Base support; account type and signer/key architecture; export, recovery, deletion, and external-wallet linking; server/client SDK boundaries; pricing and rate limits.
2. Current wagmi/viem package compatibility and the official Base migration guidance away from OnchainKit.
3. Whether the selected Privy account model interoperates with Pimlico's supported Base entry point, bundler, paymaster, and sponsorship-policy APIs; confirm testnet/mainnet support and pricing.
4. Alchemy's current Base RPC/indexing feature matrix, quotas, browser-key restrictions, webhook semantics, and failover behavior.
5. Contract audits, transaction simulation, nonce/replay behavior, session permissions, monitoring, incident controls, privacy/consent, and applicable custody/compliance obligations.

### Verdict

**`usable-with-corrections`** — the workflow match is sound, but replace OnchainKit with wagmi/viem and validate the wallet-to-smart-account-to-paymaster composition before implementation. RightStack's `production-grade` labels and scores are not verification.

Exit: `RIGHTSTACK_CORRECTED` | Operation: `recommend` (implicit build-goal grammar) | Pinned version: `rightstack@0.3.1` | Verdict: `usable-with-corrections` | Notification: attempted