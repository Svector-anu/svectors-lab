# Vuln Scanner — stripe/stripe-node (2026-09-05)

## Target
- **Repo:** stripe/stripe-node
- **Selection:** forced target via `var=stripe/stripe-node` (bare `owner/repo` → Arm A scan)
- **Stars:** 4,503 · **Language:** TypeScript — Stripe's official Node.js API client SDK
- **Active:** pushed 2026-09-05 (audited same day)
- **PVR status:** disabled (confirmed via `GET /repos/stripe/stripe-node/private-vulnerability-reporting` → `{"enabled": false}`)
- **SECURITY.md:** none at repo level; org-fallback `stripe/.github/SECURITY.md` points reporters to Stripe's own Vulnerability Disclosure and Reward Program (bug-bounty, human-submission channel) — same pattern already established on the 2026-09-04 `stripe/stripe-cli` scan. Out of scope for this skill's automated PVR/email disclosure; a HIGH/CRITICAL finding here would route to a human operator for manual bug-bounty submission, not PVR or email.
- **Audited commit:** `b64815c32436fa24bba60c1ea898b30d57391504`

## Scanner sources
| Tool | Status | Notes |
|---|---|---|
| semgrep (security-audit + owasp-top-ten + secrets) | ok | 3 results |
| trufflehog (filesystem) | ok | 0 verified secrets |
| trufflehog (full git history, bounded) | ok | 0 verified secrets, no timeout |
| osv-scanner (recursive, --no-ignore) | ok | 33 unique vulnerable-package rows across 2 lockfiles |
| slither | n/a | no `.sol` files |
| fuzz (cargo-fuzz) | skip | no `fuzz/fuzz_targets`, not a Rust repo |
| agentic logic audit | ok | N=10 budget (~330 code files → mid-size bucket) |

## Candidates and triage

**semgrep — 3/3 dropped.**
- 2× `yaml.github-actions.security.github-actions-mutable-action-tag` (WARNING) — `.github/workflows/main.yml:102` (`denoland/setup-deno`, already pinned to a commit SHA with a `# v2.0.5` comment — a benign hit) and `:148`-adjacent `uses: stripe/openapi/actions/stripe-mock@master` (genuinely a mutable tag). Hardening-class, ubiquitous across OSS, operator-discretion — not filed, matching every prior run's precedent (hono, paypal-js, harden-runner, elysia).
- 1× `yaml.github-actions.security.run-shell-injection` — `.github/workflows/rules.yml:21-27`. Read the full 32-line file: the two `${{ }}` expressions interpolated into the `run:` block are `contains(github.head_ref, '/merge-')` (a GitHub Actions function call that only ever evaluates to the literal string `"true"`/`"false"`, not raw attacker text) and `github.event.pull_request.auto_merge.merge_method` (a GitHub-controlled enum: `merge`/`squash`/`rebase`, not free text). Neither carries attacker-controlled free-form content into the shell. The workflow also declares `permissions: {}` at the root with no job-level override, so even a successful injection would carry a token with zero scopes. Semgrep's rule fires on any `${{ }}` inside a `run:` block without distinguishing constrained enum/boolean returns from free text — false positive. Dropped (can't write the attacker-controls/achieves sentence required by A4 step 2).

**trufflehog — clean.** 0 verified secrets on both the filesystem scan (5,150 chunks / 63.5MB) and the bounded full-git-history scan (well under the 300s cap, no timeout).

**osv-scanner — 33 unique vulnerable packages, 0 confirmed.** Two lockfiles flagged:
- `yarn.lock` (root) — 12 unique packages (ajv, brace-expansion, browserslist, diff, flatted, js-yaml, minimatch, nanoid, serialize-javascript, uuid) — all build/lint/test tooling (mocha, eslint, typescript-toolchain transitive deps).
- `examples/snippets/package-lock.json` — 23 unique packages (the above plus @babel/core, @babel/helpers, body-parser, cookie, lodash, path-to-regexp, picomatch, qs) — this is an **isolated example project** under `examples/`, not the published package.

Checked the published package's own `package.json`: **`"dependencies": {}`** — the `stripe` npm package ships **zero runtime dependencies** (only a `peerDependencies` entry for `@types/node`). Every one of the 33 flagged rows is therefore either dev-tooling or an unrelated example project's lockfile — none reach a consumer's production install. Same non-issue pattern already confirmed on `honojs/hono` (2026-09-04) and `paypal/paypal-js` (2026-09-05). No dependency-bump PR filed (nothing in the shipped package to bump).

**Agentic logic audit (N=10 budget, ~330 code files → mid-size bucket).**

*Threat model:* `stripe-node` is a server-side API client SDK, not a server — it has no HTTP listener of its own. The two realistic attacker-relevant surfaces are (1) **webhook signature verification** (`Webhooks.ts`) — a bypass here lets an attacker forge Stripe events to *any* merchant integration using this library, the single highest-value target in the codebase — and (2) HTTP request construction / auth-header handling and multipart/form-data encoding (header/boundary injection from user-supplied file names).

