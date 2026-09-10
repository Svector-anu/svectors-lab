# Vuln Scan — plaid/react-native-plaid-link-sdk

- **Date:** 2026-09-10
- **Mode:** scan (Arm A), forced via `var=plaid/react-native-plaid-link-sdk`
- **Repo:** plaid/react-native-plaid-link-sdk — 200 stars, TypeScript (React Native bridge for Plaid Link; native Kotlin + Swift modules wrapping Plaid's vendored `com.plaid.link` / `LinkKit.xcframework` SDKs)
- **Audited commit:** `ade9d5e97e848c4cba41e90cf4274c40689760ad` (fork: Svector-anu/react-native-plaid-link-sdk)
- **PVR status:** disabled. Has `SECURITY.md`, but it points to an external form (`https://plaid.com/security/disclosure/`), not an email address — so it's a channel for a human to use manually, not an `auto_send`-eligible email draft. Moot this run since 0 findings survived triage.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 24 raw hits |
| trufflehog (filesystem) | ok | 0 verified secrets (3,800 chunks / 48.6MB scanned) |
| trufflehog (git history) | ok | 0 verified secrets (33,269 chunks / 117MB scanned, well under the 300s bound) |
| osv-scanner | ok | 102 raw dependency-vuln rows across 2 lockfiles |
| fuzz (cargo-fuzz) | skip | no Rust / `fuzz/fuzz_targets` — not applicable to this stack |
| agentic (A3.6) | ok | N=15 budget (small repo); full source surface read, not sampled |
| PoC gate (A4.5) | not-required | no HIGH/CRITICAL candidate survived triage |

## Candidates and triage

**Semgrep (24 raw → 0 confirmed):**
- 22× `github-actions-mutable-action-tag` (`.github/workflows/codeql.yml`, `pull_request.yml`, `release_validation.yml`) — hardening-class, not exploitable, near-universal across OSS CI. Dropped.
- 1× `detect-child-process` in `scripts/validate-linkkit-xcframework.js:29` — read the file: this is a **build-time integrity check** that runs `plutil`/`file`/`otool`/`codesign` against the vendored `LinkKit.xcframework` to verify its code signature and TeamIdentifier before packaging. The path argument comes from a CLI arg (`process.argv[2]`) or a hardcoded local default, not remote/attacker input. It's a security *control*, not a vulnerability. False positive, dropped.

**osv-scanner (102 raw rows → 0 confirmed):** All flagged packages (`@xmldom/xmldom`, `brace-expansion`, `browserslist`, `image-size`, `js-yaml`, `nanoid`, `postcss`, `uuid`, `ws`, `@babel/*`, etc.) are transitive **devDependencies** pulled in by `expo-module-scripts`/`expo`/`react-native`/`@testing-library/react-native`, or come from `example/package-lock.json` (the demo app). `package.json`'s `dependencies` block is empty (`{}`) — the published npm package ships zero runtime dependencies, so none of these ever reach a consumer's bundle. Dropped per A4 (dev/build-only, never shipped).

**TruffleHog (both passes):** 0 verified secrets. Clean.

**Agentic source-to-sink pass (A3.6):**
- **Threat model:** this SDK is a thin bridge — the JS layer (`src/index.ts`, `PlaidEmbeddedSearchView.tsx`) forwards calls into native Kotlin (`ReactNativePlaidLinkSdkModule.kt`, `ReactNativePlaidLinkSdkView.kt`, `PlaidResultMappers.kt`, `PlaidEmbeddedResultDispatcher.kt`) and Swift (`ReactNativePlaidLinkSdkModule.swift`, `PlaidEmbeddedSearchView.swift`) modules, which in turn call into Plaid's own vendored, compiled SDKs (`com.plaid.link:link-sdk` via Maven, `LinkKit.xcframework` vendored binary). The realistic attacker goals against a bank-linking SDK are token/PII exfiltration via the bridge, OAuth-redirect/deep-link hijacking, and unauthorized session control. Trust boundary: the JS/native bridge is developer-controlled; the vendored Plaid frameworks are first-party/trusted and out of scope for source review (compiled, not vendored as source).
- **Reviewed (100% of non-test/non-vendor source, all files small enough that no N-budget triage was needed):** all 4 Android Kotlin files, both iOS Swift files, all 4 TS/TSX source files, the AndroidManifest, and the packaging/build scripts.
- **Findings:** no custom deep-link/URL-scheme parsing, no WebView, no crypto, no file I/O on untrusted input, no `exec`/`eval` on attacker-controlled strings, no exported Android components (manifest has zero `<activity>`/`<receiver>`/intent-filters — deep-link handling for the OAuth return lives entirely inside Plaid's own vendored SDK, not this repo). Result-mapping code (`PlaidResultMappers.kt`, the Swift `asDictionary` extensions) passes fields straight through with no logging of tokens/PII. One stray `print("[Swift] Opening Layer session")` debug statement in `ReactNativePlaidLinkSdkModule.swift:278` — noise, not a security issue.
- **CI workflow check:** grepped for `pull_request_target` and untrusted-interpolation patterns (`github.event.pull_request.title/body`, `github.event.issue.*`, `github.head_ref` in `run:` blocks) — none present. No script-injection surface.
- 0 candidates promoted past framing. `/tmp/vuln-scan/agentic.json` recorded as `[]`.

## Confirmed findings: 0

**Channels used:** none — clean audit, nothing to route.

## Dedup note

Recorded in `memory/vuln-scanned.json`: `plaid/react-native-plaid-link-sdk`, 0 findings, `channel: clean`. Not previously scanned.

## Summary

Clean audit — 24 raw scanner hits + 102 dependency rows reviewed, 0 confirmed. The repo's real attack surface is small by design (a thin native bridge with no custom parsing, crypto, or deep-link handling of its own — that logic lives in Plaid's own vendored, closed-source SDKs), and every dependency finding traced to dev-only tooling never shipped in the published package.
