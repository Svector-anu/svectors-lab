# Vuln Tracker Status

*Last updated: 2026-09-18*

## Stars Secured

- **Merged-PR repos (secured):** ★ 172.5k across 10 live repos
- **Open-PR repos (in flight):** ★ 485.4k across 16 repos
- **All tracked repos:** ★ 1.62m across 98 live repos (100 repos total; 2 unavailable and excluded)

### Secured leaderboard — every merged PR ranked by repo stars

| Rank | Repo | Stars | PR | Merged | Severity | Title |
|---|---|---:|---|---|---|---|
| 1 | abhigyanpatwari/GitNexus | 47429 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | 2026-08-30 | PRE-HISTORY | fix(deps): bump transitive packages to patch disclosed CVEs |
| 2 | tinyhumansai/openhuman | 39872 | [#5814](https://github.com/tinyhumansai/openhuman/pull/5814) | 2026-09-11 | PRE-HISTORY | fix(deps): bump mobile Tauri to patch GHSA-7gmj-67g7-phm9 |
| 3 | THU-MAIC/OpenMAIC | 37778 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | 2026-09-03 | PRE-HISTORY | fix(deps): bump disclosed dependencies |
| 4 | jdx/mise | 34077 | [#12714](https://github.com/jdx/mise/pull/12714) | 2026-09-02 | PRE-HISTORY | fix(deps): bump self_update to clear quick-xml advisories |
| 5 | pacifio/atlas | 4717 | [#233](https://github.com/pacifio/atlas/pull/233) | 2026-09-03 | PRE-HISTORY | fix(security): bind ACP fs handlers, strip event handlers |
| 6 | cloudflare/workers-sdk | 4548 | [#15584](https://github.com/cloudflare/workers-sdk/pull/15584) | 2026-09-10 | PRE-HISTORY | fix(deps): bump shell-quote |
| 7 | yetone/cumora | 3725 | [#8](https://github.com/yetone/cumora/pull/8) | 2026-08-18 | HIGH/MODERATE | fix(deps): patch known CVEs |
| 8 | pacifio/atlas | 4717 | [#220](https://github.com/pacifio/atlas/pull/220) | 2026-09-02 | PRE-HISTORY | fix(deps): bump disclosed dependencies |
| 9 | Cosmian/kms | 354 | [#1163](https://github.com/Cosmian/kms/pull/1163) | 2026-09-15 | PRE-HISTORY | fix(deps): bump brace-expansion and nanoid |
| 10 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | 2026-08-21 | MEDIUM | fix(security): escape user text in RegExp |
| 11 | Svector-anu/vuln-template | 0 | [#5](https://github.com/Svector-anu/vuln-template/pull/5) | 2026-09-14 | PRE-HISTORY | fix(deps): bump disclosed dependencies |

### Per-repo breakdown — secured

| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|---|---:|---:|---|---|---|
| abhigyanpatwari/GitNexus | 47429 | 1 | 2026-08-30 | 2026-08-30 | PRE-HISTORY |
| tinyhumansai/openhuman | 39872 | 1 | 2026-09-11 | 2026-09-11 | PRE-HISTORY |
| THU-MAIC/OpenMAIC | 37778 | 1 | 2026-09-03 | 2026-09-03 | PRE-HISTORY |
| jdx/mise | 34077 | 1 | 2026-09-02 | 2026-09-02 | PRE-HISTORY |
| pacifio/atlas | 4717 | 2 | 2026-09-02 | 2026-09-03 | PRE-HISTORY |
| cloudflare/workers-sdk | 4548 | 1 | 2026-09-10 | 2026-09-10 | PRE-HISTORY |
| yetone/cumora | 3725 | 1 | 2026-08-18 | 2026-08-18 | HIGH/MODERATE |
| Cosmian/kms | 354 | 1 | 2026-09-15 | 2026-09-15 | PRE-HISTORY |
| Svector-anu/skopos | 1 | 1 | 2026-08-21 | 2026-08-21 | MEDIUM |
| Svector-anu/vuln-template | 0 | 1 | 2026-09-14 | 2026-09-14 | PRE-HISTORY |

### Per-repo breakdown — in flight

| Repo | Stars | Open PRs | Oldest open | Severities open |
|---|---:|---:|---|---|
| NousResearch/hermes-agent | 246839 | 1 | 2026-08-25 | PRE-HISTORY |
| rtk-ai/rtk | 80912 | 1 | 2026-08-25 | PRE-HISTORY |
| vercel-labs/agent-browser | 42831 | 1 | 2026-09-02 | PRE-HISTORY |
| vercel/ai | 26827 | 1 | 2026-09-09 | PRE-HISTORY |
| AprilNEA/OpenLogi | 21525 | 1 | 2026-08-25 | PRE-HISTORY |
| firecrawl/pdf-inspector | 19216 | 1 | 2026-09-02 | PRE-HISTORY |
| jlcodes99/cockpit-tools | 17936 | 1 | 2026-09-02 | PRE-HISTORY |
| corsairdev/corsair | 11436 | 1 | 2026-08-30 | PRE-HISTORY |
| vllm-project/semantic-router | 5858 | 1 | 2026-09-03 | PRE-HISTORY |
| arcboxlabs/arcbox | 5191 | 1 | 2026-09-02 | PRE-HISTORY |
| microsoft/skill-recorder | 3977 | 1 | 2026-08-18 | HIGH |
| step-security/harden-runner | 1271 | 1 | 2026-09-04 | PRE-HISTORY |
| clawkwork/clawk | 1010 | 1 | 2026-09-02 | PRE-HISTORY |
| snowflakedb/snowflake-cli | 267 | 1 | 2026-09-10 | PRE-HISTORY |
| paypal/agent-toolkit | 194 | 1 | 2026-09-05 | PRE-HISTORY |
| fireblocks/fireblocks-sdk-js | 84 | 1 | 2026-09-10 | HIGH |

### Per-repo breakdown — queued / skipped / closed

See the disclosure queue and closed-without-merge sections below. Star counts were refetched for all 100 tracked repo identifiers; `Nervercc/gpt_nerver` and the non-repository label `solana-mobile (SKR ecosystem)` were unavailable and excluded from aggregates.

## Operator-action queue

### Needs answer (2)

| Repo | Stars | PR | Last activity | Latest commenter |
|---|---:|---|---|---|
| NousResearch/hermes-agent | 246839 | [#94342](https://github.com/NousResearch/hermes-agent/pull/94342) | 2026-08-25 | Enough1122 — review flags unrelated lockfile drift |
| vllm-project/semantic-router | 5858 | [#3425](https://github.com/vllm-project/semantic-router/pull/3425) | 2026-09-10 | changes remain requested after the issue/link follow-up |

### Newly actionable — channel opened since original scan (0)

None.

### Stale or aging

| Repo | Stars | PR | Age | Status | Suggested action |
|---|---:|---|---:|---|---|
| microsoft/skill-recorder | 3977 | [#66](https://github.com/microsoft/skill-recorder/pull/66) | 31d | stale-no-review | Consider a polite maintainer ping. |
| rtk-ai/rtk | 80912 | [#3705](https://github.com/rtk-ai/rtk/pull/3705) | 24d | stale-no-review | Consider a polite maintainer ping. |
| AprilNEA/OpenLogi | 21525 | [#956](https://github.com/AprilNEA/OpenLogi/pull/956) | 24d | stale-no-review | Consider a polite maintainer ping. |
| corsairdev/corsair | 11436 | [#1421](https://github.com/corsairdev/corsair/pull/1421) | 18d | stale-no-review | Consider a polite maintainer ping. |
| clawkwork/clawk | 1010 | [#18](https://github.com/clawkwork/clawk/pull/18) | 16d | stale-no-review | Consider a polite maintainer ping. |
| vercel-labs/agent-browser | 42831 | [#1764](https://github.com/vercel-labs/agent-browser/pull/1764) | 16d | stale-no-review | Consider a polite maintainer ping. |
| jlcodes99/cockpit-tools | 17936 | [#2217](https://github.com/jlcodes99/cockpit-tools/pull/2217) | 16d | stale-no-review | Consider a polite maintainer ping. |
| arcboxlabs/arcbox | 5191 | [#709](https://github.com/arcboxlabs/arcbox/pull/709) | 16d | stale-no-review | Consider a polite maintainer ping. |
| firecrawl/pdf-inspector | 19216 | [#485](https://github.com/firecrawl/pdf-inspector/pull/485) | 16d | stale-no-review | Consider a polite maintainer ping. |
| step-security/harden-runner | 1271 | [#693](https://github.com/step-security/harden-runner/pull/693) | 14d | stale-no-review | Consider a polite maintainer ping. |
| paypal/agent-toolkit | 194 | [#101](https://github.com/paypal/agent-toolkit/pull/101) | 13d | stale-no-review | Consider a polite maintainer ping. |
| vercel/ai | 26827 | [#20573](https://github.com/vercel/ai/pull/20573) | 9d | stale-no-review | Review before pinging. |
| snowflakedb/snowflake-cli | 267 | [#3158](https://github.com/snowflakedb/snowflake-cli/pull/3158) | 8d | stale-no-review | Review automated feedback first. |
| fireblocks/fireblocks-sdk-js | 84 | [#344](https://github.com/fireblocks/fireblocks-sdk-js/pull/344) | 8d | stale-no-review | Review automated feedback first. |

## Recently merged (last 30d, 11)

The secured leaderboard contains all 11 merged PRs. No PR moved to merged since the prior poll.

## Open / clean (no operator action — wait, < 7d) (0)

None.

## Closed without merge (last 30d, 3)

| Date | Repo | Stars | PR | Severity | Title | Likely reason |
|---|---|---:|---|---|---|---|
| 2026-09-09 | emilk/egui | 30607 | [#8481](https://github.com/emilk/egui/pull/8481) | PRE-HISTORY | fix(deps): bump event-listener | Superseded upstream. |
| 2026-09-03 | affaan-m/ECC | 261768 | [#2934](https://github.com/affaan-m/ECC/pull/2934) | PRE-HISTORY | fix(deps): bump @humanfs/node | Superseded by merged #2948. |
| 2026-08-25 | dani-garcia/vaultwarden | 67816 | [#7651](https://github.com/dani-garcia/vaultwarden/pull/7651) | PRE-HISTORY | fix(deps): bump h2 | Maintainer bundles dependency updates. |

## Disclosure queue (11 retained drafts)

| Severity | Repo | Stars | State | Age |
|---|---|---:|---|---:|
| MEDIUM | DigitalShieldOfficial/USDTPAY-woocommerce | 2 | cleanup (sent) | 31d |
| MEDIUM | NeoSoul-AI/neotrade-wallet-sdk | 0 | pending, auto-send armed | 9d |
| MEDIUM | ZSvirt/zsvirt | 1694 | escalate, email delivery blocked | 26d |
| CRITICAL | ZSvirt/zsvirt | 1694 | operator-todo | 26d |
| HIGH | amirh00sain/SpiderPanel | 1312 | cleanup (email-sent) | 24d |
| HIGH | amirh00sain/SpiderPanel | 1312 | pending, auto-send ready | 2d |
| LOW | genspark-ai/genoffice | 7147 | cleanup (submitted PVR) | 36d |
| MEDIUM | guillaumemeyer/watermarks-remover | 22303 | cleanup (accepted/fixed) | 34d |
| CRITICAL | jlcodes99/cockpit-tools | 17936 | cleanup (sent) | 16d |
| HIGH | pacifio/atlas | 4717 | cleanup (sent) | 16d |
| CRITICAL | z-fi/zFi | 17 | cleanup (sent/discussed) | 30d |

## Lost-draft ghosts

None identified.
