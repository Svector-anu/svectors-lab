# Vuln Scan — snowflakedb/snowflake-cli (2026-09-10)

Forced target via `var=snowflakedb/snowflake-cli`.

## Repo metadata

- **Repo:** snowflakedb/snowflake-cli
- **Stars:** 266
- **Language:** Python
- **Description:** Snowflake CLI — open-source command-line tool for developer-centric workloads and SQL operations
- **HEAD commit:** a557c17c ("Don't let telemetry open a connection (SNOW-4065113) (#266)")
- **PVR:** enabled (GitHub private vulnerability reporting on)
- **SECURITY.md:** present — points to a HackerOne bug-bounty program (hackerone.com/snowflake) as the primary channel, with security@snowflake.com for other questions. Per the stripe-cli (2026-09-04) and braintree_ios (2026-09-10) precedent, any future confirmed HIGH/CRITICAL **code** finding here should route to a human for the bounty program, not auto-PVR/email — moot this run since no code finding cleared triage.

## Scanner sources

| Tool | Status |
|---|---|
| semgrep (security-audit + owasp-top-ten + secrets) | ok — 78 results |
| trufflehog (filesystem, `--only-verified`) | ok — 0 verified secrets |
| trufflehog (git history, bounded 300s) | ok — 0 verified secrets, completed in ~33s, no timeout |
| osv-scanner (`scan source --recursive --no-ignore`) | ok — 152 dependency vulnerability rows across 4 lockfile/manifest sources |
| slither | not applicable — no Solidity in repo |
| fuzz (cargo-fuzz) | not applicable — no `fuzz/fuzz_targets`, not a Rust repo |
| agentic source-to-sink pass | ok — 0 candidates written to `agentic.json` after full review |

Repo size probe: 860 code files → agentic review budget N=10.

## Candidate count

- 78 raw semgrep hits (triaged individually)
- 152 osv-scanner dependency rows (11 unique packages after de-duplicating repeated PYSEC/GHSA aliases for the same CVE)
- Agentic pass over ~7 high-exposure entrypoint areas (stage get/put path handling, native-app sandbox script execution, OIDC token acquisition/logging, custom-image Docker/grype subprocess calls, dbt/project-definition YAML parsing, `secure_utils.py` Windows ACL/subprocess helpers, SQL statement URL-sourcing)
- **Confirmed:** 0 code vulnerabilities, 1 confirmed dependency CVE requiring action (jaraco-context)

## Triage notes (semgrep, code findings)

All 78 semgrep hits were reviewed and none survived triage:

- **~45 CI-hardening WARNINGs** (`github-actions-mutable-action-tag`, `secrets-inherit`, `run-shell-injection` in `.github/workflows/*`) — best-practice notes, not exploitable. The flagged `run-shell-injection` hits (`test_fork.yaml`, `test_trusted.yaml`) interpolate `${{ inputs.hatch-run }}` / `${{ inputs.python-env }}`, but both are hardcoded literal strings (`integration:test`, `integration`) set by the trusted caller workflow, not attacker-controlled — false positive (semgrep has no cross-file dataflow to see this). `test_performance_history_analysis.yaml:39` interpolates `github.event.inputs.rev` unquoted, but that workflow is `workflow_dispatch`-only, triggerable only by users with existing write access — no privilege boundary crossed, dropped.
- **`dangerous-subprocess-use-tainted-env-args` (secure_utils.py:58,112, ERROR)** — false positive. Calls `whoami.exe`/`icacls.exe` via absolute `%SystemRoot%`-anchored paths with list-form args, no `shell=True`, no attacker-controlled env. The file's own comments show this is a deliberately hardened module (explicit anti-PATH-hijacking rationale).
- **`exec-detected` (stage/manager.py:983)** — by-design: `snow stage execute` runs a Python file the *user themselves* uploaded to their own Snowflake stage, inside a Snowpark stored procedure (server-side, not local). Documented CLI feature, not an injection point.
- **`logger-credential-leak` (oidc_providers.py:181, snow_connector.py:510, oidc/manager.py:56)** — false positive x3. Each logs only `str(e)` (an exception message from a failed OIDC-detection attempt) or a provider-type enum, never the token value itself.
- **`insecure-hash-algorithm-md5` (stage/md5.py x4)** — MD5 used for S3-multipart-ETag-compatible file-integrity comparison against Snowflake stage checksums, not for any security/auth purpose. Non-issue.
- **`missing-autoescape-disabled` (dev/docs/template_utils.py:23)** — Jinja2 env used to render local dev-doc templates from a fixed in-repo template dir, not attacker-controlled HTML output. Non-issue.
- **`dynamic-urllib-use-detected` (sql/statement_reader.py:203)** — `urlopen()` on a URL from a `!source <url>`-style SQL construct the CLI user supplies themselves; the maintainers already gate this behind a `from_disabled_url` config path. By-design, already mitigated.
- **`insecure-file-permissions` (scripts/packaging/build_isolated_binary_with_hatch.py:215)** — build-time packaging script, not shipped/runtime code.
- **Dockerfile / Kubernetes hardening findings** — all inside `tests_integration/test_data/` or `tests_integration/tests_using_container_services/` fixtures — dropped per the test/fixture exclusion rule.

