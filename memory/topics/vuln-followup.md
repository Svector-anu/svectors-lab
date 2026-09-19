# Vuln Tracker Status

*Last updated: 2026-09-19*

## Stars Secured

- **Merged-PR repos (secured):** ★ 172.8k across 10 live repos
- **Open-PR repos (in flight):** ★ 486.5k across 16 repos
- **All tracked repos:** ★ 1.63m across 98 live repos (100 repos total; 2 unavailable and excluded)

### Secured leaderboard — every merged PR ranked by repo stars

| Rank | Repo | Stars | PR | Merged | Severity | Title |
|---|---|---:|---|---|---|---|
| 1 | abhigyanpatwari/GitNexus | 47449 | [#3095](https://github.com/abhigyanpatwari/GitNexus/pull/3095) | 2026-08-30 | PRE-HISTORY | fix(deps): bump transitive packages to patch disclosed CVEs |
| 2 | tinyhumansai/openhuman | 39887 | [#5814](https://github.com/tinyhumansai/openhuman/pull/5814) | 2026-09-11 | PRE-HISTORY | fix(deps): bump mobile Tauri to patch GHSA-7gmj-67g7-phm9 |
| 3 | THU-MAIC/OpenMAIC | 37966 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | 2026-09-03 | PRE-HISTORY | fix(deps): bump disclosed dependencies |
| 4 | jdx/mise | 34092 | [#12714](https://github.com/jdx/mise/pull/12714) | 2026-09-02 | PRE-HISTORY | fix(deps): bump self_update to clear quick-xml advisories |
| 5 | pacifio/atlas | 4722 | [#233](https://github.com/pacifio/atlas/pull/233) | 2026-09-03 | PRE-HISTORY | fix(security): bind ACP fs handlers, strip event handlers |
| 6 | cloudflare/workers-sdk | 4549 | [#15584](https://github.com/cloudflare/workers-sdk/pull/15584) | 2026-09-10 | PRE-HISTORY | fix(deps): bump shell-quote |
| 7 | yetone/cumora | 3752 | [#8](https://github.com/yetone/cumora/pull/8) | 2026-08-18 | HIGH/MODERATE | fix(deps): patch known CVEs |
| 8 | pacifio/atlas | 4722 | [#220](https://github.com/pacifio/atlas/pull/220) | 2026-09-02 | PRE-HISTORY | fix(deps): bump disclosed dependencies |
| 9 | Cosmian/kms | 355 | [#1163](https://github.com/Cosmian/kms/pull/1163) | 2026-09-15 | PRE-HISTORY | fix(deps): bump brace-expansion and nanoid |
| 10 | Svector-anu/skopos | 1 | [#104](https://github.com/Svector-anu/skopos/pull/104) | 2026-08-21 | MEDIUM | fix(security): escape user text in RegExp |
| 11 | Svector-anu/vuln-template | 0 | [#5](https://github.com/Svector-anu/vuln-template/pull/5) | 2026-09-14 | PRE-HISTORY | fix(deps): bump disclosed dependencies |

### Per-repo breakdown — secured

| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|---|---:|---:|---|---|---|
| abhigyanpatwari/GitNexus | 47449 | 1 | 2026-08-30 | 2026-08-30 | PRE-HISTORY |
| tinyhumansai/openhuman | 39887 | 1 | 2026-09-11 | 2026-09-11 | PRE-HISTORY |
| THU-MAIC/OpenMAIC | 37966 | 1 | 2026-09-03 | 2026-09-03 | PRE-HISTORY |
| jdx/mise | 34092 | 1 | 2026-09-02 | 2026-09-02 | PRE-HISTORY |
| pacifio/atlas | 4722 | 2 | 2026-09-02 | 2026-09-03 | PRE-HISTORY |
| cloudflare/workers-sdk | 4549 | 1 | 2026-09-10 | 2026-09-10 | PRE-HISTORY |
| yetone/cumora | 3752 | 1 | 2026-08-18 | 2026-08-18 | HIGH/MODERATE |
| Cosmian/kms | 355 | 1 | 2026-09-15 | 2026-09-15 | PRE-HISTORY |
| Svector-anu/skopos | 1 | 1 | 2026-08-21 | 2026-08-21 | MEDIUM |
| Svector-anu/vuln-template | 0 | 1 | 2026-09-14 | 2026-09-14 | PRE-HISTORY |

### Per-repo breakdown — in flight

| Repo | Stars | Open PRs | Oldest open | Severities open |
|---|---:|---:|---|---|
| NousResearch/hermes-agent | 247100 | 1 | 2026-08-25 | PRE-HISTORY |
| rtk-ai/rtk | 81002 | 1 | 2026-08-25 | PRE-HISTORY |
| vercel-labs/agent-browser | 42874 | 1 | 2026-09-02 | PRE-HISTORY |
| vercel/ai | 26850 | 1 | 2026-09-09 | PRE-HISTORY |
| AprilNEA/OpenLogi | 21615 | 1 | 2026-08-25 | PRE-HISTORY |
| firecrawl/pdf-inspector | 19237 | 1 | 2026-09-02 | PRE-HISTORY |
| jlcodes99/cockpit-tools | 17969 | 1 | 2026-09-02 | PRE-HISTORY |
| corsairdev/corsair | 11467 | 1 | 2026-08-30 | PRE-HISTORY |
| vllm-project/semantic-router | 5870 | 1 | 2026-09-03 | PRE-HISTORY |
| arcboxlabs/arcbox | 5694 | 1 | 2026-09-02 | PRE-HISTORY |
| microsoft/skill-recorder | 4000 | 1 | 2026-08-18 | HIGH |
| step-security/harden-runner | 1272 | 1 | 2026-09-04 | PRE-HISTORY |
| clawkwork/clawk | 1011 | 1 | 2026-09-02 | PRE-HISTORY |
| snowflakedb/snowflake-cli | 267 | 1 | 2026-09-10 | PRE-HISTORY |
| paypal/agent-toolkit | 193 | 1 | 2026-09-05 | PRE-HISTORY |
| fireblocks/fireblocks-sdk-js | 84 | 1 | 2026-09-10 | HIGH |

### Per-repo breakdown — queued / skipped / closed

See the disclosure queue and closed-without-merge sections below. Star counts were refetched for all 100 tracked repo identifiers; `Nervercc/gpt_nerver` and the non-repository label `solana-mobile (SKR ecosystem)` were unavailable and excluded from aggregates.

## Operator-action queue

### Needs answer (2)

| Repo | Stars | PR | Last activity | Latest commenter |
|---|---:|---|---|---|
| NousResearch/hermes-agent | 247100 | [#94342](https://github.com/NousResearch/hermes-agent/pull/94342) | 2026-08-25 | Enough1122 — review flags unrelated lockfile drift |
| vllm-project/semantic-router | 5870 | [#3425](https://github.com/vllm-project/semantic-router/pull/3425) | 2026-09-10 | changes remain requested after the issue/link follow-up |

### Newly actionable — channel opened since original scan (0)

None.

### Stale or aging

| Repo | Stars | PR | Age | Status | Suggested action |
|---|---:|---|---:|---|---|
| microsoft/skill-recorder | 4000 | [#66](https://github.com/microsoft/skill-recorder/pull/66) | 32d | stale-no-review | Consider a polite maintainer ping. |
| rtk-ai/rtk | 81002 | [#3705](https://github.com/rtk-ai/rtk/pull/3705) | 25d | stale-no-review | Consider a polite maintainer ping. |
| AprilNEA/OpenLogi | 21615 | [#956](https://github.com/AprilNEA/OpenLogi/pull/956) | 25d | stale-no-review | Consider a polite maintainer ping. |
| corsairdev/corsair | 11467 | [#1421](https://github.com/corsairdev/corsair/pull/1421) | 20d | stale-no-review | Consider a polite maintainer ping. |
| clawkwork/clawk | 1011 | [#18](https://github.com/clawkwork/clawk/pull/18) | 17d | stale-no-review | Consider a polite maintainer ping. |
| vercel-labs/agent-browser | 42874 | [#1764](https://github.com/vercel-labs/agent-browser/pull/1764) | 17d | stale-no-review | Consider a polite maintainer ping. |
| jlcodes99/cockpit-tools | 17969 | [#2217](https://github.com/jlcodes99/cockpit-tools/pull/2217) | 17d | stale-no-review | Consider a polite maintainer ping. |
| arcboxlabs/arcbox | 5694 | [#709](https://github.com/arcboxlabs/arcbox/pull/709) | 17d | stale-no-review | Consider a polite maintainer ping. |
| firecrawl/pdf-inspector | 19237 | [#485](https://github.com/firecrawl/pdf-inspector/pull/485) | 17d | stale-no-review | Consider a polite maintainer ping. |
| step-security/harden-runner | 1272 | [#693](https://github.com/step-security/harden-runner/pull/693) | 15d | stale-no-review | Consider a polite maintainer ping. |
| paypal/agent-toolkit | 193 | [#101](https://github.com/paypal/agent-toolkit/pull/101) | 14d | stale-no-review | Consider a polite maintainer ping. |
| vercel/ai | 26850 | [#20573](https://github.com/vercel/ai/pull/20573) | 10d | stale-no-review | Review before pinging. |
| snowflakedb/snowflake-cli | 267 | [#3158](https://github.com/snowflakedb/snowflake-cli/pull/3158) | 9d | stale-no-review | Review automated feedback first. |
| fireblocks/fireblocks-sdk-js | 84 | [#344](https://github.com/fireblocks/fireblocks-sdk-js/pull/344) | 9d | stale-no-review | Review automated feedback first. |

## Recently merged (last 30d, 11)

The secured leaderboard contains all 11 merged PRs. No PR moved to merged since the prior poll.

## Open / clean (no operator action — wait, < 7d) (0)

None.

## Closed without merge (last 30d, 3)

| Date | Repo | Stars | PR | Severity | Title | Likely reason |
|---|---|---:|---|---|---|---|
| 2026-09-09 | emilk/egui | 30624 | [#8481](https://github.com/emilk/egui/pull/8481) | PRE-HISTORY | fix(deps): bump event-listener | Superseded upstream. |
| 2026-09-03 | affaan-m/ECC | 262715 | [#2934](https://github.com/affaan-m/ECC/pull/2934) | PRE-HISTORY | fix(deps): bump @humanfs/node | Superseded by merged #2948. |
| 2026-08-25 | dani-garcia/vaultwarden | 67857 | [#7651](https://github.com/dani-garcia/vaultwarden/pull/7651) | PRE-HISTORY | fix(deps): bump h2 | Maintainer bundles dependency updates. |

## Disclosure queue (11 retained drafts)

| Severity | Repo | Stars | State | Age |
|---|---|---:|---|---:|
| MEDIUM | DigitalShieldOfficial/USDTPAY-woocommerce | 2 | cleanup (sent) | 32d |
| MEDIUM | NeoSoul-AI/neotrade-wallet-sdk | 0 | pending, auto-send armed | 10d |
| MEDIUM | ZSvirt/zsvirt | 1702 | escalate, email delivery blocked | 27d |
| CRITICAL | ZSvirt/zsvirt | 1702 | operator-todo | 27d |
| HIGH | amirh00sain/SpiderPanel | 1321 | cleanup (email-sent) | 25d |
| HIGH | amirh00sain/SpiderPanel | 1321 | pending, auto-send ready | 3d |
| LOW | genspark-ai/genoffice | 7234 | cleanup (submitted PVR) | 37d |
| MEDIUM | guillaumemeyer/watermarks-remover | 22369 | cleanup (accepted/fixed) | 35d |
| CRITICAL | jlcodes99/cockpit-tools | 17969 | cleanup (sent) | 17d |
| HIGH | pacifio/atlas | 4722 | cleanup (sent) | 17d |
| CRITICAL | z-fi/zFi | 17 | cleanup (sent/discussed) | 31d |

## Lost-draft ghosts

None identified.
