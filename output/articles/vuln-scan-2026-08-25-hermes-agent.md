---
title: "Vuln scan — NousResearch/hermes-agent"
date: 2026-08-25
repo: NousResearch/hermes-agent
---

# Vuln scan — NousResearch/hermes-agent

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) |
| Stars | ~235,827 |
| Language | Python (primary), TypeScript |
| License | MIT |
| HEAD audited | `5ef1409f50` |
| PVR | enabled |
| SECURITY.md | present (detailed trust model; security@nousresearch.com) |
| Fuzz harness | none |

Hermes Agent is a single-tenant personal AI agent with messaging gateways, an OpenAI-compatible API server, desktop Electron app, dashboard, MCP/skills/plugins, and sandboxed tool execution. SECURITY.md §2 makes OS-level isolation the only load-bearing boundary; in-process heuristics are explicitly out of scope for private reports.

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok (scoped) | Full production-tree scan timed out (~10 min); auth-surface subset (authz, webhook, url_safety, a2a security) → 0 ERROR/WARNING |
| trufflehog | ok | Filesystem + git history; 1 unique verified secret (AlgoliaAdminKey) |
| osv-scanner | ok | uv.lock + package-lock.json + website lock + optional-skills requirements |
| fuzz | skip | No `fuzz/fuzz_targets` |
| slither | n/a | No Solidity |
| agentic | ok | Budget N=6 on 7,154 code files |

## Threat model (agentic framing)

Attacker wants: unauthorized gateway/API dispatch (remote agent control), credential exfil from scrubbed child envs, SSRF into operator LAN/metadata, or docs-infra key abuse. Trust boundaries: network adapters require allowlists (§2.6); API server requires `API_SERVER_KEY`; dashboard session token; local IPC relies on OS user boundary; shell/code-exec scrubbing is defense-in-depth only under OS isolation.

## Agentic entrypoints reviewed (top N=6)

1. **API server auth** (`gateway/platforms/api_server.py`) — Bearer `API_SERVER_KEY` via `hmac.compare_digest`; `connect()` refuses startup without a usable key; named multiplex profiles fail closed. No confirmed finding.
2. **Gateway allowlists** (`gateway/authz_mixin.py`) — Default deny; HA/webhook/relay delegation is documented and transport-gated; `ALLOW_ALL` is explicit break-glass. No fail-open bug found against §2.6.
3. **Webhook HMAC** (`gateway/platforms/webhook.py`) — Secret required at startup; `INSECURE_NO_AUTH` refused on non-loopback binds; request path fails closed on empty secret. No confirmed finding.
4. **Credential scrub** (`tools/code_execution_tool.py`, `tools/env_passthrough.py`) — Secret-substring denylist + provider blocklist; skill passthrough cannot re-grant Hermes provider credentials (fail closed on import error). Matches prior GHSA lessons; no new bypass found.
5. **A2A network surface** (`plugins/platforms/a2a/security.py`) — No token ⇒ localhost-only bind; bearer compare_digest; trusted-peers optional. No confirmed finding.
6. **Dashboard / DocsSearch credentials** (`hermes_cli/web_server.py`, `website/docusaurus.config.ts`) — Dashboard session auth looks sound; **Algolia key ACL mismatch confirmed** (see findings).

Not deep-reviewed (noted): remaining messaging platform adapters beyond authz mixin, desktop Electron renderer IPC, ACP local transport, TUI gateway socket permissions, skills_hub path normalization edge cases beyond lock-path guards already present.

## Candidates reviewed

| Source | Count | Notes |
|--------|-------|-------|
| Semgrep (scoped) | 0 | Auth subset clean |
| TruffleHog verified | 1 unique | Algolia key (many git history hits, same secret) |
| OSV package/advisory rows | 9 | Across 4 lock/manifest sources |
| Agentic candidates | 1 | Same Algolia ACL issue |

**Confirmed after triage: 2** (1 code/credential via PVR, 1 dependency via public PR). Several OSV hits were duplicate-skipped or non-actionable.

## Confirmed findings

### 1. Overprivileged Algolia API key in Docusaurus config — MEDIUM — PVR

- **Channel:** Private Vulnerability Report [GHSA-3jv7-3pr9-766x](https://github.com/NousResearch/hermes-agent/security/advisories/GHSA-3jv7-3pr9-766x) (state: triage)
- **CWE:** CWE-798 / CWE-200
- **Summary:** Committed DocSearch `apiKey` is documented as search-only, but live Algolia key metadata includes `settings` (plus browse/listIndexes). File/line and exploit steps redacted here — see advisory.
- **Note:** An accidental duplicate report [GHSA-fw85-px44-j278](https://github.com/NousResearch/hermes-agent/security/advisories/GHSA-fw85-px44-j278) was also created (same body, double-submit). Prefer GHSA-3jv7-3pr9-766x; reporter could not withdraw the duplicate via API.

### 2. `h2` 4.3.0 request-smuggling (GHSA-6hr6-w5qg-qmwg) — MODERATE — public PR

- **Channel:** Public dependency bump [PR #94342](https://github.com/NousResearch/hermes-agent/pull/94342)
- **Package:** `h2` 4.3.0 → 4.4.1 (via `grpclib` ← `modal`); `hpack` 4.1.0 → 4.2.0
- **Advisory:** https://github.com/advisories/GHSA-6hr6-w5qg-qmwg (CVE-2026-71554)
- **Note:** `pyproject.toml` already exempted `h2` from `exclude-newer` for this fix; lockfile had not been refreshed.

## Triaged / not filed

| Item | Severity | Disposition |
|------|----------|-------------|
| electron@40.10.2 GHSA-9f4c-93c8-jc8g / GHSA-r4w5-6pfg-jxp5 | HIGH/MOD | **duplicate-skipped** — open PRs [#94262](https://github.com/NousResearch/hermes-agent/pull/94262), [#93975](https://github.com/NousResearch/hermes-agent/pull/93975) |
| nanoid@3.3.17 GHSA-2v37-7h3g-55p8 | HIGH | **duplicate-skipped** — [#89930](https://github.com/NousResearch/hermes-agent/pull/89930), also covered by #94262/#93975 |
| extract-zip@2.0.1 GHSA-jmr9-qjv8-65gv | HIGH | **not filed** — no patched release upstream |
| idna@3.9.0 in optional-skills/finance | MOD | **skipped** — optional skill requirements path, not core agent runtime |

## Dedup

Appended `memory/vuln-scanned.json` with `channel: pvr+public-pr` (30-day skip).

## Disclosure links

- PVR: https://github.com/NousResearch/hermes-agent/security/advisories/GHSA-3jv7-3pr9-766x
- Duplicate PVR (ignore): https://github.com/NousResearch/hermes-agent/security/advisories/GHSA-fw85-px44-j278
- Dep PR: https://github.com/NousResearch/hermes-agent/pull/94342
