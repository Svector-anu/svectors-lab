# Vuln Tracker Status

*Last updated: 2026-09-04*

## Stars Secured

- **Merged-PR repos (secured):** ★ 118.5k across 6 repos
- **Open-PR repos (in flight):** ★ 511.9k across 14 repos
- **All tracked repos:** ★ 1.32m across 67 live repos

Star counts were fetched live. `solana-mobile (SKR ecosystem)` is not a GitHub `owner/repo`; `Nervercc/gpt_nerver` returns 404. Both are excluded from aggregates.

### Secured leaderboard — every merged PR ranked by repo stars

| Rank | Repo | Stars | PR | Merged | Severity | Title |
|------|------|-------|----|--------|----------|-------|
| 1 | abhigyanpatwari/GitNexus | 47003 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | 2026-08-30 | HIGH/MODERATE | fix(deps): bump transitive packages to patch disclosed CVEs |
| 2 | jdx/mise | 33473 | [#12714](https://github.com/jdx/mise/pull/12714) | 2026-09-02 | HIGH | fix(deps): bump self_update to 1.3 to clear quick-xml advisories |
| 3 | THU-MAIC/OpenMAIC | 31399 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | 2026-09-03 | HIGH | fix(deps): bump next/js-yaml/undici/nanoid/lodash/sharp for disclosed CVEs |
| 4 | yetone/cumora | 3474 | [#8](https://github.com/yetone/cumora/pull/8) | 2026-08-18 | HIGH/MODERATE | fix(deps): patch known CVEs in axios, dompurify, nanoid, postcss |
| 5 | pacifio/atlas | 3183 | [#233](https://github.com/pacifio/atlas/pull/233) | 2026-09-03 | HIGH | fix(security): bind ACP fs handlers to session roots, strip inline event handlers |
| 6 | pacifio/atlas | 3183 | [#220](https://github.com/pacifio/atlas/pull/220) | 2026-09-02 | HIGH | fix(deps): bump gix/vite/mermaid/tar/js-yaml for disclosed CVEs |
| 7 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | 2026-08-21 | MEDIUM | fix(security): escape user text before constructing a RegExp |

### Per-repo breakdown — secured

| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|------|-------|------------|-------------|--------------|-------------------|
| abhigyanpatwari/GitNexus | 47003 | 1 | 2026-08-30 | 2026-08-30 | HIGH/MODERATE |
| jdx/mise | 33473 | 1 | 2026-09-02 | 2026-09-02 | HIGH |
| THU-MAIC/OpenMAIC | 31399 | 1 | 2026-09-03 | 2026-09-03 | HIGH |
| yetone/cumora | 3474 | 1 | 2026-08-18 | 2026-08-18 | HIGH/MODERATE |
| pacifio/atlas | 3183 | 2 | 2026-09-02 | 2026-09-03 | HIGH |
| Svector-anu/skopos | 1 | 1 | 2026-08-21 | 2026-08-21 | MEDIUM |

### Per-repo breakdown — in flight

| Repo | Stars | Open PRs | Oldest open | Severities open |
|------|-------|----------|-------------|-----------------|
| NousResearch/hermes-agent | 241339 | 1 | 2026-08-25 | HIGH |
| rtk-ai/rtk | 78555 | 1 | 2026-08-25 | HIGH/MEDIUM |
| vercel-labs/agent-browser | 41943 | 1 | 2026-09-02 | HIGH |
| tinyhumansai/openhuman | 39412 | 1 | 2026-08-26 | HIGH |
| emilk/egui | 30422 | 1 | 2026-09-02 | HIGH |
| firecrawl/pdf-inspector | 18813 | 1 | 2026-09-02 | HIGH |
| AprilNEA/OpenLogi | 19206 | 1 | 2026-08-25 | HIGH/MEDIUM |
| jlcodes99/cockpit-tools | 17048 | 1 | 2026-09-02 | HIGH |
| corsairdev/corsair | 11338 | 1 | 2026-08-30 | HIGH |
| vllm-project/semantic-router | 5557 | 1 | 2026-09-03 | pre-history |
| microsoft/skill-recorder | 3833 | 1 | 2026-08-18 | HIGH |
| arcboxlabs/arcbox | 3074 | 1 | 2026-09-02 | HIGH |
| clawkwork/clawk | 1005 | 1 | 2026-09-02 | HIGH |
| Cosmian/kms | 351 | 1 | 2026-09-02 | HIGH |

### Per-repo breakdown — queued / skipped / closed

| Repo | Stars | Status | Severity | Note |
|------|-------|--------|----------|------|
| dani-garcia/vaultwarden | 66833 | closed-no-merge | HIGH | Maintainer closed #7651; project prefers batched dependency/Rust updates. |
| affaan-m/ECC | 248125 | closed-no-merge | HIGH | #2934 was superseded by merged #2948; the security fix and co-author credit landed there. |
| K-Dense-AI/scientific-agent-skills | 42586 | submitted | HIGH | GHSA exists in scan history; no canonical PVR tracking file. |
| browser-use/video-use | 23992 | submitted | MEDIUM | GHSA remains in triage; no canonical PVR tracking file. |
| genspark-ai/genoffice | 5094 | submitted / cleanup | LOW | PVR submission retained as history. |
| arcboxlabs/arcbox | 3074 | submitted | HIGH | GHSA remains in triage; no canonical PVR tracking file. |
| crmne/fastpotify | 3009 | submitted | MEDIUM | GHSA remains in triage; no canonical PVR tracking file. |
| ZSvirt/zsvirt | 1580 | operator-todo + pending | CRITICAL/MEDIUM | Critical draft needs operator action; armed medium send remains blocked by Resend configuration. |
| ApodexAI/FrontierAgent | 1677 | submitted | HIGH | GHSA exists in scan history; no canonical PVR tracking file. |
| clawkwork/clawk | 1005 | submitted | MEDIUM | GHSA remains in triage; no canonical PVR tracking file. |

## Operator-action queue

### Needs answer (3)

| Repo | Stars | PR | Title | Last activity | Latest commenter |
|------|-------|----|-------|---------------|------------------|
| NousResearch/hermes-agent | 241339 | [#94342](https://github.com/NousResearch/hermes-agent/pull/94342) | h2 security bump | 2026-08-25 | Enough1122 — requested removal or explanation of unrelated lockfile marker drift |
| Cosmian/kms | 351 | [#1163](https://github.com/Cosmian/kms/pull/1163) | UI dependency hardening | 2026-09-03 | Manuthor — asked to reframe the risk and add focused validation |
| vllm-project/semantic-router | 5557 | [#3425](https://github.com/vllm-project/semantic-router/pull/3425) | gRPC advisory bump | 2026-09-03 | FAUST-BENCHOU requested changes; wilsonwu asked to fix DCO |

### Newly actionable — channel opened since original scan (0)

None.

### Stale or aging

| Repo | Stars | PR | Age | Status | Suggested action |
|------|-------|----|-----|--------|------------------|
| microsoft/skill-recorder | 3833 | [#66](https://github.com/microsoft/skill-recorder/pull/66) | 17d | stale-no-review | Confirm CI, then consider a polite ping. |
| AprilNEA/OpenLogi | 19206 | [#956](https://github.com/AprilNEA/OpenLogi/pull/956) | 10d | stale-no-review | Confirm CI, then consider a polite ping. |
| rtk-ai/rtk | 78555 | [#3705](https://github.com/rtk-ai/rtk/pull/3705) | 10d | stale-no-review | Sign or recheck the CLA, then consider a ping. |

## Recently merged (last 30d, 7)

| Date merged | Repo | Stars | PR | Severity | Title |
|-------------|------|-------|----|----------|-------|
| 2026-09-03 | pacifio/atlas | 3183 | [#233](https://github.com/pacifio/atlas/pull/233) | HIGH | ACP filesystem containment and browser-reader XSS fixes |
| 2026-09-03 | THU-MAIC/OpenMAIC | 31399 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | HIGH | dependency CVE bumps |
| 2026-09-02 | jdx/mise | 33473 | [#12714](https://github.com/jdx/mise/pull/12714) | HIGH | self_update/quick-xml advisory fix |
| 2026-09-02 | pacifio/atlas | 3183 | [#220](https://github.com/pacifio/atlas/pull/220) | HIGH | dependency CVE bumps |
| 2026-08-30 | abhigyanpatwari/GitNexus | 47003 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | HIGH/MODERATE | dependency CVE bumps |
| 2026-08-21 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | MEDIUM | RegExp injection fix |
| 2026-08-18 | yetone/cumora | 3474 | [#8](https://github.com/yetone/cumora/pull/8) | HIGH/MODERATE | dependency CVE bumps |

## Open / clean (no operator action — wait, < 7d) (7)

| Repo | Stars | PR | Severity | Opened | Age |
|------|-------|----|----------|--------|-----|
| vercel-labs/agent-browser | 41943 | [#1764](https://github.com/vercel-labs/agent-browser/pull/1764) | HIGH | 2026-09-02 | 2d |
| emilk/egui | 30422 | [#8481](https://github.com/emilk/egui/pull/8481) | HIGH | 2026-09-02 | 2d |
| firecrawl/pdf-inspector | 18813 | [#485](https://github.com/firecrawl/pdf-inspector/pull/485) | HIGH | 2026-09-02 | 2d |
| jlcodes99/cockpit-tools | 17048 | [#2217](https://github.com/jlcodes99/cockpit-tools/pull/2217) | HIGH | 2026-09-02 | 2d |
| corsairdev/corsair | 11338 | [#1421](https://github.com/corsairdev/corsair/pull/1421) | HIGH | 2026-08-30 | 5d |
| arcboxlabs/arcbox | 3074 | [#709](https://github.com/arcboxlabs/arcbox/pull/709) | HIGH | 2026-09-02 | 2d |
| clawkwork/clawk | 1005 | [#18](https://github.com/clawkwork/clawk/pull/18) | HIGH | 2026-09-02 | 2d |

## Engaged, under aging threshold (1)

| Repo | Stars | PR | Severity | Opened | Latest maintainer activity |
|------|-------|----|----------|--------|----------------------------|
| tinyhumansai/openhuman | 39412 | [#5814](https://github.com/tinyhumansai/openhuman/pull/5814) | HIGH | 2026-08-26 | Approved; no changes requested (2026-09-02) |

## Closed without merge (last 30d, 2)

| Date | Repo | Stars | PR | Severity | Title | Likely reason |
|------|------|-------|----|----------|-------|---------------|
| 2026-08-25 | dani-garcia/vaultwarden | 66833 | [#7651](https://github.com/dani-garcia/vaultwarden/pull/7651) | HIGH | h2 security bump | Unrelated package downgrades; maintainer prefers batched updates. |
| 2026-09-03 | affaan-m/ECC | 248125 | [#2934](https://github.com/affaan-m/ECC/pull/2934) | HIGH | @humanfs/node security bump | Superseded by merged #2948; fix and co-author credit incorporated. |

## Queued (no PR yet) (9 retained drafts)

| Severity | Repo | Stars | Original channel | Original blocker | Days queued |
|----------|------|-------|------------------|------------------|-------------|
| CRITICAL | ZSvirt/zsvirt | 1580 | email | operator-only send | 12 |
| CRITICAL | jlcodes99/cockpit-tools | 17048 | email | sent; cleanup candidate | 2 |
| CRITICAL | z-fi/zFi | 16 | email | sent/discussed; cleanup candidate | 15 |
| HIGH | pacifio/atlas | 3183 | email | sent and covered by merged PR #233; cleanup candidate | 2 |
| HIGH | amirh00sain/SpiderPanel | 1104 | email | sent; cleanup candidate | 10 |
| MEDIUM | ZSvirt/zsvirt | 1580 | email | autonomous send blocked by Resend 403 | 12 |
| MEDIUM | DigitalShieldOfficial/USDTPAY-woocommerce | 2 | email | sent; cleanup candidate | 17 |
| MEDIUM | guillaumemeyer/watermarks-remover | 20540 | PVR | accepted; cleanup candidate | 20 |
| LOW | genspark-ai/genoffice | 5094 | PVR | submitted; cleanup candidate | 22 |

No retained draft is a true past-threshold escalation. One is in-window, one is operator-todo, and seven are cleanup candidates.

## Lost-draft ghosts (suppressed from notifications)

None identified.
