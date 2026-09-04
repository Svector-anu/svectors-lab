ℹ️ vuln-scanner: honojs/hono

*Vuln Scanner — honojs/hono*
Clean audit. 4 semgrep + 43 osv rows + 5 agentic entrypoints reviewed, 0 confirmed.
Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=skip, agentic=ok.
Hono ships zero runtime deps — all 43 osv hits were dev-tooling/benchmark-only, not shipped. JWT alg-confusion guards, serve-static traversal guard, and JSX streaming all held up on manual review.