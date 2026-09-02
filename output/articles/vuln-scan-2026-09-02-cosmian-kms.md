# Vuln scan — Cosmian/kms (2026-09-02)

## Repo metadata
- **Repo:** [Cosmian/kms](https://github.com/Cosmian/kms)
- **Stars:** ~350
- **Language:** Rust (KMIP / FIPS KMS server + React UI)
- **Default branch audited:** `develop` @ `5c5496e02364085a0fbd1851fa36ffb4adfe5b3e`
- **Workspace version:** 5.26.0 (fixes for several COSMIAN-2026-* advisories already present on develop; release tag 5.27.0 not yet cut)
- **Disclosure channels:** PVR enabled; SECURITY.md → tech@cosmian.com
- **Selection:** trending list exhausted for today; chose PVR-enabled high-surface KMS from fresh active search

## Threat model (brief)
Cosmian KMS is a networked key-management service. Attackers most want auth bypass / Create-gate bypass, SSRF into cloud metadata, and key-material disclosure. Trust boundaries: JWT/API-token/mTLS/SPIRE auth middlewares, KMIP operation authorization, and outbound URL validation on CSE rewrap + CRL fetch.

## Scanner sources
```
semgrep=ok
trufflehog=ok
osv=ok
fuzz=skip
agentic=ok
```
- fuzz: skipped (no `fuzz/fuzz_targets`)
- agentic budget: CODE_FILES≈956 `.rs` → N=10 deep entrypoints

## Candidates reviewed
| Source | Count | Notes |
|--------|------:|-------|
| semgrep | 162 | Almost all GHA mutable-tag / secrets-inherit / docs demo keys |
| trufflehog (verified) | 2 fs + 5 git | JWT fixtures under `crate/test_kms_server` only — dropped |
| osv-scanner | 244 rows / 14 unique across Cargo.lock+pnpm+SBOMs | Filtered to actionable product lockfiles |
| agentic | 5 candidates | 2 confirmed dep CVEs; 3 dropped / needs-upstream |

## Confirmed findings

### 1. HIGH — brace-expansion DoS (CVE-2026-14257 / CVE-2026-69152)
- **Type:** published dependency CVE
- **Where:** `ui/pnpm-lock.yaml` resolved `brace-expansion@5.0.7`; override floor was `>=5.0.7`
- **Channel:** public PR
- **PoC gate:** not-required (published advisory)
- **Prior-art:** historical bumps to 5.0.5 (#833/#836); no open PR for 5.0.9
- **Fix filed:** https://github.com/Cosmian/kms/pull/1163

### 2. HIGH — nanoid infinite loop (CVE-2026-67213)
- **Type:** published dependency CVE
- **Where:** `ui/pnpm-lock.yaml` resolved `nanoid@3.3.16`
- **Channel:** public PR (same PR)
- **PoC gate:** not-required
- **Fix filed:** https://github.com/Cosmian/kms/pull/1163 (override pinned to `3.3.18` on the 3.x line)

## Reviewed but not confirmed
- **react-router GHSA-qwww-vcr4-c8h2:** lockfile already on `7.18.2` (patched); OSV row was a parse false-positive against React 19.2.4
- **GET /server-info unauthenticated:** intentional for pre-login UI; already COSMIAN-2026-012 (Low, fixed/accepted in 5.22.0)
- **ring@0.16.20 via scratchstack-aws-signature:** RUSTSEC-2025-0009 / GHSA-4p46-pwfr-66x6 (medium). Needs upstream crate bump — not lockfile-only
- **h2@0.3.27 via actix-http:** RUSTSEC-2026-0258; fixed only in h2 0.4.16 — requires actix upgrade
- **rsa@0.9.10 via jsonwebtoken:** residual Marvin advisory surface; KMIP RSA path already moved to OpenSSL (COSMIAN-2025-011). Not re-filed
- **Semgrep GHA shell-injection / curl|bash:** maintainer-controlled `workflow_dispatch` inputs / install scripts — not treated as product vulns
- **CRL SSRF / wildcard Create gate:** mitigations (`validate_crl_url`, reserved uid `*`) present on audited commit

## Agentic deep-review coverage (top N)
Deep-reviewed: ensure_auth, JWT/JWKS fetch, SPIRE vault-token middleware, auth_proxy path traversal guards, Google CSE `validate_kacls_url` + rewrap, CRL validate path, ms_dke auth wrapping, import `replace_existing` ownership check, `/server-info`, database reserved-uid gate. Remaining route surface (jose, azure_ekm, tokenize, pkcs11 loaders) noted as not-deep-reviewed in this pass.

## Dedup
Appended to `memory/vuln-scanned.json` with `channel: public-pr` (30-day skip).
