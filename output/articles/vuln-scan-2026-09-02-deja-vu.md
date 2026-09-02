# Vuln scan — vshulcz/deja-vu (2026-09-02)

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [vshulcz/deja-vu](https://github.com/vshulcz/deja-vu) |
| Stars | ~760 |
| Language | Go (stdlib-only module) + small JS plugin shims |
| Description | Local search / MCP over coding-agent session histories |
| Audited commit | `e5d9d55c5a16b947a3b9ac8ce5e8a196733cf5b7` |
| PVR | enabled |
| SECURITY.md | present (PVR + security model docs) |
| Selection | Auto-select after today's trending chain repos were already scanned; chose PVR-enabled Go tool with local session/file/SSH sync attack surface |

## Threat model (A3.6)

deja indexes local agent transcripts, serves them over MCP stdio / CLI, syncs redacted batches over user-supplied SSH, and self-updates from GitHub releases. Highest attacker goals: (1) secret leakage past redaction into share/sync/embed, (2) prompt-injection via recalled transcript content, (3) arbitrary file read via store roots/symlinks, (4) supply-chain replace of the binary on update. Trust boundaries: local filesystem stores, MCP host, SSH peer chosen by the user, GitHub release assets.

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok | 14 results |
| trufflehog (fs + git, `--only-verified`) | ok | 0 verified secrets |
| osv-scanner | ok | 0 dependency advisories (`go.mod` has no third-party requires; no `go.sum`) |
| fuzz | skip | no `fuzz/fuzz_targets` |
| agentic | ok | budget N=6 of 1835 code files; top exposure deep-reviewed |
| PoC gate | not-required | no provisional HIGH/CRITICAL code claims |

## Candidates reviewed

**Semgrep (14):**
- Dockerfile missing `USER` (2× ERROR) — container hardening only; MCP entrypoint is stdio, not a network listener. Noted, not filed (would be embarrassed defending as a vulnerability to this maintainer).
- `math/rand` in `internal/bench/*` and `scripts/miracl` — non-crypto bench/fixtures.
- `unsafe` in terminal-width / Windows lock helpers — not attacker-reachable memory corruption.
- SHA-1 in `internal/index/sync.go` / `internal/sources/aider.go` — content identity, not a security MAC.
- HTTP without TLS in `scripts/mockmodel` — local test helper.

**Agentic deep-review (top 6):**
1. **MCP stdio / recall framing** (`cmd/deja/mcp.go`, `recall_frame.go`, `mcp_resources.go`) — frame markers, marker neutralization, empty-URI refusal, budget accounting already hardened (#1077, #1728, #1797, etc.).
2. **Source walkers / symlinks** (`internal/sources/util.go`) — `walkFiles` only indexes regular files; store-root symlinks followed with path remapping; in-store links skipped (covered by tests).
3. **Sync SSH** (`cmd/deja/sync_ssh.go`) — argv-separated `ssh`/`scp`, `shellQuote` for remote scripts, remote temp path charset rejection; CLI rejects hosts starting with `-`. Hand-edited `peers.json` option-injection is same-user privilege → dropped.
4. **Update / install** (`cmd/deja/update.go`, `install.sh`) — HTTPS-only downloads, size limits, SHA-256 of archive vs `checksums.txt`; cosign intentionally out of scope (documented in SECURITY.md). In-memory extract by basename (no classic zip-slip write).
5. **SQLite CLI parsers** (cursor/opencode/hermes/…) — queries use `sqlEscape` for dynamic IN-lists; timestamps are numeric; DB path URI-escaped.
6. **Redaction / share / embed** — documented floor, not guarantee; `DEJA_NO_REDACT` intentional; embed gated by policy egress; share strips bidi/invisible.

**Entrypoints noted but not deep-reviewed (past N):** install hook writers for every harness, peers lock file, usage sidecar, digest/share budgets, plugin JS `execFile` shims (argv arrays, no shell), doctor offline path, promote `--to` export.

## Confirmed findings

**0.** Clean audit — 14 tool candidates + agentic surface reviewed, 0 confirmed.

## PoC gate

`not-required` — no HIGH/CRITICAL code claims advanced past triage. Published-dep and verified-secret exceptions unused (none present).

## Disclosure channels

None used (nothing to disclose).

## Dedup

Appended to `memory/vuln-scanned.json` with `channel: "clean"` for 30-day skip.
