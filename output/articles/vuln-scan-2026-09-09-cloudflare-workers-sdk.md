---
title: "Vuln Scan — cloudflare/workers-sdk"
date: 2026-09-09
tags: [security, vuln-scanner, dependency-cve]
---

# Vuln Scan — cloudflare/workers-sdk

**Repo metadata:** ⭐ 4,522 · TypeScript · active (last push 2026-09-09) · SECURITY.md present · PVR enabled · not a fork. Home to Wrangler, the CLI for Cloudflare Workers.

**Scanner sources:**
| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 8 raw hits |
| trufflehog (filesystem) | ok | 0 verified secrets, 24,334 chunks / 247MB scanned |
| trufflehog (git history, bounded 300s) | ok | 0 verified secrets, 288,344 chunks / 264MB scanned |
| osv-scanner | ok | `pnpm-lock.yaml` (2,615 packages) + 1 Python requirements.txt; 346 dependency-CVE rows |
| slither | n/a | no Solidity in this repo |
| fuzz (cargo-fuzz) | n/a | no `fuzz/fuzz_targets` — TypeScript repo, not Rust |
| agentic logic audit | ok | 0 confirmed candidates from bounded top-exposure review |

**Candidates:** 8 (semgrep) + 346 dependency-CVE rows (103 unique HIGH/CRITICAL by GitHub's own severity rating) + 0 (agentic) = large raw candidate volume, triaged below.
**Confirmed:** 1 (dependency CVE, routed to a public PR).

## Semgrep findings — all triaged out (0 confirmed)

| # | Rule | Location | Verdict |
|---|---|---|---|
| 1 | `run-shell-injection` | `.github/actions/install-dependencies/action.yml:53` | False positive — interpolates composite-action *inputs* (caller-controlled config, e.g. turbo cache secrets), not `github.event.*` attacker data |
| 2 | `pull-request-target-code-checkout` | `.github/workflows/c3-dependabot-versioning-prs.yml:19` | Accepted risk, already reviewed by maintainers — explicit `zizmor: ignore[dangerous-triggers]` annotation; job gated to same-repo `dependabot[bot]` PRs only |
| 3 | `pull-request-target-code-checkout` | `.github/workflows/miniflare-dependabot-versioning-prs.yml:23` | Same as above — same gating pattern |
| 4 | `var-in-script-tag` | `packages/quick-edit/editor-files/workbench.html:44` | False positive — internal dev-editor shell, template var is HTML-escaped |
| 5 | `missing-user` (Dockerfile) | `packages/vite-plugin-cloudflare/playground/containers/Dockerfile:9` | Low-severity hardening item in a local playground/example container, not shipped — declined per "example/demo" exclusion |
| 6 | `gcm-no-tag-length` | `packages/workers-auth/src/credential-store/crypto.ts:132` | False positive — code explicitly validates `tag.length === TAG_LENGTH_BYTES` before `setAuthTag()`, and `decipher.final()` still verifies the tag; well-guarded |
| 7 | `wildcard-postmessage-configuration` | `packages/workers-editor-shared/lib/useInjectSources.tsx:80` | Low-risk — target is a locally-spawned, tool-controlled iframe (`format-errors` worker) used only to hand off a private `MessagePort`, not a foreign origin |
| 8 | `detect-pseudoRandomBytes` | `packages/wrangler/e2e/unenv-preset/worker/index.ts:143` | Test fixture (`e2e/`) exercising unenv API-compat, not production code |

## Agentic logic audit

Threat model: Wrangler et al. are developer tooling (CLI, local dev proxy, scaffolding), not an unauthenticated network service — the realistic attacker classes are (a) a malicious repo a developer runs `wrangler dev`/`deploy` inside, (b) the local `wrangler dev` proxy/inspector being reachable from other local processes or via DNS rebinding, (c) supply-chain risk in `create-cloudflare` (C3) scaffolding. Reviewed: credential-store encryption (`workers-auth/src/credential-store/crypto.ts` — sound, tag-length validated before use), `wrangler dev`'s cross-origin proxy header rewriting (`api/startDevWorker/utils.ts` — has explicit origin-matching logic, not a bare passthrough), `exec`/`spawn` call sites in `pages/deploy.ts`, `pages/dev.ts`, `pages/projects.ts` (all either static git commands or a user-supplied `--command` flag the same local operator already controls — not an external attacker-reachable injection). 0 confirmed candidates.

## Dependency findings (osv-scanner)

346 total dependency-vulnerability rows across the workspace's single `pnpm-lock.yaml` (2,615 packages). By GitHub's own advisory severity (not raw CVSS, which reads noisier — e.g. a Turborepo advisory scored 9.8 CVSS is rated LOW by GHSA because it needs a malicious *input* repo): 7 CRITICAL, 96 HIGH, 108 MODERATE, 24 LOW.

The large majority trace to: (a) transitive build/test tooling never shipped to users, and (b) example-app dependencies inside `fixtures/*` and `create-cloudflare`'s scaffolding templates (e.g. `better-auth`, `kysely`, `drizzle-orm`, `hono` pulled in as *scaffolded app* deps, not `workers-sdk`'s own runtime). The repo runs an **active Dependabot** (grouped, near-daily bumps — 5 merged/open PRs observed in the last 4 days alone), so this scan deferred the bulk of that debt to the existing automated cadence per this skill's dependency-CVE-vs-Dependabot judgment call, consistent with prior scans of large, well-maintained monorepos (Shopify/cli, rainbow-me/rainbow, parse-community/parse-server).

