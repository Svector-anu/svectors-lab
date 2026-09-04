---
title: Vuln Scan — stripe/stripe-cli
description: Security audit of stripe/stripe-cli (Go, 2170 stars) — one auth-bypass candidate on the local gRPC daemon, needs-verification pending Go toolchain access
tags: [security, vuln-scanner, stripe, go]
timestamp: 2026-09-04T00:00:00Z
---

# Vuln Scan — stripe/stripe-cli

**Repo:** [stripe/stripe-cli](https://github.com/stripe/stripe-cli) — Go, 2170 stars, active (pushed 2026-09-03)
**Audited commit:** `53747866af9d270f8d293439ee8c6b9ae67deb0b` (fork: `Svector-anu/stripe-cli`)
**Disclosure channel:** No PVR, no repo-level `SECURITY.md`. The org-level `stripe/.github` `SECURITY.md` (GitHub's inherited default) explicitly directs reporters to **Stripe's own Vulnerability Disclosure and Reward Program** (a HackerOne-style bug bounty) and asks that GitHub issues/PRs not be used. That is a real channel, just not one this skill submits to automatically — it requires a human to file through Stripe's own program under its own terms.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit`, `p/owasp-top-ten`, `p/secrets`, 77 raw hits |
| trufflehog | fail (unavailable) | Only a `.tar.gz` release asset exists; no raw binary to stage, and `tar` isn't on the in-run staging allowlist |
| osv-scanner | ok | 3 vulnerable packages / 7 CVE rows |
| fuzz (cargo-fuzz) | n/a | No `fuzz/fuzz_targets` in this repo (Go project, not Rust) |
| agentic (A3.6) | ok | 1 candidate surfaced, see below |

## Candidate count / confirmed

**Candidates reviewed:** 77 semgrep + 7 dependency CVE rows + 1 agentic candidate = 85.
**Confirmed (filed/disclosed):** 0.
**Needs-verification (not filed, not disclosed):** 1.

### Semgrep — 77 hits, 0 real findings

- 66/77 are `go.lang.security.audit.unsafe.use-of-unsafe-block`, all inside generated protobuf code (`*.pb.go`) — standard `protoc-gen-go` reflection pattern, not attacker-reachable, not user-authored.
- 3× `gha-curl-pipe-shell` in `.github/workflows/curl-install-test.yml` and `plugin-canary.yml` — these are scheduled CI jobs that smoke-test Stripe's *own* published install script over HTTPS from their own repo. Intentional, not exploitable by a third party.
- 1× Dockerfile `missing-user-entrypoint` — container runs as root by default. Hardening nit, not an exploitable vulnerability on its own; common for CLI images that need arbitrary host-mounted filesystem access.
- `fs-directory-listing` + `use-tls` in `pkg/cmd/serve.go` — this is the `stripe serve` dev command, which *is* a static file server bound to localhost, invoked explicitly by the user with their own directory. Working as designed, not a vulnerability.
- 3× `math-random-used` (`pkg/terminal/p400/*.go`, `pkg/docs/tui/parallelogram.go`) — non-cryptographic tracing/transaction IDs and TUI animation, not security tokens. No security boundary depends on unpredictability here.
- 2× `missing-ssl-minversion` (`pkg/proxy/webhook_event_processor.go`, `pkg/websocket/client.go`) — no explicit `tls.MinVersion` set, but neither disables certificate verification by default and Go's client default already floors at TLS 1.2. Hardening suggestion, not a live vulnerability.

### osv-scanner — 3 packages, 7 CVE rows

| Package | Version | CVE(s) | Severity | Direct/Indirect | Disposition |
|---|---|---|---|---|---|
| `google.golang.org/grpc` | 1.82.1 | CVE-2026-84304 (GHSA-vp52-pcj8-j9qc) | HIGH (8.7) | Direct | **Duplicate-skipped** — Dependabot already opened [PR #1984](https://github.com/stripe/stripe-cli/pull/1984) bumping to 1.83.1, the exact fix, 2 days before this scan. No action needed. |
| `golang.org/x/crypto` | 0.54.0 | GO-2026-5932, GO-2026-6303 (CVE-2026-56854), GO-2026-6354 (CVE-2026-78662, called:true), GO-2026-6355 (CVE-2026-56855, called:true) | unscored / DoS-class | Indirect | Not filed this run — see Blocked below |
| `golang.org/x/mod` | 0.37.0 | GO-2026-6179 (CVE-2026-56865), GO-2026-6180 (CVE-2026-56864) | unscored | Indirect (called:false) | Not filed this run — see Blocked below |

**Blocked:** bumping the two indirect deps correctly requires regenerating `go.sum` (checksums), which needs the Go toolchain (`go mod tidy` / `go get`). This run's tool permissions don't grant `go` invocation (only the scanner binaries listed in the skill's write-tier allowlist are permitted), so a go.mod-only edit would ship a broken/unverifiable `go.sum` — worse than no PR. Recommend a follow-up run (or operator) with `go` available to do a clean `go get golang.org/x/crypto@v0.56.0 golang.org/x/mod@v0.40.0 && go mod tidy` and open one bundled PR.

### Agentic review (A3.6) — 1 candidate: local gRPC daemon auth bypass

**Threat model:** `stripe-cli` is a trusted local tool that holds the user's live/test Stripe API credentials. The two things worth protecting are (1) those credentials and (2) the user's live Stripe account state (webhook endpoints, events) that the CLI can act on with them. `stripe daemon` (`pkg/cmd/daemon.go`) is a hidden-but-directly-invokable command that starts a gRPC server on the IPv6 loopback (`::1`), explicitly documented as letting external programs "invoke Stripe CLI commands programmatically."

**Finding:** `pkg/rpcservice/middleware.go:39-50` (`authorize()`) is the only gate in front of every RPC (wired via `serverUnaryInterceptor`/`serverStreamInterceptor`, `rpc_service.go:63-65`). It checks only that a gRPC metadata header named `sec-x-stripe-cli` (a public constant, `middleware.go:18`) is **present** — it never checks the header's **value** against any secret. Any local process that can reach the loopback port (the port is printed to stdout by the daemon itself, and is trivially discoverable via `/proc`/`netstat` regardless) can attach any gRPC client, send that header with an arbitrary value, and call any of: `WebhookEndpointCreate` (`pkg/rpcservice/webhook_endpoint_create.go:12`, which uses `srv.cfg.UserCfg` — the CLI's own already-authenticated profile — with no credential required from the caller), `EventsResend`, `Trigger`, `Fixture`, `Login`, `LogsTail`.

**Attacker controls:** ability to run any process on the same machine as a user who has `stripe daemon` running (e.g. a malicious local script, another compromised app, or another local account if the OS doesn't restrict loopback TCP by uid).
**Attacker achieves:** silently register a new webhook endpoint on the victim's live Stripe account pointed at an attacker-controlled URL via `WebhookEndpointCreate` — a live, ongoing feed of the merchant's Stripe events (which for most merchants includes payment and customer PII) — without ever touching the user's actual API key.

**Why this is not confirmed or disclosed:** per this skill's fail-closed PoC-verification gate (A4.5), a HIGH/CRITICAL code claim needs an executable reproduction before it counts as confirmed. The "command" mode of `./scripts/vuln-poc-gate.sh` needs to compile and run the target's own Go code (start the daemon, connect a gRPC client, prove the unauthenticated call succeeds) — this run's tool permissions do not grant `go` invocation at all (confirmed: `go version` / `command -v go` were both denied by the permission layer). Per the skill's own rule: *"Missing toolchain… → mark the candidate needs-verification; do not count it as confirmed, do not send/file anything… Do not automatically relabel a failed HIGH claim as MEDIUM just to bypass the gate."*

**Status:** `needs-verification`. Not filed as a PVR (PVR is disabled on this repo anyway), not emailed, not made public. Flagged here for the operator: a follow-up run with `go` toolchain access could complete the PoC in a few minutes (start `stripe daemon`, dial the loopback port with any gRPC client + the public header, call `WebhookEndpointCreate` against a local httptest receiver, confirm the call succeeds with no real Stripe credential presented). If verified, the correct channel is **Stripe's bug bounty program** (https://stripe.com/docs/security/stripe#disclosure-and-reward-program) — that requires a human to submit under Stripe's own program terms, not an automated PVR/email send.

**Entrypoints reviewed but not deep-reviewed** (budget N=10 for this repo size, 427 Go files): `pkg/plugins/plugin.go` install/checksum path (reviewed — checksums are sourced from the same first-party Stripe metadata API as the download URL, no injection point found without an already-attacker-controlled `--api-base` flag), `pkg/fixtures` templating, `pkg/login` OAuth flow, terminal/P400 reader flow, `pkg/proxy` webhook forwarding (`stripe listen`), git integration via go-git. None showed an obvious high-exposure issue in a shallow pass; not exhaustively reviewed.

## Prior-art check

Ran for the `grpc` dependency finding only (the one candidate that would otherwise be filed): `gh search issues --repo stripe/stripe-cli -- "grpc"` surfaced open PR #1984 (Dependabot, same fix). Confirmed same file (`go.mod`/`go.sum`) and same root cause before treating as a match. No prior-art check was needed for the agentic candidate (never reached the filing stage).

## PoC gate status

`needs-verification` (toolchain unavailable in this run) — see above.

## Dedup note

Recorded in `memory/vuln-scanned.json` as `channel: needs-verification` so this repo isn't silently treated as "clean" and re-scanned in 30 days; a follow-up should specifically re-run the PoC gate on the daemon-auth finding rather than re-doing the full scan.
