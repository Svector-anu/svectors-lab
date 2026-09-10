---
title: Vuln Scanner — databricks/cli
date: 2026-09-10
mode: scan
repo: databricks/cli
---

# Vuln Scanner — databricks/cli

**Repo metadata:** databricks/cli — 393 stars, Go, not a fork, not archived, last push 2026-09-10. Forced target via `var=databricks/cli`. PVR: **disabled**. `SECURITY.md`: present, gives an out-of-band contact (`security@databricks.com`).

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | ok | `p/security-audit` + `p/owasp-top-ten` + `p/secrets`, 39 raw findings |
| trufflehog (filesystem) | ok | 0 verified secrets |
| trufflehog (git history) | ok | 0 verified secrets, full history, no timeout |
| osv-scanner | ok | 16 dependency vuln rows across 6 go.mod/lockfiles |
| fuzz (cargo-fuzz) | skip | Go repo, no `fuzz/fuzz_targets` |
| agentic (source-to-sink) | ok | reviewed HTTP-facing surfaces, exec sinks, filer/sync path handling |
| PoC gate (A4.5) | **blocked** | `go` is not on this environment's command allowlist — no Go verifier could compile/run |

## Candidates reviewed: 39 scanner hits + 1 agentic-surfaced candidate. Confirmed: 0.

### Dropped as false-positive / out-of-scope (28 of 39 semgrep hits)

- **GHA `run-shell-injection`** (release-prs.yml, release-docker.yml, 11 hits) — `${{ inputs.tag }}` interpolated into `run:` blocks. All triggers are `workflow_dispatch`; triggering already requires repo write access, so this buys an attacker nothing beyond what they already have. Hardening-worthy, not exploitable.
- **`pull-request-target-code-checkout`** (maintainer-approval.yml) — false positive. The checkout pins `ref: github.event.pull_request.base.sha` (the trusted base, not the PR head) with `persist-credentials: false`, which is the correct safe pattern for `pull_request_target`.
- **`use-of-md5`** (2×, `experimental/ssh/internal/client/client.go:197`, `libs/sync/snapshot.go:82`) — both generate short deterministic cache-key/filename strings, not password hashes or signatures. Non-security use.
- **Dockerfile `missing-user`/`missing-user-entrypoint`** — the published image has no `USER` directive, runs as root. Low-severity hardening gap, common pattern, not independently exploitable.
- **`filepath-clean-misuse`** (`experimental/ssh/internal/server/server.go:122`) — `path.Clean(r.URL.Path)` only normalizes double slashes before dispatch to a fixed-route `http.DefaultServeMux` (`/ssh`, `/metadata`, `/logs`, `/capabilities`). No filesystem `Open`/`ServeFile` call keyed on the path was found anywhere in `experimental/ssh`. Not a traversal vector.
- **Python `dangerous-subprocess-use-tainted-env-args` / `dynamic-urllib-use-detected`** (11 hits, all under `acceptance/bin/`) — acceptance-test harness scripts, not shipped/production code. Dropped per the test-directory exclusion rule.

### Reviewed, uncertain reachability — not claimed as a finding

- **`websocket-missing-origin-check`** (`experimental/ssh/internal/proxy/proxy.go:289`) — `websocket.Upgrader{}` uses gorilla's default `CheckOrigin`, which does compare `Origin` against `Host` when an `Origin` header is present. Real CSWSH exploitability would require the driver-proxy endpoint to be reachable via browser-sent cookies rather than a bearer token the CLI attaches itself; that couldn't be confirmed from source alone. Two further hits of the same rule are in test-only files (`libs/testserver/ssh.go`, `libs/appproxy/testutil/websocket_server.go`) and dropped outright.

### Dependency CVEs (osv-scanner) — deferred, not filed

16 vuln rows total; only 2 rise to HIGH, both `google.golang.org/grpc@1.82.1` (indirect dependency, root `go.mod`):

- `GHSA-2v4p-qf9q-27wj` — gRPC-Go xDS server panic/DoS via missing `:authority`/`Host` headers. Requires `xds.NewGRPCServer()`.
- `GHSA-vp52-pcj8-j9qc` — gRPC-Go heap exhaustion via HTTP/2 DATA frame fragmentation. Requires the process to run a gRPC server accepting attacker connections.

