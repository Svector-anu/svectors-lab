ℹ️ Vuln Scanner: stripe/openapi clean

*Vuln Scanner — stripe/openapi*
Clean audit. 2 candidates reviewed, 0 confirmed. Scanners: semgrep=ok, trufflehog=fail, trufflehog-git=fail, osv=fail, fuzz=skip, agentic=ok.
Repo is OpenAPI spec data + hardened CI/CD (SHA-pinned actions, minimal permissions, zizmor-gated). Both semgrep hits were false positives on read.