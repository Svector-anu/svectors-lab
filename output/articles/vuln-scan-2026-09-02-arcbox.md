# Vuln scan — arcboxlabs/arcbox (2026-09-02)

## Repo metadata
- **Repo:** [arcboxlabs/arcbox](https://github.com/arcboxlabs/arcbox)
- **Description:** Fast open-source container/VM runtime for macOS (Docker alternative, agent sandboxes, Linux/macOS VMs)
- **Language:** Rust · **Stars:** ~2.5k · **Not a fork** · Active (pushed 2026-08-31)
- **Audited commit:** `55b384b9193d9e564b33efe208dcc7ad5d63b0ff`
- **Disclosure channels available:** PVR enabled · `SECURITY.md` → security@arcbox.dev
- **Selection:** Top pick from `github-trending` chain (isolation/runtime attack surface); not scanned in last 30 days

## Threat model (brief)
ArcBox runs untrusted guest workloads on a host daemon. Primary attacker goals: guest-to-host breakout, privileged-helper abuse, path escape on VirtioFS/bind mounts, unauthenticated daemon control, network/proxy abuse. Trust boundaries: guest↔host, sandbox↔daemon, Docker API, OCI ingest, VirtioFS shares, vmnet/DNS/proxy.

## Scanner sources
| Source | Status | Notes |
|--------|--------|-------|
| semgrep | ok | 69 candidates (almost all GHA mutable-tag warnings; 2 shell-injection patterns on maintainer-only `workflow_dispatch` inputs — dropped) |
| trufflehog | ok | filesystem + git history; 0 verified secrets |
| osv-scanner | ok | 33 unique advisories pre-bump; HIGH cleared for openssl/quinn-proto/rustls-webpki/nanoid after lockfile bumps |
| fuzz | skip | no `fuzz/fuzz_targets` |
| slither | skip | no Solidity |
| agentic | ok | budget N=10 (1050 code files); 1 HIGH candidate emitted |
| poc gate | verified | `finding-1` local-command, commit-bound, sha256 `908506d6430ea9e5e1db1a8dc201b757f872fd342f62dcef6e5dd4b63b3810ad` |

## Candidates reviewed
- Semgrep: 69 (CI hygiene / non-exploitable by outsiders)
- OSV: 33 advisories (actionable HIGH/MODERATE dep set)
- Agentic: 10 deep-reviewed entrypoints; 1 candidate retained after triage
- **Confirmed: 2** (1 code HIGH via PVR; 1 public dep-bump PR covering multiple published CVEs)

## Confirmed findings

### 1. HV VirtioFS open/setattr symlink TOCTOU — HIGH — PVR
- **Channel:** Private Vulnerability Report — [GHSA-5p84-px8m-8gwv](https://github.com/arcboxlabs/arcbox/security/advisories/GHSA-5p84-px8m-8gwv)
- **PoC gate:** verified (`local-command`) on audited commit
- **Prior art:** [PR #474](https://github.com/arcboxlabs/arcbox/pull/474) hardened LOOKUP name validation (different root cause); open-path TOCTOU remained
- **Details:** Redacted in this public report — see private advisory. Asymmetry vs existing DAX `st_ino` guard.

### 2. Dependency CVEs — public PR
- **Channel:** Public PR [#709](https://github.com/arcboxlabs/arcbox/pull/709)
- **PoC gate:** not-required (published advisories)
- **Bumps:**
  - `openssl` 0.10.76 → 0.10.80 (multiple HIGH GHSAs)
  - `quinn-proto` 0.11.14 → 0.11.15 (HIGH DoS)
  - `rustls-webpki` 0.103.10 → 0.103.13 (HIGH DoS)
  - `russh` 0.62.2 → 0.62.5 (MODERATE pre/post-auth panics)
  - `nanoid` 3.3.17 → 3.3.18 in TS SDK (HIGH)

## Entrypoints deep-reviewed (agentic N=10)
Helper peer-auth, daemon control-plane socket, Docker API/bind mounts, VirtioFS passthrough, machine mounts/shares, egress NAT/proxy, k8s proxy, NFS host mount, sandbox FS/exec API, OCI/image naming. Near-misses discarded: intentional Docker trust model, `host.docker.internal` gateway mapping, helper `0666` + code-signing auth.

## Dedup
- Recorded in `memory/vuln-scanned.json` (`channel: pvr+public-pr`)
- Skip `arcboxlabs/arcbox` for 30 days

## Advisory / PR links
- PVR: https://github.com/arcboxlabs/arcbox/security/advisories/GHSA-5p84-px8m-8gwv
- Dep PR: https://github.com/arcboxlabs/arcbox/pull/709
