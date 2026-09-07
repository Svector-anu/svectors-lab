# Fork Divergence — 2026-09-07

**Verdict:** NEW UPSTREAM CANDIDATE: czijian729-oss/aeon — `utoken-watch` is a concrete, change-gated on-chain launch monitor; review the pattern, but generalize its hard-coded target before merging.

- **Code divergence:** ACTIVE FLEET: 39 forks building (9 PROMOTE, 30 REVIEW).
- **Config divergence:** 48 forks disable `pr-review` (upstream defaults on) — fleet is voting it as noise.

Fleet: 259 usable forks · 79 active · 0 managed instances · 79 community. Deep processing capped at the 50 freshest active forks.

---

# Part 1 — Code divergence

## What changed this week

- **New forks / went active:** prior code state retained only three top candidates, so a reliable fleet-wide delta cannot be reconstructed; today’s full 50-fork state repairs that coverage gap.
- **New skills landed:** seven PROMOTE forks are absent from the prior retained subset; treat this as newly observed, not proof they were created this week.
- **Went stale:** 6 fewer active forks than the prior aggregate snapshot (85 → 79); identities unavailable from the truncated prior state.
- **Archived/deleted:** none confirmed from retained state.

## PROMOTE — upstream contribution candidates

### MagIcKEarl/aeon — score 80 [COMMUNITY]
**Activity:** last pushed 2026-08-29 · stars 0 · +151/-46 commits vs upstream
**Unique skills:**
- `skills/forecasting/SKILL.md` — Combines technical, on-chain, sentiment, macro, and narrative inputs into multi-horizon crypto forecasts; broad but currently light on concrete source mechanics.
- `skills/hyperliquid/SKILL.md` — Scans Hyperliquid funding, open interest, order books, movers, basis, and liquidation risk into trade ideas using the public API.
- `skills/yield-farming/SKILL.md` — Ranks multi-chain farms by risk-adjusted yield, separating base yield from incentives and adding IL, protocol, token, and exit-risk checks.

**Why promote:** Three decision-oriented crypto scanners fit this fork’s trading focus, but forecasting needs explicit source and freshness contracts before upstreaming.
**Suggested action:** Review `skills/forecasting/` and ask MagIcKEarl to upstream a generalized, safety-checked version.

### Boodszw/Boodszw_Bread — score 76 [COMMUNITY]
**Activity:** last pushed 2026-09-07 · stars 0 · +21133/-844 commits vs upstream
**Unique skills:**
- `skills/alchemy/SKILL.md` — A comprehensive Alchemy router covering API-key, x402, and MPP access to RPC, NFT, price, portfolio, and webhook products.
- `skills/bankr/SKILL.md` — A full Bankr wallet/trading integration spanning portfolio reads, swaps, transfers, perps, prediction markets, token launches, and LLM access.
- `skills/opensea/SKILL.md` — Routes NFT/token reads, Seaport marketplace actions, ERC-20 swaps, wallet setup, and agent-tool registration into dedicated sub-skills.
- `skills/zerion/SKILL.md` — Adds interpreted cross-chain wallet intelligence—positions, PnL, DeFi, NFTs, transactions, gas, and quotes—with x402 or API-key access.

**Why promote:** The integrations are substantial and generalizable, but they are vendor-maintained skill packs; preserve their nested references and review auth/write-action gates as a unit.
**Suggested action:** Review `skills/alchemy/` and ask Boodszw to upstream a generalized, safety-checked version.

### czijian729-oss/aeon — score 56 [COMMUNITY]
**Activity:** last pushed 2026-09-04 · stars 0 · +203/-129 commits vs upstream
**Unique skills:**
- `skills/utoken-watch/SKILL.md` — A change-gated launch monitor for µToken on Robinhood Chain, watching a fixed deployer, factory activity, official X, and site availability.

**Why promote:** The delta-based watcher pattern is reusable. Its current wallet, factory, site, and X account are hard-coded, so upstream should extract a configurable launch-watch primitive.
**Suggested action:** Review `skills/utoken-watch/` and ask czijian729-oss to upstream a generalized, safety-checked version.

### enzoonchain/aeon — score 53 [COMMUNITY]
**Activity:** last pushed 2026-09-07 · stars 0 · +10887/-830 commits vs upstream
**Unique skills:**
- `skills/builder-post/SKILL.md` — Generates terse, data-first builder posts in one project-specific voice; useful pattern, but not general upstream functionality as written.
- `skills/delegation/SKILL.md` — Defines Venice API-key delegation, usage tracking, revocation, and a Base revenue split; potentially valuable but unsafe to upstream without implementation and secret-handling hardening.

