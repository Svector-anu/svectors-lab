ℹ️ Vuln Scanner — fireblocks/fireblocks-sdk-js

*Vuln Scanner — fireblocks/fireblocks-sdk-js*
1 confirmed finding (bundled dependency-CVE fix, filed as public PR — no code vulnerabilities confirmed).
Disclosed via: public PR [#344](https://github.com/fireblocks/fireblocks-sdk-js/pull/344) — lockfile-only bump of 9 packages fixing 24/28 osv-flagged CVEs (qs, lodash, form-data CVE-2026-12143, base-x closes [#333](https://github.com/fireblocks/fireblocks-sdk-js/issues/333), jws HMAC-verify bug, +4 dev-only), zero breaking changes. Also commented on stale [#314](https://github.com/fireblocks/fireblocks-sdk-js/pull/314) (qs bump target was insufficient).
3 dep CVEs left unfixed, no safe path: @stablelib/ed25519 signature-malleability has no patch at all (even latest 2.0.2 affected); uuid and decode-uri-component both need breaking major bumps.
1 agentic candidate (unencoded ID interpolation into request paths, every SDK method) left `needs-verification` — can't safely test Fireblocks' own production path handling, not filed anywhere.
Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip, agentic=ok. PoC gate: not-required (published CVEs) / needs-verification (1 code candidate).

🔗 https://github.com/fireblocks/fireblocks-sdk-js/pull/344