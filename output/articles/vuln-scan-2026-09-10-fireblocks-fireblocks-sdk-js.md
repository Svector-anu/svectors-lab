# Vuln Scanner — fireblocks/fireblocks-sdk-js

**Date:** 2026-09-10
**Target:** fireblocks/fireblocks-sdk-js (forced via `var`)
**Audited commit:** `c13e455e9b24c1177e3c3225e63f92c2ff767627`

## Repo metadata

- Language: TypeScript
- Stars: 84
- Fork: no, Archived: no
- Last push: 2026-07-19
- Private Vulnerability Reporting: **enabled**
- What it is: an official client SDK wrapping Fireblocks' digital-asset-custody REST API (vault/wallet/transaction management, JWT-signed requests). Small surface — 13 source files, no server-side code.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 9 raw hits |
| trufflehog (filesystem) | ok | 0 verified secrets |
| trufflehog (git history) | ok | 0 verified secrets, full history |
| osv-scanner | ok | 28 dependency CVEs found (see below) |
| fuzz (cargo-fuzz) | skip | no `fuzz/fuzz_targets` — repo is TypeScript, not Rust |
| agentic (A3.6) | ok | all 13 source files reviewed (small repo, budget N=15) |

## Candidate count / confirmed findings

**Candidates:** 28 dependency CVEs + 9 semgrep hits + 1 agentic candidate = 38
**Confirmed / actioned:** 9 dependency CVE groups fixed via PR. 0 code vulnerabilities confirmed via the A4.5 PoC gate (none reached HIGH/CRITICAL with a safe verifier available).

### 1. Semgrep (9 hits) — dropped, no code impact

All 9 hits are `github-actions-mutable-action-tag` warnings in `.github/workflows/*.yml` (mutable `@vX` action refs instead of pinned SHAs). CI supply-chain hygiene only — not reachable from the SDK's own runtime code, not something a scanner-driven weekly run should PR uninvited. Noted, not filed.

### 2. Dependency CVEs (osv-scanner, 28 findings) — public PR filed

Prior-art check (`gh search issues --include-prs`) found:
- **Issue #333** (open) — exact match for the `base-x` finding below.
- **PR #314** (open, stale) — Snyk bump of `qs` to 6.13.1, which no longer covers 4 newer `qs` CVEs.

Ran `npm audit fix --package-lock-only` (no `--force`, zero `package.json` changes, zero breaking changes). Verified before/after with `osv-scanner`: 28 → 4 remaining.

