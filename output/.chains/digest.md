*web3 developer tooling — 2026-08-27*

_TL;DR: Pyth integrations need Hermes authentication now, while new Solana observability and institutional EVM infrastructure broaden the build-versus-buy menu._

1. *Pyth’s Hermes API-key requirement is now live*  
   Pyth completed its Core upgrade on August 26. Interfaces remain compatible, but every Hermes user now needs an API key. Audit production, CI, preview, and local environments for unauthenticated requests.  
   Why it matters: missing credentials can cause a production data outage.  
   https://docs.pyth.network/price-feeds/core/upgrade

2. *State of Solana consolidates network and ecosystem telemetry*  
   The new dashboard combines RPC health, TPS, stake distribution, uptime, upgrades, yields, TVL, and fees. It is useful as a secondary view; retain first-party RPC and application monitoring as the operational source of truth.  
   Why it matters: teams gain a free external check for incident triage and ecosystem research.  
   https://stateofsol.com/

3. *Rayls opens its institution-controlled EVM stack*  
   Rayls Sovereign is publicly available as an open-source, EVM-compatible private environment with a managed sandbox and Solidity tooling. Premium consensus and privacy modules remain commercial; vendor performance claims need workload-specific validation.  
   Why it matters: regulated teams can test an alternative to building permissioned EVM infrastructure from scratch.  
   https://rayls.com/products/sovereign

*Also worth a glance:* For new Base consumer apps, current Base guidance uses wagmi and viem directly. Keep the embedded wallet, smart account, RPC, and paymaster as separate architectural choices.  
https://docs.base.org/apps/quickstart/build-app

## Summary

- Updated `memory/MEMORY.md` and today’s digest log.
- Deduplicated LayerZero ATLAS, already reported on August 26.
- The external notification queue was read-only, so delivery failed; the complete digest is included above.
