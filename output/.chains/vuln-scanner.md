ℹ️ Vuln Scanner: Shopify/cli

*Vuln Scanner — Shopify/cli*
0 confirmed HIGH/CRITICAL on main. Real finding: open PR #8320 pairs unchecked Origin reflection with a new Access-Control-Allow-Credentials: true — a credentialed CORS bypass before it even ships. Commented with the fix (origin allowlist) rather than filing a duplicate PR.
Dependency scan: 98 CVE rows (2 CRITICAL) but all trace to dev/build/telemetry transitive deps, and Dependabot's already grouping updates weekly — duplicate-skipped, no PR filed.
Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip, agentic=ok. PoC gate: not-required.
Comment: https://github.com/Shopify/cli/pull/8320#issuecomment-5609874390

🔗 https://github.com/Shopify/cli/pull/8320#issuecomment-5609874390