ℹ️ vuln-scanner: snowflake-cli

*Vuln Scanner — snowflakedb/snowflake-cli*
Clean code audit (0 confirmed code vulns, well-hardened — existing path-traversal guard, no unsafe deserialization, safe subprocess usage). 1 dependency CVE with no prior coverage: jaraco-context 6.0.1 had CVE-2026-23949 (HIGH, zip-slip path traversal) — filed public PR #3158 bumping to 6.1.2. 10 other dependency CVEs already covered by open Dependabot PRs.
Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=n/a, agentic=ok. PoC gate: not-required.
Note: repo runs a HackerOne bounty program alongside PVR — future HIGH/CRITICAL code findings route to a human, not auto-disclosure.
PR: https://github.com/snowflakedb/snowflake-cli/pull/3158