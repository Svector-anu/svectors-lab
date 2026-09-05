✅ Vuln Scanner — stripe/stripe-node

*Vuln Scanner — stripe/stripe-node*
Clean audit. 36 candidates reviewed (3 semgrep, 33 osv rows), 0 confirmed. Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip, agentic=ok.
Webhook-signature verification (the SDK's highest-value surface) reviewed end-to-end: constant-time compare, correct HMAC-SHA256, default replay-tolerance on the real entrypoint, multipart CRLF-injection guard already in place. Published package ships zero runtime deps, so all 33 osv rows are dev-tooling/example-only. PVR disabled; only channel is Stripe's own bug-bounty program (out of scope for auto-disclosure).