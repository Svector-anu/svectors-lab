---
title: Vuln Scanner — circlefin/circle-nodejs-sdk
date: 2026-09-10
mode: scan
repo: circlefin/circle-nodejs-sdk
---

# Vuln Scanner — circlefin/circle-nodejs-sdk

## Repo metadata

- **Repo:** [circlefin/circle-nodejs-sdk](https://github.com/circlefin/circle-nodejs-sdk) — official Node.js/TypeScript SDK for the Circle API (payments, crypto payouts, stablecoins)
- **Stars:** 33 · **Language:** TypeScript · **Fork:** no · **Archived:** no
- **Last push:** 2026-06-18 · **Audited commit:** `901df789b6b9ec749931cfe3633b229eee834fca` (master)
- **PVR:** enabled · **SECURITY.md:** present (private disclosure requested, no public issues)

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 1 hit |
| trufflehog (filesystem) | ok | `--only-verified`, 0 verified secrets |
| trufflehog (git history) | ok | bounded run, completed in ~1.5s (not timeout), 0 verified secrets |
| osv-scanner | ok | `scan source --recursive --no-ignore`, 98 vulnerable-package rows in `yarn.lock` |
| slither | n/a | no Solidity in this repo |
| fuzz (cargo-fuzz) | n/a | no `fuzz/fuzz_targets`, not a Rust project |
| agentic | ok | 0 candidates — see below |

## Candidate count

- Semgrep: 1 candidate
- osv-scanner: 98 dependency-CVE rows (1 runtime-relevant package, `axios`)
- Agentic logic audit: 0 candidates
- **Confirmed:** 0

## Findings detail

### 1. Semgrep: `secrets-inherit` on a local reusable workflow — discarded

`.github/workflows/release.yml:28` calls `./.github/workflows/npm-publish.yml` (a workflow file in the **same repository**, not a third-party action) with `secrets: inherit`. The rule targets the real risk of a compromised or third-party reusable workflow gaining access to every repo secret — that doesn't apply here since both workflows are maintained by the same team in the same repo, and the job is gated behind `release-please` creating an actual release. No attacker-controlled input reaches this path. Discarded on triage (A4: "write one sentence describing what an attacker controls and what they achieve" — could not).

### 2. osv-scanner: 98 dependency CVE rows — only `axios` is runtime-relevant

`package.json` declares exactly one runtime dependency: `axios@1.13.5`. Every other package flagged by osv-scanner (`@nestjs/*`, `@babel/*`, `ajv`, `browserslist`, `js-yaml`, `lodash`, `minimatch`, `picomatch`, `flatted`, `tmp`, etc. — 70 rows) is a `devDependency`-only transitive package that never ships in the published `@circle-fin/circle-sdk` npm package, so it carries no exploitable surface for SDK consumers.

`axios@1.13.5` itself carries 28 published GHSA rows, several fixed only in later 1.x releases, including one **HIGH** (GHSA-35jp-ww65-95wh / CVE-2026-44494, full MITM via prototype-pollution gadget in `config.proxy`, fixed ≥1.15.2).

**Prior-art check:** `gh search issues --repo circlefin/circle-nodejs-sdk -- "axios"` surfaced an existing open, mergeable Dependabot PR — [#151, "build(deps): bump axios from 1.13.5 to 1.16.0"](https://github.com/circlefin/circle-nodejs-sdk/pull/151) — and an open but low-content issue (#156, pointing at an unrelated npm-publish-lag issue #155). Per the duplicate-skip rule, no second PR was filed.

PR #151's target (1.16.0) does close the HIGH MITM advisory, but leaves 5 more medium-severity, already-published, upstream-fixed GHSAs open (all fixed only in axios ≥1.18.0):

| GHSA | CVE | Summary | Fixed in |
|---|---|---|---|
| GHSA-42h9-826w-cgv3 | CVE-2026-67313 | Excessive recursion in `formDataToJSON` (DoS) | 1.18.0 |
| GHSA-pmv8-rq9r-6j72 | CVE-2026-67312 | Deep `formToJSON` key recursion (DoS) | 1.18.0 |
| GHSA-7q8q-rj6j-mhjq | CVE-2026-67319 | Nested axios option objects consume polluted prototype values | 1.18.0 |
| GHSA-jqh4-m9w3-8hp9 | CVE-2026-67317 | Fetch adapter `ReadableStream` uploads bypass `maxBodyLength` | 1.18.0 |
| GHSA-mwf2-3pr3-8698 | CVE-2026-67318 | HTTP/2 streamed uploads bypass `maxBodyLength` | 1.18.0 |

This is already-public, GitHub-reviewed advisory data (verified via `gh api /advisories/<id>`), not an original finding — no PoC gate applies (A4.5's published-advisory exception). Since I had something concrete to add beyond a duplicate report, I left a comment on PR #151 with the verification block and a suggestion to target the current latest (1.20.0) instead of 1.16.0: https://github.com/circlefin/circle-nodejs-sdk/pull/151#issuecomment-5615017040

### 3. Agentic logic audit — 0 candidates

Threat model: this is a **client SDK**, not a server — it has no HTTP route handlers, no auth/session server code, no template rendering, no file-upload handling. The realistic attacker-relevant surface for an SDK is: unsafe eval/exec, insecure network defaults (TLS bypass, HTTP fallback), hardcoded/leaked credentials, and unsafe handling of user-supplied config that could reach a dangerous sink.

Reviewed the entire non-generated surface (`src/index.ts`, a 2-line re-export) plus the codegen bootstrap (`src/generated/base.ts`, `src/generated/configuration.ts`) and the OpenAPI-generator templates (`templates/typescript-axios/*.mustache`) that produce the ~255 remaining files under `src/generated/{apis,models}`. No `eval`/`Function`/`child_process`/`exec`, no `rejectUnauthorized`/TLS-bypass flags, no hardcoded secrets, `basePath` defaults are hardcoded HTTPS endpoints (`api.circle.com` / `api-sandbox.circle.com`). Generated `apis/*.ts` files are thin, uniformly-templated axios call wrappers with no custom control flow to audit individually. 0 candidates.

## PoC gate status

Not required — no HIGH/CRITICAL *original* code finding was raised. The one HIGH-severity item in scope (axios's MITM GHSA) is an already-published dependency advisory, which is explicitly exempt from the PoC gate (A4.5).

## Dedup note

Logged to `memory/vuln-scanned.json` as `channel: duplicate-skipped`, 0 confirmed findings, with the PR #151 comment link and full CVE breakdown in `notes`.

## Summary

Clean audit — 0 confirmed original vulnerabilities. The repo is a thin, OpenAPI-generated axios client with essentially no custom attacker-facing logic. The only real finding was a dependency hygiene gap: the repo's own open Dependabot PR under-shoots the fix (1.16.0 vs. needed 1.18.0+ for full coverage), addressed with a comment rather than a duplicate PR per the prior-art rule.

**Files modified:** `memory/vuln-scanned.json` (dedup entry appended), this report.
**External action taken:** one comment posted on `circlefin/circle-nodejs-sdk#151`.
**Follow-up:** none required — no channel-pending items, no PVR/disclosure needed.
