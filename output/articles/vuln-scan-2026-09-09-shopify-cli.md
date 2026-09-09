---
title: Vuln Scanner — Shopify/cli
description: Security audit of Shopify/cli (forced target) — CORS bypass flagged on an open PR before merge, dependency findings deferred to Dependabot, GHA hardening noted
tags: [security, vuln-scanner, shopify, cors, github-actions]
timestamp: 2026-09-09T23:05:00Z
resource: https://github.com/Shopify/cli
---

# Vuln Scanner — Shopify/cli

**Mode:** scan (forced target `var=Shopify/cli`)
**Repo:** Shopify/cli — 742 stars, TypeScript, active (last push 2026-09-09T22:19:18Z), not a fork, not archived
**Audited commit:** `ce5185ed5d2234e4ebb2a85ed460147679608af3` (fork clone, depth 200)
**PVR status:** enabled (`true`) — safe private channel exists if a code flaw is later confirmed
**SECURITY.md:** not present (not needed; PVR is on)

## Verdict

0 confirmed HIGH/CRITICAL code vulnerabilities on `main`. The scan's one substantive finding is **preventive, not retrospective**: an *open, unmerged* PR (#8320) on this repo would introduce a real credentialed-CORS bypass if merged as-is, and I left a review comment explaining it before that happens. Everything else triaged out as false positive, hardening-only, or already covered by the repo's own active Dependabot cadence.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 49 findings (44 WARNING, 5 ERROR) |
| trufflehog (filesystem) | ok | 0 verified secrets, 288MB scanned |
| trufflehog (git history) | ok | 0 verified secrets, 1.6GB / 472k chunks scanned in 1m55s, no timeout |
| osv-scanner | ok | 98 dependency-CVE rows across `pnpm-lock.yaml` (1844 packages) |
| slither | skip | no Solidity |
| fuzz (cargo-fuzz) | skip | TypeScript/JS monorepo, no `fuzz/fuzz_targets` |
| agentic audit | ok | N=10 budget (CODE_FILES=1061), 3 candidates written |
| PoC gate | not-required | no candidate reached a verified HIGH/CRITICAL code-flaw claim |

## Candidates reviewed (agentic + semgrep ERROR triage)

1. **CORS Origin reflection, `packages/app/src/cli/utilities/app/http-reverse-proxy.ts:78`** — the app-dev reverse proxy's OPTIONS handler sets `Access-Control-Allow-Origin: req.headers.origin ?? '*'` with no allowlist. On `main` today this is low-risk (no `Access-Control-Allow-Credentials`, so only non-credentialed simple requests can read a response). **Prior-art check surfaced open PR #8320** ("Fix CORS credentials on app-dev reverse-proxy preflight"), which adds `Access-Control-Allow-Credentials: true` whenever an `Origin` header is present, reasoning that reflecting the literal origin (instead of `*`) makes this safe. It doesn't: every origin satisfies its own reflection, so this is the textbook wildcard-CORS-with-credentials bypass — any website a developer's browser visits while `shopify app dev` (or `--use-localhost`) is running could send a credentialed cross-origin request to the local proxy and read the response. Per the skill's prior-art decision tree (match open → comment, don't file a duplicate), I posted a review comment explaining the bypass and suggesting an origin allowlist before the PR merges: https://github.com/Shopify/cli/pull/8320#issuecomment-5609874390. Not filed as a new PR or PVR — the flaw isn't live on `main`, and the PR thread is the right place to catch it pre-merge.
2. **GHA `run:` interpolation of `github` context, `.github/workflows/gardener-investigate-issue.yml:34` and `.github/workflows/release.yml:205`** — `${{ github.event.inputs.issue_number }}` / `${{ github.event.inputs.tag }}` are interpolated directly into `run:` shell blocks instead of via an intermediate env var. Real-world exploitability requires the attacker to already hold `workflow_dispatch`-trigger (write) access to the repo, so this doesn't cross an external-attacker privilege boundary today — logged as a hardening note, not filed (kept this run to the one CORS finding per "one report per repo per run").
3. **`execSync` with template string, `packages/plugin-cloudflare/src/install-cloudflared.ts:135`** and **`spawn` in `bin/run-command.js:11`** — both false positives. The first builds its shell string only from a fixed internal path or the user's own `SHOPIFY_CLI_CLOUDFLARED_PATH` env var (no privilege boundary — same local user attacking themselves); the second uses array-form `spawn` with no shell, so args aren't shell-interpreted.
4. **`detected-pgp-private-key-block`, `packages/app/src/cli/services/app-doctor-engine/rules/secret-rules.ts:84`** — false positive; this is the CLI's own secret-*redaction* rule definitions (a regex literal matching PGP key headers), not an actual leaked key.
5. **44 WARNING-level GHA hardening hits** (mutable action tags, workflow-level env secrets across ~15 workflow files) — common, broad, low-differentiation findings; not individually triaged or filed this run.

## Dependency findings (osv-scanner)

98 CVE rows, including 2 CRITICAL (`protobufjs` GHSA-xq3m-2v4x-88gg, `shell-quote` GHSA-w7jw-789q-3m8p). Both trace to transitive dependencies of dev/build/telemetry tooling (`@opentelemetry/otlp-transformer`, `@graphql-codegen/cli` via `nx`) — not the shipped CLI's runtime attack surface for untrusted external input. Dependabot is actively and continuously managing this repo's dependencies (5 grouped-update PRs merged/opened in the last 2 weeks alone, including ones already bumping `liquidjs` and `vitest` — two of the packages this scan flagged). Filing a competing manual dependency-bump PR here would be duplicate noise, not help — **duplicate-skipped**, no PR filed.

## Prior-art check

- CORS finding: `gh search issues --repo Shopify/cli -- "Access-Control-Allow-Origin"` surfaced open PR #8320 touching the exact same file/function → commented rather than filing a second PR (see above).
- GHA shell-injection findings: no matching open/closed issue or PR found; not filed this run (hardening-only, hardening findings deferred to keep one report per repo per run).
- Dependency findings: Dependabot's own grouped-update PRs (#8506, #8501, #8479, #8423, #8181) already cover this repo's dependency hygiene on an active weekly cadence.

## Disclosure channel

No PVR filed — no candidate reached verified HIGH/CRITICAL on `main` (the CORS regression is real but lives in an unmerged PR, not `main`, so the responsible action was a pre-merge review comment, not a PVR against shipped code). No dependency PR filed (Dependabot coverage). No email disclosure staged.

## Summary

- Cloned Shopify/cli at `ce5185e`, ran semgrep/trufflehog(x2)/osv-scanner (all `ok`), and an agentic entrypoint review (N=10, 3 candidates).
- 0 confirmed HIGH/CRITICAL vulnerabilities on `main`; PoC gate not required.
- Filed **1 disclosure action**: a review comment on open PR #8320 flagging that its proposed `Access-Control-Allow-Credentials: true` addition, combined with the existing unchecked `Origin` reflection in `http-reverse-proxy.ts`, creates a credentialed CORS bypass — before the PR merges.
- Dependency findings (98 CVE rows, 2 CRITICAL) deferred to the repo's own active Dependabot cadence — duplicate-skipped, no PR filed.
- Two GHA `run:`-interpolation hardening notes logged, not filed (both require pre-existing write access to trigger; kept this run to one filing per repo).
- State updated: `memory/vuln-scanned.json` (new row, channel `duplicate-skipped`), this report.
- Follow-up: none required from this run; watch PR #8320 for whether the maintainer adopts an origin allowlist.
