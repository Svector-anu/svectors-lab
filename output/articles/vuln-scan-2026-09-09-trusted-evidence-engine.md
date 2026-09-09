# Vuln Scanner Report — NeoSoul-AI/trusted-evidence-engine

**Date:** 2026-09-09
**Mode:** scan (forced target via `var=NeoSoul-AI/trusted-evidence-engine`)
**Audited commit:** `ff60e87da74e1c8c7d10cb450540ed2efec13e83`

## Repo metadata

- **Language:** Go
- **Stars:** 0
- **Pushed:** 2026-06-16
- **Description:** none set on GitHub; per README, an open-source "evidence layer" for agents, oracle workflows, and prediction-market/committee automation. Fetches from Brave Search, CoinGecko, Alpha Vantage, Polymarket, and RSS/Atom feeds, then normalizes, deduplicates, and trust-ranks results into a structured "evidence pack" served over HTTP (`/v1/evidence/resolve`) and CLI (`tee resolve`).
- **SECURITY.md:** absent
- **Private Vulnerability Reporting:** disabled (`GET /repos/.../private-vulnerability-reporting` → `enabled: false`)
- Since 0 findings survived triage, no disclosure channel was needed this run — the missing-channel gap is noted for the record only.

## Threat model (A3.6 step 0)

