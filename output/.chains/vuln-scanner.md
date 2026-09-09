✅ Vuln Scanner

*Vuln Scanner — cloudflare/workers-sdk*
1 confirmed finding (critical + high, bundled).
Disclosed via: public PR [#15584](https://github.com/cloudflare/workers-sdk/pull/15584) — `shell-quote` 1.8.1→1.10.0, fixing CVE-2026-9277 (quote() shell injection) + CVE-2026-13311 (parse() ReDoS), a direct wrangler dependency reachable from `init`/`pages dev`.
Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=n/a, agentic=ok. PoC gate: not-required (published dependency CVE).
8 semgrep hits and 345 other dependency-CVE rows triaged out (false positives, maintainer-accepted risk, or transitive/fixture-only debt already covered by this repo's active Dependabot cadence).

🔗 https://github.com/cloudflare/workers-sdk/pull/15584