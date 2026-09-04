*Vuln Scanner — step-security/harden-runner*
5 confirmed findings (all HIGH-severity dependency CVEs, patched).
Disclosed via: public PR [#693](https://github.com/step-security/harden-runner/pull/693)
Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=n/a, agentic=ok. PoC gate: not-required (dependency CVEs only).

Bumped brace-expansion, fast-xml-parser, js-yaml, browserslist, fast-uri — all same-major patch/minor bumps, no code changes needed. undici (11 GHSA) and uuid (1 GHSA) both need major/breaking bumps and were deferred with documented rationale (undici matches the maintainers' own existing risk-acceptance call for the same GHSA class). 0 code findings on this small, well-engineered security-vendor codebase; 3 stale Dependabot PRs superseded.
