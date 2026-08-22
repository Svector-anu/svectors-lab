Both memory files updated. The stray `fx/` clone and `.scan-bin/` staging dir are untracked and won't be committed (no PR — clean audit); they vanish with the ephemeral runner. Per the repo convention for clean runs (matching today's turbovec run), no `./notify` is sent — a clean audit is no-signal.

---

# Vuln Scanner — vercel-labs/fx

**Clean audit. ~5 candidate surface classes reviewed, 0 confirmed.** No exploitable findings, clean dependency surface, no committed secrets.

`vercel-labs/fx` is Vercel's **"fx" Unix-like coding agent** — a Claude-Code-style terminal agent written in **Zig** (2,080★, Apache-2.0, ~400 `.zig` files). User-directed target. PVR is **disabled** and there is **no `SECURITY.md`**, so there'd be no safe channel for a code-flaw report — moot, since nothing survived triage.

### Scanners
- **osv** = ok (via OSV batch API; scanner binary exec is denied in this session, same as today's turbovec run)
- **semgrep / slither** = n/a (no Zig support; not Solidity)
- **trufflehog** = manual regex sweep (binary denied) → **0** hardcoded secrets in `src/`, `sdk/`, `scripts/`
- **fuzz** = skip (not Rust; no `fuzz/fuzz_targets`)

### Dependency surface — clean
- `build.zig.zon` declares an **empty** dependency table → **zero** third-party Zig deps.
- Only npm manifest is `sdk/node/package-lock.json` (a test harness) with one devDep `@xterm/headless@6.0.0` → **OSV: no vulnerabilities**.

### Manual review — the crown-jewel surfaces for a coding agent
1. **Auto-run command admission** (`command_effect.zig`) — a **whitelist**, not a blacklist. It never hands the model's string to a shell: it re-tokenizes and rebuilds a *canonical argv* from a strict per-command flag allowlist (`printf`/`pwd`/`ls`/`wc`/`cat`/`head`/`tail`/`grep`/`git` only), forces absolute executables, sanitizes env, hardens git (`core.hooksPath=/dev/null`, read-only profile), and validates `printf` format strings to `%s`/`%%`/`\n` with an exact arg count. Any dynamic shell syntax/redirect/operator/env-assignment or unknown command → `approval_required`. Fail-closed by construction.
2. **Shell lexer / classification** (`command_lex.zig`, `command_classification.zig`) — careful fail-closed quote/escape state machine, NUL/invalid-UTF-8 rejection, wrapper-stripping that fails closed on ambiguity.
3. **LLM permission reviewer** (`auto_classifier.zig`) — strict trust boundary (only canonical **root** requests authorize; assistant/tool/repo text is untrusted and can identify but never authorize), review data XML-escaped, secrets masked before send, strict `allow`/`ask` schema.
4. **SSRF url policy** (`url_policy.zig`) — blocks all private/reserved IPv4 CIDRs, IPv4-mapped IPv6, and internal hostnames (`localhost`/`metadata.google.internal`/`*.internal`/`*.local`); rejects credentialed URLs, single-label hosts, ambiguous octal/hex IPv4, scope-ids, percent-encoded/Unicode hosts.
5. **HTTP fetch** (`http_fetch.zig`) — **DNS-rebinding is closed**: every resolved address is re-validated with `isPublicAddress` and the connector dials only the pinned admitted addresses (no resolve→connect TOCTOU). Plus request-smuggling defenses (rejects `TE`+`CL`, conflicting duplicate `CL`) and a 10 MB body cap.

Every surface I checked was defense-in-depth and backed by exhaustive **inline adversarial tests** — a notably high security bar. I hypothesized the classic hostname→private-IP SSRF gap; the code explicitly defends against it.

**Scope honesty:** this was a deep review of the highest-value untrusted-input surfaces, not a line-by-line audit of all ~400 files.

## Summary
- **Action:** Scan arm (Arm A) on user-directed target `vercel-labs/fx` → **clean audit**, 0 confirmed findings, 0 disclosures filed.
- **Why no disclosure:** nothing found; also no safe channel exists (PVR off, no `SECURITY.md`).
- **Files created:**
  - `output/articles/vuln-scan-2026-08-22-vercel-labs-fx.md` (full report)
  - `memory/vuln-scanned.json` (appended `vercel-labs/fx` → `channel: clean`, 30-day dedup)
  - `memory/logs/2026-08-22.md` (appended `### vuln-scanner` entry, `Mode: scan`)
- **Notify:** intentionally skipped (clean run = no signal, per CLAUDE.md and consistent with today's turbovec clean run).
- **Follow-up:** none required. Stray `fx/` clone and `.scan-bin/` staging dir are untracked, uncommitted, and ephemeral (no PR opened since there was no code change).
