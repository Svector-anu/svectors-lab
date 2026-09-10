# Vuln Scanner — aws/aws-cli

**Date:** 2026-09-10
**Target:** aws/aws-cli (forced via `var=aws/aws-cli`)
**Mode:** scan (Arm A)

## Repo metadata

- **Stars:** 17,244
- **Language:** Python
- **Description:** Universal Command Line Environment for AWS (aws-cli v1)
- **Status:** v1 entered maintenance mode 2026-08-05 — critical/security fixes only
- **Audited commit:** `a1a569733a6a413f460342b61c6a8909984c2e48`
- **Disclosure channel:** no repo-level `SECURITY.md`, but org-level `aws/.github/SECURITY.md`
  designates a Coordinated Vulnerability Disclosure program: HackerOne
  [aws_vdp](https://hackerone.com/aws_vdp) or email `aws-security@amazon.com`. PVR is
  disabled on this repo (`private_vulnerability_reporting.enabled = false`), but the
  org-wide channel is confirmed usable — this is why the repo was auditable despite
  the per-repo PVR flag being off.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 57 raw hits |
| trufflehog (filesystem) | ok | 0 verified secrets |
| trufflehog (git history) | ok | bounded 300s run, completed in ~98s, no timeout, 0 verified secrets |
| osv-scanner | ok | 4 dependency CVE rows (8 counting GHSA/PYSEC aliases) |
| fuzz (cargo-fuzz) | skip | pure Python repo, no `fuzz/fuzz_targets` harness |
| agentic | ok | 0 candidates (see below) |

## Candidate count

- Static/secret/dependency scanners: 57 semgrep + 0 trufflehog + 4 osv rows
- Agentic source-to-sink review: 0 candidates
- **Confirmed after triage: 0**

## Triage summary

**Semgrep (57 raw → 0 confirmed):**
- ~20 `logger-credential-leak` hits across vendored `awscli/botocore/{credentials,tokens,handlers,paginate,utils}.py` — spot-checked 8 directly; every one logs only metadata (filename, role name, expiry timestamp), never the actual secret value. False positive (proximity match on the word "credentials").
- 6 `insecure-hash-algorithm` (md5/sha1) — all non-cryptographic use: SHA1 as a documented AWS HTTP-checksum data-integrity algorithm (`httpchecksum.py`, matches AWS's own `ChecksumAlgorithm=SHA1` API option) or as a deterministic local cache-key hash (`credentials.py:847`), never for auth/signing.
- 4 `use-defused-xml` — vendored botocore XML serializer (`serialize.py`, write-only, no parse-time risk) and the `ElementTree` import feeding the real parse site (`parsers.py:544`). Stdlib `ElementTree` does not resolve external entities by default, and the parser only ever consumes AWS-generated response bodies (not attacker-supplied DTDs) under normal use.
- `codedeploy/systems.py:90` (`subprocess` `shell=True`) — installer path comes from the operator's own local `--installer` CLI flag on an on-prem, admin-only Windows agent-install command. Dropped: attacker would need privileges equal to or greater than what the "attack" yields (self-command-injection).
- `codecommit.py:167` (`directly-returned-format-string`) — a Flask-specific rule false-firing on a git-credential-helper function that returns a SigV4 signature string over the git-credential protocol, not an HTTP/Flask response. No web context exists.
- Remaining `subprocess-shell-true` / `dangerous-subprocess-tainted-env-args` hits are all in `scripts/ci/*` (maintainer-only build/release tooling, never shipped) or `awscli/testutils.py` (test-suite-only, not part of the installed package).
- HTML `var-in-href` hits are static Sphinx doc-theme templates (`doc/source/...`), not runtime-reachable.

**TruffleHog:** 0 verified secrets across both the working-tree filesystem scan and a bounded (300s cap, completed in ~98s, no timeout) full git-history scan.

**osv-scanner (4 CVE rows → 0 pursued):** `pytest` 8.1.1, `setuptools` 78.1.1, `idna` 3.9.0 — all sourced from `requirements-dev.txt` / `requirements-dev-lock.txt` / `requirements-docs.txt`. Confirmed none appear in `setup.py`'s `install_requires` (`docutils`, `PyYAML`, `colorama`, `rsa`, `jmespath`, `python-dateutil`, `urllib3`), so none ship in the package end users actually install via `pip install awscli`. The repo runs an active Dependabot (5+ dependency-bump PRs in the last three weeks, including these same packages' ecosystem) already covering this class — not pursued as a PR to avoid duplicating existing maintainer tooling.

**Agentic logic audit (N=10 entrypoint budget, 308 non-test `.py` files):** Threat-modeled around credential theft, RCE, and S3-download path traversal as the highest-value attacker goals for a cloud CLI (untrusted input = AWS API response content, especially S3 object keys/metadata an attacker could control in a bucket a victim downloads from). Traced the full S3 `cp`/`sync` download pipeline (`BucketLister.list_objects` → `find_dest_path_comp_key` → `BaseTransferRequestSubmitter.submit`) end to end for path traversal on attacker-chosen S3 keys — the classic bug class for this exact tool category. **Confirmed HEAD already has it correctly guarded**: `_warn_parent_reference()` in `s3handler.py` anchors the compare-key with a leading `./` before `normpath`, so a crafted key like `/../../etc/cron.d/evil` normalizes to a form starting `../` and is caught and skipped (not silently written). Verified this is a deliberate hardening already in an ancestor commit (`8695a4399`, "Fix parent reference warning") and manually confirmed three traversal payloads are all correctly rejected at the audited HEAD. Also reviewed: `paramfile.py` (`file://`/`http://` handling — only fires on user-typed CLI args, not AWS-response-driven, no SSRF path found), `credential_process` (`ProcessProvider` uses list-form `Popen`, no `shell=True`, sourced only from local profile config), all YAML loaders in the tree (all `SafeLoader`-derived), `--query` jmespath evaluation (safe DSL, never eval'd), and a full `eval`/`exec`/`pickle` sweep (only hit is in vendored `six.py`, not attacker-reachable).

Not deep-reviewed (documented, not silently dropped): SSO/OIDC device-code token-caching flow (`customizations/sso/`), CloudFormation-package local-path construction from user-owned templates (out of the remote-attacker threat model since the template is the user's own), and Windows-specific path-separator edge cases for the traversal guard (not verifiable on a POSIX runner).

## PoC gate status

Not required — no provisional HIGH/CRITICAL code finding survived triage to reach the gate.

## Dedup note

Logged to `memory/vuln-scanned.json`: `{"repo": "aws/aws-cli", "channel": "clean", "findings": 0}`. Future runs will skip this repo for 30 days.

## Verdict

Clean audit. 61 raw candidates reviewed (57 semgrep + 4 osv) plus a dedicated agentic entrypoint review, 0 confirmed exploitable findings. Notable: this pass didn't just fail to find a bug — it specifically traced and verified that a well-known bug class for this tool category (S3-download path traversal) is already correctly mitigated at HEAD, which is a more useful negative result than an unverified "looks fine."
