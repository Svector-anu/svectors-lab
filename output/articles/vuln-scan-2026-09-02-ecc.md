---
title: Vuln scan — affaan-m/ECC
description: Security audit of trending ECC agent harness; public dependency advisory bump for @humanfs/node (GHSA-p498).
tags: [security, vuln-scanner, ecc]
timestamp: 2026-09-02T16:05:00Z
---

# Vuln scan — affaan-m/ECC (2026-09-02)

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [affaan-m/ECC](https://github.com/affaan-m/ECC) |
| Stars | ~246k |
| Language | JavaScript (agent harness / installer / hooks; optional Rust `ecc2` TUI) |
| Package | `ecc-universal` v2.2.1 |
| Commit audited | `ca185ef5f7667078a1e70a763bd3a9c71c48acf0` |
| Selected from | `output/.chains/github-trending.md` (devtools — skills/memory/security harness) |
| PVR | **enabled** |
| SECURITY.md | Present — PVR preferred; email `affaan@ecc.tools` |
| Skipped earlier trending picks | `THU-MAIC/OpenMAIC`, `browser-use/video-use` (already scanned today) |

## Threat model (brief)

ECC installs skills, hooks, MCP configs, and control-pane tooling onto developer machines. Highest-value attacker goals: turn install/auto-update or a loopback dashboard into local RCE, or abuse untrusted skill/MCP config to escape the intended trust boundary. Trust boundaries: local CLI operator, loopback HTTP (Host/Origin gated), MCP configs the operator already installed, and git-cloned package roots validated by package name allowlist.

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok | 26 candidates (mostly `child_process` on intentional CLI/hook paths) |
| trufflehog | ok | 0 verified secrets (filesystem + git history) |
| osv-scanner | ok | 2 unique advisories across npm + crates lockfiles |
| fuzz | skip | no `fuzz/fuzz_targets` |
| agentic | ok | budget N=10 over ~653 code files; top exposure entrypoints deep-reviewed |
| slither | n/a | no Solidity |

## Candidates reviewed

- **Semgrep (26):** `child_process` / dynamic urllib hits in install, hooks, control-pane, dashboard, auto-update, MCP health, plan-canvas, Aura/Ollama helpers. Triaged against surrounding code.
- **OSV (2 unique):** `@humanfs/node` GHSA-p498 (moderate); `lru` RUSTSEC-2026-0253 (informational unsound).
- **Agentic top-N:** control-pane server + actions allowlist, loopback-guard, auto-update repo-root validation (prior GHSA already mitigated), install apply symlink refusal, MCP health probe/reconnect, memory-mcp stdio authz, dashboard Host/Origin bind, instinct-cli SSRF guards, Aura HTTPS lookup.

**Confirmed: 1** · **Needs-verification HIGH/CRITICAL code: 0** · **Clean code audit on reviewed surface.**

## Confirmed findings

### 1. `@humanfs/node` symlink copy disclosure — moderate (published advisory)

| Field | Value |
|-------|-------|
| Advisory | [GHSA-p498-v437-472g](https://github.com/advisories/GHSA-p498-v437-472g) |
| Severity | Moderate (advisory severity; PoC gate not-required for published dep CVEs) |
| Package | `@humanfs/node` 0.16.7 → **0.16.8** |
| Lockfiles | `package-lock.json`, `yarn.lock` |
| Reachability | Transitive via **eslint** (devDependency only). Not in the production dependency graph of `ecc-universal`. Still present for contributor/CI installs; repo already pins similar transitive issues via `overrides` / `resolutions`. |
| Channel | **Public PR** |
| Prior-art | No open/closed PR or issue for `humanfs` / `GHSA-p498` |
| PR | https://github.com/affaan-m/ECC/pull/2934 |

### Verification

- Reproduced locally: yes (lockfile resolution)
- Command: add `"@humanfs/node": "0.16.8"` to `overrides` + `resolutions`, then `yarn install --mode=update-lockfile` (+ npm lock refresh)
- Before: locks resolved `@humanfs/node@0.16.7`
- After: locks resolve `@humanfs/node@0.16.8`
- Environment: Yarn 4.9.2

## Noted / not filed

| Item | Reason |
|------|--------|
| `lru` 0.18.0 — RUSTSEC-2026-0253 | Informational **unsound** (panic-in-`Drop` UAF). Only reachable via `ratatui-core` inside `ecc2/`, which is **not** listed in the published npm `files` array. No public PR. |
| Semgrep command-injection cluster | Intentional `spawn`/`spawnSync` with argv arrays, action allowlists, Host/Origin gating, or operator-controlled env. Would not defend to maintainer as exploitable. |
| Control-pane `query` argv shape | Local loopback only; Host/Origin guarded; args passed as argv after cargo `--`. Out of scope relative to SECURITY.md local-shell guidance. |

## PoC gate

| Finding | Status |
|---------|--------|
| GHSA-p498 `@humanfs/node` | **not-required** — published dependency advisory; severity taken from GHSA |
| Code HIGH/CRITICAL | none provisional → gate not invoked |

## Dedup

Appended to `memory/vuln-scanned.json`:

```json
{"repo": "affaan-m/ECC", "scanned_at": "2026-09-02T16:00:00Z", "findings": 1, "channel": "public-pr"}
```

Skip re-scan until ~2026-10-02.
