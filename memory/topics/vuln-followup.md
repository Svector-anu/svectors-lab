# Vuln Tracker Status

*Last updated: 2026-09-02*

## Stars Secured

- **Merged-PR repos (secured):** ★ 53.1k across 4 repos
- **Open-PR repos (in flight):** ★ 722.1k across 11 repos
- **All tracked repos:** ★ 886.3k across 55 live repos

One scan-history label (`solana-mobile (SKR ecosystem)`) is not a GitHub `owner/repo` and is excluded. `Nervercc/gpt_nerver` returns 404 and is also excluded. Star counts were fetched live for this run.

### Secured leaderboard — every merged PR ranked by repo stars

| Rank | Repo | Stars | PR | Merged | Severity | Title |
|------|------|-------|----|--------|----------|-------|
| 1 | abhigyanpatwari/GitNexus | 46889 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | 2026-08-30 | HIGH/MODERATE | fix(deps): bump transitive packages to patch disclosed CVEs |
| 2 | yetone/cumora | 3421 | [#8](https://github.com/yetone/cumora/pull/8) | 2026-08-18 | HIGH/MODERATE | fix(deps): patch known CVEs in axios, dompurify, nanoid, postcss |
| 3 | pacifio/atlas | 2773 | [#220](https://github.com/pacifio/atlas/pull/220) | 2026-09-02 | HIGH | fix(deps): bump gix/vite/mermaid/tar/js-yaml for disclosed CVEs |
| 4 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | 2026-08-21 | MEDIUM | fix(security): user text reached a RegExp unescaped in the polymarket filter |

### Per-repo breakdown — secured

| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|------|-------|------------|-------------|--------------|-------------------|
| abhigyanpatwari/GitNexus | 46889 | 1 | 2026-08-30 | 2026-08-30 | HIGH/MODERATE |
| yetone/cumora | 3421 | 1 | 2026-08-18 | 2026-08-18 | HIGH/MODERATE |
| pacifio/atlas | 2773 | 1 | 2026-09-02 | 2026-09-02 | HIGH |
| Svector-anu/skopos | 1 | 1 | 2026-08-21 | 2026-08-21 | MEDIUM |

### Per-repo breakdown — in flight

| Repo | Stars | Open PRs | Oldest open | Severities open |
|------|-------|----------|-------------|-----------------|
| affaan-m/ECC | 246157 | 1 | 2026-09-02 | HIGH |
| NousResearch/hermes-agent | 240005 | 1 | 2026-08-25 | HIGH |
| rtk-ai/rtk | 78322 | 1 | 2026-08-25 | HIGH/MEDIUM |
| tinyhumansai/openhuman | 39339 | 1 | 2026-08-26 | HIGH |
| jdx/mise | 33389 | 1 | 2026-09-02 | HIGH |
| THU-MAIC/OpenMAIC | 30428 | 1 | 2026-09-02 | HIGH |
| AprilNEA/OpenLogi | 18568 | 1 | 2026-08-25 | HIGH/MEDIUM |
| firecrawl/pdf-inspector | 18395 | 1 | 2026-09-02 | HIGH |
| corsairdev/corsair | 11307 | 1 | 2026-08-30 | HIGH |
| microsoft/skill-recorder | 3769 | 1 | 2026-08-18 | HIGH |
| arcboxlabs/arcbox | 2457 | 1 | 2026-09-02 | HIGH |

### Per-repo breakdown — queued / skipped / closed

| Repo | Stars | Status | Severity | Note |
|------|-------|--------|----------|------|
| dani-garcia/vaultwarden | 66682 | closed-no-merge | HIGH | Maintainer closed #7651; project prefers batched dependency/Rust updates. |
| K-Dense-AI/scientific-agent-skills | 42052 | submitted | HIGH | GHSA exists in scan history, but no PVR tracking file exists. |
| browser-use/video-use | 23431 | submitted | MEDIUM | GHSA-79fj-7f7h-8gxx filed today; no PVR tracking file exists. |
| guillaumemeyer/watermarks-remover | 20058 | cleanup | MEDIUM | Accepted and closed; retained draft is historical. |
| genspark-ai/genoffice | 4388 | submitted / cleanup | LOW | GHSA-q3jr-86g4-cffw remains in triage; retained draft is historical. |
| arcboxlabs/arcbox | 2457 | submitted | HIGH | GHSA-5p84-px8m-8gwv filed today; no PVR tracking file exists. |
| ZSvirt/zsvirt | 1561 | operator-todo + pending | CRITICAL/MEDIUM | Critical draft needs operator action; armed medium send remains blocked by Resend configuration. |
| ApodexAI/FrontierAgent | 1386 | submitted | HIGH | GHSA exists in scan history, but no PVR tracking file exists. |
| amirh00sain/SpiderPanel | 1038 | cleanup | HIGH | Email sent manually; retained draft is historical. |
| z-fi/zFi | 16 | cleanup | CRITICAL (recalibrated) | Sent and discussed with maintainer; retained draft is historical. |
| DigitalShieldOfficial/USDTPAY-woocommerce | 1 | cleanup | MEDIUM | Frontmatter records sent; retained draft is historical. |

## Operator-action queue

### Needs answer (1)

| Repo | Stars | PR | Title | Last activity | Latest commenter |
|------|-------|----|-------|---------------|------------------|
| NousResearch/hermes-agent | 240005 | [#94342](https://github.com/NousResearch/hermes-agent/pull/94342) | h2 security bump | 2026-08-25 | Enough1122 — requested removal or explanation of unrelated lockfile marker drift |

### Newly actionable — channel opened since original scan (0)

None.

### Stale or aging

| Repo | Stars | PR | Age | Status | Suggested action |
|------|-------|----|-----|--------|------------------|
| microsoft/skill-recorder | 3769 | [#66](https://github.com/microsoft/skill-recorder/pull/66) | 15d | stale-no-review | Confirm CI, then consider a polite ping. |
| AprilNEA/OpenLogi | 18568 | [#956](https://github.com/AprilNEA/OpenLogi/pull/956) | 8d | stale-no-review | Confirm CI, then consider a polite ping. |
| rtk-ai/rtk | 78322 | [#3705](https://github.com/rtk-ai/rtk/pull/3705) | 8d | stale-no-review | Sign or recheck the CLA, then consider a ping. |

## Recently merged (last 30d, 4)

| Date merged | Repo | Stars | PR | Severity | Title |
|-------------|------|-------|----|----------|-------|
| 2026-09-02 | pacifio/atlas | 2773 | [#220](https://github.com/pacifio/atlas/pull/220) | HIGH | Dependency CVE bumps |
| 2026-08-30 | abhigyanpatwari/GitNexus | 46889 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | HIGH/MODERATE | Dependency CVE bumps |
| 2026-08-21 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | MEDIUM | Escape user text before constructing a RegExp |
| 2026-08-18 | yetone/cumora | 3421 | [#8](https://github.com/yetone/cumora/pull/8) | HIGH/MODERATE | Dependency CVE bumps |

## Open / clean (no operator action, 7)

| Repo | Stars | PR | Severity | Opened | Age |
|------|-------|----|----------|--------|-----|
| affaan-m/ECC | 246157 | [#2934](https://github.com/affaan-m/ECC/pull/2934) | HIGH | 2026-09-02 | 0d |
| tinyhumansai/openhuman | 39339 | [#5814](https://github.com/tinyhumansai/openhuman/pull/5814) | HIGH | 2026-08-26 | 7d |
| jdx/mise | 33389 | [#12714](https://github.com/jdx/mise/pull/12714) | HIGH | 2026-09-02 | 0d |
| THU-MAIC/OpenMAIC | 30428 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | HIGH | 2026-09-02 | 0d |
| firecrawl/pdf-inspector | 18395 | [#485](https://github.com/firecrawl/pdf-inspector/pull/485) | HIGH | 2026-09-02 | 0d |
| corsairdev/corsair | 11307 | [#1421](https://github.com/corsairdev/corsair/pull/1421) | HIGH | 2026-08-30 | 3d |
| arcboxlabs/arcbox | 2457 | [#709](https://github.com/arcboxlabs/arcbox/pull/709) | HIGH | 2026-09-02 | 0d |

## Closed without merge (last 30d, 1)

| Date | Repo | Stars | PR | Severity | Title | Likely reason |
|------|------|-------|----|----------|-------|---------------|
| 2026-08-25 | dani-garcia/vaultwarden | 66682 | [#7651](https://github.com/dani-garcia/vaultwarden/pull/7651) | HIGH | h2 security bump | Unrelated package downgrades; maintainer prefers batched updates. |

## Disclosure queue (8 retained drafts)

| Severity | Repo | State | Age | Note |
|----------|------|-------|-----|------|
| CRITICAL | ZSvirt/zsvirt | operator-todo | 10d | Human-held critical disclosure; vendor contact context exists. |
| HIGH | pacifio/atlas | pending | 0d | Armed autonomous email send, in window. |
| MEDIUM | ZSvirt/zsvirt | pending | 10d | Armed autonomous email send, in window; prior Resend 403. |
| HIGH | amirh00sain/SpiderPanel | cleanup | 8d | Email sent. |
| MEDIUM | DigitalShieldOfficial/USDTPAY-woocommerce | cleanup | 15d | Sent. |
| LOW | genspark-ai/genoffice | cleanup | 20d | Submitted via PVR; still triage. |
| MEDIUM | guillaumemeyer/watermarks-remover | cleanup | 18d | Accepted and closed. |
| CRITICAL | z-fi/zFi | cleanup | 14d | Sent and discussed. |

No retained draft is a true past-threshold escalation after disclosure-state classification. PVR scan-history entries without canonical tracking files are a coverage gap for Arm B.

## Lost-draft ghosts

None identified.
