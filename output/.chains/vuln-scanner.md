⚠️ Vuln Scanner — cockpit-tools

*Vuln Scanner — jlcodes99/cockpit-tools*
4 confirmed findings (1 critical hardcoded Google OAuth client secret, 1 medium third-party GitHub OAuth embed, 1 medium WS missing auth on switch/list, 1 low default report token).
Disclosed via: pending-email (auto_send staged) + public PR #2217 (openssl/rustls-webpki HIGH bumps).
Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=skip, agentic=ok. PoC gate: not-required (verified secret + published dep CVEs).