# Vuln Tracker Status

*Last updated: 2026-09-02*

## Stars Secured

- **Merged-PR repos (secured):** ★ 86.6k across 5 repos
- **Open-PR repos (in flight):** ★ 779.5k across 15 repos
- **All tracked repos:** ★ 1.22m across 62 live repos

Star counts were fetched live. `solana-mobile (SKR ecosystem)` is not a GitHub `owner/repo`; `Nervercc/gpt_nerver` returns 404. Both are excluded from aggregates.

### Secured leaderboard — every merged PR ranked by repo stars

| Rank | Repo | Stars | PR | Merged | Severity | Title |
|------|------|-------|----|--------|----------|-------|
| 1 | abhigyanpatwari/GitNexus | 46897 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | 2026-08-30 | HIGH/MODERATE | fix(deps): bump transitive packages to patch disclosed CVEs |
| 2 | jdx/mise | 33395 | [#12714](https://github.com/jdx/mise/pull/12714) | 2026-09-02 | HIGH | fix(deps): bump self_update to 1.3 to clear quick-xml advisories |
| 3 | yetone/cumora | 3423 | [#8](https://github.com/yetone/cumora/pull/8) | 2026-08-18 | HIGH/MODERATE | fix(deps): patch known CVEs in axios, dompurify, nanoid, postcss |
| 4 | pacifio/atlas | 2849 | [#220](https://github.com/pacifio/atlas/pull/220) | 2026-09-02 | HIGH | fix(deps): bump gix/vite/mermaid/tar/js-yaml for disclosed CVEs |
| 5 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | 2026-08-21 | MEDIUM | fix(security): escape user text before constructing a RegExp |

### Per-repo breakdown — secured

| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|------|-------|------------|-------------|--------------|-------------------|
| abhigyanpatwari/GitNexus | 46897 | 1 | 2026-08-30 | 2026-08-30 | HIGH/MODERATE |
| jdx/mise | 33395 | 1 | 2026-09-02 | 2026-09-02 | HIGH |
| yetone/cumora | 3423 | 1 | 2026-08-18 | 2026-08-18 | HIGH/MODERATE |
| pacifio/atlas | 2849 | 1 | 2026-09-02 | 2026-09-02 | HIGH |
| Svector-anu/skopos | 1 | 1 | 2026-08-21 | 2026-08-21 | MEDIUM |

### Per-repo breakdown — in flight

| Repo | Stars | Open PRs | Oldest open | Severities open |
|------|-------|----------|-------------|-----------------|
| affaan-m/ECC | 246293 | 1 | 2026-09-02 | HIGH |
| NousResearch/hermes-agent | 240099 | 1 | 2026-08-25 | HIGH |
| rtk-ai/rtk | 78343 | 1 | 2026-08-25 | HIGH/MEDIUM |
| vercel-labs/agent-browser | 41802 | 1 | 2026-09-02 | HIGH |
| tinyhumansai/openhuman | 39349 | 1 | 2026-08-26 | HIGH |
| THU-MAIC/OpenMAIC | 30495 | 1 | 2026-09-02 | HIGH |
| emilk/egui | 30365 | 1 | 2026-09-02 | HIGH |
| AprilNEA/OpenLogi | 18592 | 1 | 2026-08-25 | HIGH/MEDIUM |
| firecrawl/pdf-inspector | 18480 | 1 | 2026-09-02 | HIGH |
| jlcodes99/cockpit-tools | 16934 | 1 | 2026-09-02 | HIGH |
| corsairdev/corsair | 11310 | 1 | 2026-08-30 | HIGH |
| microsoft/skill-recorder | 3770 | 1 | 2026-08-18 | HIGH |
| arcboxlabs/arcbox | 2346 | 1 | 2026-09-02 | HIGH |
| clawkwork/clawk | 1004 | 1 | 2026-09-02 | HIGH |
| Cosmian/kms | 350 | 1 | 2026-09-02 | HIGH |

### Per-repo breakdown — queued / skipped / closed

| Repo | Stars | Status | Severity | Note |
|------|-------|--------|----------|------|
| dani-garcia/vaultwarden | 66698 | closed-no-merge | HIGH | Maintainer closed #7651; project prefers batched dependency/Rust updates. |
| K-Dense-AI/scientific-agent-skills | 42083 | submitted | HIGH | GHSA exists in scan history; no canonical PVR tracking file. |
| browser-use/video-use | 23537 | submitted | MEDIUM | GHSA-79fj-7f7h-8gxx remains in triage. |
| genspark-ai/genoffice | 4404 | submitted / cleanup | LOW | GHSA-q3jr-86g4-cffw retained as history. |
| arcboxlabs/arcbox | 2346 | submitted | HIGH | GHSA-5p84-px8m-8gwv remains in triage. |
| crmne/fastpotify | 2193 | submitted | MEDIUM | GHSA-hqg7-6gj3-g28w remains in triage. |
| ZSvirt/zsvirt | 1563 | operator-todo + pending | CRITICAL/MEDIUM | Critical draft needs operator action; armed medium send remains blocked by Resend configuration. |
| ApodexAI/FrontierAgent | 1390 | submitted | HIGH | GHSA exists in scan history; no canonical PVR tracking file. |
| clawkwork/clawk | 1004 | submitted | MEDIUM | GHSA-f92w-wjfp-773j remains in triage. |

## Operator-action queue

### Needs answer (1)

| Repo | Stars | PR | Title | Last activity | Latest commenter |
|------|-------|----|-------|---------------|------------------|
| NousResearch/hermes-agent | 240099 | [#94342](https://github.com/NousResearch/hermes-agent/pull/94342) | h2 security bump | 2026-08-25 | Enough1122 — requested removal or explanation of unrelated lockfile marker drift |

### Newly actionable — channel opened since original scan (0)

None.

### Stale or aging

| Repo | Stars | PR | Age | Status | Suggested action |
|------|-------|----|-----|--------|------------------|
| microsoft/skill-recorder | 3770 | [#66](https://github.com/microsoft/skill-recorder/pull/66) | 15d | stale-no-review | Confirm CI, then consider a polite ping. |
| AprilNEA/OpenLogi | 18592 | [#956](https://github.com/AprilNEA/OpenLogi/pull/956) | 8d | stale-no-review | Confirm CI, then consider a polite ping. |
| rtk-ai/rtk | 78343 | [#3705](https://github.com/rtk-ai/rtk/pull/3705) | 8d | stale-no-review | Sign or recheck the CLA, then consider a ping. |

## Recently merged (last 30d, 5)

| Date merged | Repo | Stars | PR | Severity | Title |
|-------------|------|-------|----|----------|-------|
| 2026-09-02 | jdx/mise | 33395 | [#12714](https://github.com/jdx/mise/pull/12714) | HIGH | self_update/quick-xml advisory fix |
| 2026-09-02 | pacifio/atlas | 2849 | [#220](https://github.com/pacifio/atlas/pull/220) | HIGH | dependency CVE bumps |
| 2026-08-30 | abhigyanpatwari/GitNexus | 46897 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | HIGH/MODERATE | dependency CVE bumps |
| 2026-08-21 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | MEDIUM | RegExp injection fix |
| 2026-08-18 | yetone/cumora | 3423 | [#8](https://github.com/yetone/cumora/pull/8) | HIGH/MODERATE | dependency CVE bumps |

## Open / clean (no operator action — wait, 11)

| Repo | Stars | PR | Severity | Opened | Age |
|------|-------|----|----------|--------|-----|
| affaan-m/ECC | 246293 | [#2934](https://github.com/affaan-m/ECC/pull/2934) | HIGH | 2026-09-02 | 0d |
| tinyhumansai/openhuman | 39349 | [#5814](https://github.com/tinyhumansai/openhuman/pull/5814) | HIGH | 2026-08-26 | 7d |
| vercel-labs/agent-browser | 41802 | [#1764](https://github.com/vercel-labs/agent-browser/pull/1764) | HIGH | 2026-09-02 | 0d |
| emilk/egui | 30365 | [#8481](https://github.com/emilk/egui/pull/8481) | HIGH | 2026-09-02 | 0d |
| THU-MAIC/OpenMAIC | 30495 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | HIGH | 2026-09-02 | 0d |
| firecrawl/pdf-inspector | 18480 | [#485](https://github.com/firecrawl/pdf-inspector/pull/485) | HIGH | 2026-09-02 | 0d |
| jlcodes99/cockpit-tools | 16934 | [#2217](https://github.com/jlcodes99/cockpit-tools/pull/2217) | HIGH | 2026-09-02 | 0d |
| corsairdev/corsair | 11310 | [#1421](https://github.com/corsairdev/corsair/pull/1421) | HIGH | 2026-08-30 | 3d |
| arcboxlabs/arcbox | 2346 | [#709](https://github.com/arcboxlabs/arcbox/pull/709) | HIGH | 2026-09-02 | 0d |
| clawkwork/clawk | 1004 | [#18](https://github.com/clawkwork/clawk/pull/18) | HIGH | 2026-09-02 | 0d |
| Cosmian/kms | 350 | [#1163](https://github.com/Cosmian/kms/pull/1163) | HIGH | 2026-09-02 | 0d |

## Closed without merge (last 30d, 1)

| Date | Repo | Stars | PR | Severity | Title | Likely reason |
|------|------|-------|----|----------|-------|---------------|
| 2026-08-25 | dani-garcia/vaultwarden | 66698 | [#7651](https://github.com/dani-garcia/vaultwarden/pull/7651) | HIGH | h2 security bump | Unrelated package downgrades; maintainer prefers batched updates. |

## Queued (no PR yet) (9 retained drafts)

| Severity | Repo | Stars | Original channel | Original blocker | Days queued |
|----------|------|-------|------------------|------------------|-------------|
| CRITICAL | ZSvirt/zsvirt | 1563 | email | operator-only send | 10 |
| CRITICAL | jlcodes99/cockpit-tools | 16934 | email | autonomous send pending | 0 |
| CRITICAL | z-fi/zFi | 16 | email | sent/discussed; cleanup candidate | 14 |
| HIGH | pacifio/atlas | 2849 | email | autonomous send pending | 0 |
| HIGH | amirh00sain/SpiderPanel | 1042 | email | sent; cleanup candidate | 8 |
| MEDIUM | ZSvirt/zsvirt | 1563 | email | autonomous send blocked by Resend 403 | 10 |
| MEDIUM | DigitalShieldOfficial/USDTPAY-woocommerce | 1 | email | sent; cleanup candidate | 15 |
| MEDIUM | guillaumemeyer/watermarks-remover | 20087 | PVR | accepted; cleanup candidate | 18 |
| LOW | genspark-ai/genoffice | 4404 | PVR | submitted; cleanup candidate | 20 |

No retained draft is a true past-threshold escalation. Three are in-window, one is operator-todo, and five are cleanup candidates.

## Lost-draft ghosts (suppressed from notifications)

None identified.
