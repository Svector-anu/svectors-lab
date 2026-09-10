# Vuln Scanner Report — auth0/nextjs-auth0

**Date:** 2026-09-10
**Mode:** scan (Arm A), target forced via `var=auth0/nextjs-auth0`

## Repo metadata

- **Repo:** [auth0/nextjs-auth0](https://github.com/auth0/nextjs-auth0)
- **Stars:** 2,305
- **Language:** TypeScript
- **Description:** Official Okta/Auth0 authentication SDK for Next.js (OAuth/OIDC, session cookies, DPoP, passkeys, passwordless, MFA, connected accounts, `/me` and `/my-org` proxy handlers)
- **Fork audited:** `Svector-anu/nextjs-auth0`, HEAD at scan time
- **PVR:** disabled (`private-vulnerability-reporting.enabled == false`)
- **SECURITY.md:** present, but it's a security-considerations doc (cookie/caching/error-handling guidance for SDK consumers), not a vuln-reporting contact — moot here since 0 HIGH/CRITICAL findings surfaced and no disclosure routing was needed.

## Scanner sources

| Scanner | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 14 raw hits, 0 confirmed |
| trufflehog (filesystem) | **fail** | GitHub only ships `tar.gz`/`zip` release assets for trufflehog, no raw `linux_amd64` binary at the "latest" asset name this skill stages — and `tar` is not on the in-run capability allowlist. Could not stage; never ran. |
| trufflehog (git history) | **fail** | Same staging failure — never ran (not a timeout, genuinely unavailable this run). |
| osv-scanner | ok | 12 lockfiles, 337 raw vuln-package rows, 0 confirmed after triage |
| fuzz (cargo-fuzz) | skip | TypeScript project, no `fuzz/fuzz_targets` |
| agentic (source-to-sink) | ok | N=15 budget (small repo, ~71 non-test `src/` files) |

## Candidate count

- Semgrep: 14 raw hits → 0 confirmed
- OSV: 337 raw vuln-package rows → 0 confirmed
- Agentic: 0 candidates emitted (see below)
- **Total confirmed: 0**

## Triage detail

### Semgrep (0/14 confirmed)
- **8× `github-actions-mutable-action-tag`** (`.github/actions/{npm-publish,prepare,rl-scanner,get-release-notes}/action.yml`) — CI steps reference `actions/checkout@v4`, `pnpm/action-setup@v4`, `actions/setup-node@v4` by mutable major-version tag instead of pinned SHA. Standard, near-universal practice across OSS; a supply-chain hardening suggestion, not an exploitable flaw. Dropped per A4 ("you'd be embarrassed to defend it to the maintainer").
- **2× `detected-private-key`** (`README.md:275`, `EXAMPLES.md:2585`) — DPoP quick-start snippets showing `AUTH0_DPOP_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQ...\n-----END PRIVATE KEY-----"`. Truncated placeholder documentation, not a real credential (the ellipsis and structurally-invalid base64 confirm it). False positive.
- **4× `plaintext-http-link`** (`docs/index.html`) — auto-generated TypeDoc output linking `http://` URLs in doc comments. Informational, not attacker-reachable.

### OSV-scanner (0/337 confirmed)
- **2 ancient advisories** (open-redirect ≤1.6.1 / GHSA-2mqv-4j3r-vjvp, reflected-XSS ≤1.4.1 / GHSA-954c-jjx6-cxv7, both patched in 2018–2019) false-positive-matched against the unversioned workspace-local `@auth0/nextjs-auth0@file:../..` self-reference — osv-scanner has no real version to compare, so it matches everything below the last-patched version. Confirmed via the GitHub Advisory API that both ranges are `< 1.4.2` / `< 1.6.2`; current package.json is `4.29.0`.
- **1 real-but-already-fixed advisory in scope** — `GHSA-xq8m-7c5p-c2r6` (Improper Proxy Cache Lookup, DPoP + `/me`/`/my-org` proxy handler, affects 4.12.0–4.17.0, fixed in 4.18.0), found only in the *committed* `pnpm-lock.yaml` of `examples/with-dpop`, `examples/with-mrrt`, `examples/with-shadcn`. Those examples' `package.json` already declares `^4.17.1` (would resolve to current `4.29.0` on a fresh install) — the lockfiles are just stale. `examples/` is an explicit A4 drop category (demo code, not shipped to SDK consumers).
- **Remaining ~330 rows** are devDependencies (`vitest`, `eslint` tooling, `brace-expansion`, `postcss`, `js-yaml`, `nanoid`, `glob`, `minimatch`, `ws`, etc.) in the root `pnpm-lock.yaml` and example lockfiles — never shipped in the published npm package. Root `package.json`'s actual runtime `dependencies` block is only `@edge-runtime/cookies`, `@panva/hkdf`, `jose`, `oauth4webapi`, `openid-client`, `swr` — none flagged.

### Agentic source-to-sink audit (0 candidates)

**Threat model:** OAuth/OIDC auth SDK for Next.js. Top attacker goals: session forgery/tampering, open-redirect-driven phishing via `returnTo`, SSRF via the `/me` and `/my-org` proxy handlers, XSS via the popup-mode `postMessage` callback HTML. Trust boundary: unauthenticated requests hit `/auth/login`, `/auth/callback`, `/auth/logout`; authenticated requests carry an encrypted session cookie validated on every request by the middleware.

**Deep-reviewed** (top of the N=15 budget):
- `src/server/cookies.ts` — session cookie encryption is AES-256-GCM (`jose` `EncryptJWT`, `alg: dir`) with an HKDF-derived key; chunking/reassembly logic for cookies >3.5KB is bounds-checked. Sound.
- `src/utils/url-helpers.ts` `toSafeRedirect` — resolves the candidate against a fixed base URL and checks `origin` equality, which correctly rejects the classic `//evil.com` protocol-relative open-redirect bypass. Traced every call site in `auth-client.ts`: `handleLogin` (query-param `returnTo`) → `startInteractiveLogin` (validates via `toSafeRedirect`), `handleConnectAccount` (query-param `returnTo`) → `connectAccount` (validates via `toSafeRedirect`). All app-internal post-auth redirects are validated before use.
- `handleLogout`'s `returnTo` is forwarded *unvalidated* to Auth0's own `/v2/logout` or the OIDC `end_session_endpoint` as `returnTo`/`post_logout_redirect_uri` — but that's standard OIDC RP-Initiated Logout delegation: the authorization server enforces its own configured Allowed Logout URLs allowlist server-side. Not a flaw in this SDK.
- `src/utils/proxy.ts` `transformTargetUrl` / `buildForwardedRequestHeaders` — the proxy target origin is always built from the SDK's configured `issuer` (never attacker-influenced), and the header allow-list excludes `Authorization` (the real token is attached separately by the fetcher, not forwarded from the incoming request). No SSRF or header-injection path found.
- `src/utils/html-helpers.ts` `createAuthCompletePostMessageResponse` — the popup-mode callback HTML embeds `postMessage` payload data via `JSON.stringify()` with a global `<` → `<` replace (defeats `</script>` breakout), uses `escapeHtml()` on the static status text, and validates any developer-supplied CSP nonce's charset before interpolating it into the `nonce="..."` attribute. This is the well-hardened pattern for the exact bug class the historical `GHSA-954c-jjx6-cxv7` reflected-XSS advisory covered.
- `handleCallback` state/CSRF binding delegates to `oauth4webapi`'s `validateAuthResponse`, which does the state comparison against the value stored in the encrypted transaction cookie.

**Reviewed but not deep** (past the N=15 depth budget — noted, not silently dropped): DPoP nonce/replay handling (`dpopUtils.ts`, `dpopRetry.ts`), passkey/passwordless/MFA flow handlers, `fetcher.ts` retry/backoff logic, stateful/stateless session-store internals beyond the cookie-encryption layer, client-side hooks (`use-user.ts`).

A sanity grep for `dangerouslySetInnerHTML`, `eval(`, `new Function(`, `child_process`/`exec(` across `src/` returned no matches outside test files and an unrelated `RegExp.exec()` call.

0 candidates were promoted past step 0/1 framing, so **the A4.5 PoC-verification gate was not invoked this run** — nothing reached the provisional HIGH/CRITICAL bar.

## PoC gate status

**Not required** — no provisional HIGH/CRITICAL code finding survived triage.

## Dedup note

Logged to `memory/vuln-scanned.json`: `{"repo": "auth0/nextjs-auth0", "channel": "clean", "findings": 0}`. Skip re-scanning for 30 days per the standard dedup policy.

## Conclusion

Clean audit. 351 raw candidates across two scanners (14 semgrep + 337 osv-scanner) plus a manual source-to-sink pass over the SDK's core session/redirect/proxy/callback surface — 0 confirmed. This SDK shows evidence of deliberate prior security hardening (explicit code comments referencing the old open-redirect and reflected-XSS advisories, the `<` `</script>`-breakout defense, `toSafeRedirect`'s origin-equality check, CSP-nonce charset validation), consistent with an actively-maintained, security-conscious vendor SDK (Okta/Auth0). One infra gap: `trufflehog` could not be staged this run (GitHub only publishes `tar.gz`/`zip` release assets for it, and `tar` isn't on this skill's in-run capability allowlist) — recorded as `fail`, not folded into a false "clean" secrets-scan claim.
