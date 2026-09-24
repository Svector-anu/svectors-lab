# Vuln Tracker Status

*Last updated: 2026-09-24*

## Stars Secured

- **Merged-PR repos (secured):** ★ 84.3k across 6 repos
- **Open-PR repos (in flight):** ★ 91.0k across 9 repos
- **All tracked repos:** ★ 478.5k across 18 repos

### Secured leaderboard — every merged PR ranked by repo stars
| Rank | Repo | Stars | PR | Merged | Severity | Title |
|------|------|-------|----|--------|----------|-------|
| 1 | THU-MAIC/OpenMAIC | 38,914 | [#1357](https://github.com/THU-MAIC/OpenMAIC/pull/1357) | 2026-09-03 | HIGH | bump next/js-yaml/undici/nanoid/lodash/sharp for disclosed CVEs |
| 2 | jdx/mise | 34,253 | [#12714](https://github.com/jdx/mise/pull/12714) | 2026-09-02 | dep | bump self_update to 1.3 to clear quick-xml advisories |
| 3 | pacifio/atlas | 6,159 | [#233](https://github.com/pacifio/atlas/pull/233) | 2026-09-03 | HIGH | bind ACP fs handlers to session roots, strip inline event handlers |
| 3 | pacifio/atlas | 6,159 | [#220](https://github.com/pacifio/atlas/pull/220) | 2026-09-02 | dep | bump gix/vite/mermaid/tar/js-yaml for disclosed CVEs |
| 4 | cloudflare/workers-sdk | 4,575 | [#15584](https://github.com/cloudflare/workers-sdk/pull/15584) | 2026-09-10 | CRITICAL+HIGH | bump shell-quote to patch CVE-2026-9277 (critical) / CVE-2026-13311 (high) |
| 5 | Cosmian/kms | 358 | [#1163](https://github.com/Cosmian/kms/pull/1163) | 2026-09-15 | dep | bump brace-expansion and nanoid to patch UI CVEs |
| 6 | Svector-anu/vuln-template | 0 | [#5](https://github.com/Svector-anu/vuln-template/pull/5) | 2026-09-14 | dep | bump packages (own test/template fork, not an external target) |

### Per-repo breakdown — secured (sorted by stars desc)
| Repo | Stars | Merged PRs | First merge | Latest merge | Severities landed |
|------|-------|------------|-------------|--------------|-------------------|
| THU-MAIC/OpenMAIC | 38,914 | 1 | 2026-09-03 | 2026-09-03 | HIGH |
| jdx/mise | 34,253 | 1 | 2026-09-02 | 2026-09-02 | dep |
| pacifio/atlas | 6,159 | 2 | 2026-09-02 | 2026-09-03 | HIGH, dep |
| cloudflare/workers-sdk | 4,575 | 1 | 2026-09-10 | 2026-09-10 | CRITICAL, HIGH |
| Cosmian/kms | 358 | 1 | 2026-09-15 | 2026-09-15 | dep |
| Svector-anu/vuln-template | 0 | 1 | 2026-09-14 | 2026-09-14 | dep (own fork) |

### Per-repo breakdown — in flight (sorted by stars desc)
| Repo | Stars | Open PRs | Oldest open | Severities open |
|------|-------|----------|-------------|-----------------|
| vercel-labs/agent-browser | 43,154 | 1 | 2026-09-02 (22d) | dep |
| jlcodes99/cockpit-tools | 18,335 | 1 | 2026-09-02 (22d) | HIGH |
| arcboxlabs/arcbox | 7,304 | 1 | 2026-09-02 (22d) | dep |
| step-security/harden-runner | 1,274 | 1 | 2026-09-04 (20d) | dep |
| clawkwork/clawk | 1,014 | 1 | 2026-09-02 (22d) | dep |
| paypal/agent-toolkit | 195 | 1 | 2026-09-05 (19d) | dep |
| snowflakedb/snowflake-cli | 267 | 1 | 2026-09-10 (14d) | dep |
| fireblocks/fireblocks-sdk-js | 85 | 1 | 2026-09-10 (14d) | dep |
| firecrawl/pdf-inspector | 19,328 | 1 | 2026-09-02 (22d) | HIGH |

**All 9 open PRs: zero human maintainer engagement.** Every comment/review present is an automated CI/security bot (semgrep, socket-security, snowflake-security-bot, pullfrog, cubic-dev-ai, claude-reviewer) — no maintainer has looked at any of these yet, ages run 14–22 days.

### Per-repo breakdown — closed-superseded (sorted by stars desc)
| Repo | Stars | PR | Closed | Severity | Note |
|------|-------|----|--------|----------|------|
| affaan-m/ECC | 266,638 | [#2934](https://github.com/affaan-m/ECC/pull/2934) | 2026-09-03 | dep | superseded by maintainer's consolidated merge #2948 — same fix landed |
| emilk/egui | 30,696 | [#8481](https://github.com/emilk/egui/pull/8481) | 2026-09-09 | dep | superseded — already fixed on main via #8515 |
| vllm-project/semantic-router | 5,911 | [#3425](https://github.com/vllm-project/semantic-router/pull/3425) | 2026-09-20 | dep | superseded by maintainer's own #3944 (bumped further, to v0.41.0) |

All three CVEs shipped anyway via a different PR — no operator action, just bucket cleanup.

## Operator-action queue

### Needs answer (0)
None — no open PR has any human/maintainer comment or CHANGES_REQUESTED review.

### Newly actionable (0)
None — the only channel="skipped" scan-history entries (stripe/openapi, NeoSoul-AI/0g-builders, NeoSoul-AI/neotrade-release) were skipped for "no scannable content," not a no-PVR/no-SECURITY.md blocker, so there is nothing to re-probe.

### Stale — zero maintainer response (9)
| Repo | Stars | PR | Age | Suggested action |
|------|-------|----|----|--------------------|
| vercel-labs/agent-browser | 43,154 | #1764 | 22d | ping or let auto-close |
| firecrawl/pdf-inspector | 19,328 | #485 | 22d | ping |
| jlcodes99/cockpit-tools | 18,335 | #2217 | 22d | ping (HIGH severity, worth a nudge) |
| arcboxlabs/arcbox | 7,304 | #709 | 22d | bot-approved (pullfrog), just needs a maintainer to click merge |
| clawkwork/clawk | 1,014 | #18 | 22d | ping |
| step-security/harden-runner | 1,274 | #693 | 20d | ping |
| paypal/agent-toolkit | 195 | #101 | 19d | ping |
| snowflakedb/snowflake-cli | 267 | #3158 | 14d | wait one more week |
| fireblocks/fireblocks-sdk-js | 85 | #344 | 14d | wait one more week |

## Recently merged (last 30d, 7)
| Date merged | Repo | Stars | PR | Severity | Title |
|-------------|------|-------|----|----------|-------|
| 2026-09-15 | Cosmian/kms | 358 | #1163 | dep | brace-expansion + nanoid UI CVEs |
| 2026-09-14 | Svector-anu/vuln-template | 0 | #5 | dep | bump packages (own fork) |
| 2026-09-10 | cloudflare/workers-sdk | 4,575 | #15584 | CRITICAL+HIGH | shell-quote CVE-2026-9277/13311 |
| 2026-09-03 | pacifio/atlas | 6,159 | #233 | HIGH | ACP fs escape + XSS fix |
| 2026-09-03 | THU-MAIC/OpenMAIC | 38,914 | #1357 | HIGH | next/js-yaml/undici/nanoid/lodash/sharp |
| 2026-09-02 | pacifio/atlas | 6,159 | #220 | dep | gix/vite/mermaid/tar/js-yaml |
| 2026-09-02 | jdx/mise | 34,253 | #12714 | dep | self_update / quick-xml |

## Open / clean — no operator action, < 7d (0)
None — every open PR is already past the 7-day mark.

## Closed-superseded (last 30d, 3)
| Date | Repo | Stars | PR | Note |
|------|------|-------|----|------|
| 2026-09-20 | vllm-project/semantic-router | 5,911 | #3425 | superseded by maintainer's #3944 |
| 2026-09-09 | emilk/egui | 30,696 | #8481 | superseded, already on main via #8515 |
| 2026-09-03 | affaan-m/ECC | 266,638 | #2934 | superseded by consolidated #2948 |

## Queued (no PR — disclosure-only findings) (3)
| Severity | Repo | Original channel | Status | Days queued |
|----------|------|-------------------|--------|-------------|
| CRITICAL | ZSvirt/zsvirt | email (human_only) | pending-operator-send, unsent | 32d |
| CRITICAL | jlcodes99/cockpit-tools | email | sent | 22d |
| HIGH | pacifio/atlas | email | sent (code fix also merged via #233) | 22d |

(Full disclosure-queue aging — all severities, all channels — lives in the Arm C section of today's run output, not duplicated here.)

## Coverage gap — PVR triage tracking (flagged 2026-09-24)

Arm B's file-based lookup (`channel: pvr` in `memory/pending-disclosures/*.md`) finds **zero** matches — no local draft file has that exact schema. But cross-referencing `memory/vuln-scanned.json` + `memory/logs/` against live `gh api .../security-advisories/<GHSA>` turned up **10 real in-flight PVR submissions across 8 repos**, none of which any run has been polling:

| Repo | GHSA | Submitted | Age | State |
|------|------|-----------|-----|-------|
| genspark-ai/genoffice | GHSA-q3jr-86g4-cffw | 2026-08-18 | 37d | triage — **past 30d threshold** |
| NousResearch/hermes-agent | GHSA-3jv7-3pr9-766x | 2026-08-25 | 30d | triage — **at 30d threshold** |
| NousResearch/hermes-agent | GHSA-fw85-px44-j278 | 2026-08-25 | 30d | triage — **duplicate of 3jv7, same body, never withdrawn** |
| NousResearch/hermes-agent | GHSA-qjq9-cgwp-r73h | 2026-09-04 | 20d | triage |
| browser-use/video-use | GHSA-79fj-7f7h-8gxx | 2026-09-02 | 22d | triage |
| arcboxlabs/arcbox | GHSA-5p84-px8m-8gwv | 2026-09-02 | 22d | triage |
| crmne/fastpotify | GHSA-hqg7-6gj3-g28w | 2026-09-02 | 22d | triage |
| clawkwork/clawk | GHSA-f92w-wjfp-773j | 2026-09-02 | 22d | triage |
| paypal/agent-toolkit | GHSA-gqhm-vqwg-p28r | 2026-09-05 | 19d | triage |
| JustVugg/colibri | GHSA-p8g4-257m-g7pm | 2026-09-11 | 13d | triage |

Already resolved (for contrast, confirmed live): guillaumemeyer/watermarks-remover GHSA-pjg6-92pm-mmcf → `closed`.

**Root cause:** `vuln-scanner` only writes a local `memory/pending-disclosures/*.md` draft when a disclosure is *held back* (email needing operator review, or a PVR-API failure needing a manual fallback like genoffice/watermarks-remover). A PVR that submits cleanly via the API leaves no local record, so Arm B's file scan structurally can't see it. **Fix options:** (a) have `vuln-scanner` always write a `channel: pvr` stub file on every successful PVR submission, or (b) give Arm B a second source — reconstruct the PVR list from `vuln-scanned.json`'s `pvr`/`pvr+public-pr`/`pvr-submitted` channel rows the way this run just did by hand.

**Immediate action items:** withdraw the duplicate `GHSA-fw85-px44-j278` on hermes-agent; genoffice's advisory is 37 days unanswered — consider a maintainer ping or reassessing the low-severity finding's channel.
