*Vuln Scanner — genspark-ai/genoffice*

1 confirmed finding (low, defense-in-depth) — needs operator action to disclose.

Audited the genoffice Electron AI office suite (~2748★, commit dc4d7e5). Path traversal in the `docs:save-new` IPC handler: `apps/docs/src/main/docs-main.ts` joins a renderer-supplied filename into the default save dir with no `..`/containment check, on the *silent* first-save path — an arbitrary-path, arbitrary-content write. Sibling handlers (`docs:save-as`, slides) already validate; this one is the outlier. Not reachable from documents or the AI agent (current renderer callers all sanitize) — it needs a prior renderer-compromise, which the app's own sandbox model exists to contain. So: low severity, framed as a hardening/consistency fix.

Clean on the rest: AI layout-script sandbox holds, Electron hardening (contextIsolation/sandbox/IPC) verifies, SSRF guard solid, auto-updater signature-enforced, OOXML parsing (fast-xml-parser) has no XXE/zip-slip/proto-pollution.

Disclosure: PVR is enabled on the repo, but our fine-grained token got 403 on `POST /security-advisories/reports` (same 403 blocked the fork). Report is staged for you to paste into the PVR form:
https://github.com/genspark-ai/genoffice/security/advisories/new
Draft: memory/pending-disclosures/genspark-ai-genoffice-2026-08-13.md

Scanners: semgrep=ok (0), trufflehog=ok (0), osv=fail (binary not staged), slither=n/a. Report: output/articles/vuln-scan-2026-08-13.md
