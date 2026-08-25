# Vulnerability scan — rtk-ai/rtk

## Repository

- Repository: `rtk-ai/rtk`
- Snapshot: `develop` @ `29f9bb7161775cd807565fd3041eb2b7d1be071c`
- Stars: ~77,293
- Primary language: Rust (Apache-2.0)
- Product: CLI proxy that rewrites / filters common dev-tool output to cut LLM token use (hooks into Claude Code / Codex / Cursor / etc.)
- Disclosure channel: PVR **enabled** + `SECURITY.md` (email `security@rtk-ai.app`, 90-day embargo)
- Review size: 149 production-language source files; agentic budget N=15
- Selection: github-trending chain (2026-08-23) was exhausted of unscanned channel-bearing targets; picked via fresh search for Rust CLI with untrusted I/O + usable disclosure path. Not scanned in prior 30 days.

## Threat model

RTK sits on the agent→shell trust boundary: it rewrites Bash tool calls, optionally auto-allows rewritten commands via PreToolUse hooks, executes child processes, parses untrusted command output (including XML TRX / build logs), and maintains a local SQLite tracking DB. Highest-value attacker outcomes: (1) hook rewrite that auto-allows a dangerous command the user/agent would otherwise deny, (2) command-injection via rewrite/filter paths, (3) DoS / crash while parsing untrusted tool output, (4) secret exfil via telemetry or tracking DB. Trust boundaries: agent-supplied shell strings, project-local TOML filters (hash-gated trust), compile-time telemetry URL/token, user-owned config under `~/.local/share/rtk`.

## Scanner sources

| Source | Status | Result |
|---|---|---|
| Semgrep security-audit / OWASP / secrets | ok | 38 candidates — 35× mutable GHA tags; 2× `secrets-inherit`; 1× `run-shell-injection` on `github.base_ref` |
| TruffleHog filesystem | ok | 0 verified secrets (1890 chunks) |
| TruffleHog git history | ok | 0 verified secrets |
| osv-scanner | ok | 4 RustSec rows in `Cargo.lock` (cleared after bump) |
| Slither | n/a | No Solidity |
| cargo-fuzz | skip | No `fuzz/fuzz_targets` |
| Agentic source-to-sink review | ok | Top-15 exposure surfaces deep-reviewed; 0 code vulns confirmed |

## Triage summary

- **Candidates reviewed:** 38 Semgrep + 4 OSV + agentic pass over runner/hooks/rewrite/lexer/toml-trust/telemetry/dotnet XML/container/pnpm
- **Confirmed:** 4 dependency advisories (bundled into one public PR)
- **Dropped / not filed:**
  - GHA `run-shell-injection` on `${{ github.base_ref }}` — base branch name on `pull_request`, not attacker-controlled payload; hardening only
  - `secrets: inherit` + mutable action tags — CI hardening noise, not product vulns
  - Remaining `Command::new("sh")` / `sh -c` in `rtk err` / `rtk test` / `rtk summary` — intentional shell-string product surface; already tracked by open PR [#1194](https://github.com/rtk-ai/rtk/pull/1194) and discussed in [#640](https://github.com/rtk-ai/rtk/issues/640)
  - TOML project filters — trust-gated with content hash (SA-2025-RTK-002); untrusted skipped fail-closed
  - Telemetry — URL/token compile-time (`option_env!`), user can disable via `RTK_TELEMETRY_DISABLED=1`
  - Hook auto-allow — gated on rewrite success + permission verdict; unattestable constructs (`$()`, backticks, redirects) force passthrough

## Confirmed findings

### 1–4. RustSec advisories (dependency bumps)

| Package | From → To | Advisory | Notes |
|---|---|---|---|
| `quick-xml` (direct) | 0.37.5 → 0.41.0 | RUSTSEC-2026-0194, RUSTSEC-2026-0195 | High DoS / mem-exhaustion on untrusted XML (dotnet TRX / MTP parsing) |
| `anyhow` (direct) | 1.0.102 → 1.0.103 | RUSTSEC-2026-0190 | Unsoundness in `Error::downcast_mut()` |
| `crossbeam-epoch` (via `crossbeam-deque`) | 0.9.18 → 0.9.20 | RUSTSEC-2026-0204 | Invalid pointer deref in `fmt::Pointer` |

**Prior art:** [#2866](https://github.com/rtk-ai/rtk/pull/2866) had the correct 0.41 migration but was closed without merge (author redirected to a personal fork). Open [#1742](https://github.com/rtk-ai/rtk/pull/1742) only reaches 0.40.1, which does not clear 0194/0195. Fresh PR warranted.

**Channel:** public PR — https://github.com/rtk-ai/rtk/pull/3705

**Verification:** osv-scanner 4 → 0 after bump; `cargo build` clean; `cargo test -- cmds::dotnet` → 116 passed. Mechanical `quick-xml` 0.41 API updates in `dotnet_cmd.rs` / `dotnet_trx.rs`.

## Agentic review (top N=15)

Deep-reviewed: `hooks/claude/rtk-rewrite.sh` auto-allow path; `rewrite_cmd` / permission verdict mapping; `discover/lexer` unattestable constructs; `discover/registry` rewrite; `core/runner` + `stream` child exec; `core/toml_filter` + `hooks/trust`; `core/tracking` DB paths; `core/telemetry`; `cmds/dotnet/*` XML; `cmds/cloud/container`; `cmds/js/pnpm_cmd`; `cmds/system/summary` + `cmds/rust/runner` sh -c; GHA CI injection surface. Entrypoints beyond N noted as inventory-only (filter TOML corpus, analytics/ccusage, learn, init agent installers).

## Dedup

Appended `memory/vuln-scanned.json` with `channel=public-pr` (30-day skip).

## Links

- PR: https://github.com/rtk-ai/rtk/pull/3705
- Commit audited: `29f9bb7161775cd807565fd3041eb2b7d1be071c`