## Agentic review

Threat model: a locally-installed CLI that authenticates to Snowflake and executes user-supplied SQL/Python/config. The two things an attacker most wants are (1) credential/token exfiltration from the local config or OIDC flow, (2) an escape from an intended sandbox (stage download path traversal, native-app codegen sandbox escape). Reviewed:

- **Stage `get_recursive` path handling** (`stage/manager.py:391-425`) — the maintainers already implement `_check_for_path_traversal`, an explicit sandbox-containment check specifically defending against a malicious/compromised server returning a stage file path that would resolve outside the destination directory. This is exactly the vulnerability class I was checking for; it's already mitigated with a purpose-built guard and clear docstring.
- **Native-app codegen sandbox** (`codegen/sandbox.py`) — executes user-authored Python via list-form `subprocess.run`/`check_output` (no `shell=True`, no string interpolation of untrusted input into a shell command). By-design local script execution, same trust boundary as running any script the user already has.
- **`custom_images/manager.py`** Docker/grype subprocess wrappers — list-form args, no shell.
- **YAML parsing** (`dbt/manager.py`, `api/project/definition.py`) — both use `yaml.SafeLoader`-derived or `yaml.loader.BaseLoader` loaders, not the unsafe `yaml.Loader`/`FullLoader`. No unsafe deserialization found anywhere in `src/` (also checked for `pickle.load`/`eval`/`marshal.loads` — none present).
- **Credential storage** — no direct `keyring`/password-manager calls in `src/`; delegated to the `snowflake-connector-python` dependency (out of scope for this repo's own code).

0 candidates survived to `agentic.json`.

## Dependency findings (osv-scanner, 152 rows / 11 unique packages)

| Package | Version | CVEs | Disposition |
|---|---|---|---|
| pyjwt | 2.10.1 | 6 unique (incl. GHSA-xgmm-8j9v-c9wx HS256 forgery, GHSA-993g-76c3-p5m4 PyJWKClient SSRF) | duplicate-skipped — open PR [#3111](https://github.com/snowflakedb/snowflake-cli/pull/3111) bumps to 2.13.0. Not directly imported by `src/` (transitive). |
| cryptography | 46.0.6 | 9 rows | duplicate-skipped — open PR [#3115](https://github.com/snowflakedb/snowflake-cli/pull/3115) bumps to 48.0.1 |
| urllib3 | 2.6.3 | 2 unique (CVE-2026-44431, CVE-2026-44432) | duplicate-skipped — open PR [#3009](https://github.com/snowflakedb/snowflake-cli/pull/3009) bumps to 2.7.0 |
| filelock | 3.18.0 | 4 rows | duplicate-skipped — open PR [#2895](https://github.com/snowflakedb/snowflake-cli/pull/2895) bumps to 3.20.3 |
| idna | 3.10 | 2 rows | duplicate-skipped — open PR [#3035](https://github.com/snowflakedb/snowflake-cli/pull/3035) bumps to 3.15 |
| pygments | 2.19.2 | 2 rows | duplicate-skipped — open PR [#2844](https://github.com/snowflakedb/snowflake-cli/pull/2844) bumps to 2.20.0 |
| setuptools | 80.8.0 | 2 rows | duplicate-skipped — open PR [#2469](https://github.com/snowflakedb/snowflake-cli/pull/2469) bumps to 80.9.0 |
| wheel | 0.45.1 | 2 rows | duplicate-skipped — open PR [#2894](https://github.com/snowflakedb/snowflake-cli/pull/2894) bumps to 0.46.2 |
| click | 8.1.8 | 1 row | already-fixed — merged PRs #2280/#2338 bumped click historically; residual row is the same low-severity advisory already tracked, not re-filed |
| aiohttp | 3.9.5 | 68 rows | dropped — only appears in `tests_integration/test_data/projects/snowpark_duplicate_test/requirements.txt`, a test fixture, not a shipped/runtime manifest |
| **jaraco-context** | **6.0.1** | **CVE-2026-23949 / GHSA-58pv-8j8x-9vj2 (HIGH, CWE-22)** | **no prior art found — filed public PR [#3158](https://github.com/snowflakedb/snowflake-cli/pull/3158)** |

### jaraco-context — filed finding

- **Type:** already-disclosed dependency CVE (osv-scanner hit, GitHub-reviewed advisory, HIGH severity)
- **Summary:** Zip Slip path traversal in `jaraco.context.tarball()`'s `strip_first_component` filter. A malicious tar archive with a path like `dummy_dir/../../etc/passwd` can extract outside the intended directory; a nested-tarball variant also bypasses the filter. Affects `jaraco.context` directly and `setuptools` (which vendors it).
- **Reachability:** `jaraco-context` 6.0.1 is a transitive dependency pulled in via `keyring` 25.6.0 (not directly declared in `pyproject.toml`); appears in both `pylock.toml` and `snyk/requirements.txt`.
- **Prior-art check:** `gh search issues --repo snowflakedb/snowflake-cli --include-prs -- "jaraco-context"` returned zero results — no existing open/closed/merged PR or issue for this package.
- **Channel:** Public PR (A5a) — already-disclosed CVE, patch is net-positive per this skill's routing table.
- **Fix applied:** bumped `jaraco-context` from `6.0.1` to `6.1.2` (latest; fixed-in is `6.1.0`) in `snyk/requirements.txt` only — matching this repo's own existing dependency-bump PR convention (verified against merged PR #2895's diff, which touches only `snyk/requirements.txt`, not the hash-pinned `pylock.toml`). `pylock.toml` was deliberately left untouched since it's a PEP 751 lockfile with cryptographic hashes that this run has no safe way to regenerate correctly (`uv` toolchain not available in this environment) — hand-editing a hash-pinned lockfile risks a subtly broken build, which is worse than not filing.
- **PR:** https://github.com/snowflakedb/snowflake-cli/pull/3158

## Channels used

- Public PR: 1 (jaraco-context, #3158)
- PVR: 0
- Skipped: 0

## PoC gate status

Not required — no HIGH/CRITICAL **code** claim survived triage (the one filed finding is an already-published dependency CVE, which is exempt from the PoC-verification gate per A4.5).

## Dedup note

`memory/vuln-scanned.json` updated with a `public-pr` channel row for `snowflakedb/snowflake-cli`, `scanned_at: 2026-09-10T09:40:00Z`. Repo will be skipped for 30 days.
