# Vuln Scan — NeoSoul-AI/0g-builders (2026-09-09)

## Repo metadata
- **Repo:** NeoSoul-AI/0g-builders
- **Selection:** forced target via `var=NeoSoul-AI/0g-builders` (bare `owner/repo` → Arm A scan)
- **Stars:** 0 · **Language:** none detected · **Fork:** no · **Archived/Disabled:** no
- **Size:** 5 KB · **Default branch:** main · **Last push:** 2026-05-25 (~3.5 months old)
- **Description:** none. README describes "EvoEvo," an AI-agent prediction platform by NeoSoul, with marketing/traction stats (agent counts, funding, investors) — no product code in this repo.
- **SECURITY.md:** not present (404)
- **Private Vulnerability Reporting:** disabled (`enabled: false`)

## Selection-criteria check (A1)
- ≥50 stars: **fail** (0 stars)
- Active in last 6 months: borderline (last push ~3.5 months ago)
- Handles untrusted input (auth/crypto/network/file I/O/templating): **fail** — no code present
- Repo contents: exactly one file, `README.md` (marketing copy only)

**Decision: skip.** The repo has no source code, no dependency manifests, and no lockfiles — nothing for SAST (semgrep), secret-scanning (TruffleHog), dependency-CVE scanning (osv-scanner), or an agentic entrypoint review to operate on. No fork or clone was performed.

## Scanner sources
| Tool | Status | Reason |
|---|---|---|
| semgrep | skip | no source files to scan |
| trufflehog (filesystem) | skip | no source files to scan |
| trufflehog (git history) | skip | not attempted — no clone made |
| osv-scanner | skip | no manifests/lockfiles present |
| slither | skip | no Solidity files |
| fuzz (cargo fuzz) | skip | no fuzz harness (no code at all) |
| agentic review (A3.6) | skip | no entrypoints exist to inventory |

## Candidates / findings
- Candidates surfaced: 0
- Confirmed: 0
- PoC gate: not-required (no HIGH/CRITICAL candidate — none surfaced)

## Disclosure channel
- Channel: **skipped** — nothing to route. (Also moot: no SECURITY.md and PVR disabled, so even if a finding existed there would be no safe channel without out-of-band contact resolution.)

## Dedup note
Logged to `memory/vuln-scanned.json` (`channel: "skipped"`, `findings: 0`) so this repo is not re-selected for 30 days. No entry added to `memory/security-watchlist.md` (that watchlist is for real findings with no channel, not empty repos).

## Summary
NeoSoul-AI/0g-builders is not an audit target in any meaningful sense — it holds a single 5 KB README advertising an external product ("EvoEvo"). No fork, no scan, no findings. Recorded as a clean/skipped scan for dedup purposes.
