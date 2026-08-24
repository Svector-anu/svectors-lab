# Vuln Scan — vercel-labs/fx (2026-08-22)

**Verdict: Clean audit.** No confirmed exploitable findings across the highest-value
untrusted-input surfaces. Dependency surface clean; no committed secrets.

## Repo metadata

| Field | Value |
|---|---|
| Repo | `vercel-labs/fx` |
| Description | "Unix like coding agent" (an fx / Claude-Code-style terminal coding agent) |
| Language | Zig (~400 `.zig` files) |
| Stars | 2,080 |
| License | Apache-2.0 |
| PVR | **disabled** |
| SECURITY.md | **absent** |
| Selection | User-directed (`var=vercel-labs/fx`) |

Disclosure-channel note: with PVR off and no `SECURITY.md`, there is no safe channel
for a code-flaw report — but this is moot because nothing survived triage.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| osv-scanner | ok (via OSV batch API) | binary exec denied this session (same as 2026-08-22 turbovec run); queried OSV API directly |
| semgrep | n/a | no Zig ruleset/support |
| slither | n/a | not Solidity |
| trufflehog | manual grep | binary exec denied; compensated with regex secret sweep → 0 hardcoded secrets |
| fuzz (cargo-fuzz) | skip | not Rust; no `fuzz/fuzz_targets` |

### Dependencies
- **Zig:** `build.zig.zon` declares an **empty** `.dependencies` table — zero third-party Zig deps.
- **npm:** the only manifest is `sdk/node/package-lock.json`, a test harness with a single
  devDependency `@xterm/headless@6.0.0`. OSV API query → no vulnerabilities.

### Secrets
- Regex sweep over `src/`, `sdk/`, `scripts/` for API-key / private-key patterns → **0** real
  hits (only false positives from broad alternation on ordinary identifiers).

## Manual review — surfaces audited

For a coding agent, the security-critical surface is the **command-execution guardrail** and
the **web-fetch SSRF boundary**. Both were reviewed in depth; both are strong.

1. **Auto-run command admission** (`core/shell_command/command_effect.zig`) — a **whitelist**
   design, not a blacklist. Rather than passing the model's command to a shell, it re-tokenizes
   and rebuilds a *canonical argv* from a strict per-command flag allowlist
   (`printf`/`pwd`/`ls`/`wc`/`cat`/`head`/`tail`/`grep`/`git` only), forces absolute executables,
   applies a sanitized env profile, and hardens git (`--no-pager`, `core.hooksPath=/dev/null`,
   `core.fsmonitor=false`, `git_read_only` env). `printf` format strings are validated to only
   `%s`/`%%`/`\n` with an exact argument count (kills format-string abuse). Any dynamic shell
   syntax, redirect, control operator, or env-assignment → `approval_required`; unknown command
   → `approval_required`. Fail-closed by construction.

2. **Shell lexer / classification** (`command_lex.zig`, `command_classification.zig`) — a careful,
   fail-closed lexer with explicit single/double-quote and escape state, embedded-NUL and
   invalid-UTF-8 rejection, and wrapper-stripping for `env`/`nice`/`stdbuf`/`timeout`/`time` that
   itself fails closed on ambiguous args. Extensive inline adversarial tests.

3. **LLM permission reviewer** (`core/permissions/auto_classifier.zig`) — the "last-chance safety
   reviewer." Strict trust boundary: only canonical **root-user** requests can authorize a
   consequential action; assistant prose, tool output, repository content, and attachments are
   explicitly untrusted (may *identify* an action, never *authorize* it). Review data is
   XML-escaped, secrets are masked before the review payload is sent, and the decision schema is
   strict (`allow`/`ask` only, no `deny`, `additionalProperties:false`).

4. **URL policy / SSRF** (`tools/web/url_policy.zig`) — blocks every private/reserved IPv4 CIDR,
   IPv4-mapped IPv6 (`::ffff:*`), and internal hostnames (`localhost`, `metadata.google.internal`,
   `*.internal`, `*.local`, …); rejects credentialed URLs, single-label hosts, ambiguous
   octal/hex IPv4, IPv6 scope-ids, and percent-encoded / Unicode hosts. Redirects re-pin scheme
   and port.

5. **HTTP fetch** (`tools/web/http_fetch.zig`) — **closes the DNS-rebinding gap**: after
   resolution it re-validates *every* returned address with `isPublicAddress` and connects only to
   those pinned addresses, so there is no resolve→connect TOCTOU. HTTP head parsing has
   request-smuggling defenses (rejects `Transfer-Encoding`+`Content-Length`, rejects conflicting
   duplicate `Content-Length`), a 10 MB body cap, and interim-response limits.

**Candidate classes reviewed: ~5. Confirmed: 0.**

## Prior-art check
- n/a — nothing public to file (clean audit, and no safe channel exists anyway).

## Dedup
- `memory/vuln-scanned.json` updated: `vercel-labs/fx` → `channel: clean` (skips this repo for 30 days).

## Scope honesty
Manual review covered the highest-value untrusted-input surfaces (command admission, permission
review, SSRF/web-fetch, direct executor, lexer). It was **not** an exhaustive line-by-line audit
of all ~400 source files. Within the reviewed surface the code is defense-in-depth,
whitelist-based, and backed by exhaustive inline adversarial tests — a notably high security bar.
