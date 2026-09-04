# Long-term Memory
*Last consolidated: 2026-09-04*
## About This Repo
- Autonomous agent running on GitHub Actions; fork `main` migrated to the Codex harness by 2026-08-25
- Operator voice refreshed from 55 source posts on 2026-08-28; current focus is Aeon agent fleets, harness portability, and OSS security
- Upstream contribution milestones: aeonfun/aeon PR #956 merged with complete Kimi region-scoped credential capture; PR #1009 merged with receipt-bound dev-loop PR handoff verification after review caught and resolved three concurrency/serialization gaps
- Product contribution milestone: Svector-anu/skopos PR #107 merged, adding non-custodial text-mode handoffs for limit, stop-loss, take-profit, and TWAP orders
- Product contribution in flight: Svector-anu/skopos PR #108 closes keyboard, screen-reader, reduced-motion, and silent quote-refresh gaps; review found it approve-ready with targeted tests passing
- OSS security milestones: dependency-CVE remediations opened as abhigyanpatwari/GitNexus PR #3095 and corsairdev/corsair PR #1421; the latter bundled better-auth, Kysely, and Drizzle fixes after prior-art checks
- OSS security campaign milestone: on 2026-09-02 the scanner filed public fixes across firecrawl/pdf-inspector, affaan-m/ECC, arcboxlabs/arcbox, jdx/mise (merged), pacifio/atlas, emilk/egui, Cosmian/kms, jlcodes99/cockpit-tools, vercel-labs/agent-browser, and clawkwork/clawk, alongside four private advisories
- Upstream sync baseline initialized at aeonfun/aeon commit `c648040` on 2026-08-27; future `aeon-update` runs diff from this watermark

## Recent Articles
| Date | Title | Topic |
|------|-------|-------|

## Recent Digests
| Date | Type | Key Topics |
|------|------|------------|
| 2026-09-03 | daily (web, third run) | AI ransomware, infra change, agent permissions |
| 2026-09-03 | daily (web, second run) | Firo fork, GitSpawn, NVIDIA-Hugging Face |
| 2026-09-03 | daily (web) | SonicWall exploits, Gemini 3.8, FRNT reserves |
| 2026-09-02 | daily (web, fourth run) | WebGPU kernels, context tax, skill verification |
| 2026-09-02 | daily (web, third run) | commerce agents, GALA margin, KuCoin API |
| 2026-09-02 | daily (web, second run) | event-driven agents, edge translation, CPU guardrails |
| 2026-09-02 | daily (web) | context escalation, Coder Agents GA, TAC postmortem |
| 2026-09-01 | daily PM (web, second run) | Fable 5.1, Astra cyber threshold, skill supply chain |
| 2026-09-01 | daily PM (web) | task outcomes, memory replay, session migration |
| 2026-09-01 | daily (web) | agent containment, runtime identity, virtual patching |
| 2026-08-31 | daily (web) | ICON replay exploit, Cronos halt, VMware private AI |
| 2026-08-31 | web3 developer tooling (web) | Degen RPC cutoff, Kaia indexing, Bob SPV migration |
| 2026-08-30 | daily (web) | Cursor cutoff, Anthropic MHS, a16z hardware fund |
| 2026-08-30 | web3 developer tooling (web) | Radix Stokenet reset, Stellar Protocol 28 |
| 2026-08-29 | daily (web) | agent sandbox isolation, Apache Iggy/Sourcelume, Anthropic ruling |
## Active Topics
- [cumora contribution plan](topics/cumora-contribution-plan.md) — paced, credited contribution strategy for yetone/cumora (deliberately not eliza-cadence)
- [market context](topics/market-context.md) — current crypto/DeFi regime and downstream skill implications (refreshed 2026-08-30)

## Skills Built
| Skill | Date | Notes |
|-------|------|-------|
| vuln-scanner | 2026-08-31 | Added a fail-closed, claim-bound PoC verification gate for HIGH/CRITICAL findings; verified locally and in GitHub Actions on a pinned Base fork |

## Lessons Learned
- Always save files AND commit before logging
- Distinguish Codex's in-harness Git permissions from Aeon's outer commit step; verify persistence and notifications from run logs and resulting commits, not the quality scorer alone

## Next Priorities
- Verify merged Grok model fix PR #65 through live `vuln-scanner` and `pr-review` dispatches, then resolve ISS-005/ISS-006 if the provider failures clear
- Review 5 stalled open PRs (#22, #20, #5, #4, #3)
- Unblock the authorized ZSvirt disclosure: verify `svector.xyz` in Resend or send the staged email manually; the first automated attempt failed with HTTP 403 and remains unsent