**Fixed (9 packages, filed as [PR #344](https://github.com/fireblocks/fireblocks-sdk-js/pull/344)):**

| Package | From | To | Advisory |
|---|---|---|---|
| qs | 6.11.1 | 6.16.0 | GHSA-4mjr-xmp4-gh2g, GHSA-6rw7-vpxm-498p, GHSA-q8mj-m7cp-5q26, GHSA-w7fw-mjwx-w883 |
| lodash | 4.17.21 | 4.18.1 | GHSA-f23m-r3pf-42rh, GHSA-r5fr-rjxr-66jc, GHSA-xxjr-mmjv-4gpg |
| form-data | 4.0.5 | 4.0.6 | GHSA-hmw2-7cc7-3qxx (CVE-2026-12143, CRLF injection) |
| base-x | 4.0.0 | 4.0.1 | GHSA-xq7p-g2vc-g82p (homograph/Unicode-lookalike bypass) — closes #333 |
| jws | 3.2.2 | 3.2.3 | GHSA-869p-cjfg-cm3x (improper HMAC signature verification) |
| js-yaml, minimatch, brace-expansion, diff | — | — | dev-only, transitive of `tslint`; not shipped (package `files` is `dist/**/*` only) |

Also commented on #314 pointing to the new PR (superseding it), and on #333 linking the fix.

**Not fixed — no safe non-breaking path, noted in the PR body and deferred:**

| Package | Issue | Why not fixed |
|---|---|---|
| `@stablelib/ed25519` 1.0.3 | GHSA-x3ff-w252-2g7j — Ed25519 signature malleability (missing S < L check) | **No patched release exists at all** — even the latest 2.0.2 is still affected. Transitive via `@notabene/pii-sdk` (direct runtime dep). A dependency bump cannot fix this; would need a fix upstream in stablelib/ed25519 itself, or a mitigation inside `@notabene/pii-sdk`. Reachability from fireblocks-sdk-js's own code could not be confirmed (neither the ed25519 lib nor base-x/bs58 are imported directly by this repo's `src/` — both live only inside `@notabene/pii-sdk`'s own dependency tree). |
| `uuid` 8.3.2 | GHSA-w5hq-g745-h8pq — missing buffer bounds check in v3/v5/v6 | Fix requires a major bump (8 → 13), out of scope for a lockfile-only patch. |
| `decode-uri-component` 0.2.2 | GHSA-vcc3-ghjq-m6fr — DoS via exponential decoding | Fix requires `query-string` to cross a breaking-change boundary (5.0.0–9.4.1 → 9.5.1). |

### 3. Agentic source-to-sink review (A3.6)

**Threat model:** this is a client SDK, not a server — the main things an attacker would want are (a) leaking or misusing the operator's Fireblocks private API key, or (b) getting the SDK to make an authenticated request the calling application never intended (confused-deputy / request redirection), since every request is signed and executed with the operator's own privileged custody-API credentials.

Reviewed all 13 source files (small repo, no budget constraint hit):
- `api-token-provider.ts` — JWT signing (RS256) only. **`jwt.verify` is never called anywhere in this repo** — confirmed by grep — so the `jws` HMAC-signature-verification CVE (GHSA-869p-cjfg-cm3x, fixed above) was never reachable via this repo's own call path even before the patch; it only matters if a downstream consumer independently verifies tokens with the same vulnerable `jws`.
- `api-client.ts` / `fireblocks-sdk.ts` — **1 candidate surfaced**: nearly every SDK method (`getVaultAccountAsset`, `getNetworkConnection`, etc. — dozens of call sites) interpolates a caller-supplied ID (`vaultAccountId`, `assetId`, `connectionId`, `networkId`, `exchangeAccountId`, ...) directly into the request path template with no `encodeURIComponent` or format validation. A local test (`axios` request interceptor, no network call) confirmed a literal `../../../v1/users/admin` value survives unmodified into the outbound request's resolved `config.url` — axios does naive string concatenation for `baseURL` + path, not RFC-3986 URL resolution, so nothing on the client side normalizes or rejects it.
  - **Attacker-controls:** an ID value passed through to any `FireblocksSDK` method (realistic if a calling backend forwards an external user's ID/asset-symbol input without validating its shape first).
  - **Attacker-achieves (claimed):** redirecting the SDK's already-signed, authenticated request to an unintended Fireblocks API endpoint under the operator's own credentials.
  - **PoC-gate verdict: needs-verification.** The claim's second half — whether Fireblocks' own production API/edge normalizes or rejects a `..`-containing path before routing — depends entirely on infrastructure outside this repo. There is no safe way to build a deterministic local verifier for that half without probing Fireblocks' live production service, which the PoC gate explicitly forbids ("never point it at a production service or third-party live target"). Per A4.5, an unverifiable HIGH/CRITICAL claim stays `needs-verification`: not counted as confirmed, not filed, not disclosed — surfaced here for the operator instead.
- No `eval`/`exec`/`Function` sinks, no hardcoded secrets, no `process.env` reads of sensitive material — the private key is entirely caller-supplied and held in memory only for signing.

No other code-vulnerability candidates found.

## PoC gate status

- Dependency CVEs (9 fixed): **not-required** — published-advisory exception (A4.5), severities quoted directly from the linked GHSA records.
- Agentic path-interpolation candidate: **needs-verification** — no safe deterministic verifier available (depends on third-party production infra); not filed anywhere, surfaced to operator only.

## Dedup note

Logged to `memory/vuln-scanned.json` as `channel: public-pr`, 1 finding (the bundled dependency-CVE fix). Repo will be skipped for 30 days from 2026-09-10.

## Links

- PR: https://github.com/fireblocks/fireblocks-sdk-js/pull/344
- Comment on stale qs PR: https://github.com/fireblocks/fireblocks-sdk-js/pull/314#issuecomment-5619664322
- Comment on base-x issue: https://github.com/fireblocks/fireblocks-sdk-js/issues/333#issuecomment-5619665466

## Summary

- **What I did:** Forked and scanned `fireblocks/fireblocks-sdk-js` (semgrep, trufflehog filesystem+git-history, osv-scanner, agentic source-to-sink review). Ran the mandatory prior-art check before filing anything public.
- **Files created/modified:** Opened upstream PR #344 (lockfile-only, 9 package bumps, zero breaking changes) fixing 24 of 28 found dependency CVEs; commented on upstream PR #314 and issue #333; appended an entry to `memory/vuln-scanned.json`; wrote this report.
- **Follow-up needed:**
  1. Operator/maintainer review of PR #344.
  2. `@stablelib/ed25519`'s unpatched signature-malleability advisory (GHSA-x3ff-w252-2g7j) has no upstream fix at all — worth periodic re-checking, not actionable today.
  3. The unencoded-path-interpolation candidate is `needs-verification` and was deliberately **not** filed or disclosed anywhere — if a future run gets a safe way to confirm Fireblocks' server-side path handling (e.g. via their own bug-bounty/PVR program with their cooperation), it should be re-raised then.
