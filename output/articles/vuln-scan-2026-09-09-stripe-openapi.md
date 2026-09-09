# Vuln Scan — stripe/openapi

- **Repo:** stripe/openapi (forced target)
- **Description:** An OpenAPI specification for the Stripe API
- **Stars:** 501 · **Language:** none detected (JSON/YAML spec data) · **Default branch:** master
- **Audited commit:** `58e06a3214ae1574600fba64d40b770e5da6d505` (2026-09-05)
- **PVR status:** disabled (`private_vulnerability_reporting.enabled = false`)
- **SECURITY.md:** none in this repo; org-level `stripe/.github/SECURITY.md` applies and points to Stripe's own [Vulnerability Disclosure and Reward Program](https://stripe.com/docs/security/stripe#disclosure-and-reward-program) (a formal bug-bounty channel, not GitHub PVR/email) — same precedent as the 2026-09-04 stripe/stripe-cli scan.

## Repo shape

This repo is almost entirely non-executable content: four large OpenAPI spec files (JSON/YAML, ~tens of MB) plus doc README's under `openapi/`, `latest/`, `preview/`. The only "code" surface is CI/CD config — 4 GitHub Actions workflows (`.github/workflows/`) and 5 small composite actions (`actions/*/action.yml`), used both by this repo and (per comments) invoked from Stripe's SDK repos. No package.json/Gemfile/go.mod/Cargo.toml — no application dependency surface at all.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 2 results, 0 errors that blocked the run |
| trufflehog | fail | binary execution blocked by this session's permission layer (freshly-downloaded binary requires interactive approval not available here); repo has no secret-shaped semgrep hits either |
| trufflehog-git | fail | same as above, not attempted |
| osv-scanner | fail | binary staged but execution blocked the same way; moot regardless — repo has zero dependency manifests/lockfiles to scan |
| agentic | ok | manually reviewed all 4 workflow files + all 5 composite actions (the entire code surface) against a GitHub-Actions threat model (script injection, `pull_request_target` misuse, secret exfiltration, unpinned supply-chain refs, GraphQL/API injection) |
| fuzz | skip | no `fuzz/fuzz_targets`, not Rust |

## Threat model (A3.6 step 0)

An attacker's most valuable targets in a CI/CD-only repo like this are: (1) getting a `run:` step to execute attacker-controlled shell via unsanitized `${{ }}` expression interpolation, (2) tricking a `pull_request_target`-triggered workflow into checking out and running untrusted PR code with write-scoped secrets, (3) exfiltrating one of the two GitHub App private keys / Slack bot token used across these workflows. Trust boundary: all workflow triggers here are `workflow_dispatch`, `push` to `master`/tags, or `release: created` — none are externally triggerable by an unauthenticated forker, and the one `pull_request` trigger (zizmor.yml) is read-only with `permissions: {}`.

## Candidates (2, both discarded on triage)

1. **`actions/stripe-mock/action.yml:27`** — semgrep `run-shell-injection` (provisional medium). The rule flags `${{ }}` expressions appearing inside a `run:` block. On read: all attacker-shaped inputs (`beta`, `openapi_version`, `spec_path`, `fixtures`) are correctly routed through the step's `env:` block and referenced as `"${INPUTS_*}"` — safe shell-side expansion, not template interpolation. The two expressions still evaluated inline (`contains(inputs.base, 'b')`, `runner.os`) resolve to fixed boolean/enum strings before the shell ever sees them, so there's no attacker-controlled string reaching the shell. **False positive** — discarded, no attacker-controls/achieves sentence could be written.
2. **`actions/notify-release/action.yml:13`** — semgrep `github-actions-mutable-action-tag` (informational). The rule doesn't recognize the `$/actions/notify-slack` local-repo-relative ref syntax (resolves to the exact running commit, i.e. already pinned) and misreads it as a floating third-party tag. **False positive** — discarded.

No further candidates surfaced from the manual agentic pass — every `${{ }}` expression that reaches a `run:` shell block across all 9 files is either routed via `env:`, a typed GraphQL variable (`enable-auto-merge/action.yml`), or a fixed/non-attacker-controlled value (`runner.os`, `job.status`, `github.sha`). Third-party action refs are consistently SHA-pinned with a version comment. GitHub App tokens are scoped per-comment to the single downstream repo and single permission they need. The repo's own `zizmor.yml` workflow already gates every push/PR on `min-severity: high` for exactly this class of finding.

## Verdict

**Clean audit — 2 candidates reviewed, 0 confirmed.** No PoC-verification gate was needed (no HIGH/CRITICAL candidate survived triage). No dependency-CVE surface exists to route to a PR. No disclosure channel was engaged.

## Dedup

`memory/vuln-scanned.json`: `{"repo": "stripe/openapi", "scanned_at": "2026-09-09T00:00:00Z", "findings": 0, "channel": "skipped"}` — skips this repo for 30 days.

## Follow-up needed

`trufflehog`/`osv-scanner` execution was blocked by this interactive session's permission layer (arbitrary freshly-downloaded binaries require approval this run couldn't obtain) rather than by the target repo. osv-scanner's absence costs nothing here (no lockfiles exist to scan). trufflehog's absence is lower-confidence — a future run with binary-execution approval available should re-run `trufflehog filesystem` + bounded `trufflehog git` history over this clone to close that gap, though semgrep's `p/secrets` pass already came back clean.