*Entrypoints deep-reviewed:*
- `src/Webhooks.ts` — full read of `constructEvent`/`constructEventAsync`/`verifyHeader`/`verifyHeaderAsync`/`parseHeader`/`validateComputedSignature`. The public entrypoint (`constructEvent`) defaults `tolerance` to `Webhook.DEFAULT_TOLERANCE` (300s) when unset — timestamp replay protection is on by default for the actual merchant-facing call. (A lower-level internal `signature.verifyHeader` defaults `tolerance` to `0`/skip-check when called directly and bypassing `constructEvent`, but that's flagged in the source's own `TODO(MAJOR)` comment as intentional test/offline-processing behavior, not the standard verification path.) Signature comparison is delegated to `platformFunctions.secureCompare`.
- `src/platform/{PlatformFunctions,NodePlatformFunctions}.ts` — `secureCompare`: Node implementation uses `crypto.timingSafeEqual` (the length-mismatch early-return is the same accepted pattern Node's own primitive requires); base fallback implementation accumulates XOR over the full string with no early exit. Constant-time, correctly implemented.
- `src/crypto/NodeCryptoProvider.ts` — `computeHMACSignature`/`computeHMACSignatureAsync` use `crypto.createHmac('sha256', secret)` correctly; no algorithm confusion, no truncation.
- `src/utils.ts` — `parsePayload`/`maybeExtractFromCloudProviderEnvelope` use native `JSON.parse` (does not pollute `Object.prototype` via `__proto__` as an own key, standard JS semantics); `createApiKeyAuthenticator` builds the `Bearer` header from the developer-supplied API key with no injection surface. `uuid4()` deliberately throws rather than degrading to `Math.random()` if `crypto.randomUUID` is unavailable — used both for `Idempotency-Key` and multipart boundaries.
- `src/multipart.ts` — `multipartDataGenerator`/`quote`/`stripCrLf`: explicit CR/LF stripping and `"`→`%22` escaping on every caller-supplied value (name, filename, content-type) before it's written into a `Content-Disposition`/`Content-Type` part header — the classic multipart header-injection vector (extra-part smuggling via unescaped filename) is already closed. Boundary itself comes from `uuid4()` (cryptographically secure), matching the source's own comment citing an internal hardening ticket (`RUN_DEVSDK-2807`).
- Repo-wide grep for `eval(|child_process|exec(|spawn(|new Function(` across `src/` → single match, a `RegExp.exec()` call in `Decimal.ts` (unrelated, not a code-exec sink).

No candidates survived to A4 triage. Remaining surface (the ~280 generated `src/resources/*.ts` API-resource files, `RequestSender.ts` retry/idempotency plumbing, `net/{NodeHttpClient,FetchHttpClient}.ts`) was grep-swept (no `Authorization`/redirect-handling logic found outside the single `Bearer` construction site already reviewed) but not individually deep-read within the N=10 budget — noted as reviewed-but-not-deep, not silently dropped. Per this repo's own `.claude/CLAUDE.md`, most of `src/resources/` is generated directly from Stripe's OpenAPI spec and not hand-written attack surface.

## Result
**0 confirmed findings.** Clean audit — 3 semgrep candidates (2 CI-hardening, 1 false-positive shell-injection flag) + 33 osv dependency rows (100% dev-tooling/example-only, zero production exposure — published package ships no runtime dependencies at all) + a full read of the webhook-signature-verification/HMAC/multipart code paths, all correctly implemented. No PVR filed (PVR disabled on this repo and the only channel is Stripe's own bug-bounty program, out of scope for automated disclosure), no PR filed, no disclosure staged — nothing crossed the bar for an actionable finding.

## PoC gate status
Not required — no provisional HIGH/CRITICAL code finding was raised.

## Dedup note
Logged to `memory/vuln-scanned.json` as `channel: "clean"`, `scanned_at: 2026-09-05` — repo will be skipped on re-selection for 30 days.

## Summary
- Forked and cloned `stripe/stripe-node` (depth 200), ran semgrep, trufflehog (filesystem + bounded git-history), and osv-scanner against the clone, plus a manual agentic source-to-sink review centered on webhook-signature verification (the SDK's single highest-value attack surface) and multipart/header-injection handling.
- 3 semgrep hits (2 CI mutable-tag hardening, 1 false-positive shell-injection flag on a workflow with `permissions: {}` and enum/boolean-only interpolation), 0 verified secrets, 33 osv dependency-CVE rows (100% dev-tooling or an isolated example project, zero production exposure — the published `stripe` package has zero runtime dependencies).
- Manual review of `Webhooks.ts`, the crypto providers, `secureCompare`, and `multipart.ts` found constant-time signature comparison, correct HMAC-SHA256 computation, default timestamp-tolerance enforcement on the real merchant-facing verification entrypoint, and existing CRLF/quote escaping against multipart header injection.
- **Verdict: clean audit, 0 confirmed findings.** No PVR, no PR, no disclosure — this is a mature, heavily-scrutinized official payment SDK and its most security-critical code path (webhook auth) holds up.
- Files created/modified: `output/articles/vuln-scan-2026-09-05-stripe-node.md` (this report; a separate `paypal/paypal-js` report already occupied `vuln-scan-2026-09-05.md` from an earlier run today), `memory/vuln-scanned.json` (dedup entry appended), `memory/logs/2026-09-05.md` (run log, appended below).
- Follow-up: none required. Local clone left at `stripe-node/` and scratch scanner output at `vuln-scan-stripe-node/` in the workspace (consistent with prior runs' leftover clone directories in this checkout).
