# Vuln Scanner — braintree/braintree_ios (2026-09-10)

## Repo metadata

- **Target**: `braintree/braintree_ios` (forced via `var=braintree/braintree_ios`)
- **Stars**: 581 · **Language**: Swift (+ Objective-C interop) · **Fork**: no · **Archived**: no
- **Description**: Braintree SDK for iOS — official PayPal/Braintree payments SDK (card, PayPal, Venmo, Apple Pay, 3DS, local payments, SEPA, AmEx)
- **Audited commit**: `78dcd1874e669b5fa8dd0d184c5fb1237eb22008` (HEAD of `main`, verified against `gh api repos/.../commits/main`)
- **Disclosure channel**: has `SECURITY.md`. This repo is covered by the **PayPal Vulnerability Reporting Policy / HackerOne bug-bounty program** (https://hackerone.com/paypal), in addition to GitHub PVR (`/security/advisories/new`) and `security@paypal.com`. No code flaw was confirmed this run, so no disclosure routing was needed — noted for any future run: per prior precedent (stripe/stripe-cli scan, 2026-09-04), a bug-bounty-eligible finding should be routed to a human for the program's own process, not auto-filed via PVR/email.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, Sources/Demo/Tests excluded. 16 raw hits, all `github-actions-mutable-action-tag` WARNINGs across `.github/workflows/*.yml` (hardening-class, common across nearly all OSS, not filed — see Guidelines). 0 hits in Swift/ObjC source (expected: semgrep's registry rulesets have weak Swift coverage). |
| trufflehog (filesystem) | ok | 1473 chunks / 11.9MB scanned, 0 verified secrets. |
| trufflehog-git (bounded, 300s) | ok | Bounded git-history scan, 11887 chunks / 61.4MB, completed in 3.6s — no timeout. 0 verified secrets. |
| osv-scanner | ok | `scan source --recursive --no-ignore`. 3 lockfiles found: `Package.resolved` (SPM, 1 pkg), `Braintree.xcodeproj/.../Package.resolved` (SPM, 2 pkgs), `Gemfile.lock` (RubyGems, 55 pkgs). 1 raw finding total (see below), 0 for the SPM packages. |
| slither | skipped | No Solidity in this repo (n/a, not a failure). |
| fuzz (cargo-fuzz) | skipped | No `fuzz/fuzz_targets` — Swift project, no Rust fuzz harness shipped. |
| agentic | ok | See below. 0 candidates written to `agentic.json`. |

## Candidate count / confirmed findings

**Candidates surfaced: 2 (1 dependency, 1 header-hygiene observation). Confirmed HIGH/CRITICAL: 0.**

### 1. Dependency: `sqlite3` 1.7.3 (RubyGems) — GHSA-28hh-pr2h-2w89 / CVE-2026-54619
- **Severity**: LOW (per GHSA — use-after-free when redefining a SQLite function with different arity via `Database#create_function`/`define_function`; CVSS4 `AV:L/AC:H/.../VC:L/VI:L/VA:L`).
- **Reachability**: `sqlite3` is a **transitive dev-tooling dependency of `jazzy`** (the Ruby docs generator) in the repo's `Gemfile.lock`, used only for local/CI documentation generation — not compiled into the shipped SDK, not reachable from any iOS runtime code path, and the vulnerable API (redefining a custom SQL function at a different arity) isn't something `jazzy`/`cocoapods` invoke.
- **Decision**: not filed. LOW severity + non-shipped dev-tooling transitive dependency does not clear the bar for a dependency-bump PR (would be noise for the maintainer). Logged here for completeness, not routed.
- No dependency findings for either SPM `Package.resolved` (3 packages total, 0 CVEs matched).

### 2. Header hygiene observation (not filed): tokenization-key header sent on PayPal-domain requests
- **Location**: `Sources/BraintreeCore/BTHTTP.swift:172-217` (`buildHTTPRequest`).
- **What I saw**: when `url.isPayPalURL` is true, headers are intentionally reset to `[:]` and only an `Authorization: Bearer` is added for `clientToken`-type auth (lines 172-176). But a later, unconditional block (lines 215-217: `if authorization.type == .tokenizationKey { headers["Client-Key"] = authorization.originalValue }`) re-adds the `Client-Key` header regardless of whether the request target is a PayPal-domain URL, undoing the isolation the earlier branch appears to intend.
- **Why not filed as a finding**: Braintree tokenization keys are explicitly documented as non-secret, client-embeddable credentials (same trust model as a Stripe publishable key) — they cannot decrypt vaulted payment data and are already observable via reverse-engineering the app binary. The destination (`api(.sandbox).paypal.com`) is PayPal's own first-party infrastructure (Braintree is a PayPal company), not an arbitrary third party. Net exposure of a non-secret, already-client-visible key to a first-party affiliate domain over TLS does not meet the "attacker achieves a boundary crossing" bar this skill requires (A4 step 2) — I would not be comfortable defending this to the maintainer as a security bug rather than a minor code-hygiene inconsistency. Noted here for transparency, not filed as an issue/PR (per the skill's one-report-per-repo policy, a non-finding shouldn't consume the repo's one filing).