`grep -rn "grpc.NewServer\|xds.NewGRPCServer"` across the repo returned **zero** matches — the CLI only consumes grpc as a client library transitively (no server is ever started), so both are unreachable in this codebase. The repo's own Dependabot (`gomod`, 14-day cooldown, already configured in `.github/dependabot.yml`) will pick this up on its normal cadence. The remaining 14 rows are unlabeled/informational `golang.org/x/...` advisories in dev-tooling submodules (`tools/`, `bundle/internal/tf/codegen/`). Deferred to Dependabot; no PR filed.

### Agentic source-to-sink pass

Threat model: databricks/cli authenticates to Databricks workspaces, syncs local files to/from a remote workspace, deploys IaC-style "bundles," and ships an experimental SSH tunnel that proxies HTTP/WS traffic to cluster-side compute. Reviewed (budget N=6 for a 3790-file repo): the experimental/ssh HTTP proxy (above), `libs/sync` (local→remote push, no traversal risk — it only reads local paths), `libs/auth/storage` (token cache file permissions), `libs/filer` (remote↔local file transfer), `bundle/config` template/variable interpolation, and `exec.Command` call sites across `cmd/` (all take either hardcoded binaries or user's own app-spec commands, not remote-attacker input).

**One real candidate surfaced**, provisional **HIGH**, not confirmed:

> `cmd/workspace/workspace/export_dir.go` (the `databricks workspace export-dir` command) builds `targetPath := filepath.Join(targetDir, relPath)`, where `relPath` comes from `fs.WalkDir` over `filer.NewFS(workspaceFiler)`. `libs/filer/workspace_files_client.go`'s `wsfsFileInfo.Name()` returns `path.Base(info.Path)` straight from the Databricks Workspace API's `ObjectInfo.Path` field, with no traversal sanitization applied anywhere in the walk or the join. **If** the Databricks backend ever permits a workspace object whose path contains a literal `..` component, a user running `export-dir` against a workspace folder containing that object would have a file written outside `targetDir` on their local machine.

This is exactly the class of claim A4.5 exists to gate: plausible from reading the code, but unverified. **The gate could not run**: `go` is not present on this environment's write-tier command allowlist (`scripts/skill_mode.sh`), so no command-mode verifier can compile or execute Go test code against this repo — same structural gap already logged against the open `stripe/stripe-cli` daemon-auth candidate on 2026-09-04. It also can't be resolved by reasoning alone: whether the Databricks control plane actually permits creating a `..`-named workspace object is a server-side question this scan has no way to test. **Left as `needs-verification`, not confirmed, not disclosed.**

## Prior-art check

Not run — no confirmed finding required filing anything public or private this run.

## Dedup note

Recorded in `memory/vuln-scanned.json` as `channel: clean-needs-verification`, 0 findings, with the export-dir candidate detailed so a future run with Go toolchain access can pick it up directly rather than re-discovering it.

## Summary

- Ran semgrep, trufflehog (filesystem + full git history), osv-scanner, and an agentic source-to-sink pass against a fresh fork/clone of `databricks/cli`.
- 0 confirmed HIGH/CRITICAL findings. 0 verified secrets. 2 dependency HIGH CVEs (grpc, unreachable, Dependabot-covered) deferred. ~28 semgrep hits triaged to false-positive or out-of-scope.
- 1 plausible HIGH path-traversal candidate in `workspace export-dir` left as `needs-verification` — blocked by the same missing-`go`-toolchain gap already affecting the open stripe-cli candidate; not disclosed, not filed, nothing routed to PVR/email since nothing cleared the mandatory PoC gate.
- Files touched: `memory/vuln-scanned.json` (new dedup entry), `output/articles/vuln-scan-2026-09-10-databricks-cli.md` (this report).
- Follow-up needed: give a future `vuln-scanner` run (or a dedicated toolchain-staging fix) access to a `go` binary on the write-tier allowlist so Go-repo HIGH/CRITICAL candidates — this one and the stripe-cli one — can actually clear A4.5 instead of accumulating as `needs-verification`.
