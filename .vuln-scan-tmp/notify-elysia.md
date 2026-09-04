*Vuln Scanner — elysiajs/elysia*
Clean audit. 65 candidates reviewed, 0 confirmed. Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=skip, agentic=ok.

Core package ships only 4 runtime deps (cookie, exact-mirror, fast-decode-uri-component, memoirist); all 60 osv hits were devDependency/test-fixture-only or already-fixed self-CVEs (elysia's own past cookie-prototype-pollution, cookie-config code injection, URL ReDoS, and multi-schema prototype-pollution advisories — all patched by the audited 1.4.30). 5 semgrep hits were GHA mutable-tag hardening noise. Agentic pass traced the Function()-based codegen pipeline (compose.ts/sucrose.ts) — all schema keys are JSON.stringify-escaped, no attacker-reachable injection found. No disclosure filed.

Note: the cloned repo's own CLAUDE.md contained a prompt-injection attempt targeting AI agents; ignored per policy.
