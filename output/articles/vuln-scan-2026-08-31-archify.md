# Vuln scan — tt-a1i/archify (2026-08-31)

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [tt-a1i/archify](https://github.com/tt-a1i/archify) |
| Stars | ~36.6k |
| Language | JavaScript (Node ≥18, ESM `.mjs`) |
| License | MIT |
| Audited commit | `5de7275fe87a66a19d52a4d9b0b3a4f2a5a90115` (main) |
| Description | Agent skill: JSON-IR → self-contained HTML architecture / workflow / sequence / dataflow / lifecycle diagrams |
| Disclosure channel | PVR **enabled** + `SECURITY.md` (private reporting) |
| Selection | Auto-selected from `output/.chains/github-trending.md` (2026-08-30). Skipped `K-Dense-AI/scientific-agent-skills` and `corsairdev/corsair` (scanned within 30 days). |

## Threat model (agentic framing)

Archify is a local CLI / agent skill that ingests authored JSON diagrams and emits shareable HTML. Highest-value attacker goals against this surface: (1) XSS in generated HTML when a malicious diagram is rendered and opened, (2) SSRF via `archify brands capture <url>` / pinned remote brand fetches, (3) path traversal or symlink aliasing on `meta.output` / delivery paths, (4) command injection through artifact openers or `git -C` evidence checks. Trust boundary: untrusted JSON IR and brand URLs; operator-local filesystem and loopback preview server.

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`; 28 WARNING hits |
| trufflehog | ok | filesystem + git history; **0** verified secrets (~190MB / 14.7k chunks) |
| osv-scanner | ok | scanned `archify/package-lock.json` (10 packages); **0** advisories |
| fuzz | skip | no `fuzz/fuzz_targets` |
| agentic | ok | budget N=15 (small repo, ~56 production `.mjs` files under `archify/`); deep-reviewed top exposure entrypoints |

## Candidates reviewed

| Source | Count | Disposition |
|--------|-------|-------------|
| Semgrep | 28 | All GitHub Actions mutable-tag warnings (`actions/checkout@v4`-style). Hardening / supply-chain hygiene only — not filed (no public-PR spam for tag pinning; not a code vuln for PVR). |
| TruffleHog | 0 | — |
| OSV | 0 | Clean lockfile (ajv, parse5, saxes, simple-icons, …) |
| Agentic | 0 confirmed | Surfaces below reviewed; defenses held under smoke tests |

### Agentic surfaces reviewed (top exposure)

1. **HTML/SVG escaping pipeline** (`escapeHtml` / `applyTemplate` / `serializeScriptJson` / `focusNodeAttrs`) — labels, titles, cards, boundaries, aria, brand `data:` image hrefs. Smoke-rendered malicious payloads (`<script>`, `</g><script>`, attribute breakouts); all appeared entity-escaped; no live HTML injection.
2. **`brands capture` / remote brand fetch** — DNS-pinned requests, private IPv4/IPv6 blocklists, redirect re-validation, size caps, content-type allowlist (no SVG). Localhost / `::1` captures fail closed.
3. **Preview HTTP server** — bind `127.0.0.1` only, Host header gate, fixed routes (`/`, `/state`, `/artifact.html`, `/events`), CSP on shell page, no arbitrary file serve.
4. **`open-artifact` / `openLoopbackUrl`** — `shell: false`; PowerShell uses `$args[0]`; loopback URL shape enforced.
5. **`output-path` / delivery staging** — rejects absolute `meta.output`, cwd escape, symlink cycles, input/output aliases (covered by extensive unit tests).
6. **Repository evidence** — repo-relative path validation (no `..` / `.git`), origin slug match, full SHA pin, `git -C` argv array.
7. **Update checker** — hardcoded default manifest URL only; bounded JSON; cache token / symlink non-follow checks.
8. **CLI `spawnSync(process.execPath, …)`** — argv array, no shell interpolation of diagram fields.
9. **Viewer runtime in `assets/template.html`** — no `innerHTML` / `eval` / `document.write`; guided-views / i18n / evidence consumed via `textContent` + `JSON.parse`.
10. **Schema ID pattern** — `^[a-zA-Z][a-zA-Z0-9_-]*$` limits attribute-id injection even before escaping.

Entrypoints past the deep-review budget (docs site i18n `innerHTML`, gallery builders, experiments/, deepseek harness Windows CLI shims) noted as lower exposure / not attacker-controlled IR paths for this pass.

## Confirmed findings

**0** — clean audit.

## Channels used

None (nothing to disclose). PVR was available had a code finding survived triage.

## Dedup

Appended `memory/vuln-scanned.json` with `channel: "clean"` — skip re-scan for 30 days.

## Summary

`tt-a1i/archify` is a security-conscious diagram renderer: escaping, SSRF controls, path/symlink gates, and preview isolation are deliberate and tested. Static scanners found only GHA mutable-tag noise and zero dependency CVEs; agentic review confirmed the high-risk paths behave safely under adversarial labels and private URL capture attempts.