**Why promote:** `builder-post` is voice-specific and `delegation` reads more like an architecture note than an executable, safety-complete skill; use as design input, not a direct cherry-pick.
**Suggested action:** Review `skills/builder-post/` and ask enzoonchain to upstream a generalized, safety-checked version.

### damo-nu11/aeon-minebean — score 48 [COMMUNITY]
**Activity:** last pushed 2026-09-07 · stars 0 · +5091/-830 commits vs upstream
**Unique skills:**
- `skills/mine-bean/SKILL.md` — Runs bounded multi-round $BEAN mining sessions on Base with dry-run controls, balance thresholds, auto-claims, and explicit wallet-conflict safety rules.

**Why promote:** The batch-amortized mining loop and wallet-conflict safeguards are concrete, but this is protocol-specific and writes on-chain; require script review and explicit spend caps before considering upstream.
**Suggested action:** Review `skills/mine-bean/` and ask damo-nu11 to upstream a generalized, safety-checked version.

## REVIEW — worth a look

| Fork | Score | Ahead | New/Modified | Notable |
|---|---:|---:|---:|---|
| Svector-anu/svectors-lab | 54 | +4077/-60 | 0/0 | schedule/config, workflows, dashboard |
| hansj73/aeon | 37 | +152/-63 | 0/0 | schedule/config |
| swarm-ai-research/aeon-atlas | 37 | +851/-752 | 0/0 | schedule/config, workflows |
| chxoky/aeon | 36 | +16770/-672 | 0/0 | workflows |
| taekwonv89/aeon | 36 | +19498/-811 | 0/0 | schedule/config |
| yugo-engineer/aeon | 36 | +1447/-971 | 0/0 | commit divergence |
| 0xMal0u/aeon | 35 | +8867/-818 | 0/0 | schedule/config, workflows |
| madebyshun/blueagent-aeon | 35 | +1417/-834 | 0/0 | schedule/config, workflows |
| youpsla/aeon | 35 | +4114/-818 | 0/0 | schedule/config, workflows |
| nigelon11/aeon | 35 | +495/-441 | 0/0 | dashboard |
| beijiangqukuailian/aeon | 34 | +250/-690 | 0/0 | workflows |
| darkstaryuri/aeon | 33 | +14/-0 | 0/0 | schedule/config |
| stefrogovskyi/aeon | 33 | +67/-99 | 0/0 | schedule/config, dashboard |
| pezetel/aeon | 33 | +5832/-866 | 0/0 | schedule/config |
| amritmirch/aeon | 33 | +79/-155 | 0/0 | schedule/config, workflows |

+ 15 more REVIEW forks omitted for brevity.

## NOTE — low divergence

11 forks had fewer than three unique commits and no new/modified skill files.

## Fleet vs community

| Category | Count |
|---|---:|
| Managed instances | 0 |
| Community forks (active) | 79 |
| Stale (30–365d) | 180 |
| Dormant (>365d) | 0 |

## Code source status

`forks_list=ok · compare_ok=50/50 · deep_read=11/11 · rate_limit_retries=0 · unreadable=0 · truncated_at=50`

---

# Part 2 — Config divergence

*Scanned the 50 freshest of 79 active forks of aeonfun/aeon. 49 are configured and one is an untouched template. Divergence is scored against those 49 configured forks.*

## Default-flip candidates

### Enable upward (upstream off → fleet enables)

No skills crossed the 50% enable-upward threshold this week.

### Disable downward (upstream on → fleet disables)

| Skill | Forks disabled | % of configured | Δ vs last week |
|---|---:|---:|---|
| pr-review | 48 | 98% | NEW |
| defi-overview | 47 | 96% | — |
| digest | 47 | 96% | — |
| search-skill | 47 | 96% | — |
| skill-repair | 47 | 96% | NEW |
| vuln-scanner | 47 | 96% | — |
| auto-merge | 46 | 94% | — |
| fork-fleet | 46 | 94% | NEW |
| github-trending | 46 | 94% | NEW |
| self-improve | 46 | 94% | NEW |
| skill-health | 45 | 92% | NEW |
| write-tweet | 45 | 92% | NEW |
| token-pick | 44 | 90% | NEW |
| narrative-tracker | 41 | 84% | NEW |
| vuln-tracker | 34 | 69% | NEW |
| memory-flush | 30 | 61% | NEW |
| picks-tracker | 28 | 57% | NEW |
| shiplog | 27 | 55% | NEW |

## Fleet consensus on alternative settings

### Model overrides

No model override crossed the 40% consensus threshold. `monitor-polymarket → claude-sonnet-4-6` faded from 20 to 19 forks, one below the 20-fork threshold.

### Var hotspots

None this week.

### Schedule overrides

