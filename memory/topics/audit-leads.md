---
type: Leads
title: Audit Leads
description: Companies vuln-scanner has privately disclosed a real, confirmed vulnerability to — a warm list for a manual private-audit follow-up. Disclosure and sales are kept deliberately separate; nothing here is auto-pitched.
tags: [security, leads, business-dev, vuln-scanner]
timestamp: 2026-09-04T07:06:25Z
---

# Audit Leads

Every row is a company/repo vuln-scanner privately disclosed a real, confirmed finding to (PVR report accepted, or maintainer email sent) — free, credible proof of skill, already in their inbox. Any follow-up sales conversation from here is manual, never automated. Update the Status column by hand as you work a lead; new rows are only ever appended, existing rows are never rewritten, so your notes survive.

| Date | Repo | Severity | Channel | Status | Notes |
|------|------|----------|---------|--------|-------|
| 2026-08-25 | NousResearch/hermes-agent | medium | PVR GHSA-3jv7-3pr9-766x | disclosed | Overprivileged Algolia apiKey in docusaurus.config.ts (settings ACL) |
| 2026-08-31 | ApodexAI/FrontierAgent | high | PVR GHSA-ch5r-299j-j7h5 | disclosed | file_editor_* sandbox shell injection / approval-gate bypass |
| 2026-08-31 | K-Dense-AI/scientific-agent-skills | high | PVR GHSA-3jvm-qqmm-hp97 | disclosed | predictable LibreOffice /tmp profile RCE + Actions script injection |
| 2026-09-02 | browser-use/video-use | medium | PVR GHSA-79fj-7f7h-8gxx | disclosed | EDL source-key path traversal writes render segments outside edit_dir |
| 2026-09-02 | arcboxlabs/arcbox | high | PVR GHSA-5p84-px8m-8gwv | disclosed | HV VirtioFS open/setattr symlink TOCTOU — guest read/truncate outside share |
| 2026-09-02 | crmne/fastpotify | medium | PVR GHSA-hqg7-6gj3-g28w | disclosed | OAuth localhost callback reflected XSS (CWE-79) |
| 2026-09-02 | clawkwork/clawk | medium | PVR GHSA-f92w-wjfp-773j | disclosed | world-writable agent.sock (0666) lets local users exec inside another user VM |
| 2026-09-04 | NousResearch/hermes-agent | high | PVR GHSA-qjq9-cgwp-r73h | disclosed | remote bot-name attribute breakout -> DOM XSS (verified PoC) + live Algolia key w/ settings ACL |
