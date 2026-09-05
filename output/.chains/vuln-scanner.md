ℹ️ Vuln Scanner: paypal/paypal-js clean

*Vuln Scanner — paypal/paypal-js*
Clean audit. 100 candidates reviewed (21 semgrep, 79 osv), 0 confirmed. Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=skip, agentic=ok.
Semgrep hits were all GH Actions mutable-tag hardening, not code vulns. All 79 osv CVE rows are devDependency-only — neither published package (promise-polyfill / @paypal/sdk-constants / server-only) is affected. Agentic review of script-injection and options-processing found safe DOM-API usage throughout, no eval/innerHTML/postMessage.