- `defi-overview` — 47 forks use `0 12 * * *`
- `feature` — 23 forks use `0 10 * * 6`
- `heartbeat` — 25 forks use `0 8,14,20 * * *`
- `memory-flush` — 8 forks use `30 21 * * *`
- `narrative-tracker` — 46 forks use `30 13 * * *`
- `write-tweet` — 21 forks use `0 17 * * *`

## Watchlist (emerging — 25–49% adoption)

None this week.

## Heaviest customizers (top 5)

| Fork | Total overrides | Dominant category | Notes |
|---|---:|---|---|
| chxoky/aeon | 192 | fork-only | Large fork-only inventory relative to this instance’s consolidated skill catalog |
| aeoncity-hub/aeon | 179 | fork-only | Large fork-only inventory relative to this instance’s consolidated skill catalog |
| ashneil12/aeon-upstream | 179 | fork-only | Large fork-only inventory relative to this instance’s consolidated skill catalog |
| sparkleware/aeon | 169 | fork-only | Large fork-only inventory relative to this instance’s consolidated skill catalog |
| beijiangqukuailian/aeon | 169 | fork-only | Large fork-only inventory relative to this instance’s consolidated skill catalog |

## Fork-only skills

The raw tree comparison found 2,735 fork/skill pairs (218 unique names). This is dominated by historical upstream skills removed or consolidated in this running instance, so it is baseline drift—not 2,735 fresh experiments.

Fresh code-compare additions worth reviewing are the 16 skills listed under PROMOTE; the complete raw inventory is preserved in `memory/topics/fork-digest-state.json`.

## Config week-over-week

- **NEW_FLIP:** fork-fleet, github-trending, memory-flush, narrative-tracker, picks-tracker, pr-review, self-improve, shiplog, skill-health, skill-repair, token-pick, vuln-tracker, write-tweet. 
- **FADED:** none.
- **MODEL_CONSENSUS faded:** monitor-polymarket.
- **Baseline caution:** local upstream skill consolidation makes fork-only and some enabled deltas structurally larger than last week; do not read those as one-week operator changes.

## Fleet composition (config tiers)

| Tier | Count | % |
|---|---:|---:|
| Configured | 49 | 98% |
| Template | 1 | 2% |
| Unreadable | 0 | 0% |
| **Total processed active** | 50 | 100% |

## Config source status

- Trees fetched: 50 / 50
- aeon.yml readable: 50 / 50
- YAML parse failures: 0
- Rate-limited: 0
- Fork-only skill files enumerated: 2,735

## Appendix — full divergence table

| Skill | Enable diff | Var | Model | Schedule |
|---|---:|---:|---:|---:|
| defi-overview | 47 | 0 | 0 | 48 |
| narrative-tracker | 41 | 1 | 1 | 48 |
| write-tweet | 45 | 0 | 0 | 22 |
| feature | 31 | 0 | 0 | 24 |
| pr-review | 48 | 0 | 0 | 1 |
| digest | 47 | 0 | 0 | 1 |
| search-skill | 47 | 0 | 0 | 1 |
| self-improve | 46 | 0 | 0 | 2 |
| vuln-scanner | 47 | 0 | 0 | 1 |
| auto-merge | 46 | 0 | 0 | 1 |
| auto-workflow | 47 | 0 | 0 | 0 |
| autoresearch | 47 | 0 | 0 | 0 |
| create-skill | 47 | 0 | 0 | 0 |
| fork-fleet | 46 | 0 | 0 | 1 |
| github-trending | 46 | 0 | 0 | 1 |
| skill-health | 45 | 0 | 0 | 2 |
| skill-repair | 47 | 0 | 0 | 0 |
| token-pick | 44 | 0 | 0 | 1 |
| memory-flush | 30 | 0 | 0 | 9 |
| vuln-tracker | 34 | 0 | 0 | 1 |
| picks-tracker | 28 | 0 | 1 | 1 |
| shiplog | 27 | 0 | 0 | 1 |
| heartbeat | 0 | 0 | 0 | 27 |
| soul-builder | 27 | 0 | 0 | 0 |
| hunter-22 | 22 | 0 | 0 | 1 |
| monitor-polymarket | 3 | 0 | 19 | 1 |
| aeon-doctor | 21 | 0 | 0 | 1 |
| operator-scorecard | 0 | 0 | 17 | 1 |
| x402-monitor | 12 | 0 | 6 | 0 |
| schedule-ads | 0 | 0 | 16 | 1 |

---
*Source: GitHub API — forks of aeonfun/aeon. Code divergence compares fork commits/files with upstream; config divergence compares configured fork settings with this running instance’s defaults. Untouched templates are excluded.*
