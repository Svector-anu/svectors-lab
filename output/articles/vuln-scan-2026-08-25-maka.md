# Vuln scan — apache/maka

- **Date:** 2026-08-25
- **Repo:** [apache/maka](https://github.com/apache/maka) (Incubating)
- **HEAD:** `689a4515f15870d3c0ae9ee66c2f2021b34c0e2b`
- **Stars / language:** 3,125 · TypeScript (Electron desktop + Runtime Host monorepo)
- **License:** Apache-2.0
- **Disclosure channel:** SECURITY.md → `security@maka.app` (PVR disabled)
- **Mode:** scan (Arm A), target override `var=apache/maka`

## Threat model (framing)

Maka is a **local-first, single-tenant** desktop AI agent. Load-bearing boundaries per SECURITY.md §2.3: OS user account, `credentials.json` 0o700/0o600 + no symlink/traversal escape, renderer sandbox + preload IPC (cleartext secrets never main→renderer), settings sensitive masking, proxy egress. In-process permission engine / `redactSecrets` / URL allowlists are **explicitly not** advisory boundaries (§2.4).

Attacker goals ranked for this audit: (1) cleartext secret IPC leak, (2) credentials path/perm escape, (3) renderer-controlled path → filesystem outside workspace, (4) Runtime Host remote auth bypass, (5) OAuth/callback CSRF or openExternal scheme abuse, (6) already-public dependency CVEs in the lockfile.

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok | 5 hits (4 ERROR, 1 WARNING); 32 internal errors (non-fatal) |
| trufflehog | ok | filesystem + git history; **0 verified** secrets |
| osv-scanner | ok | `package-lock.json` (+ eval/windows Cargo.lock); 3 packages / 8 advisories |
| fuzz | skip | no `fuzz/fuzz_targets` |
| agentic | ok | CODE_FILES=2505 → budget **N=6** deep-reviewed |

## Candidates reviewed

| Source | Count | Survived triage |
|--------|-------|-----------------|
| Semgrep | 5 | 0 |
| OSV advisory rows | 8 (3 packages) | 3 packages → **duplicate-skipped** (#3724) |
| TruffleHog verified | 0 | 0 |
| Agentic candidates | 0 emitted | — |
| **Total** | **13** | **3 dep packages (already tracked)** |

### Semgrep triage (dropped)

1. **`gcm-no-tag-length`** — `apps/desktop/src/main/qq-bot-scan-login.ts:96`  
   False positive: `decipher.setAuthTag(authTag)` is on the next line; AES-256-GCM auth tag is enforced.
2. **`missing-user-entrypoint`** — `packages/eval/harbor/egress-proxy/Dockerfile`  
   Eval harness image, not the shipped desktop/CLI product path. Out of scope for product advisory.
3. **Flask format-string XSS** — `packages/eval/harbor/relay_agent.py`  
   Same eval harbor path; not a load-bearing product boundary.
4. **`subprocess-shell-true` (×2)** — under test/fixture paths only. Dropped.

### Dependency CVEs (prior art)

| Package | Advisories | Severity | Fixed in | Lock path |
|---------|------------|----------|----------|-----------|
| `brace-expansion@5.0.7` | GHSA-mh99-v99m-4gvg, GHSA-rgw5-rvv9-x895 | HIGH | 5.0.9 | electron-builder → minimatch (dev/packaging) |
| `undici@7.28.0` | GHSA-4cwx-7wf7-3272 (+ 4 MODERATE) | HIGH | 7.29.0 | `@electron/get` under electron (dev) |
| `@babel/core@7.29.0` | GHSA-4x5r-pxfx-6jf8 | LOW | 7.29.6 | transpile toolchain |

**Prior-art:** open issue [#3724](https://github.com/apache/maka/issues/3724) — *dep: npm audit report three vulnerabilities* — already lists exactly these three packages and points at `npm audit fix`. No second issue/PR filed. Channel: **`duplicate-skipped`**.

Production `undici` copies under `@maka/runtime` / `@maka/eval` are already on patched lines (8.10.0 / 7.29.0); the vulnerable 7.28.0 instance is the Electron packaging transitive.

## Agentic logic audit (top N=6)

Deep-reviewed (source→sink):

1. **`app:openPath` / `projects:reveal` + `open-path-guard.ts`** — key allowlist + `realpath` + `isInsideOrSamePath`; renderer cannot pass arbitrary paths. No finding.
2. **Settings / credential IPC (`maskAppSettings`, `credential-store.ts`)** — `settings:get` always masks; Tavily never echoed on update; bot/proxy reveal-on-update is intentional and unit-tested. `credentials.json` uses 0o700 dir / 0o600 `O_EXCL` atomic write, fail-closed chmod. No §2.3 breach.
3. **`external-link-guard.ts` + MCP OAuth `openExternal`** — http/https/mailto only; MCP auth URL requires https or loopback http; callback listener binds `127.0.0.1`, checks Host/Origin, validates OAuth `state`. No finding.
4. **Runtime Host WebSocket (`websocket-listener.ts`)** — bearer auth, Origin allowlist, plaintext listeners forced to loopback unless `allowInsecureRemote`, TLS/insecure mutual exclusion. Defaults bind `127.0.0.1`. No finding.
5. **Attachment approval registry** — paths stay in main behind one-shot opaque IDs bound to `senderId` + TTL. No finding.
6. **Path containment / skill transactions / Mermaid HTML** — shared `isPathInside` / `isSafeSkillId`; skill txn refuses symlink escape; Mermaid uses `securityLevel: 'strict'` plus a product sanitize pass (strip script/foreignObject/event handlers). No finding.

**Not deep-reviewed (inventory only, past budget):** ~180 `ipcMain.handle` registrations (session execution, profiles, pets, diagnostics, computer-use, browser CDP bridge), bot platform bridges (Telegram/Slack/Discord/WeChat/…), SSH tunnel + terminal write path, Seatbelt/Linux sandbox transformers (documented as not yet a product boundary), config import/export credential apply path.

Permission-engine / shell-tool behavior intentionally treated as §2.4 heuristics (OS account is the boundary) — not filed.

## Confirmed findings & channels

| # | Finding | Severity | Channel |
|---|---------|----------|---------|
| 1–3 | Lockfile dep CVEs (`brace-expansion`, `undici`, `@babel/core`) | HIGH/HIGH/LOW | **duplicate-skipped** → [#3724](https://github.com/apache/maka/issues/3724) |

No Private Vulnerability Report, no maintainer email, and no public dependency PR (would duplicate the open tracking issue).

## Dedup

Appended `memory/vuln-scanned.json` for `apache/maka` (30-day skip).

## Summary

Clean code audit against Maka’s published load-bearing boundaries. Dependency CVEs already tracked upstream in #3724; scanners healthy; no new disclosure actions this run.
