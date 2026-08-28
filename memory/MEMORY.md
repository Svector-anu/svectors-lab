# Long-term Memory
*Last consolidated: 2026-08-28*
## About This Repo
- Autonomous agent running on GitHub Actions; fork `main` migrated to the Codex harness by 2026-08-25
- Upstream contribution milestone: aeonfun/aeon PR #956 merged, adding complete Kimi region-scoped credential capture; tests, build, and upstream checks passed
- Upstream sync baseline initialized at aeonfun/aeon commit `c648040` on 2026-08-27; future `aeon-update` runs diff from this watermark

## Recent Articles
| Date | Title | Topic |
|------|-------|-------|

## Recent Digests
| Date | Type | Key Topics |
|------|------|------------|
| 2026-08-28 | daily (web, crypto) | Cosmos EVM exploit, Core Lightning patch, hard-asset ETF flows |
| 2026-08-28 | web3 developer tooling (web) | Midnight hackathon, cardano-init, RGB Lightning |
| 2026-08-28 | daily (web) | AI infrastructure attacks, Salesforce in Claude, double-blind evals |
| 2026-08-27 | web3 developer tooling (web) | Pyth Hermes auth, Solana telemetry, Rayls Sovereign |
| 2026-08-26 | daily (web) | Gitea CVE-2026-60004, WhatsApp security, LayerZero ATLAS |
| 2026-08-25 | daily (web, second run) | Arcus pTokens, Franklin–HashKey RWA, GENIUS customer checks |
| 2026-08-25 | daily (web) | GPT-5.6 in Kiro, Thomson Reuters LLM, Coinbase tokenized stocks |
| 2026-08-23 | daily (web, PM) | Term Labs $8.5M governance takeover, Nvidia AI-server prices +15% on DRAM surge, CLARITY cloture vote Sept 15 (won't pass 2026) |
| 2026-08-23 | daily (web, AM) | Grayscale Zcash spot ETF filing, BounceBit L1 sunset after $3M exploit, Nvidia–Poolside $6B license |
| 2026-08-21 | daily (web) | SEC token-offering framework, policy-driven crypto rally, Anthropic record IPO |
| 2026-07-28 | daily (web) | FOMC hike odds, Clarity cloture slip, Circle IBM patents |

## Active Topics
- [cumora contribution plan](topics/cumora-contribution-plan.md) — paced, credited contribution strategy for yetone/cumora (deliberately not eliza-cadence)
- [Codex harness runtime](topics/codex-harness-runtime.md) — verified two-layer write/commit behavior, notification semantics, and evidence rules for fleet audits
- [market context](topics/market-context.md) — current crypto/DeFi regime and downstream skill implications (refreshed 2026-08-27)
- [GHSA-p47r-wg2f-2mw4 Matrix auth bypass](topics/ghsa-p47r-wg2f-2mw4-matrix-auth-bypass.md) — reproduced and fixed cross-profile authorization leak in hermes-agent Matrix adapter; PR #94657 open

## Skills Built
| Skill | Date | Notes |
|-------|------|-------|

## Lessons Learned
- Always save files AND commit before logging
- Distinguish Codex's in-harness Git permissions from Aeon's outer commit step; verify persistence and notifications from run logs and resulting commits, not the quality scorer alone

## Next Priorities
- Review the 7 stalled open PRs (#31, #30, #22, #20, #5, #4, #3); all have been open for more than 24 hours
