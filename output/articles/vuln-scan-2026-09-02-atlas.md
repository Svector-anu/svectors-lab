# Vuln scan — pacifio/atlas (2026-09-02)

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [pacifio/atlas](https://github.com/pacifio/atlas) |
| Stars | ~2.7k (trending top pick 2026-09-02) |
| Language | Rust (Tauri v2) + React/TypeScript |
| Audited commit | `4b2aa8a027df8cb9c1deb8566be891f4e1bd55f2` |
| PVR | disabled |
| Disclosure channel | SECURITY.md → `adibmohsin.root@gmail.com` |
| Selection | Chained `github-trending` top pick; not scanned in prior 30 days |

## Threat model (brief)

Atlas hosts coding agents (native + ACP) with local FS/PTY access. Highest-value attacker goals: approval/sandbox bypass, credential exfil, FS escape outside the granted project, malicious update/agent install. Frontend webview is untrusted relative to Rust IPC.

## Scanner sources

| Source | Status |
|--------|--------|
| semgrep | ok (8 hits; mutable GHA tags only — dropped) |
| trufflehog | ok (0 verified secrets) |
| osv-scanner | ok (136 advisory hits across Cargo.lock + bun.lock before triage) |
| fuzz | skip (no `fuzz/fuzz_targets`) |
| agentic (A3.6) | ok — CODE_FILES≈727, N=10 deep-reviewed |
| PoC gate | verified (2 HIGH code findings) |

## Candidates reviewed

- Semgrep: 8 (CI mutable tags — not confirmed vulns)
- OSV: 136 raw advisories → actionable direct/override bumps filed; residual `vercel`→`sandbox@4.0.0` Critical has no published patch
- Trufflehog: 0
- Agentic: 9 candidates → 2 HIGH confirmed (PoC verified), several mediums bundled or dropped as intentional UI

**Confirmed: 3** (2 HIGH code + 1 public dep-bump bundle)

## Confirmed findings

### 1. HIGH — ACP filesystem escape (no project bind / no approval)

- **Channel:** private email (staged, `auto_send: true`)
- **PoC gate:** `verified` — verifier=`local-command`, finding id=`finding-acp-fs`, commit pinned
- **Redacted:** path/handler details in private draft only; do not publish exploit steps
- **CWE:** CWE-22 / missing authorization on agent FS tools

### 2. HIGH — Browser-reader XSS (`sanitize_html` leaves `on*` handlers; `csp: null`)

- **Channel:** private email (same staged draft)
- **PoC gate:** `verified` — verifier=`local-command`, finding id=`finding-xss`, commit pinned
- **Impact chain:** hostile page → surviving inline handlers → main webview → privileged IPC
- **CWE:** CWE-79

### 3. Dependency CVEs (already public) — public PR

- **Channel:** public PR [#220](https://github.com/pacifio/atlas/pull/220)
- **PoC gate:** `not-required` (published advisories)
- **Bumps:** `gix` 0.81.0→0.83.0; `vite`→6.4.3; `mermaid`→^11.17.2; overrides `tar`→7.5.21, `js-yaml`→4.3.1
- **Prior-art:** no open matching bump PRs for these advisories
- **Left open:** `sandbox@4.0.0` via `vercel` — Critical GHSA with no patched version at scan time

### Related mediums (bundled in private email, not separately filed)

- ACP `terminal/create` without permission gate
- `clone_github_repo` / delete path join without `..` rejection
- Optional SHA-256 on registry `install_archive`

### Dropped / not confirmed

- Unrestricted Tauri IPC FS alone (editor product surface; elevated by XSS which is filed)
- `byok_env_reveal` / `agents_set_mode(bypass)` as standalone — intentional UI; noted as XSS amplifiers
- Semgrep GHA mutable tags — hygiene only

## Agentic coverage note

Top-10 deep-reviewed. Past-N not deep-reviewed: user-facing terminal PTY, `asset_allow_dir`, auth session file, pack install markdown, memory/capture/git ops, external agent binaries’ own tools.

## Dedup

Appended `memory/vuln-scanned.json` — skip `pacifio/atlas` for 30 days. Channel: `pending-email+public-pr`.

## Artifacts

- Draft: `memory/pending-disclosures/pacifio-atlas-2026-09-02.md`
- PR: https://github.com/pacifio/atlas/pull/220
- Fork branch: `Svector-anu:security/bump-deps-gix-vite-mermaid-tar`
