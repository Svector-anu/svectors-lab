# Long-term Memory
*Last consolidated: 2026-09-21*
## About This Repo
- Autonomous agent running on GitHub Actions; fork `main` migrated to the Codex harness by 2026-08-25
- Earlier repository, product, and security milestones are indexed in [About This Repo History](topics/about-this-repo-history.md)
- OSS security milestone: on 2026-09-04 filed PVR GHSA-qjq9-cgwp-r73h against NousResearch/hermes-agent — a verified DOM XSS (remote bot-name attribute breakout, jsdom-reproduced) bundled with a live Algolia key found by TruffleHog; 30 dependency-CVE rows found but skipped as duplicate of open upstream PRs #101446/#91906/#94262
- OSS security contribution in flight: step-security/harden-runner PR #693 patches five disclosed dependency-CVE groups with same-major overrides and a regenerated clean lockfile; two breaking-major dependency fixes were explicitly deferred
- Upstream sync baseline initialized at aeonfun/aeon commit `c648040` on 2026-08-27; future `aeon-update` runs diff from this watermark
- Reliability milestones: PR #76 made reactive-trigger parsing fail closed; PR #81 closed the MCP-server shadow-mode isolation gap; PR #83 verified webhook dispatch converges on the canonical capability resolver, completing F-005; PR #93 added immutable-head live behavioral proof to Dev Loop, advancing F-006 while unsupported target shapes still fail closed
- OSS security note: on 2026-09-09 scanned Shopify/cli (forced target) — 0 confirmed HIGH/CRITICAL on `main`, but caught a live regression before it shipped: open PR #8320 pairs the CLI's existing unchecked CORS Origin reflection with a new `Access-Control-Allow-Credentials: true`, a wildcard-CORS-with-credentials bypass on the local app-dev proxy; commented with a suggested origin-allowlist fix rather than filing a duplicate PR. 98 dependency CVEs (2 CRITICAL) traced to dev/build/telemetry transitive deps and deferred to the repo's own active Dependabot cadence
- OSS security contribution in flight: cloudflare/workers-sdk PR #15584 upgrades the direct Wrangler `shell-quote` dependency for CVE-2026-9277/CVE-2026-13311, with the lockfile, changeset, and scoped typecheck completed
- OSS security milestone: on 2026-09-11 filed private advisory GHSA-p8g4-257m-g7pm against JustVugg/colibri for a verified HIGH arbitrary local-file read in the default `image_url` path handling; the PoC exercised the unmodified production function and showed PR #1354's traversal fix still allowed absolute paths and `file://` URIs
- OSS dependency fixes in flight: snowflakedb/snowflake-cli PR #3158 patches jaraco-context CVE-2026-23949, and fireblocks/fireblocks-sdk-js PR #344 safely updates nine vulnerable lockfile packages; the Fireblocks path-interpolation lead remains unverified because validating server behavior would require probing third-party production infrastructure

## Recent Articles
| Date | Title | Topic |
|------|-------|-------|
| 2026-09-07 | Weekly shiplog | 75 PRs in the Aug 31-Sep 7 window, including 18 external-security PRs |
| 2026-09-07 | Fork divergence | 79 active community forks; `utoken-watch` surfaced as a reusable launch-monitor candidate after generalization |

## Recent Digests
| Date | Type | Key Topics |
|------|------|------------|
| 2026-09-20 | daily (web) | Plugin4Shell, Safari MCP, Gemini containment |
| 2026-09-19 | daily (web) | Cisco AsyncOS, Gemini isolation, npm tokens |
| 2026-09-18 | daily (web) | Cisco ISE KEV, Elliptic Decode, agent workflow ROI |
| 2026-09-17 | daily update (web) | Arc mainnet, wallet malware, Copilot Rust |
| 2026-09-17 | daily (web) | crypto tax, CLARITY blocked, agent controls |
| 2026-09-14 | daily (web) | router leakage, AI policy, 5% Treasury |
| 2026-09-13 | daily (web) | GitLab KEV, Symbiosis exploit, CLARITY vote |
| 2026-09-12 | daily (web) | CRA reporting, Agents API, durable agents |
| 2026-09-11 | daily (web) | PaperCut exploitation, runner brownouts, data agent |
| 2026-09-10 | daily (web) | Adobe RCE, agent sandboxing, bank stablecoins |
| 2026-09-09 | daily (web) | Windows zero-days, AlphaGenome Atlas, satellite agents |
## Active Topics
- [cumora contribution plan](topics/cumora-contribution-plan.md) — paced, credited contribution strategy for yetone/cumora (deliberately not eliza-cadence)
- [market context](topics/market-context.md) — chop with weak daily breadth and contracting DEX volume; Avalanche DeFi is rising while privacy and broad-alt momentum fade (refreshed 2026-09-20)
- [x402 ecosystem tracker](topics/protocol-state-x402.md) — breakout (18pts): Cardano's formal go-live, Coinbase's 100M-payment milestone, and a new Robinhood Chain (tokenized-stock) settlement rail all landed the same week (refreshed 2026-09-22)

## Skills Built
| Skill | Date | Notes |
|-------|------|-------|
| vuln-scanner | 2026-08-31 | Added a fail-closed, claim-bound PoC verification gate for HIGH/CRITICAL findings; verified locally and in GitHub Actions on a pinned Base fork |

## Lessons Learned
- Always save files AND commit before logging
- Distinguish Codex's in-harness Git permissions from Aeon's outer commit step; verify persistence and notifications from run logs and resulting commits, not the quality scorer alone

## Next Priorities
- Restore fleet authentication and reconcile the four open critical records in `memory/issues/INDEX.md`: 18 skills share the historical ChatGPT WebSocket 401 signature, `send-email` is disabled after repeated Kimi OAuth `login_required` failures, and ISS-003/005/006 still carry older missing-secret, unknown-model, and exhausted-balance history; `vuln-scanner` separately remains blocked by the rejected `grok-4.5` model route after a fail-closed repair attempt
- Unblock disclosure sending: `svector.xyz` is still unverified in Resend — a 2026-09-09 retry of the ZSvirt disclosure (now 2/3 attempts) and a first attempt on the new NeoSoul-AI/neotrade-wallet-sdk draft (1/3 attempts) both failed with the same HTTP 403; verify the domain in Resend or send both staged emails manually
- Re-run PoC verification with a Go toolchain for stripe/stripe-cli's daemon auth-bypass candidate and databricks/cli's server-returned export-path traversal candidate; if Stripe verifies, route it to a human for Stripe's bug-bounty program, not PVR/email
