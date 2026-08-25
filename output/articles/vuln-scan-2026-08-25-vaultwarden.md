# Vulnerability scan — dani-garcia/vaultwarden

## Repository

- Repository: `dani-garcia/vaultwarden`
- Snapshot: `main` @ `fa2566d14fc745937ce104011475eca9e6c7a6f6` ("Fix password change with newer web-vault")
- Stars: ~66,209
- Primary language: Rust (Rocket)
- Product: unofficial Bitwarden-compatible self-hosted password vault server
- Disclosure channel: GitHub PVR **enabled** + `SECURITY.md` (Matrix + `security@vaultwarden.org` / GPG)
- Review size: 97 production-language source files; agentic budget N=15
- Selected from: `output/.chains/github-trending.md` (2026-08-25); skipped already-scanned trending peers (`apache/maka`, and earlier same-day scans)

## Threat model

Vaultwarden stores encrypted vault material and brokers auth for Bitwarden clients. Highest-value attacker outcomes: (1) auth bypass / account takeover (JWT, SSO, device approval, 2FA/protected-actions), (2) cross-user cipher/collection IDOR, (3) admin-panel takeover, (4) SSRF via the internal icon fetcher into operator infra, (5) secret exfil from attachments/sends. Trust boundaries: unauthenticated identity/register/prelogin + public Send access; authenticated user API; admin token cookie; org API key (LDAP import); outbound HTTP for icons/push/SSO with custom DNS + non-global IP blocking.

## Scanner sources

| Source | Status | Result |
|---|---|---|
| Semgrep security-audit / OWASP / secrets | ok | 26 candidates — Jinja/Docker in `docker/`+`playwright/`, Handlebars admin/email template warnings, `tools/global_domains.py` urllib |
| TruffleHog filesystem | ok | 0 verified secrets |
| TruffleHog git history | ok | 0 verified secrets (depth-200 clone) |
| osv-scanner | ok | Cargo.lock + `playwright/package-lock.json` advisory rows |
| Slither | n/a | No Solidity |
| cargo-fuzz | skip | No `fuzz/fuzz_targets` |
| Agentic source-to-sink review | ok | Top 15 exposure surfaces deep-reviewed; 0 code vulns confirmed |

## Triage summary

- **Candidates reviewed:** 26 Semgrep + ~52 OSV vuln rows + agentic top-15
- **Confirmed:** 1 dependency advisory with an available lockfile patch (`h2` → public PR)
- **Dropped / not filed:**
  - Semgrep Dockerfile/`USER` and Jinja autoescape hits under `playwright/` and `docker/` — test/packaging, not the production server path
  - Handlebars `var-in-href` / unquoted-attr warnings — server-generated admin/email URLs behind admin-token or mail templates; no attacker-controlled href confirmed
  - `tools/global_domains.py` dynamic urllib — maintainer tooling, not a network-facing sink
  - OSV `vaultwarden@1.0.0` GHSA set (HTML injection, collection manage, bulk privilege, 2FA rate-limit, XSS, cipher partial-update, impersonation) — **false positive**: `Cargo.toml` keeps placeholder `version = "1.0.0"` while tagged releases are 1.37.x and the fixed versions are ≤1.35.4; call-path review shows current guards (`is_accessible_to_user`, `is_manageable_by_user`, protected-action attempt limits)
  - `rsa` Marvin (RUSTSEC-2023-0071) via `jsonwebtoken`/`openidconnect` — no patched release
  - `rustls-webpki@0.101.7` advisories — pulled only by Rocket 0.5.1’s `rustls 0.21`; parallel `0.103.13` already present via `rustls 0.23`; no lockfile-only fix without a Rocket major bump (SECURITY.md also excludes already-upstream-reported dep issues from their private disclosure process)
  - `async-std` discontinued / `rustls-pemfile` unmaintained — informational
  - All npm advisories under `playwright/` — E2E test stack only, not shipped in the server binary

## Confirmed findings

### 1. `h2` unbounded empty DATA frames (RUSTSEC-2026-0258)

| Field | Value |
|---|---|
| Package | `h2` `0.4.15` → `0.4.16` |
| Advisory | [RUSTSEC-2026-0258](https://rustsec.org/advisories/RUSTSEC-2026-0258) |
| Severity | medium (DoS) |
| Reachability | `h2` ← `hyper` ← `reqwest` (icon download / outbound HTTP) |
| Channel | **Public PR** (already-disclosed dep advisory) |
| Prior-art | No open/recent PR for `RUSTSEC-2026-0258` or `h2 0.4.16`; older Dependabot `h2 0.3.x` bump #4471 unrelated |
| PR | https://github.com/dani-garcia/vaultwarden/pull/7651 |

### Verification

- Reproduced locally: yes
- Command: `cargo update -p h2 --precise 0.4.16`
- Before: `Cargo.lock` pinned `h2 0.4.15`
- After: `Cargo.lock` pins `h2 0.4.16`
- Environment: osv-scanner 2.5.1 on `main` @ `fa2566d`

## Agentic review (top 15)

1. **Admin panel auth** (`src/api/admin.rs`) — Argon2/`ct_eq` token check, rate-limited login, Strict/HttpOnly admin JWT cookie; post-login redirect is prefixed with `admin_path()` so absolute open-redirect candidates collapse to same-origin paths.
2. **Attachment download** (`src/api/web.rs`) — JWT `decode_file_download` binds `cipher_id` + `file_id`; mismatch → 404.
3. **Cipher access / update** (`src/api/core/ciphers.rs`) — `is_accessible_to_user` on read/update/delete paths; historical IDOR GHSAs appear addressed.
4. **Collection bulk permissions** (`src/api/core/organizations.rs`) — `is_manageable_by_user` before bulk-access writes.
5. **Protected actions / email OTP** (`two_factor/protected_actions.rs`) — attempt ceiling, expiry, constant-time compare; 30s resend delay.
6. **Device auth-requests** (`accounts.rs`) — create/approve scoped by user+device; poll requires access code + matching device type + client IP.
7. **Icon SSRF path** (`icons.rs` + `http_client.rs`) — host validation, non-global IP block, redirect re-check, DNS post-resolve IP filter, regression tests for decimal/hex/octal IP forms.
8. **Public Send access** — access-count / password / expiry / disable gates; org Disable-Send policy enforced on mutate.
9. **SSO / OIDC** (`identity.rs`, `sso*.rs`) — state/error branches present; keyed via `openidconnect` (Marvin timing is theoretical on JWT lib path, not filed).
10. **Org public LDAP import** — gated by org API-key `PublicToken`; last-owner revoke protection.
11. **Emergency access** — feature-flagged; confirm/approve/takeover flows present with grantor/grantee scoping.
12. **Registration / email verify / delete-recover** — tokenized flows with password or OTP re-auth on sensitive account changes.
13. **Web vault static join** — catch-all serves under configured web-vault folder; debug-only disk reload behind `debug_assertions`.
14. **Push / WebSocket notify** — authenticated device registration; anonymous notify limited to auth-request response fanout.
15. **RSA key bootstrap** (`auth.rs`) — generates/stores server JWT signing key via opendal; not an untrusted-input sink.

Entrypoints noted but not deep-reviewed past N: Duo OIDC/YubiKey/WebAuthn enroll details, archive/trash purge jobs, S3 connector adapter, mail template rendering internals, Playwright E2E helpers.

## Dedup

Recorded in `memory/vuln-scanned.json` with `channel: public-pr` (30-day skip).

## Advisory / PR links

- https://github.com/dani-garcia/vaultwarden/pull/7651
