# Fork Divergence — 2026-09-14

**Verdict:** NEW UPSTREAM CANDIDATE: Boodszw/Boodszw_Bread expanded its reusable onchain integration pack from 4 to 9 skill files.

- **Code divergence:** ACTIVE FLEET: 43 forks crossed PROMOTE or REVIEW; Boodszw/Boodszw_Bread added five more skill files week over week.
- **Config divergence:** 20 forks converge on `monitor-polymarket` → `claude-sonnet-4-6`; 18 persistent disable-default votes remain unchanged.

Fleet: 264 total forks · 69 active · 0 managed instances · 69 community.

---

# Part 1 — Code divergence

## What changed this week
- **New forks in the processed active set:** niu12503/aeon, corinth1ans/aeon, 0xsnackbaker/aeon, krpx0341/aeon, Pinont/aeon.fun, caseykreps-eng/aeon, NurstarK/aeon-upstream
- **Went active:** none
- **New skills landed:** Boodszw/Boodszw_Bread → five additional OpenSea sub-skills; corinth1ans/aeon → `nq-research-scout`; 0xsnackbaker/aeon → `moltycash-campaign-agent`
- **Went stale:** not asserted because the 50-fork cap changed membership at the cutoff
- **Archived/deleted:** none confirmed

## PROMOTE — upstream contribution candidates

### Boodszw/Boodszw_Bread — score 126 [COMMUNITY]
**Activity:** last pushed 2026-09-14 · stars 0 · +21796/-869 commits vs upstream

**Unique skills:**
- `skills/alchemy/SKILL.md` — Multi-chain blockchain data through Alchemy, with API-key, x402, and MPP access paths.
- `skills/bankr/SKILL.md` — Natural-language crypto wallet, trading, automation, Polymarket, and paid-API access through Bankr.
- `skills/opensea/SKILL.md` — Router for OpenSea data, NFT trading, token swaps, wallet signing, and agent-tool registration.
- `skills/opensea/opensea-api/SKILL.md` — Specialized fork capability; review its operational and credential requirements before upstreaming.
- `skills/opensea/opensea-marketplace/SKILL.md` — Specialized fork capability; review its operational and credential requirements before upstreaming.
- `skills/opensea/opensea-swaps/SKILL.md` — Specialized fork capability; review its operational and credential requirements before upstreaming.
- `skills/opensea/opensea-tool-sdk/SKILL.md` — Specialized fork capability; review its operational and credential requirements before upstreaming.
- `skills/opensea/opensea-wallet/SKILL.md` — Specialized fork capability; review its operational and credential requirements before upstreaming.
- `skills/zerion/SKILL.md` — Agent-ready wallet, DeFi, NFT, transaction, PnL, gas, and swap intelligence across 41+ chains.

**Why promote:** This is a broad, vendor-backed onchain integration bundle with reusable data and transaction primitives.
**Suggested action:** Review and cherry-pick the relevant skill directory, or invite Boodszw to upstream it.

### czijian729-oss/aeon — score 56 [COMMUNITY]
**Activity:** last pushed 2026-09-04 · stars 0 · +203/-154 commits vs upstream

**Unique skills:**
- `skills/utoken-watch/SKILL.md` — Monitors µToken launch readiness via wallet, factory deployment, official social, and site-availability signals.

**Why promote:** The capability is distinct from upstream and potentially reusable, but should be generalized and safety-reviewed before merge.
**Suggested action:** Review and cherry-pick the relevant skill directory, or invite czijian729-oss to upstream it.

### enzoonchain/aeon — score 53 [COMMUNITY]
**Activity:** last pushed 2026-09-14 · stars 0 · +11237/-855 commits vs upstream

**Unique skills:**
- `skills/builder-post/SKILL.md` — Produces concise, data-first builder posts in a project-specific voice.
- `skills/delegation/SKILL.md` — Manages delegated API keys, usage accounting, revocation, and on-chain revenue sharing.

**Why promote:** The capability is distinct from upstream and potentially reusable, but should be generalized and safety-reviewed before merge.
**Suggested action:** Review and cherry-pick the relevant skill directory, or invite enzoonchain to upstream it.

### damo-nu11/aeon-minebean — score 48 [COMMUNITY]
**Activity:** last pushed 2026-09-14 · stars 0 · +5238/-855 commits vs upstream

**Unique skills:**
- `skills/mine-bean/SKILL.md` — Automates multi-round $BEAN mining on Base while amortizing agent-session overhead.

