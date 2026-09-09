# Vuln Tracker Status

*Last updated: 2026-09-09*

## Stars Secured

- **Merged-PR repos (secured):** ★ 122.0k across 6 repos
- **Open-PR repos (in flight):** ★ 490.0k across 15 repos
- **All tracked repos:** ★ 1.36m across 80 live repos

Star counts were fetched live. `solana-mobile (SKR ecosystem)` is not a GitHub `owner/repo`; `Nervercc/gpt_nerver` returns 404. Both are excluded from aggregates.

### Secured leaderboard — every merged PR ranked by repo stars

| Rank | Repo | Stars | PR | Merged | Severity | Title |
|------|------|-------|----|--------|----------|-------|
| 1 | abhigyanpatwari/GitNexus | 47176 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | 2026-08-30 | HIGH/MODERATE | dependency CVE bumps |
| 2 | THU-MAIC/OpenMAIC | 34288 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | 2026-09-03 | HIGH | dependency CVE bumps |
| 3 | jdx/mise | 33702 | [#12714](https://github.com/jdx/mise/pull/12714) | 2026-09-02 | HIGH | self_update / quick-xml advisory fix |
| 4 | yetone/cumora | 3539 | [#8](https://github.com/yetone/cumora/pull/8) | 2026-08-18 | HIGH/MODERATE | axios, DOMPurify, nanoid, postcss fixes |
| 5 | pacifio/atlas | 3287 | [#233](https://github.com/pacifio/atlas/pull/233) | 2026-09-03 | HIGH | ACP containment and browser-reader XSS fixes |
| 6 | pacifio/atlas | 3287 | [#220](https://github.com/pacifio/atlas/pull/220) | 2026-09-02 | HIGH | dependency CVE bumps |
| 7 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | 2026-08-21 | MEDIUM | RegExp injection fix |

### Per-repo breakdown — secured

| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|------|-------|------------|-------------|--------------|-------------------|
| abhigyanpatwari/GitNexus | 47176 | 1 | 2026-08-30 | 2026-08-30 | HIGH/MODERATE |
| THU-MAIC/OpenMAIC | 34288 | 1 | 2026-09-03 | 2026-09-03 | HIGH |
| jdx/mise | 33702 | 1 | 2026-09-02 | 2026-09-02 | HIGH |
| yetone/cumora | 3539 | 1 | 2026-08-18 | 2026-08-18 | HIGH/MODERATE |
| pacifio/atlas | 3287 | 2 | 2026-09-02 | 2026-09-03 | HIGH |
| Svector-anu/skopos | 1 | 1 | 2026-08-21 | 2026-08-21 | MEDIUM |

### Per-repo breakdown — in flight

| Repo | Stars | Open PRs | Oldest open | Severities open |
|------|-------|----------|-------------|-----------------|
| NousResearch/hermes-agent | 243791 | 1 | 2026-08-25 | HIGH |
| rtk-ai/rtk | 79680 | 1 | 2026-08-25 | HIGH/MEDIUM |
| vercel-labs/agent-browser | 42303 | 1 | 2026-09-02 | HIGH |
| tinyhumansai/openhuman | 39567 | 1 | 2026-08-26 | HIGH |
| AprilNEA/OpenLogi | 20324 | 1 | 2026-08-25 | HIGH/MEDIUM |
| firecrawl/pdf-inspector | 18971 | 1 | 2026-09-02 | HIGH |
| jlcodes99/cockpit-tools | 17389 | 1 | 2026-09-02 | HIGH |
| corsairdev/corsair | 11315 | 1 | 2026-08-30 | HIGH |
| vllm-project/semantic-router | 5697 | 1 | 2026-09-03 | pre-history |
| arcboxlabs/arcbox | 4211 | 1 | 2026-09-02 | HIGH |
| microsoft/skill-recorder | 3899 | 1 | 2026-08-18 | HIGH |
| step-security/harden-runner | 1267 | 1 | 2026-09-04 | HIGH |
| clawkwork/clawk | 1009 | 1 | 2026-09-02 | HIGH |
| Cosmian/kms | 353 | 1 | 2026-09-02 | HIGH |
| paypal/agent-toolkit | 190 | 1 | 2026-09-05 | HIGH |

### Per-repo breakdown — queued / skipped / closed

| Repo | Stars | Status | Severity | Note |
|------|-------|--------|----------|------|
| affaan-m/ECC | 255002 | closed-no-merge | HIGH | #2934 was superseded by merged #2948; fix and co-author credit landed there. |
| dani-garcia/vaultwarden | 67068 | closed-no-merge | HIGH | Maintainer closed #7651; project prefers batched dependency/Rust updates. |
| emilk/egui | 30480 | closed-no-merge | HIGH | #8481 closed on 2026-09-09 without merge; review closure reason. |
| guillaumemeyer/watermarks-remover | 21236 | submitted / cleanup | MEDIUM | Accepted and already fixed via #146. |
| jlcodes99/cockpit-tools | 17389 | submitted / cleanup | CRITICAL | Disclosure email sent. |
| genspark-ai/genoffice | 5871 | submitted / cleanup | LOW | PVR submitted; draft retained as history. |
| pacifio/atlas | 3287 | covered / cleanup | HIGH | Email sent and fix merged in #233. |
| ZSvirt/zsvirt | 1644 | operator-todo + pending | CRITICAL/MEDIUM | Critical draft needs operator action; armed medium send remains blocked by Resend configuration. |
| amirh00sain/SpiderPanel | 1185 | submitted / cleanup | HIGH | Disclosure email sent. |
| NeoSoul-AI/neotrade-wallet-sdk | 0 | pending | MEDIUM | Armed for autonomous email; in-window at 0d. |
| z-fi/zFi | 17 | submitted / cleanup | CRITICAL | Sent and discussed; retained draft is historical. |
| DigitalShieldOfficial/USDTPAY-woocommerce | 2 | submitted / cleanup | MEDIUM | Disclosure email sent. |

## Operator-action queue

### Needs answer (2)

| Repo | Stars | PR | Title | Last activity | Latest commenter |
|------|-------|----|-------|---------------|------------------|
| NousResearch/hermes-agent | 243791 | [#94342](https://github.com/NousResearch/hermes-agent/pull/94342) | h2 security bump | 2026-08-25 | Enough1122 requested removal or explanation of unrelated lockfile marker drift |
| vllm-project/semantic-router | 5697 | [#3425](https://github.com/vllm-project/semantic-router/pull/3425) | gRPC advisory bump | 2026-09-07 | Xunzhuo requested a rebase plus matching `go.onnx.mod` updates after exact-head E2E failed |

### Newly actionable — channel opened since original scan (0)

None.

### Stale or aging

| Repo | Stars | PR | Age | Status | Suggested action |
|------|-------|----|-----|--------|------------------|
| microsoft/skill-recorder | 3899 | [#66](https://github.com/microsoft/skill-recorder/pull/66) | 22d | stale-no-review | Confirm CI, then consider a polite ping. |
| AprilNEA/OpenLogi | 20324 | [#956](https://github.com/AprilNEA/OpenLogi/pull/956) | 15d | stale-no-review | Confirm CI, then consider a polite ping. |
| rtk-ai/rtk | 79680 | [#3705](https://github.com/rtk-ai/rtk/pull/3705) | 15d | stale-no-review | Sign or recheck the CLA, then consider a ping. |
| corsairdev/corsair | 11315 | [#1421](https://github.com/corsairdev/corsair/pull/1421) | 10d | stale-no-review | CI is green; consider a polite maintainer ping. |
| firecrawl/pdf-inspector | 18971 | [#485](https://github.com/firecrawl/pdf-inspector/pull/485) | 7d | stale-no-review | Newly crossed the review window; consider a polite ping. |
| arcboxlabs/arcbox | 4211 | [#709](https://github.com/arcboxlabs/arcbox/pull/709) | 7d | stale-no-review | Newly crossed the review window; automated review is approved. |
| jlcodes99/cockpit-tools | 17389 | [#2217](https://github.com/jlcodes99/cockpit-tools/pull/2217) | 7d | stale-no-review | Newly crossed the review window; consider a polite ping. |
| vercel-labs/agent-browser | 42303 | [#1764](https://github.com/vercel-labs/agent-browser/pull/1764) | 7d | stale-no-review | Newly crossed the review window; consider a polite ping. |
| clawkwork/clawk | 1009 | [#18](https://github.com/clawkwork/clawk/pull/18) | 7d | stale-no-review | Newly crossed the review window; consider a polite ping. |

## Recently merged (last 30d, 7)

| Date merged | Repo | Stars | PR | Severity | Title |
|-------------|------|-------|----|----------|-------|
| 2026-09-03 | pacifio/atlas | 3287 | [#233](https://github.com/pacifio/atlas/pull/233) | HIGH | ACP containment and browser-reader XSS fixes |
| 2026-09-03 | THU-MAIC/OpenMAIC | 34288 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | HIGH | dependency CVE bumps |
| 2026-09-02 | jdx/mise | 33702 | [#12714](https://github.com/jdx/mise/pull/12714) | HIGH | self_update / quick-xml advisory fix |
| 2026-09-02 | pacifio/atlas | 3287 | [#220](https://github.com/pacifio/atlas/pull/220) | HIGH | dependency CVE bumps |
| 2026-08-30 | abhigyanpatwari/GitNexus | 47176 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | HIGH/MODERATE | dependency CVE bumps |
| 2026-08-21 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | MEDIUM | RegExp injection fix |
| 2026-08-18 | yetone/cumora | 3539 | [#8](https://github.com/yetone/cumora/pull/8) | HIGH/MODERATE | dependency CVE bumps |

## Open / clean (no operator action — wait) (2)

| Repo | Stars | PR | Severity | Opened | Age |
|------|-------|----|----------|--------|-----|
| paypal/agent-toolkit | 190 | [#101](https://github.com/paypal/agent-toolkit/pull/101) | HIGH | 2026-09-05 | 4d |
| step-security/harden-runner | 1267 | [#693](https://github.com/step-security/harden-runner/pull/693) | HIGH | 2026-09-04 | 5d |

## Engaged, no operator action (2)

| Repo | Stars | PR | Severity | Opened | Latest maintainer activity |
|------|-------|----|----------|--------|----------------------------|
| tinyhumansai/openhuman | 39567 | [#5814](https://github.com/tinyhumansai/openhuman/pull/5814) | HIGH | 2026-08-26 | Approved; waiting for second maintainer approval |
| Cosmian/kms | 353 | [#1163](https://github.com/Cosmian/kms/pull/1163) | HIGH | 2026-09-02 | Maintainer feedback answered on 2026-09-05 |

## Closed without merge (last 30d, 3)

| Date | Repo | Stars | PR | Severity | Title | Likely reason |
|------|------|-------|----|----------|-------|---------------|
| 2026-09-09 | emilk/egui | 30480 | [#8481](https://github.com/emilk/egui/pull/8481) | HIGH | event-listener security bump | Closed without a visible maintainer comment; inspect before deciding whether to revise. |
| 2026-09-03 | affaan-m/ECC | 255002 | [#2934](https://github.com/affaan-m/ECC/pull/2934) | HIGH | @humanfs/node security bump | Superseded by merged #2948; fix and co-author credit incorporated. |
| 2026-08-25 | dani-garcia/vaultwarden | 67068 | [#7651](https://github.com/dani-garcia/vaultwarden/pull/7651) | HIGH | h2 security bump | Unrelated package downgrades; maintainer prefers batched updates. |

## Queued (no PR yet) (10 retained drafts)

| Severity | Repo | Stars | State | Days queued |
|----------|------|-------|-------|-------------|
| CRITICAL | ZSvirt/zsvirt | 1644 | operator-todo | 17 |
| CRITICAL | jlcodes99/cockpit-tools | 17389 | submitted / cleanup | 7 |
| CRITICAL | z-fi/zFi | 17 | submitted / cleanup | 21 |
| HIGH | pacifio/atlas | 3287 | covered by merged PR #233 / cleanup | 7 |
| HIGH | amirh00sain/SpiderPanel | 1185 | submitted / cleanup | 15 |
| MEDIUM | ZSvirt/zsvirt | 1644 | escalate; autonomous send blocked by Resend 403 | 17 |
| MEDIUM | DigitalShieldOfficial/USDTPAY-woocommerce | 2 | submitted / cleanup | 22 |
| MEDIUM | guillaumemeyer/watermarks-remover | 21236 | accepted, already fixed / cleanup | 25 |
| MEDIUM | NeoSoul-AI/neotrade-wallet-sdk | 0 | pending autonomous send / in-window | 0 |
| LOW | genspark-ai/genoffice | 5871 | submitted / cleanup | 27 |

One retained draft remains a true past-threshold escalation: the automated ZSvirt dependency disclosure is 17 days old, beyond its 14-day MEDIUM threshold, while the Resend send remains blocked. One draft is operator-todo, one is in-window, and seven are cleanup candidates.

## Lost-draft ghosts

None identified.
