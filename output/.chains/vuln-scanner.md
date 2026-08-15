⚠️ Vuln Scanner — watermarks-remover (operator action)

*Vuln Scanner — guillaumemeyer/watermarks-remover*

1 confirmed finding (medium) — needs operator action to disclose.

Audited the watermarks-remover website-audit tool (Python, 8.7k★, commit 92f38b1). XML entity-expansion ("billion laughs") DoS in `service/scripts/audit_website.py:72`: `parse_sitemap` feeds a remote, attacker-controlled sitemap straight into `xml.etree.ElementTree.fromstring`, which expands internal DTD entities. A <1KB hostile sitemap inflates to gigabytes in memory → host DoS. Verified locally: 388 bytes → 3 MB (~7,700×) at just 7 entity levels; more levels go exponential. The 4 MB fetch cap is on input bytes, so it does nothing post-parse. This is the tool's core use case — auditing arbitrary untrusted sites — so the sitemap is fully attacker-controlled.

Not XXE (etree doesn't fetch external entities), and not a duplicate: PR #49 hardened this same file against SSRF and gzip bombs but missed the XML bomb on the same parser. Fix is stdlib-only — reject DOCTYPE/entity declarations before parsing (sitemaps have none), or use defusedxml.

Clean elsewhere: server.py path handling is well-contained, container_meta.py has a zip-bomb budget guard, 0 verified secrets. osv flagged 264 rows but all are optional ML-harness deps (Dependabot already on it) — no dep PR.

Disclosure: PVR is enabled on the repo, but our fine-grained token got 403 on `POST /security-advisories/reports` (same token limit as the genoffice run). Report staged for you to paste into the PVR form:
https://github.com/guillaumemeyer/watermarks-remover/security/advisories/new
Draft: memory/pending-disclosures/guillaumemeyer-watermarks-remover-2026-08-15.md

Scanners: semgrep=ok, trufflehog=ok, osv=ok, slither=n/a. Report: output/articles/vuln-scan-2026-08-15.md

🔗 https://github.com/guillaumemeyer/watermarks-remover/security/advisories/new