- **What it is:** a self-hostable Go HTTP/CLI service. Untrusted-input surface is the unauthenticated `POST /v1/evidence/resolve` endpoint, which accepts `query`/`claim`/`source_urls`/`context_metadata` from any caller and fans that input out to 6 provider integrations, several of which make outbound HTTP calls using the operator's own third-party API keys (Brave, CoinGecko, Alpha Vantage).
- **What an attacker would most want:** (1) SSRF — coerce the server into issuing requests to attacker-chosen internal/arbitrary hosts via `source_urls` or feed URLs; (2) secret exfiltration — leak the Brave/CoinGecko/Alpha Vantage API keys held server-side; (3) injection into the third-party API query strings.
- **Trust boundaries:** no authentication anywhere in the HTTP API (this is stated as a known v0-skeleton gap in the project's own README, not a hidden flaw). All outbound provider calls originate from server-side config (env vars), not per-request user input, except for the Polymarket provider, which extracts a slug from user-supplied `source_urls`/`query`/`claim` but only re-issues the request against a fixed, server-configured Polymarket endpoint.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep (`p/security-audit`, `p/owasp-top-ten`, `p/secrets`) | ok | 6 hits, all WARNING severity |
| trufflehog (filesystem, `--only-verified`) | ok | 0 verified secrets, 119 chunks scanned |
| trufflehog (git history, bounded 300s) | ok | 0 verified secrets, 94 chunks scanned, finished in 54ms (no timeout) |
| osv-scanner (`scan source --recursive --no-ignore`) | ok | 1 dependency vulnerability group |
| slither | not-applicable | no Solidity in repo |
| fuzz (cargo-fuzz) | skip | no `fuzz/fuzz_targets`, not a Rust repo |
| agentic logic audit | ok | budget N=15 (repo is small: 24 Go files, all reviewed) |

## Candidates reviewed: 8 (6 semgrep + 1 osv group + 1 agentic-threat-model pass yielding 0 new candidates) — Confirmed: 0

### Semgrep — 5× `github-actions-mutable-action-tag` (WARNING)
`.github/workflows/build-push.yml` lines 23, 26, 30, 44, 62 — `actions/checkout@v6`, `docker/setup-buildx-action@v4`, `docker/login-action@v4`, `docker/metadata-action@v6`, `docker/build-push-action@v7` are all referenced by mutable major-version tag rather than pinned SHA.
**Triage:** technically correct (a compromised upstream action could repoint the tag), but these are all official, heavily-scrutinized first-party GitHub/Docker actions — standard practice used by the overwhelming majority of public repos. Not a meaningful, actionable disclosure for a 0-star personal skeleton project. **Dropped.**

### Semgrep — `use-tls` (WARNING)
`cmd/tee-server/main.go:19` — `http.ListenAndServe` without TLS.
**Triage:** the Dockerfile/CI (`build-push.yml`) show this service is built as a container image and deployed via a Kubernetes rollout (`kubectl -n lifefun-test rollout restart deploy/trusted-evidence-engine`), the standard pattern of TLS termination at an ingress/proxy in front of a plaintext backend listener. No code-level attacker-controls-to-attacker-achieves claim beyond "the operator must remember to put this behind TLS," which is already implied by the deployment tooling present. **Dropped.**

### osv-scanner — `golang.org/x/sys@0.35.0`, GO-2026-5024 / CVE-2026-39824
Integer overflow in `NewNTUnicodeString` (`golang.org/x/sys/windows`), fixed in 0.44.0.
**Triage:** osv-scanner's own experimental reachability analysis marks `called: false` — the vulnerable symbol lives under the `windows` build path and is never invoked by this codebase's call graph. The service is built/deployed as a Linux container (see Dockerfile, CI). No realistic attacker-controls claim. **Dropped, no PR filed** (a dependency-bump PR for an unreachable Windows-only symbol in a Linux service would be noise, not help).

### Agentic logic audit — entrypoint inventory (all reviewed, 0 candidates escalated)
- `internal/httpapi/server.go` — the only HTTP mutation surface (`POST /v1/evidence/resolve`); unbounded `json.NewDecoder(r.Body)` (no explicit size cap) was considered but not escalated — Go's default `http.Server` has no built-in limit either way, and this is a documented, acknowledged gap (README's "Current Skeleton Status" explicitly lists missing "rate limiting policies" as known future work), not a novel finding worth disclosing.
- `internal/providers/polymarket.go` — slug extracted from `source_urls`/`query`/`claim` only proceeds if the parsed host contains `polymarket.com` or `gamma-api.polymarket.com`; the outbound request always targets the fixed, server-configured `provider.endpoint`. Not SSRF (host is never attacker-controlled). `path.Join` on the extracted slug could theoretically let a crafted slug (e.g. containing `../`) alter the request path sent to the *fixed* Polymarket host — reviewed and judged non-exploitable beyond causing the server to request a different path on the same fixed third-party host, no internal-network reach. Below the confirmed-finding bar.
- `internal/providers/feed.go` — feed URLs come only from `TEE_FEED_URLS` env var / server-side presets, never per-request input; Go's `encoding/xml` does not resolve external entities (no XXE class in Go stdlib).
- `internal/providers/brave.go`, `coingecko.go`, `coingecko_price.go`, `alphavantage.go` — all build outbound query strings via `url.Values.Set`/`.Encode()` (i.e., value is always taken as a single query-string field, never as a raw path or header key); base hosts are compile-time constants overridable only by server-side env vars. `alphavantage.go`'s ticker/symbol path is additionally constrained by `tickerPattern` regex before free-form use. No injection surface found.
- `internal/dedup/dedup.go`, `internal/ranking/ranking.go`, `internal/providers/presets.go`, `internal/providers/provider.go` — pure data-shape/scoring logic and server-config-only file loads (`TEE_SOURCE_PRESETS_PATH` is env-set, not request-derived). No path traversal, no eval/exec, no auth/session/crypto code present in the repo at all.
- `cmd/tee/main.go`, `cmd/tee-server/main.go` — thin CLI/server bootstrapping, no additional surface beyond the handler already covered.

0 candidates written to `agentic.json`.

## Verdict

**Clean audit — 8 candidates reviewed, 0 confirmed.** This is a small (24 Go files), defensively-written v0 skeleton: every outbound HTTP call is built with `net/url`'s `Values.Set`/`Encode` (no raw string concatenation into URLs), all provider hosts are fixed server-side configuration rather than per-request input, all HTTP clients carry explicit timeouts and `io.LimitReader`-bounded response reads, and there is no auth/crypto/exec/eval/SQL surface in the codebase to misuse. The one real gap — no authentication on the resolve endpoint — is already documented by the maintainer as a known v0 limitation, not a hidden flaw, so it was not raised as a new disclosure.

## Dedup note

Not previously scanned (no prior entry in `memory/vuln-scanned.json` for this repo). This run's result has been appended there (`channel: "clean"`) so a future run skips it for 30 days.

## PoC gate status

**not-required** — no provisional HIGH/CRITICAL code claim survived A4 triage, so `./scripts/vuln-poc-gate.sh` was not invoked.

## Prior-art check

Not run — no public filing was made (0 confirmed findings).
