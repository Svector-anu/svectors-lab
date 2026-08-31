# Fork Divergence — 2026-08-31

**Verdict:** 48 of 49 configured forks explicitly disable `search-skill` while upstream defaults it on — the clearest fleet vote is to flip that default off.

- **Code divergence:** NEW UPSTREAM CANDIDATE: Svector-anu/svectors-lab
- **Config divergence:** 48 forks disable `search-skill` (upstream defaults on) — fleet is voting it as noise

Fleet: 256 total forks · 85 active · 0 managed instances · 85 community. Deep processing was capped at the 50 most recently pushed active forks.

---

# Part 1 — Code divergence

## What changed this week

- **New forks:** first snapshot; 50 sampled active forks established as baseline
- **Went active:** first snapshot
- **New skills landed:** 10 forks add 18 `SKILL.md` files relative to upstream
- **Went stale:** none
- **Archived/deleted:** none

## PROMOTE — upstream contribution candidates

### Svector-anu/svectors-lab — score 92 COMMUNITY

**Activity:** last pushed 2026-08-31 · +3293/-28 commits vs upstream

- `skills/fear-divergence/SKILL.md` — conditional fear-regime scanner for assets outperforming during broad market stress.
- `skills/verdikta-hunter/SKILL.md` — discovers and drafts rubric-targeted Verdikta bounty submissions.
- `skills/x402-monitor/SKILL.md` — configurable ecosystem-velocity monitor for x402, RWA, compute, MCP, and agent displacement.

**Why review:** The protocol monitor is broadly reusable; the other two are narrower operator workflows. The fork is heavily diverged, so extract skill directories rather than merge its branch.

### MagIcKEarl/aeon — score 80 COMMUNITY

**Activity:** last pushed 2026-08-29 · +151/-14 commits vs upstream

- `skills/forecasting/SKILL.md` — confidence-scored crypto forecasts combining technical, onchain, sentiment, and macro signals.
- `skills/hyperliquid/SKILL.md` — Hyperliquid funding, open-interest, basis, mover, and market-structure analysis.
- `skills/yield-farming/SKILL.md` — multi-chain yield scan with risk and impermanent-loss assessment.

**Why review:** A coherent crypto-analysis pack with modest upstream drift; inspect source and secret handling before proposing the directories upstream.

### Boodszw/Boodszw_Bread — score 76 COMMUNITY

**Activity:** last pushed 2026-08-31 · +20444/-812 commits vs upstream

- `skills/alchemy/SKILL.md` — multi-chain blockchain data through API-key, x402, or MPP access.
- `skills/bankr/SKILL.md` — wallet, trading, transfer, NFT, leverage, Polymarket, and LLM-gateway operations.
- `skills/opensea/SKILL.md` — router across OpenSea data, NFT trading, token swaps, and agent tooling.
- `skills/zerion/SKILL.md` — interpreted wallet, portfolio, DeFi, NFT, PnL, and swap data across 41+ chains.

**Why review:** Broad, reusable provider integrations, but the extreme branch divergence makes directory-level provenance and safety review mandatory.

### enzoonchain/aeon — score 53 COMMUNITY

**Activity:** last pushed 2026-08-31 · +10530/-798 commits vs upstream

- `skills/builder-post/SKILL.md` — data-first builder posts in a fork-specific voice.
- `skills/delegation/SKILL.md` — API-key delegation and compute-revenue splitting.

**Why review:** Delegation may generalize; builder-post is voice-specific. Review the delegation flow independently.

### czijian729-oss/aeon — score 56 COMMUNITY

**Activity:** last pushed 2026-08-31 · +167/-97 commits vs upstream

- `skills/utoken-watch/SKILL.md` — fork-only token watcher; content deep-read was not completed within the five-fork cap.

**Why review:** Small enough divergence for targeted inspection, but requires content review before promotion.

Five additional PROMOTE candidates were moved to review because of the cap: `damo-nu11/aeon-minebean`, `UIZorrot/aeon`, `abhirajprasad/aeon`, `lawbworld-tech/aeon`, and `danbuildss/aeon`.

## REVIEW — worth a look

