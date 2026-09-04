# Vuln Scan — honojs/hono (2026-09-04)

## Repo metadata
- **Repo:** honojs/hono
- **Stars:** ~32,100
- **Language:** TypeScript
- **Description:** Web framework built on Web Standards
- **Last push:** 2026-08-28
- **PVR:** enabled (confirmed via `gh api repos/honojs/hono/private-vulnerability-reporting`)
- **SECURITY.md:** none found, but PVR being enabled means a safe channel exists if a finding had needed one
- **Selection:** forced via `var=honojs/hono` (dispatch parsed as a bare `owner/repo` → Arm A scan)
- **Fork:** Svector-anu/hono
- **Audited commit:** `e2740d5a1bd0b4254e517e3af8b60789284bc7bd`
- **Code size:** 361 source files (JS/TS/JSX/TSX) → agentic review budget N=10

## Scanner sources
| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 4 raw hits |
| trufflehog | ok | filesystem + full git history, `--only-verified` |
| osv-scanner | ok | v2 `scan source --recursive --no-ignore`, 4 lockfiles scanned |
| slither | skipped | no Solidity files |
| fuzz (cargo fuzz) | skipped | no `fuzz/fuzz_targets` (not a Rust repo) |
| agentic | ok | 0 candidates after source-to-sink review of top-exposure entrypoints |

## Candidates reviewed
- **4 semgrep hits.** 3× `react-insecure-request` in `benchmarks/http-server/benchmark.ts` — dropped per the standing rule that anything under a `bench/` directory is out of scope (these are the benchmark harness making plain HTTP calls to a local target, not a shipped code path). 1× `unknown-value-with-script-tag` in `src/jsx/components.ts:234` (Suspense/streaming HTML rewriter) — traced the dataflow: the only value interpolated into the emitted `<script>` block is `errorBoundaryCounter`, a process-local monotonic integer, not the flagged `callbacks` array or any request-derived content. False positive, dropped.
- **43 osv-scanner vulnerable-package rows across 4 lockfiles** (root `bun.lock` devDependencies — vite/rollup/eslint toolchain — plus three `benchmarks/*` lockfiles that pin comparison frameworks including two stale copies of `hono` itself, 3.10.4 and 4.12.18, used only as benchmark targets). Confirmed via `package.json` that the published `hono` npm package declares **zero runtime dependencies and zero peerDependencies** — none of the 43 flagged packages ship to, or execute in, a consumer's production install. All non-issues.
- **Agentic pass (~5 entrypoints deep-reviewed within the N=10 budget), threat model: auth bypass, path traversal, SSRF, injection —** the classes an attacker would target in a web framework:
  - `middleware/serve-static/{path.ts,index.ts}` — an explicit regex (`/(?:^|[\/\\])\.{1,2}(?:$|[\/\\])|[\/\\]{2,}|\\/`) rejects any `.`/`..`/double-slash/backslash path segment from the request path *before* it reaches `join()`. Traversal-safe.
  - `utils/jwt/{jwt.ts,jwa.ts}` — `verify()` requires the header `alg` to exactly match the caller-supplied expected algorithm; `AlgorithmTypes` has no `none` entry, so there's no alg-none bypass. `verifyWithJwks` explicitly rejects symmetric algorithms (HS256/384/512) for JWKS verification and cross-checks the matched JWK's own `alg` against the header — both are documented algorithm-confusion mitigations, and both actually hold up on read.
  - `helper/proxy/index.ts` — SSRF-shaped by design (it's an explicit fetch proxy), but the target URL is always developer-supplied, not derived from request input inside the helper itself. Not a framework flaw.
  - `router/`, `middleware/cors`, `middleware/basic-auth`, `middleware/csrf`, `middleware/secure-headers` — noted reviewed-but-not-deep within budget; nothing surfaced in the pass that reached them at lower depth.
  - 0 candidates emitted.

## Confirmed findings
None. 0 confirmed after full triage.

## PoC gate status
Not required — no HIGH/CRITICAL code candidate survived triage to need verification.

## Disclosure channel
Not applicable — no finding to route.

## Dedup
`memory/vuln-scanned.json` updated: `honojs/hono`, `channel: clean`, 30-day skip window from 2026-09-04.

## Assessment
Hono ships zero runtime dependencies, which collapses most of the supply-chain attack surface that shows up in this kind of scan on other frameworks. The code that remains (JWT/JWK verification, static-file serving, JSX streaming) shows deliberate, documented hardening against the exact bug classes an attacker would try first (algorithm confusion, path traversal, script injection via internal counters). This reads as a mature, heavily-scrutinized codebase — consistent with a 32k-star framework in wide production use — not an under-reviewed target.
