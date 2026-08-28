# Vuln Tracker Status

*Last updated: 2026-08-28*

## Stars Secured

- **Merged-PR repos (secured):** ★ 3.2k across 2 repos
- **Open-PR repos (in flight):** ★ 375.2k across 5 repos
- **All tracked repos:** ★ 609.9k across 41 live repos

One scan-history label (`solana-mobile (SKR ecosystem)`) is not a GitHub `owner/repo` and is excluded from repo and star aggregates.

### Secured leaderboard — every merged PR ranked by repo stars

| Rank | Repo | Stars | PR | Merged | Severity | Title |
|------|------|-------|----|--------|----------|-------|
| 1 | yetone/cumora | 3211 | [#8](https://github.com/yetone/cumora/pull/8) | 2026-08-18 | HIGH/MODERATE | fix(deps): patch known CVEs in axios, dompurify, nanoid, postcss |
| 2 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | 2026-08-21 | MEDIUM | fix(security): user text reached a RegExp unescaped in the polymarket filter |

### Per-repo breakdown — secured (sorted by stars desc)

| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|------|-------|------------|-------------|--------------|-------------------|
| yetone/cumora | 3211 | 1 | 2026-08-18 | 2026-08-18 | HIGH/MODERATE |
| Svector-anu/skopos | 1 | 1 | 2026-08-21 | 2026-08-21 | MEDIUM |

### Per-repo breakdown — in flight (sorted by stars desc)

| Repo | Stars | Open PRs | Oldest open | Severities open |
|------|-------|----------|-------------|-----------------|
| NousResearch/hermes-agent | 237728 | 1 | 2026-08-25 | HIGH |
| rtk-ai/rtk | 77737 | 1 | 2026-08-25 | HIGH/MEDIUM |
| tinyhumansai/openhuman | 38717 | 1 | 2026-08-26 | HIGH |
| AprilNEA/OpenLogi | 17398 | 1 | 2026-08-25 | HIGH/MEDIUM |
| microsoft/skill-recorder | 3627 | 1 | 2026-08-18 | HIGH |

### Per-repo breakdown — queued / skipped / closed (sorted by stars desc)

| Repo | Stars | Status | Severity | Note |
|------|-------|--------|----------|------|
| dani-garcia/vaultwarden | 66431 | closed-no-merge | HIGH | Maintainer closed #7651; the lock update downgraded unrelated packages and the project batches dependency/Rust updates. |
| guillaumemeyer/watermarks-remover | 19032 | cleanup | MEDIUM | GHSA accepted and closed; regression-test PR #146 merged. |
| genspark-ai/genoffice | 3869 | submitted / cleanup | LOW | GHSA-q3jr-86g4-cffw was submitted; retained draft is historical. |
| ZSvirt/zsvirt | 1492 | operator-todo | CRITICAL + MEDIUM | Vendor was contacted and acknowledged the findings; archive or normalize the two retained drafts. |
| amirh00sain/SpiderPanel | 842 | submitted / cleanup | HIGH | Disclosure sent manually on 2026-08-25. |
| z-fi/zFi | 16 | submitted / cleanup | CRITICAL (recalibrated) | Sent and discussed with the maintainer; retained draft is historical. |
| DigitalShieldOfficial/USDTPAY-woocommerce | 1 | submitted / cleanup | MEDIUM | Frontmatter records `status: sent`; retained draft is historical. |

## Operator-action queue

### Needs answer (1)

| Repo | Stars | PR | Title | Last activity | Latest commenter |
|------|-------|----|----|--------------|------------------|
| NousResearch/hermes-agent | 237728 | [#94342](https://github.com/NousResearch/hermes-agent/pull/94342) | h2 security bump | 2026-08-25 | Enough1122 — requested removal or explanation of unrelated lockfile marker drift |

### Newly actionable — channel opened up since the original scan (0)

None.

### Stale or aging

| Repo | Stars | PR | Age | Status | Suggested action |
|------|-------|----|----|-----|------------------|
| microsoft/skill-recorder | 3627 | [#66](https://github.com/microsoft/skill-recorder/pull/66) | 10d | stale-no-review | Consider a polite ping after confirming CI remains green. |

## Recently merged (last 30d, 2)

| Date merged | Repo | Stars | PR | Severity | Title |
|-------------|------|-------|----|----------|-------|
| 2026-08-21 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | MEDIUM | Escape user text before constructing a RegExp |
| 2026-08-18 | yetone/cumora | 3211 | [#8](https://github.com/yetone/cumora/pull/8) | HIGH/MODERATE | Patch known dependency CVEs |

## Open / clean (no operator action — wait, < 7d) (3)

| Repo | Stars | PR | Severity | Opened | Age |
|------|-------|----|----------|--------|-----|
| rtk-ai/rtk | 77737 | [#3705](https://github.com/rtk-ai/rtk/pull/3705) | HIGH/MEDIUM | 2026-08-25 | 3d |
| tinyhumansai/openhuman | 38717 | [#5814](https://github.com/tinyhumansai/openhuman/pull/5814) | HIGH | 2026-08-26 | 2d |
| AprilNEA/OpenLogi | 17398 | [#956](https://github.com/AprilNEA/OpenLogi/pull/956) | HIGH/MEDIUM | 2026-08-25 | 3d |

## Closed without merge (last 30d, 1)

| Date | Repo | Stars | PR | Severity | Title | Likely reason |
|------|------|-------|----|----------|-------|---------------|
| 2026-08-25 | dani-garcia/vaultwarden | 66431 | [#7651](https://github.com/dani-garcia/vaultwarden/pull/7651) | HIGH | h2 security bump | Unrelated package downgrades; maintainer prefers batched dependency and Rust updates. |

## Queued (no PR yet) (2 operator-held)

| Severity | Repo | Stars | Original channel | Original blocker | Days queued |
|----------|------|-------|------------------|------------------|-------------|
| CRITICAL | ZSvirt/zsvirt | 1492 | email | Operator-held; vendor already acknowledged | 5 |
| MEDIUM | ZSvirt/zsvirt | 1492 | email | Operator-held; vendor already acknowledged | 5 |

## Lost-draft ghosts (suppressed from notifications)

None.
