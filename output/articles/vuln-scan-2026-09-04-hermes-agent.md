---
title: vuln-scanner — NousResearch/hermes-agent
date: 2026-09-04
type: security-audit
---

# Vuln Scanner — NousResearch/hermes-agent

## Repo metadata

- **Repo:** [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) (~241,030 stars, Python/TypeScript, Electron desktop agent)
- **Audited commit:** `63279301bcbdc185c1b07b98a9312eb0c862f26d`
- **Selection:** trending pick (GitHub Trending 2026-09-03 chain output), not previously scanned within 30 days
- **PVR status:** enabled — used as the disclosure channel
- **SECURITY.md:** present

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep (`p/security-audit`, `p/owasp-top-ten`, `p/secrets`) | ok | 415 findings (357 WARNING / 58 ERROR) |
| trufflehog (`--only-verified`, filesystem) | ok | 1 verified secret |
| osv-scanner (`scan source --recursive --no-ignore`) | ok | 30 dependency-CVE rows across 5 lockfiles |
| slither | skipped | no `.sol` files in this repo |
| cargo-fuzz (A3.5) | skipped | no `fuzz/fuzz_targets` harness |
| agentic logic audit (A3.6) | ok | threat-modeled, budget N=6 (7,990 code files → large-repo tier) |

## Candidate count

- 415 semgrep hits, 30 osv dependency-CVE rows, 1 verified secret, 1 agentic candidate reviewed deeply (plus JWT/subprocess/CI-workflow/dangerouslySetInnerHTML clusters triaged from the semgrep output) → **2 confirmed findings**.

## Confirmed findings

### 1. HIGH — DOM injection via `blobMarkup` attribute breakout (verified)

- **File:** `apps/desktop/src/plugins/hermes-bots/avatar.tsx:212`
- **Attacker controls:** a remote group-chat participant's bot display name (`entry.from.name` — remote speakers get the deterministic face from their raw name, per the code's own comment)
- **Attacker achieves:** breaks out of the `data-bot-face` HTML attribute (string-built via `JSON.stringify` + concatenation, which does not neutralize `"` for HTML-attribute context) and injects a live sibling DOM element with an executable event-handler attribute (e.g. `<img onerror=...>`) via `dangerouslySetInnerHTML`
- **PoC gate:** `verified` — `local-command` verifier. A Node.js harness extracted the exact vulnerable expression verbatim from the shipped file, exercised it against a benign control (`"Assistant"` → 0 injected elements) and a malicious payload (`x"><img src=x onerror=window.__X__=1><svg x="` → exactly 1 live `<img onerror>` DOM element, confirmed via `querySelectorAll`/`parentElement`), parsed with `jsdom`
- **Channel:** PVR — [GHSA-qjq9-cgwp-r73h](https://github.com/NousResearch/hermes-agent/security/advisories/GHSA-qjq9-cgwp-r73h)

### 2. MEDIUM — live Algolia key with broader-than-documented ACL (verified secret)

- **File:** `website/docusaurus.config.ts:105`
- **Detail:** TruffleHog `--only-verified` confirmed the committed Algolia API key is live, with ACL `browse,listIndexes,search,settings` — the code comment claims "public search-only... safe to commit," but `settings` ACL permits modifying index configuration, which is broader than search-only
- **Channel:** PVR — bundled into the same report above (per "one report per repo per run")

## Channels used

- PVR: 1 (bundling both findings above) → [GHSA-qjq9-cgwp-r73h](https://github.com/NousResearch/hermes-agent/security/advisories/GHSA-qjq9-cgwp-r73h)
- Public PR: 0 (see dependency-CVE note below — all matched open prior art)
- Skipped: 0

## Dependency CVEs (osv-scanner) — not filed, duplicate prior art

30 CVE rows across `package-lock.json`, `website/package-lock.json`, `scripts/whatsapp-bridge/package-lock.json`, `uv.lock`, and `optional-skills/finance/dcf-model/requirements.txt` (browserslist, electron, extract-zip, fast-uri, nanoid, sanitize-html, qs, @xmldom/xmldom, tornado, h2, idna). Prior-art check found these already covered by open upstream PRs:

- [#101446](https://github.com/NousResearch/hermes-agent/pull/101446) "fix: clear npm and Python security advisories" — bumps browserslist, sanitize-html, nanoid, qs (website tree), onnxruntime, setuptools; verified with `npm audit` (0 vulnerabilities) and full test suite
- [#91906](https://github.com/NousResearch/hermes-agent/pull/91906) "fix(deps): close standalone Nano ID gap..." — includes the identical `website/package.json` nanoid override bump (3.3.17 → 3.3.18) I had independently prepared locally before finding this match
- [#94262](https://github.com/NousResearch/hermes-agent/pull/94262) "fix(security): bump electron to 43.3.0 and pin patched nanoid/postcss" — covers the root-workspace electron/nanoid/postcss CVEs

No new PR filed — logged as `duplicate-skipped` per the prior-art check. `tornado`/`h2`/`idna` (transitive, root Python project) have no open prior art but are not directly pinned in `pyproject.toml`; flagged here for a future run rather than hand-editing a generated lockfile without `uv lock --upgrade-package` verification.

## Prior-art check

- 1 candidate checked before filing (dependency CVEs, since PVR filing skips the mandatory check per the skill's guidance for private 1:1 reports) — searched `nanoid`, found 2 closed + 3 open matching PRs; the PVR itself required no separate search since it's a private code-vulnerability report, not a public filing.

## PoC gate status

- Finding 1 (DOM injection): `verified` (`local-command`, `jsdom` reproduction, bound to commit `6327930`, claim hash recorded by `vuln-poc-gate.sh`)
- Finding 2 (leaked secret): `not-required` — TruffleHog `--only-verified` is a pre-authenticated exemption per A4.5

## Dedup

`memory/vuln-scanned.json` updated: `NousResearch/hermes-agent`, `channel: pvr`, `findings: 2`, scanned_at `2026-09-04T07:06:25Z` (30-day skip).

## Notes

Most semgrep hits triaged as false positives after reading surrounding code: 3× `unverified-jwt-decode` (all diagnostic-only decodes after the real, properly-verified `jwt.decode` call already failed — never used for an authz decision), 2× `subprocess-injection`/`dangerous-subprocess-use-tainted-env-args` (argv-list `subprocess.run` calls with a locally-configured Python version string, no `shell=True`), 7× GitHub Actions `run-shell-injection` (none reference attacker-controlled expressions like `head_ref`/PR title — only `base_ref`, which a fork contributor cannot set), 1× `dangerouslySetInnerHTML` in `svg-embed.tsx` (DOMPurify-sanitized with the `svg` profile before render — safe).
