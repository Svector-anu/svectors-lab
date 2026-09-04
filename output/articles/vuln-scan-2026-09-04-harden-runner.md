---
title: Vuln Scan — step-security/harden-runner
date: 2026-09-04
tags: [security, vuln-scanner, dependency-cve]
---

# Vuln Scanner Report — step-security/harden-runner

**Target:** [step-security/harden-runner](https://github.com/step-security/harden-runner) — 1,265 stars, TypeScript
**Selection:** forced via `var=step-security/harden-runner`
**Description:** CI/CD security agent (EDR-style) for GitHub Actions runners — monitors network egress, file integrity, and process activity.
**Audited commit:** `e14015d583714f6e62063499dc959a02595150a1` (fork: `Svector-anu/harden-runner`)
**Disclosure channel available:** PVR enabled, `SECURITY.md` present

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | 10 hits, all `github-actions-mutable-action-tag` hardening warnings in `.github/workflows/publish-immutable-actions.yml` + `runs-on.yml` — not code vulnerabilities, not filed |
| trufflehog (filesystem) | ok | 0 verified secrets — 5,433 chunks / 70MB, ~4s |
| trufflehog (git history) | ok | 0 verified secrets — 12,276 chunks / ~1GB, 17m33s (`dist/` bundles committed at every release tag across ~200 commits) |
| osv-scanner | ok | 8 vulnerable-package rows (see below) |
| slither | n/a | no `.sol` files |
| fuzz (cargo-fuzz) | skip | no `fuzz/fuzz_targets` (not a Rust repo) |
| agentic (A3.6) | ok | 0 candidates, N=15 budget on a 23-file codebase |

## Candidate count

8 osv-scanner package/CVE groups (candidates) → **5 confirmed and patched**, 2 deferred (documented rationale), 0 code findings survived triage.

## Dependency CVEs — filed as public PR

| Package | Scope | From | To | Advisories | Severity |
|---|---|---|---|---|---|
| `brace-expansion` | prod (transitive) | 1.1.14 | 1.1.18 | GHSA-3jxr-9vmj-r5cp, GHSA-mh99-v99m-4gvg, GHSA-rgw5-rvv9-x895 | HIGH |
| `fast-xml-parser` | prod (transitive) | 5.9.3 | 5.10.1 | GHSA-8r6m-32jq-jx6q | HIGH |
| `js-yaml` | dev (transitive) | 3.14.2 | 3.15.1 | GHSA-52cp-r559-cp3m, GHSA-5p4m-2wfm-xmqj, GHSA-h67p-54hq-rp68 | HIGH/HIGH/MODERATE |
| `browserslist` | dev (transitive) | 4.28.4 | 4.28.7 | GHSA-73wf-gq98-2v4g, GHSA-c83g-rgw3-j3cx | HIGH |
| `fast-uri` | dev (transitive) | 3.1.2 | 3.1.6 | GHSA-4c8g-83qw-93j6, GHSA-7p8r-x3mc-p8w7, GHSA-f65p-4m7j-42xc, GHSA-fph4-wmhf-6fwf, GHSA-jqff-g426-hqxp, GHSA-v2hh-gcrm-f6hx | HIGH |

**PR filed:** [step-security/harden-runner#693](https://github.com/step-security/harden-runner/pull/693) — pins each package via a `package.json` `overrides` block to its lowest same-major patched version, then regenerates `package-lock.json` with `npm install --package-lock-only`. No source changes required. Verified before/after with `osv-scanner`.

**Prior-art check:** found 3 open Dependabot PRs (#557 `brace-expansion`→1.1.12, #610 `js-yaml`→3.14.2, #633 `fast-xml-parser`→5.3.4). All three predate the CVEs above and target versions that don't fix them — the current lockfile was already past #557/#633's targets, and #610's target (3.14.2) is exactly what's installed but is still vulnerable to newer disclosures. Judged non-duplicate; PR #693 references all three as superseded.

## Dependency CVEs — reviewed, not filed

| Package | Scope | Version | CVEs | Why deferred |
|---|---|---|---|---|
| `undici` | prod (transitive) | 5.29.0 | 11 GHSA rows (MODERATE/HIGH/LOW) | Fix requires a major bump (5.x → 6/7/8.x). The repo's own `osv-scanner.toml` already dismisses a sibling undici GHSA (`GHSA-g9mf-h72j-4rw9`) with the rationale "fetch() is only used to call GitHub API; exploitation requires a malicious server" — the same reasoning applies to this batch. A major-version bump on the maintainers' own trust call is outside the scope of a dependency-patch PR. |
| `uuid` | prod (direct, `^8.3.2`) | 3.4.0 + 8.3.2 | GHSA-w5hq-g745-h8pq (MODERATE) | Fix requires jumping to uuid v11+, breaking the directly-declared `^8.3.2` semver range in `package.json` — a breaking API change, not a patch bump. |

## Code findings (A3.6 agentic audit)

**Threat model:** harden-runner runs privileged setup/cleanup steps on GitHub-hosted and self-hosted runners, installs an eBPF agent binary, and enforces/audits egress policy. The attacker's highest-value goals against a tool like this are (a) bypassing/disabling enforcement, (b) command injection in the privileged setup/cleanup steps, (c) a checksum-bypass letting a malicious agent binary run, (d) SSRF/config-injection via the remote policy-fetch path.

**Reviewed (N=15 budget, 23 source files — small, well-scoped codebase):**
- `install-agent.ts` — all `execSync`/`spawn` call sites use static commands or fixed-path interpolation (e.g. hardcoded `/opt/step-security/Installer`); no external/attacker-controlled input reaches a shell string.
- `cleanup.ts` — `journalctl`/`log show` invocations are static commands, no interpolation of variable data.
- `checksum.ts` — SHA-256 verification of every downloaded agent binary against hardcoded expected hashes per platform/arch; strict equality check, no bypass path found.
- `policy-utils.ts` / `bravo-config.ts` / `tls-inspect.ts` — remote policy and TLS-status fetches go to a hardcoded `STEPSECURITY_API_URL` (`configs.ts`), not attacker- or user-configurable, so no SSRF. `owner`/`repo`/`policyName` are interpolated unescaped into the URL path, but GitHub repo/owner names cannot contain path-breaking characters, so this isn't exploitable.
- `setup.ts` — `allowed-endpoints`/`denied-endpoints`/`egress-policy` action inputs flow into a JSON config object consumed by the eBPF agent binary, never into a shell command string.

Reviewed-but-not-deep within budget: `index.ts`, `arc-runner.ts`, `cache.ts`, `utils.ts` (lower-risk orchestration/glue).

**Result:** 0 candidates emitted to `agentic.json`. No HIGH/CRITICAL code claim was made, so the A4.5 PoC-verification gate was not required for any code finding (only already-published dependency CVEs were confirmed, which don't need a new PoC per policy).

## Dedup

`memory/vuln-scanned.json` — `channel: public-pr`, `findings: 5` (30-day skip on this repo).