**Why promote:** The capability is distinct from upstream and potentially reusable, but should be generalized and safety-reviewed before merge.
**Suggested action:** Review and cherry-pick the relevant skill directory, or invite damo-nu11 to upstream it.

### UIZorrot/aeon — score 47 [COMMUNITY]
**Activity:** last pushed 2026-09-14 · stars 0 · +1948/-797 commits vs upstream

**Unique skills:**
- `skills/careful-finance/SKILL.md` — Scans Careful Finance perpetual and stablecoin opportunity feeds with explicit informational-only guardrails.

**Why promote:** The capability is distinct from upstream and potentially reusable, but should be generalized and safety-reviewed before merge.
**Suggested action:** Review and cherry-pick the relevant skill directory, or invite UIZorrot to upstream it.

## REVIEW — worth a look

| Fork | Score | Ahead | New/Modified | Notable |
|---|---:|---:|---:|---|
| Svector-anu/svectors-lab | 54 | +4547/-85 | 0/0 | dashboard changes, workflow changes, custom schedule/config |
| swarm-ai-research/aeon-atlas | 38 | +887/-777 | 0/0 | workflow changes, custom schedule/config |
| hansj73/aeon | 37 | +215/-88 | 0/0 | custom schedule/config |
| chxoky/aeon | 36 | +18607/-697 | 0/0 | workflow changes |
| taekwonv89/aeon | 36 | +20170/-836 | 0/0 | custom schedule/config |
| yugo-engineer/aeon | 36 | +1447/-996 | 0/0 | commit divergence |
| 0xMal0u/aeon | 35 | +9167/-843 | 0/0 | workflow changes, custom schedule/config |
| youpsla/aeon | 35 | +4216/-843 | 0/0 | workflow changes, custom schedule/config |
| madebyshun/blueagent-aeon | 35 | +1499/-859 | 0/0 | workflow changes, custom schedule/config |
| nigelon11/aeon | 35 | +495/-466 | 0/0 | dashboard changes |
| beijiangqukuailian/aeon | 34 | +261/-715 | 0/0 | workflow changes |
| stefrogovskyi/aeon | 33 | +88/-124 | 0/0 | dashboard changes, custom schedule/config |
| amritmirch/aeon | 33 | +125/-180 | 0/0 | workflow changes, custom schedule/config |
| pezetel/aeon | 33 | +5985/-891 | 0/0 | custom schedule/config |
| darkstaryuri/aeon | 33 | +14/-25 | 0/0 | custom schedule/config |

+ 18 additional REVIEW forks omitted for brevity.

## NOTE — low divergence
7 forks remained below REVIEW; these were minor or two-commit divergences.

## Fleet vs community

| Category | Count |
|---|---:|
| Managed instances (active) | 0 |
| Community forks (active) | 69 |
| Stale (30–365d) | 195 |
| Dormant (>365d) | 0 |

## Code source status
`forks_list=ok · compare_ok=50/50 · deep_read=5/5 · rate_limit_retries=0 · unreadable=0 · truncated_at=50`

---

# Part 2 — Config divergence

*Scanned 69 active forks of aeonfun/aeon; the 50 most recently pushed were processed. 49 are configured and one is an untouched template.*

## Default-flip candidates

### Enable upward
No skills crossed the 50% enable-upward threshold this week.

### Disable downward

| Skill | Forks disabled | % of configured | Δ vs last week |
|---|---:|---:|---|
| auto-merge | 47 | 96% | — |
| defi-overview | 48 | 98% | — |
| digest | 46 | 94% | — |
| fork-fleet | 47 | 96% | — |
| github-trending | 47 | 96% | — |
| memory-flush | 31 | 63% | — |
| narrative-tracker | 42 | 86% | — |
| picks-tracker | 28 | 57% | — |
| pr-review | 49 | 100% | — |
| search-skill | 47 | 96% | — |
| self-improve | 47 | 96% | — |
| shiplog | 27 | 55% | — |
| skill-health | 45 | 92% | — |
| skill-repair | 48 | 98% | — |
| token-pick | 45 | 92% | — |
| vuln-scanner | 48 | 98% | — |
| vuln-tracker | 35 | 71% | — |
| write-tweet | 45 | 92% | — |

All 18 disable votes persisted from last week; this is strong fleet disagreement, not a new weekly transition.

## Fleet consensus on alternative settings

### Model overrides
- `monitor-polymarket` — 20 forks → `claude-sonnet-4-6` (41% of configured); **NEW consensus this week**.

### Var hotspots
none this week

