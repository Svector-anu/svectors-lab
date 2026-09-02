# Vuln scan — clawkwork/clawk (2026-09-02)

## Repo metadata
- **Repo:** [clawkwork/clawk](https://github.com/clawkwork/clawk)
- **Description:** Give coding agents a disposable Linux VM, not your laptop
- **Language:** Go (~300 source files)
- **Stars:** ~1004
- **Audited commit:** `a67d04f102152a67df4228d52da9812aa82ffe50` (v0.4.0 / upstream main)
- **Disclosure channel:** PVR enabled + SECURITY.md (VM isolation + egress allow-list threat model)
- **Selection:** Auto-select after today's github-trending chain targets were already scanned; chose a fresh PVR-enabled agent-sandbox target

## Threat model (agentic pass)
clawk runs coding agents inside disposable VMs with permission prompts off by design. Attackers most want: sandbox escape, egress-filter bypass, abuse of host daemon/control/agent sockets, or credential leakage (OAuth / ssh-agent / mounted secrets). Trust boundaries are the guest VM edge and the DNS-aware egress allow-list.

## Scanner sources
| Source | Status | Notes |
|--------|--------|-------|
| semgrep | ok | 29 findings (26 GHA mutable-tag hardening; 3 Go unsafe; 1 decompression-bomb pattern) |
| trufflehog | ok | 0 verified secrets (filesystem; 713 chunks) |
| osv-scanner | ok | 12 unique advisory rows pre-bump; actionable Go bumps applied |
| fuzz | skip | no `fuzz/fuzz_targets` |
| agentic | ok | budget N=15; deep-reviewed top exposure entrypoints (agent proxy, vzdctl, netfilter ACL/DNS observe, OCI tar2ext4, shares/oauth seeding, vsockproto) |

## Candidates → triage
- **29 semgrep:** GHA mutable tags dropped (standard low-priority class). Three `unsafe` uses are TAP/netns/pty plumbing — necessary, not filed. `tar2ext4` unbounded `io.Copy` noted as local DoS when converting a malicious OCI image; not filed standalone this run (user-initiated pull; Medium DoS).
- **OSV:** Bumped `golang.org/x/net`, `golang.org/x/crypto`, `golang.org/x/mod`, `github.com/klauspost/compress` (root + `machine/` module). Left: Windows-only `docker/cli` plugin LPE, `insomniacslk/dhcp` via gvisor-tap-vsock replace, unmaintained `openpgp` (no fixed version).
- **Agentic:** World-writable `agent.sock` (0666) under world-traversable `~/.clawk` (0755) confirmed as medium trust-boundary break. Shared-IP DNS observation limitation reviewed as inherent allow-list tradeoff — not filed.

## Confirmed findings
| # | Severity | Type | Channel | Ref |
|---|----------|------|---------|-----|
| 1 | medium | Code — insecure socket/dir permissions enabling local cross-user guest exec | PVR | GHSA-f92w-wjfp-773j (details redacted; private advisory) |
| 2 | high/moderate (published) | Dependency advisories (x/net, x/crypto/ssh, x/mod sumdb, klauspost/compress/s2) | Public PR | https://github.com/clawkwork/clawk/pull/18 |

### PoC gate
- Finding 1: **not-required** — provisional severity medium (gate applies to HIGH/CRITICAL code claims only)
- Finding 2: **not-required** — published dependency CVEs / OSV advisories

### Prior-art check
- Searched `deps`, `x/net`, `agent.sock` / `0666` on clawkwork/clawk — no open duplicate for these advisories or the socket mode issue → filed

### Optional private patch
- Draft fix branch (fork only, no upstream PR): https://github.com/Svector-anu/clawk/tree/private/fix-agent-sock-perms

## Dedup
Appended `memory/vuln-scanned.json` with `channel: pvr+public-pr` (30-day skip).