**One exception was pulled out and fixed directly:** `shell-quote`, a **direct** dependency of `packages/wrangler` (not transitive, not a fixture), imported by `src/utils/shell-quote.ts` and used from `src/init.ts` and `src/pages/dev.ts` — i.e. it's in the shipped CLI's own reachable code path, not scaffolding.

- **CVE-2026-9277 / GHSA-w7jw-789q-3m8p** (critical) — `quote()` fails to escape line terminators in an object token's `.op` field, allowing shell command injection for callers that pass object tokens through to a shell.
- **CVE-2026-13311 / GHSA-395f-4hp3-45gv** (high) — `parse()` is O(n²) in token count via an `Array.prototype.concat`-based reduce; plain space-separated input (no shell metacharacters needed) can block the Node event loop for tens of seconds.
- Fixed upstream in `1.9.0`. Wrangler was pinned to `1.8.1` (lockfile also carried a second vulnerable resolution, `1.8.3`, via `concurrently@8.2.2`).
- Reachability: wrangler's `parse()` wrapper is exposed to CLI-provided command strings (ReDoS applies); its `quote()` call site only ever passes string args, not object tokens (injection CVE not reachable via this call site specifically, but no reason to stay vulnerable).

**Prior-art check:** `gh search issues --include-prs -- "shell-quote"` and `"bump turbo"`-style queries turned up no open/recent PR addressing this specific CVE pair — clear to file.

**Fix applied:** bumped `packages/wrangler/package.json` `shell-quote` range from `^1.8.1` to `^1.9.0`, regenerated `pnpm-lock.yaml` via `pnpm install --lockfile-only --filter wrangler` (pnpm resolved `1.10.0`, which also fixed the `concurrently@8.2.2` transitive pin), added a changeset, and confirmed `tsc --noEmit` produces no new errors referencing `shell-quote` (the wrapper's `.parse`/`.quote` API surface is unchanged).

**Channel:** Public PR (already-disclosed CVE against a lockfile only — no code changes, no zero-day risk from disclosure).
**PR:** [cloudflare/workers-sdk#15584](https://github.com/cloudflare/workers-sdk/pull/15584)

## PoC gate

Not required — this is a published dependency CVE (A4.5 exception: quote the severity from the linked GHSA record, no new PoC needed) with no HIGH/CRITICAL *code* claim to verify.

## Dedup

Appended to `memory/vuln-scanned.json`: `cloudflare/workers-sdk`, 1 finding, channel `public-pr`. Skip re-scanning for 30 days.
