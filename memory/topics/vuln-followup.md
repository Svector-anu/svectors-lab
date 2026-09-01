# Vuln Tracker Status

*Last updated: 2026-09-01*

## Stars Secured

- **Merged-PR repos (secured):** ★ 50.2k across 3 repos
- **Open-PR repos (in flight):** ★ 390.1k across 6 repos
- **All tracked repos:** ★ 741.7k across 45 live repos

One scan-history label (`solana-mobile (SKR ecosystem)`) is not a GitHub `owner/repo` and is excluded from repo and star aggregates. `Nervercc/gpt_nerver` currently returns 404 and is excluded from aggregates as `repo-deleted`. Two pre-history PR repos discovered by the live searches are included.

### Secured leaderboard — every merged PR ranked by repo stars

| Rank | Repo | Stars | PR | Merged | Severity | Title |
|------|------|-------|----|--------|----------|-------|
| 1 | abhigyanpatwari/GitNexus | 46832 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | 2026-08-30 | HIGH/MODERATE | fix(deps): bump transitive packages to patch disclosed CVEs |
| 2 | yetone/cumora | 3386 | [#8](https://github.com/yetone/cumora/pull/8) | 2026-08-18 | HIGH/MODERATE | fix(deps): patch known CVEs in axios, dompurify, nanoid, postcss |
| 3 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | 2026-08-21 | MEDIUM | fix(security): user text reached a RegExp unescaped in the polymarket filter |

### Per-repo breakdown — secured (sorted by stars desc)

| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|------|-------|------------|-------------|--------------|-------------------|
| abhigyanpatwari/GitNexus | 46832 | 1 | 2026-08-30 | 2026-08-30 | HIGH/MODERATE |
| yetone/cumora | 3386 | 1 | 2026-08-18 | 2026-08-18 | HIGH/MODERATE |
| Svector-anu/skopos | 1 | 1 | 2026-08-21 | 2026-08-21 | MEDIUM |

### Per-repo breakdown — in flight (sorted by stars desc)

| Repo | Stars | Open PRs | Oldest open | Severities open |
|------|-------|----------|-------------|-----------------|
| NousResearch/hermes-agent | 239454 | 1 | 2026-08-25 | HIGH |
| rtk-ai/rtk | 78067 | 1 | 2026-08-25 | HIGH/MEDIUM |
| tinyhumansai/openhuman | 39290 | 1 | 2026-08-26 | HIGH |
| AprilNEA/OpenLogi | 18347 | 1 | 2026-08-25 | HIGH/MEDIUM |
| corsairdev/corsair | 11216 | 1 | 2026-08-30 | HIGH |
| microsoft/skill-recorder | 3729 | 1 | 2026-08-18 | HIGH |

### Per-repo breakdown — queued / skipped / closed (sorted by stars desc)

| Repo | Stars | Status | Severity | Note |
|------|-------|--------|----------|------|
| dani-garcia/vaultwarden | 66623 | closed-no-merge | HIGH | Maintainer closed #7651; the lock update downgraded unrelated packages and the project batches dependency/Rust updates. |
| K-Dense-AI/scientific-agent-skills | 41440 | submitted | HIGH | GHSA-3jvm-qqmm-hp97 remains in triage; PVR tracking file has not been created. |
| guillaumemeyer/watermarks-remover | 19821 | cleanup | MEDIUM | GHSA accepted and closed; regression-test PR #146 merged. |
| genspark-ai/genoffice | 4197 | submitted / cleanup | LOW | GHSA-q3jr-86g4-cffw remains in triage; retained draft is historical. |
| ZSvirt/zsvirt | 1543 | operator-todo | CRITICAL + MEDIUM | Vendor was contacted and acknowledged the findings; archive or normalize the two retained drafts. |
| ApodexAI/FrontierAgent | 1357 | submitted | HIGH | GHSA-ch5r-299j-j7h5 remains in triage; PVR tracking file has not been created. |
| amirh00sain/SpiderPanel | 1003 | submitted / cleanup | HIGH | Disclosure sent manually on 2026-08-25. |
| z-fi/zFi | 16 | submitted / cleanup | CRITICAL (recalibrated) | Sent and discussed with the maintainer; retained draft is historical. |
| DigitalShieldOfficial/USDTPAY-woocommerce | 1 | submitted / cleanup | MEDIUM | Frontmatter records `status: sent`; retained draft is historical. |

## Operator-action queue

### Needs answer (1)

| Repo | Stars | PR | Title | Last activity | Latest commenter |
|------|-------|----|----|--------------|------------------|
| NousResearch/hermes-agent | 239454 | [#94342](https://github.com/NousResearch/hermes-agent/pull/94342) | h2 security bump | 2026-08-25 | Enough1122 — requested removal or explanation of unrelated lockfile marker drift |

### Newly actionable — channel opened up since the original scan (0)

None.

### Stale or aging

| Repo | Stars | PR | Age | Status | Suggested action |
|------|-------|----|----|-----|------------------|
| microsoft/skill-recorder | 3729 | [#66](https://github.com/microsoft/skill-recorder/pull/66) | 14d | stale-no-review | Consider a polite ping after confirming CI remains green. |
| rtk-ai/rtk | 78067 | [#3705](https://github.com/rtk-ai/rtk/pull/3705) | 7d | stale-no-review | Sign or recheck the CLA, then consider a polite maintainer ping. |
| AprilNEA/OpenLogi | 18347 | [#956](https://github.com/AprilNEA/OpenLogi/pull/956) | 7d | stale-no-review | Consider a polite ping after confirming CI remains green. |

## Recently merged (last 30d, 3)

| Date merged | Repo | Stars | PR | Severity | Title |
|-------------|------|-------|----|----------|-------|
| 2026-08-30 | abhigyanpatwari/GitNexus | 46832 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | HIGH/MODERATE | Bump transitive packages to patch disclosed CVEs |
| 2026-08-21 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | MEDIUM | Escape user text before constructing a RegExp |
| 2026-08-18 | yetone/cumora | 3386 | [#8](https://github.com/yetone/cumora/pull/8) | HIGH/MODERATE | Patch known dependency CVEs |

## Open / clean (no operator action — wait, < 7d) (2)

| Repo | Stars | PR | Severity | Opened | Age |
|------|-------|----|----------|--------|-----|
| corsairdev/corsair | 11216 | [#1421](https://github.com/corsairdev/corsair/pull/1421) | HIGH | 2026-08-30 | 2d |
| tinyhumansai/openhuman | 39290 | [#5814](https://github.com/tinyhumansai/openhuman/pull/5814) | HIGH | 2026-08-26 | 6d |

## Closed without merge (last 30d, 1)

| Date | Repo | Stars | PR | Severity | Title | Likely reason |
|------|------|-------|----|----------|-------|---------------|
| 2026-08-25 | dani-garcia/vaultwarden | 66623 | [#7651](https://github.com/dani-garcia/vaultwarden/pull/7651) | HIGH | h2 security bump | Unrelated package downgrades; maintainer prefers batched dependency and Rust updates. |

## Queued (no PR yet) (2 operator-held)

| Severity | Repo | Stars | Original channel | Original blocker | Days queued |
|----------|------|-------|------------------|------------------|-------------|
| CRITICAL | ZSvirt/zsvirt | 1543 | email | Operator-held; vendor already acknowledged | 9 |
| MEDIUM | ZSvirt/zsvirt | 1543 | email | Autonomous email retry blocked by unverified Resend domain | 9 |

## Lost-draft ghosts (suppressed from notifications)

None.