### Schedule overrides
- `defi-overview` — 47 forks use `0 12 * * *`
- `narrative-tracker` — 47 forks use `30 13 * * *`
- `heartbeat` — 26 forks use `0 8,14,20 * * *`
- `feature` — 22 forks use `0 10 * * 6`
- `write-tweet` — 22 forks use `0 17 * * *`
- `memory-flush` — 9 forks use `30 21 * * *`

## Watchlist (emerging — 25–49% adoption)
none this week

## Heaviest customizers (top 5)

| Fork | Total overrides | Dominant category | Notes |
|---|---:|---|---|
| chxoky/aeon | 192 | fork-only | 157 fork-only skills; 21 enable, 9 model, 5 schedule overrides |
| aeoncity-hub/aeon | 179 | fork-only | 149 fork-only skills; 25 enable, 0 model, 5 schedule overrides |
| ashneil12/aeon-upstream | 179 | fork-only | 149 fork-only skills; 25 enable, 0 model, 5 schedule overrides |
| NurstarK/aeon-upstream | 170 | fork-only | 137 fork-only skills; 21 enable, 7 model, 5 schedule overrides |
| sparkleware/aeon | 169 | fork-only | 136 fork-only skills; 21 enable, 7 model, 5 schedule overrides |

## Fork-only skills
2892 fork/skill pairs were observed. The week-over-week set added 165 pairs, but most reflect the local upstream catalog having contracted relative to older forks, so they are not treated as 165 independent launches.

Genuinely new code-side additions this week:
- corinth1ans/aeon → `nq-research-scout`
- 0xsnackbaker/aeon → `moltycash-campaign-agent`

## Config week-over-week
- NEW model consensus: `monitor-polymarket` → `claude-sonnet-4-6` in 20 forks.
- DEFAULT_FLIP_DISABLE set unchanged: 18 skills.
- One new top-five customizer: `NurstarK/aeon-upstream`; its apparent fork-only weight is primarily catalog-version drift.

## Fleet composition (config tiers)

| Tier | Count | % of processed |
|---|---:|---:|
| Configured | 49 | 98% |
| Template | 1 | 2% |
| Unreadable | 0 | 0% |
| **Total processed** | 50 | 100% |

## Config source status
- Trees fetched: 50 / 50
- aeon.yml readable: 50 / 50
- YAML parse failures: 0
- Rate-limited: 0
- Fork-only skill paths inspected: 2892

## Appendix — full divergence table

| Skill | Enable diff | Var overrides | Model overrides | Schedule overrides |
|---|---:|---:|---:|---:|
| defi-overview | 48 | 0 | 0 | 48 |
| narrative-tracker | 42 | 1 | 1 | 48 |
| write-tweet | 45 | 0 | 0 | 23 |
| feature | 32 | 0 | 0 | 23 |
| pr-review | 49 | 0 | 0 | 1 |
| self-improve | 47 | 0 | 0 | 2 |
| vuln-scanner | 48 | 0 | 0 | 1 |
| auto-merge | 47 | 0 | 0 | 1 |
| fork-fleet | 47 | 0 | 0 | 1 |
| github-trending | 47 | 0 | 0 | 1 |
| search-skill | 47 | 0 | 0 | 1 |
| skill-repair | 48 | 0 | 0 | 0 |
| auto-workflow | 47 | 0 | 0 | 0 |
| autoresearch | 47 | 0 | 0 | 0 |
| create-skill | 47 | 0 | 0 | 0 |
| digest | 46 | 0 | 0 | 1 |
| skill-health | 45 | 0 | 0 | 2 |
| token-pick | 45 | 0 | 0 | 1 |
| memory-flush | 31 | 0 | 0 | 10 |
| vuln-tracker | 35 | 0 | 0 | 1 |
| picks-tracker | 28 | 0 | 1 | 1 |
| heartbeat | 1 | 0 | 0 | 28 |
| shiplog | 27 | 0 | 0 | 1 |
| soul-builder | 27 | 0 | 0 | 0 |
| monitor-polymarket | 2 | 0 | 20 | 1 |
| hunter-22 | 21 | 0 | 0 | 1 |
| aeon-doctor | 20 | 0 | 0 | 1 |
| x402-monitor | 13 | 0 | 7 | 0 |
| operator-scorecard | 0 | 0 | 18 | 1 |
| schedule-ads | 0 | 0 | 17 | 1 |

+ 29 more skills with low-signal divergence.

---
*Source: GitHub API — forks of aeonfun/aeon. Code divergence compares unique commits and skills; config divergence compares configured forks with this instance’s local defaults. Untouched templates are excluded.*
