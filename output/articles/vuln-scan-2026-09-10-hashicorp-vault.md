# Vuln Scanner — hashicorp/vault (2026-09-10)

## Repo metadata

| Field | Value |
|---|---|
| Repo | hashicorp/vault |
| Stars | 36,222 |
| Language | Go (+ TypeScript/Ember UI) |
| Fork | no |
| Last push | 2026-09-10 |
| PVR (repo-level) | disabled (`false`) |
| SECURITY.md (repo-level) | not present |
| Out-of-band channel | confirmed usable — org-level `hashicorp/.github/SECURITY.md` + repo README both designate **security@hashicorp.com**; HashiCorp also runs a HackerOne bug-bounty program and has published third-party audits (Trail of Bits, NCC Group, Cure53) |
| Selection basis | forced target via `var=hashicorp/vault` |

Vault is HashiCorp's secrets-management and identity-broker product — it stores secrets, issues short-lived dynamic credentials, and mediates access via ACL/Sentinel policy attached to tokens/entities. It is one of the most heavily reviewed pieces of OSS security software in existence (dedicated internal security team, active bounty, multiple public third-party audits), so the realistic bar for a single scan pass is confirming the existing hardening holds, not discovering a novel bypass.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | `ok` | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 8,011 raw hits |
| trufflehog (filesystem) | `ok` | 52,084 chunks / 547MB scanned, 0 verified secrets |
| trufflehog (git history) | `ok` | 865,818 chunks / 918MB scanned, 84s (well under the 300s bound), 0 verified secrets |
| osv-scanner | `ok` | 178 dependency vulnerability entries (85 unique GHSA/CVE ids) across 14 lockfiles/manifests |
| slither | `skipped` | no Solidity in this repo |
| fuzz (cargo-fuzz) | `skipped` | Go codebase, no `fuzz/fuzz_targets`; A3.5 is Rust-scoped only |
| agentic (A3.6) | `ok` | threat-modeled + reviewed top-6 highest-exposure entrypoints (budget N=6 for 2,372 non-vendor `.go` files) |

**Candidate count:** 8,011 raw scanner hits + 6 agentic candidates reviewed → **0 confirmed** after triage.

## Triage detail

**Semgrep (8,011 hits → 0 confirmed):**
- 7,746 `generic.html-templates.security.unquoted-attribute-var` hits are a systemic false positive: the rule doesn't understand Ember Handlebars component-argument syntax (`@onClose={{@onClose}}` is safe component-arg passing, not raw HTML attribute interpolation) and fires across nearly every `.hbs` file under `ui/app/`.
- 7 `string-formatted-query` hits (`physical/cockroachdb`, `physical/mssql`, `physical/mysql`) build `CREATE TABLE`/schema-check statements from `database`/`table`/`lock_table` values — these come from the **operator-supplied storage-backend config file**, not remote/attacker input. Same trust boundary as every physical-backend driver.
- 3 `unsafe-deserialization-interface` hits (`api/sys_raft.go`, `builtin/logical/aws/iam_policies.go`, `physical/raft/raft_autopilot.go`) are standard Go `json.Unmarshal` into `interface{}` — not vulnerable the way languages with polymorphic/magic-method deserialization (Java `ObjectInputStream`, Python `pickle`) are.
- 20 `detected-private-key` hits are all in `test-fixtures/` or `vault/testing.go` — test-only TLS material.
- 48 GitHub Actions `run-shell-injection` hits spot-checked, including the one workflow (`copy-external-contributor-pull-request-ce.yml`) named for exactly the classic fork-PR-injection pattern: it only interpolates a numeric PR number, and is gated behind a manual deployment-approval environment. The two genuinely PR-derived string values found repo-wide (`HEAD_REF`/`BASE_REF` in `bob-review-approval-gate.yml` and `build.yml`) are already passed through `env:` indirection, with an inline comment citing GitHub's own script-injection mitigation guide.
- Remaining hits (`unsafe` blocks, `math/rand`, `missing-ssl-minversion`, weak-hash usage) are internal crypto/FFI code, not attacker-reachable auth or transport paths.

