ℹ️ Vuln Scanner — circlefin/circle-nodejs-sdk

*Vuln Scanner — circlefin/circle-nodejs-sdk*
Clean audit. 2 candidates reviewed, 0 confirmed. This is a thin OpenAPI-generated axios client SDK with no custom server/auth logic to exploit.
One useful dependency-hygiene contribution: the repo's own open Dependabot PR #151 only bumps axios to 1.16.0, leaving 5 published medium-severity GHSAs open (fixed only in axios>=1.18.0) — commented with the gap and a suggestion to target 1.20.0 instead, rather than filing a duplicate PR.
Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip(n/a), agentic=ok. PoC gate: not-required.