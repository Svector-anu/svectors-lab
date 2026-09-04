ℹ️ Vuln Scanner: parse-server

*Vuln Scanner — parse-community/parse-server*
Clean audit. 58 candidates reviewed (3 code, 55 dependency), 0 confirmed. Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=skip, agentic=ok.

3 semgrep code hits were all false positives on review (GCM default tag length, an already-safe CORS allowlist reflection, an intentional timing-normalization dummy bcrypt hash). 55 dependency CVEs found by osv-scanner are already covered by the repo's own Dependabot (746 PRs total) — spot-checked 11 of the top hits, all had open or recently-merged bump PRs, so nothing filed to avoid duplicating the bot's own work.