# Vuln Tracker Status

*Last updated: 2026-09-06*

## Stars Secured

- **Merged-PR repos (secured):** ★ 119.7k across 6 repos
- **Open-PR repos (in flight):** ★ 516.1k across 16 repos
- **All tracked repos:** ★ 1.34m across 72 live repos

Star counts were fetched live. `solana-mobile (SKR ecosystem)` is not a GitHub `owner/repo`; `Nervercc/gpt_nerver` returns 404. Both are excluded from aggregates.

### Secured leaderboard — every merged PR ranked by repo stars

| Rank | Repo | Stars | PR | Merged | Severity | Title |
|------|------|-------|----|--------|----------|-------|
| 1 | abhigyanpatwari/GitNexus | 47080 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | 2026-08-30 | HIGH/MODERATE | dependency CVE bumps |
| 2 | jdx/mise | 33539 | [#12714](https://github.com/jdx/mise/pull/12714) | 2026-09-02 | HIGH | self_update / quick-xml advisory fix |
| 3 | THU-MAIC/OpenMAIC | 32335 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | 2026-09-03 | HIGH | dependency CVE bumps |
| 4 | yetone/cumora | 3489 | [#8](https://github.com/yetone/cumora/pull/8) | 2026-08-18 | HIGH/MODERATE | axios, DOMPurify, nanoid, postcss fixes |
| 5 | pacifio/atlas | 3251 | [#233](https://github.com/pacifio/atlas/pull/233) | 2026-09-03 | HIGH | ACP containment and browser-reader XSS fixes |
| 6 | pacifio/atlas | 3251 | [#220](https://github.com/pacifio/atlas/pull/220) | 2026-09-02 | HIGH | dependency CVE bumps |
| 7 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | 2026-08-21 | MEDIUM | escape user text before RegExp construction |

### Per-repo breakdown — secured

| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|------|-------|------------|-------------|--------------|-------------------|
| abhigyanpatwari/GitNexus | 47080 | 1 | 2026-08-30 | 2026-08-30 | HIGH/MODERATE |
| jdx/mise | 33539 | 1 | 2026-09-02 | 2026-09-02 | HIGH |
| THU-MAIC/OpenMAIC | 32335 | 1 | 2026-09-03 | 2026-09-03 | HIGH |
| yetone/cumora | 3489 | 1 | 2026-08-18 | 2026-08-18 | HIGH/MODERATE |
| pacifio/atlas | 3251 | 2 | 2026-09-02 | 2026-09-03 | HIGH |
| Svector-anu/skopos | 1 | 1 | 2026-08-21 | 2026-08-21 | MEDIUM |

### Per-repo breakdown — in flight

| Repo | Stars | Open PRs | Oldest open | Severities open |
|------|-------|----------|-------------|-----------------|
| NousResearch/hermes-agent | 242415 | 1 | 2026-08-25 | HIGH |
| rtk-ai/rtk | 79069 | 1 | 2026-08-25 | HIGH/MEDIUM |
| vercel-labs/agent-browser | 42050 | 1 | 2026-09-02 | HIGH |
| tinyhumansai/openhuman | 39465 | 1 | 2026-08-26 | HIGH |
| emilk/egui | 30445 | 1 | 2026-09-02 | HIGH |
| AprilNEA/OpenLogi | 19680 | 1 | 2026-08-25 | HIGH/MEDIUM |
| firecrawl/pdf-inspector | 18885 | 1 | 2026-09-02 | HIGH |
| jlcodes99/cockpit-tools | 17147 | 1 | 2026-09-02 | HIGH |
| corsairdev/corsair | 11327 | 1 | 2026-08-30 | HIGH |
| vllm-project/semantic-router | 5619 | 1 | 2026-09-03 | pre-history |
| microsoft/skill-recorder | 3862 | 1 | 2026-08-18 | HIGH |
| arcboxlabs/arcbox | 3357 | 1 | 2026-09-02 | HIGH |
| step-security/harden-runner | 1265 | 1 | 2026-09-04 | HIGH |
| clawkwork/clawk | 1007 | 1 | 2026-09-02 | HIGH |
| Cosmian/kms | 352 | 1 | 2026-09-02 | HIGH |
| paypal/agent-toolkit | 190 | 1 | 2026-09-05 | HIGH |

### Per-repo breakdown — queued / skipped / closed

| Repo | Stars | Status | Severity | Note |
|------|-------|--------|----------|------|
| affaan-m/ECC | 250925 | closed-no-merge | HIGH | #2934 was superseded by merged #2948; fix and co-author credit landed there. |
| dani-garcia/vaultwarden | 66938 | closed-no-merge | HIGH | Maintainer closed #7651; project prefers batched dependency/Rust updates. |
| guillaumemeyer/watermarks-remover | 20943 | submitted / cleanup | MEDIUM | Accepted and already fixed via #146. |
| jlcodes99/cockpit-tools | 17147 | submitted / cleanup | CRITICAL | Disclosure email sent. |
| genspark-ai/genoffice | 5663 | submitted / cleanup | LOW | PVR submitted; draft retained as history. |
| pacifio/atlas | 3251 | covered / cleanup | HIGH | Email sent and fix merged in #233. |
| ZSvirt/zsvirt | 1601 | operator-todo + pending | CRITICAL/MEDIUM | Critical draft needs operator action; armed medium send remains blocked by Resend configuration. |
| amirh00sain/SpiderPanel | 1153 | submitted / cleanup | HIGH | Disclosure email sent. |
| z-fi/zFi | 16 | submitted / cleanup | CRITICAL | Sent and discussed; retained draft is historical. |
| DigitalShieldOfficial/USDTPAY-woocommerce | 2 | submitted / cleanup | MEDIUM | Disclosure email sent. |

## Operator-action queue

### Needs answer (2)

| Repo | Stars | PR | Title | Last activity | Latest commenter |
|------|-------|----|-------|---------------|------------------|
| NousResearch/hermes-agent | 242415 | [#94342](https://github.com/NousResearch/hermes-agent/pull/94342) | h2 security bump | 2026-08-25 | Enough1122 requested removal or explanation of unrelated lockfile marker drift |
| vllm-project/semantic-router | 5619 | [#3425](https://github.com/vllm-project/semantic-router/pull/3425) | gRPC advisory bump | 2026-09-03 | FAUST-BENCHOU requested a linked issue; wilsonwu requested a DCO fix |

Cosmian/kms #1163 left this queue after the contributor answered the maintainer on 2026-09-05.

### Newly actionable — channel opened since original scan (0)

None.

### Stale or aging

| Repo | Stars | PR | Age | Status | Suggested action |
|------|-------|----|-----|--------|------------------|
| microsoft/skill-recorder | 3862 | [#66](https://github.com/microsoft/skill-recorder/pull/66) | 19d | stale-no-review | Confirm CI, then consider a polite ping. |
| AprilNEA/OpenLogi | 19680 | [#956](https://github.com/AprilNEA/OpenLogi/pull/956) | 12d | stale-no-review | Confirm CI, then consider a polite ping. |
| rtk-ai/rtk | 79069 | [#3705](https://github.com/rtk-ai/rtk/pull/3705) | 12d | stale-no-review | Sign or recheck the CLA, then consider a ping. |

## Recently merged (last 30d, 7)

| Date merged | Repo | Stars | PR | Severity | Title |
|-------------|------|-------|----|----------|-------|
| 2026-09-03 | pacifio/atlas | 3251 | [#233](https://github.com/pacifio/atlas/pull/233) | HIGH | ACP containment and browser-reader XSS fixes |
| 2026-09-03 | THU-MAIC/OpenMAIC | 32335 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | HIGH | dependency CVE bumps |
| 2026-09-02 | jdx/mise | 33539 | [#12714](https://github.com/jdx/mise/pull/12714) | HIGH | self_update / quick-xml advisory fix |
| 2026-09-02 | pacifio/atlas | 3251 | [#220](https://github.com/pacifio/atlas/pull/220) | HIGH | dependency CVE bumps |
| 2026-08-30 | abhigyanpatwari/GitNexus | 47080 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | HIGH/MODERATE | dependency CVE bumps |
| 2026-08-21 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | MEDIUM | RegExp injection fix |
| 2026-08-18 | yetone/cumora | 3489 | [#8](https://github.com/yetone/cumora/pull/8) | HIGH/MODERATE | dependency CVE bumps |

## Open / clean (no operator action — wait, < 7d) (9)

| Repo | Stars | PR | Severity | Opened | Age |
|------|-------|----|----------|--------|-----|
| paypal/agent-toolkit | 190 | [#101](https://github.com/paypal/agent-toolkit/pull/101) | HIGH | 2026-09-05 | 1d |
| step-security/harden-runner | 1265 | [#693](https://github.com/step-security/harden-runner/pull/693) | HIGH | 2026-09-04 | 2d |
| firecrawl/pdf-inspector | 18885 | [#485](https://github.com/firecrawl/pdf-inspector/pull/485) | HIGH | 2026-09-02 | 4d |
| emilk/egui | 30445 | [#8481](https://github.com/emilk/egui/pull/8481) | HIGH | 2026-09-02 | 4d |
| jlcodes99/cockpit-tools | 17147 | [#2217](https://github.com/jlcodes99/cockpit-tools/pull/2217) | HIGH | 2026-09-02 | 4d |
| vercel-labs/agent-browser | 42050 | [#1764](https://github.com/vercel-labs/agent-browser/pull/1764) | HIGH | 2026-09-02 | 4d |
| clawkwork/clawk | 1007 | [#18](https://github.com/clawkwork/clawk/pull/18) | HIGH | 2026-09-02 | 4d |
| arcboxlabs/arcbox | 3357 | [#709](https://github.com/arcboxlabs/arcbox/pull/709) | HIGH | 2026-09-02 | 4d |
| corsairdev/corsair | 11327 | [#1421](https://github.com/corsairdev/corsair/pull/1421) | HIGH | 2026-08-30 | 7d |

## Engaged, no operator action (2)

| Repo | Stars | PR | Severity | Opened | Latest maintainer activity |
|------|-------|----|----------|--------|----------------------------|
| tinyhumansai/openhuman | 39465 | [#5814](https://github.com/tinyhumansai/openhuman/pull/5814) | HIGH | 2026-08-26 | Approved; waiting for second maintainer approval |
| Cosmian/kms | 352 | [#1163](https://github.com/Cosmian/kms/pull/1163) | HIGH | 2026-09-02 | Maintainer feedback answered on 2026-09-05 |

## Closed without merge (last 30d, 2)

| Date | Repo | Stars | PR | Severity | Title | Likely reason |
|------|------|-------|----|----------|-------|---------------|
| 2026-08-25 | dani-garcia/vaultwarden | 66938 | [#7651](https://github.com/dani-garcia/vaultwarden/pull/7651) | HIGH | h2 security bump | Unrelated package downgrades; maintainer prefers batched updates. |
| 2026-09-03 | affaan-m/ECC | 250925 | [#2934](https://github.com/affaan-m/ECC/pull/2934) | HIGH | @humanfs/node security bump | Superseded by merged #2948; fix and co-author credit incorporated. |

## Queued (no PR yet) (9 retained drafts)

| Severity | Repo | Stars | State | Days queued |
|----------|------|-------|-------|-------------|
| CRITICAL | ZSvirt/zsvirt | 1601 | operator-todo | 14 |
| CRITICAL | jlcodes99/cockpit-tools | 17147 | submitted / cleanup | 4 |
| CRITICAL | z-fi/zFi | 16 | submitted / cleanup | 18 |
| HIGH | pacifio/atlas | 3251 | covered by merged PR #233 / cleanup | 4 |
| HIGH | amirh00sain/SpiderPanel | 1153 | submitted / cleanup | 12 |
| MEDIUM | ZSvirt/zsvirt | 1601 | escalate; autonomous send blocked by Resend 403 | 14 |
| MEDIUM | DigitalShieldOfficial/USDTPAY-woocommerce | 2 | submitted / cleanup | 19 |
| MEDIUM | guillaumemeyer/watermarks-remover | 20943 | accepted, already fixed / cleanup | 22 |
| LOW | genspark-ai/genoffice | 5663 | submitted / cleanup | 24 |

One retained draft is now a true past-threshold escalation: the automated ZSvirt dependency disclosure reached its 14-day MEDIUM threshold while the Resend send remains blocked. One separate draft is operator-todo, and seven are cleanup candidates.

## Lost-draft ghosts

None identified.
