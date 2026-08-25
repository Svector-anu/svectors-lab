ℹ️ RightStack: Base consumer app architecture

## RightStack architecture brief

**Request:** consumer app on Base with embedded wallet  
**Selected workflow:** `base-consumer-app` (Base Consumer App Workflow), MVP, adapter confidence 0.65

### Recommended stack by phase

1. **Required — identity and embedded signing:** Privy React SDK, configured for Base. Decide explicitly whether each user gets an EOA only or a Privy-controlled ERC-4337 smart wallet. Preserve an external-wallet/Base Account connection path if existing wallet holders matter.
2. **Required — app interaction layer:** standalone wagmi + viem, with the app's own UI components. **Correction:** do not start a new build on OnchainKit; current Base documentation says it is no longer maintained and documents migration away from it.
3. **Required — chain access:** a dedicated Base RPC/data provider. Alchemy is usable, but it is one supported option rather than a uniquely verified default; Base lists CDP, Alchemy, QuickNode, and others. Use Base Sepolia for testing and a dedicated endpoint for production.
4. **Conditional — gas sponsorship/account abstraction:** start with Privy's native smart-wallet sponsorship if its policies and pricing meet the product's needs. Add Pimlico only if you need its bundler/paymaster capabilities or want that infrastructure boundary explicitly. Enforce per-user, per-action, and global spend limits.
5. **Before launch — application services:** product backend/database, wallet-to-user authorization rules, observability, transaction simulation, recovery/support flows, abuse controls, and smart-contract review. RightStack omitted these non-Web3 but required production layers.

### Confidence and assumptions

**Confidence: medium.** The chain, consumer-app, and embedded-wallet route matches the request. Assumptions: React/Next.js web app; non-crypto-native users; Base-only MVP; user-approved transactions; no autonomous server-side signing; and at least one onchain write flow. Custody semantics, recovery, geographic/compliance requirements, expected transaction volume, and contract scope were not specified.

### Tradeoffs and anti-patterns

- Privy improves onboarding but creates wallet/auth vendor dependence. Document export/recovery and migration behavior before launch; do not assume migration is impossible or seamless without contractual and technical verification.
- Keep identity, embedded signer, smart account, bundler, paymaster, and RPC as separate architectural roles even when one vendor supplies several.
- Sponsorship improves conversion but creates an abuse and budget surface. Never deploy an unlimited policy; bind sponsorship to authenticated users, allowed contracts/functions, value caps, rate limits, and monitoring.
- Do not use public Base RPC endpoints in production; Base labels them rate-limited and recommends a partner or self-hosted node.
- Do not use browser wallet SDKs for backend signing. If server-controlled operations are later required, design a separate policy-controlled signer with least privilege.
- Avoid making the embedded wallet the only recovery or support mechanism. Define account linking, lost-access recovery, user offboarding, and external-wallet interoperability.

### Verify against primary documentation before coding

- Current Privy package names, supported Base chain configuration, smart-wallet account implementation, paymaster integration, export/recovery guarantees, pricing, and security model.
- Current Base Account terminology and compatibility; Coinbase Smart Wallet has been renamed Base Account.
- wagmi/viem peer-version compatibility with Privy and the chosen React/Next.js version.
- Whether Privy native sponsorship or Pimlico is the better operational boundary; confirm Base mainnet/Sepolia support, policy controls, quotas, pricing, and failure behavior.
- RPC provider rate limits, WebSocket/webhook needs, archive/trace requirements, geographic redundancy, key restrictions, and failover.
- Contract audits, transaction simulation, phishing defenses, session duration, signer permissions, data retention, privacy, sanctions/KYC obligations, and incident response.

### Verdict

**`usable-with-corrections`** — The workflow match and Privy/RPC foundation are useful. Replace the stale OnchainKit recommendation with wagmi/viem, and make Pimlico conditional after evaluating Privy's native sponsorship. RightStack's scores and “production-grade” labels are corpus metadata, not independent verification.

Primary checks: [Base OnchainKit migration notice](https://docs.base.org/onchainkit/buy/buy), [Base–Privy setup](https://docs.base.org/base-account/framework-integrations/privy/setup), [Privy smart wallets and sponsorship](https://docs.privy.io/wallets/using-wallets/evm-smart-wallets/overview), [Base production RPC guidance](https://docs.base.org/base-chain/quickstart/connecting-to-base), and [Base node-provider list](https://docs.base.org/base-chain/node-operators/node-providers).