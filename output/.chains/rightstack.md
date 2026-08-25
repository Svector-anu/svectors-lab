## RightStack brief: Base consumer app with embedded wallet

**Request:** consumer app on Base with embedded wallet  
**Selected workflow:** `base-consumer-app`

### Recommended stack by phase
- **Required — onboarding/wallet:** Privy embedded user wallets with email/social/passkey auth. Decide custody model explicitly; preserve user key-export/recovery paths.
- **Required — chain access:** a dedicated Base RPC/data provider. Alchemy is a viable default, but not uniquely required; add provider fallback for critical reads/writes.
- **Optional — UI:** OnchainKit for Base-opinionated React components and faster delivery; use wagmi/viem directly when custom UX or lower lock-in matters.
- **Conditional — gasless/smart accounts:** first choose EOA embedded wallets versus ERC-4337 smart wallets. If gas sponsorship or batching is required, evaluate Privy's native path against Pimlico or Alchemy Account Kit. Do not add Pimlico merely because the wallet is embedded.

### Confidence and assumptions
**Confidence:** medium-high on workflow fit; medium on named-provider selection. Assumes a React web/mobile consumer app, users without existing wallets, user-controlled accounts, and Base-only launch. Custody/compliance needs, external-wallet support, transaction patterns, scale, and recovery requirements are unspecified.

### Tradeoffs and anti-patterns
- Privy improves onboarding but creates auth/key-management dependency; document export, recovery, outage, and migration behavior.
- OnchainKit speeds Base delivery but is optional and Base-opinionated.
- A single RPC provider is an availability dependency; public RPC is unsuitable as the sole production endpoint.
- Gas sponsorship needs allowlists, per-user/action budgets, abuse controls, observability, and bundler rejection handling.
- Do not confuse embedded wallets, smart accounts, and UI components; they are separate layers.
- Avoid browser auth SDKs for server signing and never grant server signers unrestricted authority.

### Verify before coding
- Current Privy SDK/package names, custody model, key export/recovery, smart-wallet provider compatibility, and pricing.
- Whether OnchainKit still fits the chosen Privy connector and account model; verify its current migration direction and chain assumptions.
- Exact Base support, quotas, SLAs, webhooks, and failover behavior for the RPC/data provider.
- Smart-account implementation, bundler/paymaster support, sponsorship policy limits, pricing, and Base mainnet/testnet compatibility.
- Security reviews and deployment addresses for every smart-account contract used.

**Verdict:** usable-with-corrections. RightStack routed correctly, but its `production-grade` labels and scores are corpus metadata, not verification. Main correction: Pimlico is conditional, and provider choices should follow custody, account model, UX, and resilience requirements.