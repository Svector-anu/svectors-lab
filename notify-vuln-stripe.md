*Vuln Scanner — stripe/stripe-cli*
0 confirmed findings, 1 needs-verification (not disclosed).
Disclosed via: none — grpc CVE-2026-84304 (HIGH) duplicate-skipped (Dependabot PR #1984 already fixes it); a plausible HIGH auth-bypass on the local `stripe daemon` gRPC service (public-constant header, no real secret check — any local process can create webhook endpoints/trigger events using the CLI's own session) couldn't clear the PoC gate, no `go` toolchain permission this run.
Scanners: semgrep=ok, trufflehog=fail (no raw binary asset), osv=ok, fuzz=n/a, agentic=ok. PoC gate: needs-verification.
Full report: output/articles/vuln-scan-2026-09-04-stripe-cli.md
