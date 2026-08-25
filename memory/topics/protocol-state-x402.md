---
type: Reference
title: x402 Ecosystem Tracker
description: Per-run state for the x402 Protocol Monitor — known integrations, npm stats, GitHub repo counts, signal log.
tags: [x402, protocol-monitor, micropayments, ai-agents]
timestamp: 2026-08-25T12:05:00Z
---

# x402 Ecosystem Tracker

*Last run: 2026-08-25*

## Known Integrations
- cloudflare/agents (5234★) — official Cloudflare agents framework; x402 listed as native pay-per-call feature
- x402-rs/x402-rs (277★) — Rust x402 toolkit; Permit2 + usage-based payments; multi-chain (EVM, Solana, Aptos)
- voidly-ai/voidly-pay (11★) — off-chain credit ledger + hire marketplace for AI agents; x402 adapter included
- solvela-ai/solvela (9★) — Solana-native AI agent payment infrastructure via x402 protocol
- gordonmurray/Sluice (1★) — self-hostable pay-per-request gateway; x402 USDC on Base
- XR-Utilities/h-series-mcp (0★) — MCP server (H-Series product family); x402 payment middleware
- primer-systems/x402view (1★) — investment-focused directory of x402 projects and tokens; 1092 commits
- vbkotecha/aiservices-api (1★) — premium APIs for AI agents via x402 micropayments on Base
- andrefaria-star/alf-agent-card (0★) — ERC-8004 seller agent card for an x402 gateway on Base
- nohosa001-pixel/minerals-oracle-x402 (0★) — x402 minerals and scrap valuation oracle for agents on Base
- vrsai-tech/mcp (0★) — TypeScript MCP bridge with native x402 payments and buyer-side controls
- api-evangelist/done (0★) — catalog of 26 metered utility APIs paid per call via x402 on Base or Solana
- CaBsCrypto/stellar-bazaar-x402 (1★) — Stellar-native discovery for paid HTTP APIs and MCP tools using x402
- epistemedeus/x402-url-extractor (1★) — live pay-per-call URL extraction API using x402 and USDC on Base
- ardentairesearch/agent-execution-platform (1★) — agent transaction backend with ERC-4337 wallets and x402 payment verification
- akoita/resonate (1★) — machine-first audio licensing API with x402-powered stem checkout
- seancrecord/scvd-general-store-repo (3★) — conformance, settlement-attestation, and general-store layer for x402 offers and receipts
- solosofi/tollbooth (0★) — machine-payable endpoint charging agents per request through x402 on Base

## Key Stats
- npm @coinbase/x402: 60,625 weekly downloads (-1,935 vs prior run; +22,491 vs 2026-07-08 baseline)
- npm x402: 383,599 weekly downloads (+9,617 vs prior run; +137,658 vs 2026-07-08 baseline)
- npm paykit: 404 (not found — skipped)
- GitHub repos matching x402: 2,567 broad-query matches pushed in the last 7 days; 356 stricter `"x402 protocol"` matches. Five additional integrations absent from the morning baseline were retained after relevance review.
- Notable announcements: x402 List reports 533 monitored services, 479 payment-ready, but only one delivery-verified as of 2026-08-24; Animica published a live native-ANM payment lane tutorial on 2026-08-23.

## Signal Log
- 2026-07-08: First run. 6+ new integrations in last 7d. cloudflare/agents (5234★) is highest-signal. x402=245k/wk, @coinbase/x402=38k/wk npm. Momentum: breakout (14pts).
- 2026-08-25: Five new, clearly relevant integrations retained from a much larger noisy GitHub result set (+10). Both tracked npm packages rose vs the July baseline (+6). One ecosystem reliability report (+2), one fresh cross-chain implementation tutorial (+1), and one settlement-quality analysis (+1). Momentum: breakout (20pts). Read: ride developer adoption, but watch verified delivery—the service count is expanding faster than proof that paid calls return useful output.
- 2026-08-25 (12:05 UTC rerun): Five additional repositories absent from the morning baseline were active today (+10), spanning data extraction, transaction execution, audio licensing, settlement attestation, and pay-per-request middleware. `x402` npm downloads rose (+3), while `@coinbase/x402` declined and scored zero. No new announcement was retained after same-day dedup. Momentum: breakout (13pts). Read: ride integration breadth; watch whether the long tail converts from low-star experiments into used services.

# Citations
- [GitHub repository search API](https://api.github.com/search/repositories?q=x402%20in%3Areadme%2Cdescription%20pushed%3A%3E%3D2026-08-18&sort=updated&order=desc&per_page=20)
- [npm downloads: @coinbase/x402](https://api.npmjs.org/downloads/point/last-week/%40coinbase%2Fx402)
- [npm downloads: x402](https://api.npmjs.org/downloads/point/last-week/x402)
- [x402 Ecosystem Reliability Report — August 2026](https://x402-list.com/blog/x402-reliability-report)
- [Animica x402 agent-payments tutorial](https://animica.org/learn/x402-agent-payments/)
- [What Agents Buy settlement analysis](https://whatagentsbuy.com/)