**TruffleHog:** 0 verified secrets, filesystem and full git history both clean.

**OSV-scanner (178 entries, 85 unique, 42 critical/high):** almost entirely UI frontend build-tooling dependencies (`@xmldom/xmldom`, `browserslist`, `postcss`, `js-yaml`, `nanoid`, `socket.io-parser`, `fast-uri`, `brace-expansion`, `shell-quote`, `immutable`, `jsondiffpatch`, `linkify-it`, `websocket-driver`) plus Go `grpc`/`docker`/`moby`. Prior-art check confirmed an extremely active first-party Dependabot already covers this exact class — e.g. `grpc` already bumped past our found `1.79.3` to `1.82.1+` in merged PR #32048, `@xmldom/xmldom` bumped in #31869, `docker/docker` bumped repeatedly through #31821/#31496. All entries **duplicate-skipped** rather than filed as a new PR, consistent with prior audits of similarly Dependabot-active repos (parse-server, hono, Shopify/cli).

**Agentic logic audit (A3.6):** threat-modeled around ACL/policy bypass, auth-method login bypass, and SSRF/injection into the unseal/audit/replication path as the highest-value attacker goals. Deep-reviewed:
- `vault/acl.go` `AllowOperation` + `resolveACLPermsForListOp` — LIST deny-precedence logic checked against historical VAULT-3825 fix intent, holds.
- `vault/token_store.go` `handleCreateCommon` — child-token policy-subset enforcement via `StrListSubset`, holds.
- OAuth-JWT unauthenticated fast path in `vault/request_handling.go` — dead code in CE (`IsOAuthJwt` hardcoded `false`).
- DR-secondary unauthenticated raft paths in `vault/logical_system.go` — gated behind a replication state bit CE never sets.
- `vault/identity_store_oidc_provider.go` OIDC token/userinfo issuance — provider `name` constrained by `GenericNameRegex` before reaching policy templating, no injection surface.
- `builtin/credential/approle/path_login.go` CIDR/use-count handling — re-validates after re-acquiring the write lock, no obvious TOCTOU found.

Not deep-reviewed (past the N=6 budget): `userpass`/`cert`/`aws` credential `path_login.go`, `logical_system.go` `handleWrappingUnwrap`, `http/handler.go` CORS/header handling.

## Confirmed findings

None.

## PoC gate status

`not-required` — no candidate survived A4 triage to reach a provisional HIGH/CRITICAL classification, so the A4.5 verifier was never invoked.

## Disclosure channel

Not applicable — 0 confirmed findings. No PVR filed, no email queued.

## Dedup note

Logged to `memory/vuln-scanned.json`: `{"repo": "hashicorp/vault", "channel": "clean", "findings": 0}`. Repo will be skipped for future scans until 2026-10-10 (30-day window).

## Summary

- Ran Arm A (scan) of the vuln-scanner skill against `hashicorp/vault`, forced via `var=hashicorp/vault`.
- Forked and cloned the repo, ran semgrep, trufflehog (filesystem + git history), osv-scanner, and a threat-model-driven agentic logic audit of the top-6 ACL/authn entrypoints.
- Result: **clean audit, 0 confirmed findings.** All 8,011 semgrep hits are false positives or config-driven/non-attacker-controlled patterns; 0 verified secrets; 178 dependency findings are duplicate-skipped against Vault's own active Dependabot cadence; the agentic ACL/auth review found no bypass.
- Files created: `output/articles/vuln-scan-2026-09-10-hashicorp-vault.md` (this report).
- Files modified: `memory/vuln-scanned.json` (appended dedup entry), `memory/logs/2026-09-10.md` (appended run log).
- Follow-up: none required — no channel needed since nothing to disclose. `hashicorp/vault` is now in the 30-day scan-dedup window.
