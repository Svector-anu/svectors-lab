---
type: Article
title: "Vuln scan — rainbow-me/rainbow (clean audit)"
description: Security audit of the Rainbow Ethereum wallet — clean code and secrets, large but transitive/public dependency CVE surface already under Dependabot management.
tags: [security, vuln-scanner, audit, rainbow, crypto-wallet]
timestamp: 2026-07-31T09:00:00Z
---

# Vuln scan — rainbow-me/rainbow

**Verdict: clean code audit.** No exploitable code flaws and no leaked secrets. The
only surface is a large, entirely-transitive, already-public dependency CVE tree —
which the repo already manages with Dependabot. Nothing here warrants private
disclosure, and the one applicable public channel (a dependency-bump PR) is both
fork-blocked and impractical for deep-transitive packages.

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [rainbow-me/rainbow](https://github.com/rainbow-me/rainbow) |
| Language | TypeScript (React Native mobile wallet) |
| Stars | 4,378 |
| Default branch | develop @ `6c6a067` (2026-07-30) |
| PVR enabled | no |
| SECURITY.md | none (root or `.github/`) |
| Dependabot | yes (`.github/dependabot.yml`) |

## Scanner sources

| Scanner | Status | Result |
|---------|--------|--------|
| semgrep (security-audit + owasp-top-ten + secrets) | ok | 0 findings / 2,510 files scanned |
| trufflehog (filesystem, `--only-verified`) | ok | 0 verified secrets |
| trufflehog (git history, `--only-verified`) | ok | 0 verified secrets (200-commit shallow) |
| osv-scanner (recursive) | ok | 313 vuln rows across 83 packages |
| slither | n/a | no Solidity in target |

## Code audit (semgrep + trufflehog)

- **Semgrep:** 2,510 source files under `src/` scanned against the security-audit,
  OWASP Top Ten, and secrets rulesets (560+ rules loaded from the registry).
  **Zero ERROR/WARNING findings.** Two files produced parser warnings
  (`nativeStackConfig.ts`, `useDepositController.ts` — TS syntax semgrep's parser
  choked on), not security issues.
- **TruffleHog:** filesystem and full-git-history scans with verified-only matching
  returned **zero authenticated secrets**. No live API keys, tokens, or private keys
  committed to the tree or recoverable from the shallow history window.

Confirmed code findings: **0**.

## Dependency scan (osv-scanner)

osv-scanner resolved `yarn.lock` (2,564 pkgs), `src/graphql/yarn.lock` (509 pkgs),
and `Gemfile.lock` (120 pkgs, the iOS/Ruby toolchain), reporting **313 advisory rows
across 83 packages** (17 CRITICAL, 151 HIGH, 114 MODERATE, 31 LOW).

**Triage — why none route to a disclosure channel:**

1. **All are already-public CVEs.** Per the disclosure policy, public dependency CVEs
   go to a public dep-bump PR, never a private advisory. There is no zero-day to
   protect here.
2. **Every notable package is transitive-only.** None of the security-relevant
   crypto primitives — `secp256k1`, `pbkdf2`, `elliptic`, `sha.js`, `cipher-base`,
   `base-x`, `sjcl`, `bn.js`, `@stablelib/ed25519` — is a direct dependency
   (232 direct deps, 63 dev, 27 resolutions checked). A clean single-line lockfile
   bump isn't available, and reachability into the wallet's actual signing/key-
   derivation path is **unproven** — osv-scanner does no call-graph analysis for JS.
   Claiming exploitability would be unfounded.
3. **The maintainer already has this visibility.** The repo ships a configured
   `dependabot.yml`; these advisories are surfaced to the Rainbow team automatically.
   A hand-filed report would be redundant noise, not signal.
4. **The public-PR channel is blocked anyway.** The scanner token cannot fork
   `rainbow-me/rainbow` (HTTP 403), so a dependency-bump PR is not filable this run
   (same constraint recorded on prior scans).

**Worth the maintainer's own review (not asserted as exploitable):** the transitive
tree pulls known-vulnerable crypto primitives (`pbkdf2` GHSA-h7cp-r72f-jxh6 CRITICAL,
`secp256k1` GHSA-584q-6j8j-r5pm HIGH, `sha.js` GHSA-95m3-7q98-8xr5 CRITICAL,
`cipher-base` GHSA-cpq7-6gpm-g9rc CRITICAL, `elliptic` GHSA-848j-6mx2-7j84 LOW). For a
wallet, confirming whether any of these sit on the signing path is a reasonable
Dependabot-triage priority — but that is their call with reachability context we do
not have, not a finding to disclose.

## Channels used

- PVR: 0 (no code flaw / secret to report)
- Public PR: 0 (public CVEs only; transitive + fork-blocked)
- Skipped / logged: dependency CVE surface (public, transitive, Dependabot-managed)

## Dedup note

Recorded in `memory/vuln-scanned.json` — `rainbow-me/rainbow` skipped for the next 30
days. First scan of this repo.

---
Filed by [Aeon](https://github.com/aeonframework/aeon).
