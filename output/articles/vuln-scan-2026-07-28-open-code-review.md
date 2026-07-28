---
type: Article
title: "Vuln scan — alibaba/open-code-review (2026-07-28)"
description: "Responsible-disclosure audit of Alibaba open-code-review. 26 Semgrep + 3 OSV candidates triaged to 1 confirmed HIGH dependency CVE (brace-expansion); public PR blocked by fork 403."
tags: [security, vuln-scanner, open-code-review, dependency-cve, go]
timestamp: 2026-07-28T12:15:00Z
---

# Vuln scan — alibaba/open-code-review

**Date:** 2026-07-28  
**Mode:** scan (auto-select from github-trending chain)  
**Repo:** [alibaba/open-code-review](https://github.com/alibaba/open-code-review) — hybrid deterministic + LLM PR review tool  
**Stars:** ~15,350 · **Language:** Go · **HEAD:** `f93d1a4`  
**Disclosure channels available:** PVR **enabled** · `SECURITY.md` (advisory form only; no AI-report ban)

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok | p/security-audit + owasp-top-ten + secrets; 26 results (3 ERROR, 23 WARNING) |
| trufflehog | ok | filesystem + git history; 0 verified secrets |
| osv-scanner | ok | recursive; yarn.lock + go.mod; 3 advisories |
| slither | n/a | no Solidity |

## Selection rationale

Picked from `output/.chains/github-trending.md` after skipping `makecindy/cindy` (already scanned earlier today). Criteria match: Go, ≥50★, active, handles untrusted PR diffs / LLM output / CI inputs. **PVR on** + written SECURITY policy → safe channel for any code flaw. Not in `memory/vuln-scanned.json` within 30 days.

Fork failed: `HTTP 403 Resource not accessible by integration` (Actions `GITHUB_TOKEN` cannot fork third-party repos; `GH_GLOBAL` unset). Scan proceeded on a shallow local clone (`--depth 200`).

## Triage summary

| Bucket | Candidates | Confirmed |
|--------|------------|-----------|
| Semgrep ERROR/WARNING | 26 | 0 code vulns |
| TruffleHog verified secrets | 0 | 0 |
| OSV dependency advisories | 3 | **1** HIGH actionable (brace-expansion) |

### Code candidates reviewed and dropped

1. **github-script injection (`action.yml` post-review step)** — Semgrep ERROR. Script interpolates `${{ inputs.sticky_summary == 'true' }}` / `incremental == 'true'`, which evaluate to JSON booleans `true`/`false`, not untrusted PR/issue text. Classic injection vector (issue title/body into script string) is absent. Dropped.

2. **child_process in VS Code `CliService.ts`** — Semgrep ERROR. `probeCommand(bin, …)` is only called with fixed bins (`node`, `npm`, configured CLI path). Local extension; no remote attacker-controlled argv. Dropped.

3. **child_process in `scripts/update.js`** — Semgrep ERROR. `spawnSync(binPath, ["version"])` where `binPath` is the package’s own native binary path from install resolution, not network input. Dropped.

4. **`dangerouslySetInnerHTML` in `pages/…/MarkdownRenderer.tsx`** — Semgrep WARNING. HTML is produced via `marked` then **DOMPurify.sanitize** before inject; mermaid path uses `securityLevel: 'strict'`. Dropped.

5. **22× mutable GitHub Actions tags** — hygiene / supply-chain hardening, not a confirmed exploitable vuln for private disclosure. Dropped (not embarrassed to skip as a finding).

### Dependency candidates

| Advisory | Package | Locked | Severity | Verdict |
|----------|---------|--------|----------|---------|
| [GHSA-mh99-v99m-4gvg](https://github.com/advisories/GHSA-mh99-v99m-4gvg) / CVE-2026-14257 | `brace-expansion@2.1.2` (npm, via `minimatch` in `extensions/vscode/yarn.lock`) | 2.1.2 | **HIGH** (CVSS 7.5, A:H) | **Confirmed** — public dep CVE |
| [GO-2026-5942](https://pkg.go.dev/vuln/GO-2026-5942) / CVE-2026-46600 | `golang.org/x/net@0.55.0` (indirect) | 0.55.0 | unset | **Dropped** — osv-scanner experimental analysis `called: false` |
| [GO-2026-5970](https://pkg.go.dev/vuln/GO-2026-5970) / CVE-2026-56852 | `golang.org/x/text@0.37.0` (indirect) | 0.37.0 | unset | **Dropped** — osv-scanner experimental analysis `called: false` |

## Confirmed finding

### HIGH — brace-expansion DoS (CVE-2026-14257)

- **What an attacker achieves:** Unbounded brace expansion can OOM-crash a Node process that expands attacker-controlled patterns through `minimatch` → `brace-expansion`.
- **Where:** `extensions/vscode/yarn.lock` locks `brace-expansion@2.1.2` under `minimatch@9.0.9` (and related ranges). Extension `package.json` **resolutions** currently pin `"brace-expansion": ">=2.1.2 <3"`, which keeps the tree on the vulnerable 2.x line.
- **Fixed in:** `brace-expansion@5.0.8` (only published fixed line per OSV; no 2.x backport). Practical path: upgrade `minimatch` to **≥10.2.6** (`brace-expansion ^5.0.8`) and relax/replace the resolution pin to `brace-expansion@>=5.0.8`. Note engines: brace-expansion 5 requires Node `20 || >=22`.
- **Channel:** **Public PR** (CVE already disclosed). **Blocked this run** — cannot fork or push a branch with the Actions integration token (`fork 403`; `GH_GLOBAL` unset). No public zero-day created; finding stays in this report only.

## Channels used

| Channel | Count | Detail |
|---------|-------|--------|
| PVR | 0 | No confirmed unpatched code flaw |
| Public PR | 0 filed | 1 HIGH dep CVE ready; **fork 403** blocked filing |
| Skipped (no channel) | 0 | PVR + SECURITY.md present |

## Operator follow-up

1. Set `GH_GLOBAL` (classic PAT with `public_repo` + fork ability) so dependency-bump PRs can land.
2. Re-run: `gh workflow run aeon.yml -f skill=vuln-scanner -f var=alibaba/open-code-review` after token fix to open the brace-expansion / minimatch bump PR.
3. Optional: pin `golang.org/x/net` ≥0.56.0 and `golang.org/x/text` ≥0.39.0 on next `go get` hygiene pass (not confirmed reachable here).

## Dedup

Appended to `memory/vuln-scanned.json` — skip re-scan for 30 days unless `var=alibaba/open-code-review` is forced.
