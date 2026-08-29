## Base consumer app architecture brief

**Request:** consumer app on Base with an embedded wallet

**Workflow:** `base-consumer-app` (schema `1.0`, command `recommend`). The routing fits the stated chain, app type, and no-existing-wallet onboarding constraint. RightStack reports confidence `0.65`; its `production-grade` labels and scores are corpus metadata, not independent verification.

### Stack by phase

- **MVP — required wallet layer:** Privy for email/social/passkey onboarding and embedded wallet creation. Decide key custody, recovery, export, deletion, and fallback authentication before implementation.
- **MVP — required chain access:** a dedicated Base RPC/data provider. RightStack names Alchemy; QuickNode is its multi-chain alternative. Add provider abstraction, retries, observability, and a tested failover path rather than depending on a public RPC.
- **MVP — optional UI:** OnchainKit for fast Base-native components; use wagmi directly when custom UX and lower-level control matter more than speed. OnchainKit is UI, not wallet custody.
- **Post-MVP — conditional gasless actions:** Pimlico only after confirming ERC-4337 compatibility with the selected embedded-wallet/account model. Define sponsorship allowlists, per-user/per-action limits, rate limits, monitoring, and rejection fallbacks. Alchemy Account Kit is a consolidation option; ZeroDev is for advanced session-key/policy needs.

### Assumptions and tradeoffs

- Assumes a React/web app for users who may not already own a wallet. Native mobile, Farcaster Mini App, hybrid external-wallet support, server-side agents, compliance, geography, and transaction volume are unspecified.
- Privy minimizes onboarding friction but creates wallet/auth vendor dependence. Require documented key export and recovery paths; do not make it the only identity recovery route.
- OnchainKit accelerates delivery but adds Base/Coinbase conventions and visual opinions. wagmi offers more control with more implementation work.
- Alchemy reduces RPC/data setup work but creates provider concentration. Avoid coupling application logic to enhanced APIs without an exit path.
- Sponsored gas improves UX but adds an abuse and budget surface. It is optional, not a default requirement.

### Anti-patterns

- Requiring MetaMask or Coinbase Wallet when embedded onboarding is the product requirement.
- Treating OnchainKit as the wallet provider or mixing browser authentication SDKs into server-side signing.
- Shipping without wallet recovery/export, transaction simulation, clear signing consent, spend limits, monitoring, or RPC/bundler failure handling.
- Unlimited paymaster policies or a single production RPC with no operational fallback.
- Copying corpus package versions into the build without checking current official release and migration guidance.

### Primary-documentation checks before implementation

Verify, in official Privy, Base/Coinbase Developer Platform, OnchainKit, wagmi/viem, Alchemy or QuickNode, and Pimlico ERC-4337 documentation: current Base support; compatible React/runtime and package versions; custody and key-export model; smart-account type; bundler/paymaster compatibility; sponsorship pricing and limits; supported transaction flows; recovery/deletion behavior; security guidance; and migration notices. Also threat-model auth takeover, session handling, phishing/signing clarity, paymaster abuse, provider outage, and vendor exit.

**Verdict:** `usable-with-corrections`. Start with Privy plus a production RPC and either OnchainKit or wagmi. Add paymaster infrastructure only after the smart-account model and sponsorship controls are explicit. Confidence: medium, because the broad architecture fits but product, custody, recovery, compliance, and scale requirements remain unspecified.

## Summary

- Evaluated the pinned RightStack recommendation without modifying the repository or external systems.
- Files created/modified: none in the repository.
- Follow-up: confirm platform, custody/recovery model, external-wallet support, transaction types, geography/compliance needs, expected volume, and gas-sponsorship budget before selecting packages.

`RIGHTSTACK_CORRECTED` · operation: `recommend` · pinned RightStack: `0.3.2` · verdict: `usable-with-corrections` · notification: sent