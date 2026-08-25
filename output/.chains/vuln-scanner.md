ℹ️ Vuln Scanner — rtk-ai/rtk

*Vuln Scanner — rtk-ai/rtk*
4 confirmed findings (RustSec dep advisories: quick-xml DoS×2, anyhow unsoundness, crossbeam-epoch ptr deref).
Disclosed via: public PR #3705
Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=skip, agentic=ok.

🔗 https://github.com/rtk-ai/rtk/pull/3705
ℹ️ Vuln Scanner — hermes-agent

*Vuln Scanner — NousResearch/hermes-agent*
2 confirmed findings (1 medium credential ACL mismatch, 1 moderate dep CVE).
Disclosed via: PVR GHSA-3jv7-3pr9-766x; public PR #94342 (h2 4.4.1). Electron/nanoid already covered by open maintainer PRs — skipped.
Scanners: semgrep=ok (auth subset; full tree timed out), trufflehog=ok, osv=ok, fuzz=skip, agentic=ok.