## Agentic logic audit (A3.6)

**Threat model**: this is a payment SDK embedded in third-party merchant apps. The two realistic external-attacker goals are (1) hijacking or spoofing the "return from app/browser switch" flow that completes a PayPal/Venmo/3DS payment (an attacker-controlled or attacker-observable app on the same device is the relevant adversary — not a remote network attacker, since all outbound traffic is TLS+cert-pinned to Braintree/PayPal), and (2) undermining the SDK's own TLS trust so a MITM can intercept a live payment session.

**Budget**: `Sources/**/*.swift` exceeds 100 files across 13 modules (BraintreeCore, Card, PayPal, Venmo, ApplePay, ThreeDSecure, LocalPayment, SEPADirectDebit, AmericanExpress, DataCollector, ShopperInsights, PayPalMessaging, UIComponents) — sized to the medium bucket, so I deep-reviewed the highest-exposure entrypoints rather than every file.

**Deep-reviewed** (source-to-sink, per the step-0 threat model above):
- `BTAppContextSwitcher.swift` / `BTAppContextSwitchClient.swift` — the top-level dispatcher for all "return from app switch" URLs. Only the first registered client whose `canHandleReturnURL` returns `true` gets the URL; that gate runs *before* any client-specific parsing.
- `BTPayPalReturnURL.swift` / `BTPayPalClient.swift` (`handleReturnURL`, `handleReturn`, `canHandleReturnURL`) — the native-app-switch return path validates via `BTPayPalReturnURL.isValid` (requires `scheme == "https"` + `braintreeAppSwitchPayPal` in path + a success/cancel action, OR an exact match on the merchant's own `fallbackURLScheme`) before any URL content is trusted; the ASWebAuthenticationSession/browser path additionally validates host+path against a static `callbackURLHostAndPath` via `isValidURLAction`. Both paths are sound: no attacker-reachable branch skips validation before acting on URL content.
- `BTVenmoAppSwitchReturnURL.swift` / `BTVenmoClient.swift` (`handleOpen`, `handleDirectSuccess`, `handlePaymentContextSuccess`) — same universal-link/host-gated pattern (`isValid` requires `braintreeAppSwitchVenmo` in an https path, or `host == "x-callback-url"` + a fixed path prefix). Noted but not filed: the legacy `handleDirectSuccess` path trusts a `nonce`/`username` pulled directly from return-URL query parameters with no additional server round-trip when the merchant isn't using vault-on-clientToken. This is inherent to the legacy vzero pairing protocol (the Venmo app itself, which already authenticated the user, is the party generating that nonce) — a forged nonce from a URL-scheme-squatting attacker app cannot be redeemed against Braintree's server-side gateway (it wouldn't correspond to a real vaulted account), so the achievable impact caps at a spoofed local "success" UI state, not fund movement or credential theft. This doesn't clear the HIGH/CRITICAL PoC-gate bar and is a platform-inherent risk class (custom URL-scheme non-uniqueness) rather than a code defect specific to this repo.
- `BTWebAuthenticationSession.swift` — delegates callback-URL matching to `ASWebAuthenticationSession`'s own system-managed callback-scheme broker (in-process delivery, not a manually-parsed `openURL`), which is not subject to URL-scheme squatting by other installed apps. Sound.
- `BTHTTP.swift` (`urlSession(_:didReceive:completionHandler:)`, `buildHTTPRequest`) — TLS pinning replaces the trust anchors with `BTAPIPinnedCertificates.trustedCertificates()` (a generated list of DigiCert root/intermediate CAs matching Braintree/PayPal's actual TLS issuance chain) and still runs `SecPolicyCreateSSL(true, domain)` for hostname validation — this fails closed (an empty/mismatched anchor set rejects the connection, `.rejectProtectionSpace`), not open. Sound. See the header-hygiene note above for the one inconsistency found.
- `BTClientToken.swift` (`decodeClientToken`) — `configUrl`/`authorizationFingerprint` are extracted from a client token that is generated and signed off by the **merchant's own trusted server-side Braintree library**, not attacker-controlled network input in this SDK's threat model; version/encoding checks (`version 1` requires UTF8, `2`/`3` require base64) are enforced before use.

**Reviewed-but-not-deep** (past the review budget, not silently dropped): `BraintreeThreeDSecure` (Cardinal Mobile wrapper — largely opaque vendored binary, `Frameworks/CardinalMobile.xcframework`), `BraintreeApplePay`/`BraintreeAmericanExpress` request/nonce models, `BraintreeDataCollector` (`PPRiskMagnes` binary wrapper — vendored, not source-reviewable), `BraintreeUIComponents`, `BraintreeShopperInsights`, `BraintreePayPalMessaging`, and all `UnitTests`/`IntegrationTests`/`Demo` code (explicit A4 drop category).

0 candidates were promoted past framing to `agentic.json` (written as `[]`) — the two items discussed above were considered and explicitly dropped with reasoning, not silently omitted.

## PoC gate status

**Not required.** No candidate reached provisional HIGH/CRITICAL after A4 triage, so `./scripts/vuln-poc-gate.sh` was not invoked this run.

## Dedup note

Not previously scanned — no entry existed for `braintree/braintree_ios` in `memory/vuln-scanned.json` or the last 30 days of `memory/logs/`. This run adds the first ledger entry (see below); future runs should skip re-scanning this repo before 2026-10-10 per the 30-day dedup window.

## Verdict

**Clean audit. 2 candidates reviewed (1 dependency, 1 header-hygiene note), 0 confirmed HIGH/CRITICAL.** All three purpose-built scanners ran to completion with real output; the only semgrep hits were common CI-hardening warnings; TruffleHog found 0 verified secrets across filesystem and bounded git history; osv-scanner's one real finding is a LOW-severity, unreachable, dev-tooling-only transitive dependency. Manual review of the highest-attacker-value surface (PayPal/Venmo app-switch and browser-return URL handling, TLS certificate pinning, and client-token trust boundary) found consistently defensive, gate-before-trust design with no confirmed exploitable gap.

## Summary

- Forked and audited `braintree/braintree_ios` @ `78dcd1874e669b5fa8dd0d184c5fb1237eb22008` (Arm A — scan) per `var=braintree/braintree_ios`.
- Ran semgrep, TruffleHog (filesystem + bounded git-history), and osv-scanner to completion; slither and fuzz correctly skipped (no Solidity, no fuzz harness).
- Performed a manual agentic source-to-sink review of PayPal/Venmo app-switch return-URL handling, ASWebAuthenticationSession usage, TLS cert pinning, core HTTP auth-header construction, and client-token parsing.
- 0 confirmed findings; nothing filed (no PR, no PVR, no email) — clean audit.
- Updated `memory/vuln-scanned.json` with a `clean` entry (30-day dedup) and appended today's `memory/logs/2026-09-10.md` entry.
- Follow-up: none required. The one dropped header-hygiene note (tokenization-key header sent on PayPal-domain requests, `BTHTTP.swift:215-217`) is not being filed but could be worth a low-priority upstream mention if a future run reconfirms it alongside a higher-severity finding in the same area.
