ℹ️ Vuln Scanner

*Vuln Scanner — vercel/ai*
Clean audit. 4 scanner hits + 6 agentic entrypoints reviewed, 0 confirmed. Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip, agentic=ok.
108 HIGH/CRITICAL dependency findings triaged as non-reachable from published packages or already covered by the repo's own active Dependabot -- deferred, no PR filed.
SSRF validateUrl guard hand-checked across ~25 call sites (own AGENTS.md flags it as sensitive) -- holds. Report: output/articles/vuln-scan-2026-09-10.md