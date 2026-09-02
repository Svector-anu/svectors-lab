---
title: Vuln scan — vercel-labs/agent-browser
description: Dependency CVE bump for Next.js plus agentic review of the Rust browser-automation CLI
tags: [security, vuln-scanner, agent-browser, nextjs]
timestamp: 2026-09-02T20:00:00Z
---

# Vuln scan — vercel-labs/agent-browser

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) |
| Stars | ~41.8k |
| Language | Rust CLI + TypeScript monorepo (dashboard/docs) |
| Audited commit | `eb05921bad874cd2a1b4fa5d1149f1ed26576cae` (v0.36.0) |
| PVR | disabled |
| SECURITY.md | absent |
| Selection | github-trending chain (first unscanned: after atlas/pdf-inspector/mise/cockpit-tools/arcbox/egui) |

**Threat model (brief):** agent-browser is a local browser-automation CLI for AI agents. An attacker most wants (1) drive the local daemon/dashboard to run browser actions or exfil session state, (2) escape domain allowlists / SSRF into internal hosts, (3) abuse install/upgrade/plugin paths for code execution. Trust boundary is primarily the local user plus any page that can talk to loopback HTTP/WS servers the CLI binds.

## Scanner sources

| Source | Status |
|--------|--------|
| semgrep | ok (52 hits; 4 unique outside tests/examples/docs noise) |
| trufflehog | ok (0 verified secrets filesystem + git history) |
| osv-scanner | ok (prod HIGH rows dominated by `next@16.1.1`) |
| fuzz | skip (no `fuzz/fuzz_targets`) |
| slither | n/a (no Solidity) |
| agentic | ok (N=15 budget on 294 code files) |

## Candidates reviewed

- **Tool:** ~52 semgrep + ~142 production OSV rows + 0 trufflehog
- **Agentic:** 15 highest-exposure entrypoints deep-reviewed (stream HTTP, dashboard server, websocket, inspect proxy, read allowlist, network/CDP, auth, policy, plugins, upgrade, install, MCP, CLI/commands, connection, validation)
- **Not deep-reviewed (noted):** lower-exposure UI helpers, React tree renderer internals, doctor non-security checks, webdriver backends beyond binding

## Confirmed findings

### 1. High — Next.js dependency CVEs (public, already disclosed)

- **Package:** `next` `16.1.1` (docs, dashboard) / `16.2.6` (examples/eve) → `16.3.3`
- **Channel:** public PR
- **PoC gate:** not-required (published dependency CVEs; severity from GHSA/OSV)
- **Why it matters:** `docs/` runs a real Next.js server (`next start`). Advisories include SSRF and middleware/proxy bypass classes fixed in the 16.2.11+ line (covered by 16.3.3). Dashboard is `output: "export"` (static embed) — bump still aligns the build toolchain.
- **Prior-art check:** searched open+closed issues/PRs for next bump / GHSA / CVE ids — 0 matches
- **PR:** https://github.com/vercel-labs/agent-browser/pull/1764

Notable advisories covered:

- GHSA-c4j6-fc7j-m34r / CVE-2026-44578
- GHSA-6gpp-xcg3-4w24 / CVE-2026-64642
- GHSA-89xv-2m56-2m9x / CVE-2026-64649
- GHSA-p9j2-gv94-2wf4 / CVE-2026-64645
- GHSA-m99w-x7hq-7vfj / CVE-2026-64641
- related 16.2.x middleware bypass / DoS GHSA entries

## Triaged / not confirmed

| Candidate | Verdict | Reason |
|-----------|---------|--------|
| Stream `POST /api/sessions` wildcard CORS vs `/api/command` same-origin gate | not confirmed (hardening) | Loopback-only bind; limited impact (spawn `about:blank` session); modern Chrome PNA likely blocks; no PoC — would need A4.5 before any HIGH claim. Dashboard path already gates all `/api/*`. |
| `is_allowed_origin(None) == true` | drop | Sensitive command routes use `is_same_origin_command_request` (Origin or Referer must match loopback Host). |
| Semgrep mutable GHA action tags | drop | CI hygiene, not product vuln. |
| React `installHook.js` postMessage | drop | Vendored React DevTools hook; message listener scoped to known source. |
| docs `dangerouslySetInnerHTML` | drop | Docs site code-block rendering; not an untrusted sink without further chain. |
| Cargo RUSTSEC unsound / unmaintained | drop / defer | Informational or LOW; no clear exploitable path in this CLI. |
| Transitive HIGH npm (hono, undici, js-yaml, …) | deferred | Mostly docs/dashboard transitive; next bump was the direct high-signal fix. Follow-up possible. |

## Disclosure channel summary

| Finding | Channel |
|---------|---------|
| next CVEs | public PR #1764 |
| Code candidates | none confirmed; PVR off + no SECURITY.md anyway |

## PoC gate

- Dependency finding: **not-required** (published GHSA/OSV)
- No HIGH/CRITICAL original code claims filed

## Dedup

Appended to `memory/vuln-scanned.json` with `channel: public-pr` (30-day skip).
