ℹ️ Vuln Scanner — trusted-evidence-engine

*Vuln Scanner — NeoSoul-AI/trusted-evidence-engine*
Clean audit. 8 candidates reviewed, 0 confirmed. Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip, agentic=ok.
Unauthenticated evidence-resolve endpoint fans out to Brave/CoinGecko/AlphaVantage/Polymarket, but every outbound host is fixed server-side config with properly escaped query params — no SSRF, no injection. 1 dependency CVE (golang.org/x/sys, Windows-only, unreachable on this Linux service) dropped as non-actionable.