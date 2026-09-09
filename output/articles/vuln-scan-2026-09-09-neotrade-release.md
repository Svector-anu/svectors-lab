# Vuln Scan — NeoSoul-AI/neotrade-release (2026-09-09)

## Repo metadata
- **Repo:** NeoSoul-AI/neotrade-release
- **Selection:** forced target via `var=NeoSoul-AI/neotrade-release` (bare `owner/repo` → Arm A scan)
- **Stars:** 1 · **Language:** none detected · **Fork:** no · **Archived/Disabled:** no
- **Size:** 7 KB · **Default branch:** main · **Last push:** 2026-09-07
- **Description:** none. README documents download/install/update instructions for "NeoTrade" (neotrade.pro), described as a self-custodial desktop trading-agent runtime distributed as signed Tauri-style bundles (dmg/exe/msi/deb/rpm/AppImage) via GitHub Releases.
- **SECURITY.md:** not present (404)
- **Private Vulnerability Reporting:** disabled (`enabled: false`)

## Selection-criteria check (A1)
- ≥50 stars: **fail** (1 star)
- Active in last 6 months: pass (pushed 2026-09-07)
- Handles untrusted input (auth/crypto/network/file I/O/templating): **fail** — no application code present in this repo
- Repo contents: exactly one file, `README.md` (download/install/update documentation, no source)
- Git tree (`git/trees/main?recursive=1`) confirms: `README.md` only — no workflows, no manifests, no lockfiles

**Decision: skip code audit.** This repo is a release-artifact index for a desktop app whose source lives elsewhere — it holds no application source, dependency manifests, or lockfiles, so there is nothing for SAST (semgrep), secret-scanning (TruffleHog), dependency-CVE scanning (osv-scanner), or an agentic entrypoint review to operate on. No fork or clone was performed.

The release assets themselves (signed `.dmg`/`.exe`/`.msi`/`.deb`/`.rpm`/`.AppImage` binaries, `.sig` files, `SHA256SUMS`, `latest.json` updater manifest) are outside this skill's scope — it audits source repositories with purpose-built static/dependency/secret scanners, not compiled release binaries. Nothing in the surveyed metadata (README text, release asset listing) raised a distribution-integrity concern: bundles ship individually ed25519-signed with a companion `SHA256SUMS`, `latest.json` gates the updater by channel (stable/beta), and the guidance to bypass macOS Gatekeeper / Windows SmartScreen is explained as a consequence of the app being ad-hoc-signed rather than notarized/Authenticode-signed — a known, disclosed limitation, not a hidden one.

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
- Channel: **skipped** — nothing to route. (Also moot: no SECURITY.md and PVR disabled, so even if a code finding existed in the *actual* NeoTrade source repo, this release-index repo has no safe channel without out-of-band contact resolution.)

## Dedup note
Logged to `memory/vuln-scanned.json` (`channel: "skipped"`, `findings: 0`) so this repo is not re-selected for 30 days. No entry added to `memory/security-watchlist.md` (that watchlist is for real findings with no channel, not empty/non-source repos).

## Summary
NeoSoul-AI/neotrade-release is a binary-distribution index, not a source repository — it holds a single 7 KB README pointing at signed release artifacts for the "NeoTrade" desktop app, whose actual source lives in a different (unspecified) repository. No fork, no scan, no findings. Recorded as a clean/skipped scan for dedup purposes, matching the pattern already established for other non-source NeoSoul-AI marketing/index repos scanned today (0g-builders).
