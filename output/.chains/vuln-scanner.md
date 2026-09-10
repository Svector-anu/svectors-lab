ℹ️ Vuln Scanner: aws/aws-cli

*Vuln Scanner — aws/aws-cli*
Clean audit. 61 candidates reviewed (57 semgrep + 4 osv), 0 confirmed. Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip, agentic=ok.
Notable: agentic pass traced the S3 sync/cp download path-traversal class end to end and confirmed HEAD's parent-reference guard correctly rejects it — verified, not assumed.