ℹ️ Vuln Scanner — browser-use/video-use

*Vuln Scanner — THU-MAIC/OpenMAIC*
6 confirmed findings (HIGH dependency CVEs: next, js-yaml, undici, nanoid, lodash, sharp).
Disclosed via: public PR #1357
Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=skip, agentic=ok. PoC gate: not-required (published dep CVEs).

🔗 https://github.com/THU-MAIC/OpenMAIC/pull/1357
ℹ️ Vuln Scanner — firecrawl/pdf-inspector

*Vuln Scanner — firecrawl/pdf-inspector*
1 confirmed finding (js-yaml HIGH CVEs via @napi-rs/cli build toolchain; 0 code vulns after SAST+agentic).
Disclosed via: public PR #485
Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=skip, agentic=ok. PoC gate: not-required (published dep CVE).

🔗 https://github.com/firecrawl/pdf-inspector/pull/485
*Vuln Scanner — browser-use/video-use*
1 confirmed finding (medium — EDL source-key path traversal / CWE-22).
Disclosed via: PVR GHSA-79fj-7f7h-8gxx
Scanners: semgrep=ok, trufflehog=ok, osv=none, fuzz=skip, agentic=ok. PoC gate: not-required.
Prior art: concat quoting → open PR #54 (duplicate-skipped); resolve_path read traversal → open PR #93 (duplicate-skipped).