| Fork | Score | Ahead/behind | New/modified | Notable |
|---|---:|---:|---:|---|
| damo-nu11/aeon-minebean | 48 | +4938/-798 | 1/0 | `mine-bean` |
| UIZorrot/aeon | 47 | +1742/-740 | 1/0 | `careful-finance` |
| abhirajprasad/aeon | 44 | +1941/-798 | 1/0 | `aeonbook-onboarding` |
| lawbworld-tech/aeon | 43 | +5554/-776 | 1/0 | LawbFishing pool-health monitor |
| danbuildss/aeon | 42 | +21/-20 | 1/0 | `cortx-reliability`; low drift |
| remaining sampled REVIEW forks | — | — | — | 27 forks crossed the commit/modified-skill review threshold |

## NOTE — low divergence

13 sampled forks had fewer than three unique commits and no modified skill.

## Fleet vs community

| Category | Count |
|---|---:|
| Managed instances | 0 |
| Community forks | 85 active |
| Stale (30–365d) | 169 |
| Dormant (>365d) | 0 |

## Code source status

`forks_list=ok · compare_ok=50/50 · deep_read=5/5 forks · rate_limit_retries=0 · unreadable=0 · truncated_at=50`

---

# Part 2 — Config divergence

*Scanned the 50 newest of 85 active forks of aeonfun/aeon. 49 are configured and one is template-equivalent. Percentages use the 49 configured forks.*

## Default-flip candidates

### Disable downward (upstream on → fleet explicitly disables)

| Skill | Forks disabled | % configured | Delta |
|---|---:|---:|---|
| search-skill | 48 | 98% | first snapshot |
| auto-merge | 47 | 96% | first snapshot |
| defi-overview | 47 | 96% | first snapshot |
| digest | 47 | 96% | first snapshot |
| vuln-scanner | 47 | 96% | first snapshot |
| self-improve | 47 | 96% | first snapshot |
| skill-repair | 47 | 96% | first snapshot |
| fork-fleet | 47 | 96% | first snapshot |
| github-trending | 46 | 94% | first snapshot |
| skill-health | 45 | 92% | first snapshot |
| token-pick | 44 | 90% | first snapshot |
| write-tweet | 44 | 90% | first snapshot |
| narrative-tracker | 41 | 84% | first snapshot |
| vuln-tracker | 34 | 69% | first snapshot |
| memory-flush | 30 | 61% | first snapshot |
| shiplog | 27 | 55% | first snapshot |
| picks-tracker | 27 | 55% | first snapshot |

No non-meta skill crossed the 50% enable-upward threshold.

## Fleet consensus on alternative settings

- **Model:** `monitor-polymarket` → `claude-sonnet-4-6` in 20 forks (41%).
- **Schedules:** `defi-overview` → `0 12 * * *` in 47 forks; `narrative-tracker` → `30 13 * * *` in 46; `heartbeat` → `0 8,14,20 * * *` in 26; `write-tweet` → `0 17 * * *` in 22.
- **Var hotspots:** none crossed the shared-value threshold.

## Watchlist

No enable-upward adoption pattern landed in the 25–49% range.

## Heaviest customizers

| Fork | Total overrides | Dominant category | Notes |
|---|---:|---|---|
| hansj73/aeon | 47 | mixed | 45 schedule changes plus one enable and one var change |
| MagIcKEarl/aeon | 20 | crypto | 17 enable changes and three schedules |
| chxoky/aeon | 16 | mixed | nine model and six schedule changes |
| Kodawari10/aeon | 16 | mixed | five enable, three var, eight schedule changes |
| swarm-ai-research/aeon-atlas | 13 | mixed | seven model and six schedule changes |

## Fork-only skills

The code compare found 18 added skill definitions across ten forks. These are experiments worth inspecting, not automatic merge recommendations.

## Config week-over-week

First divergence snapshot — no prior comparison.

## Fleet composition (sampled config tiers)

| Tier | Count | % |
|---|---:|---:|
| Configured | 49 | 98% |
| Template | 1 | 2% |
| Unreadable | 0 | 0% |
| **Total sampled active** | **50** | **100%** |

## Config source status

- Trees fetched: 50/50
- aeon.yml readable: 50/50
- YAML parse failures: 0
- Rate-limited: 0
- Active set truncated: 85 → 50 newest

---

*Source: GitHub API — forks of aeonfun/aeon. Code divergence compares unique commits and files against upstream; config divergence compares explicit fleet settings with local upstream defaults. Untouched templates are excluded from config math.*
