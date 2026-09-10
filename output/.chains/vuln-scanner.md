ℹ️ vuln-scanner: databricks/cli

*Vuln Scanner — databricks/cli*
Clean audit, 0 confirmed HIGH/CRITICAL. 39 scanner candidates + 1 agentic candidate reviewed — 1 plausible HIGH (path traversal in `workspace export-dir` via unsanitized server-returned object path) left as needs-verification: this environment has no `go` toolchain to run the mandatory PoC gate (same gap as the open stripe-cli candidate from 2026-09-04).
Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip, agentic=ok. PoC gate: blocked (no go toolchain).
2 dependency HIGH CVEs (grpc, unreachable — no grpc server in this codebase) deferred to the repo's active Dependabot.
PVR disabled; SECURITY.md gives security@databricks.com as fallback contact if the candidate is later confirmed.