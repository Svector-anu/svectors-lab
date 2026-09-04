*Vuln Scanner — NousResearch/hermes-agent*
2 confirmed findings (1 high, 1 medium).
Disclosed via: PVR GHSA-qjq9-cgwp-r73h (both findings bundled)
Scanners: semgrep=ok, trufflehog=ok, osv=ok, fuzz=skip, agentic=ok. PoC gate: verified.

**Finding 1 (HIGH, verified):** `apps/desktop/src/plugins/hermes-bots/avatar.tsx:212` — a remote group-chat participant's bot display name breaks out of an HTML attribute in string-built SVG markup (JSON.stringify doesn't neutralize `"` for HTML context) and injects a live DOM element with an executable event handler via `dangerouslySetInnerHTML`. Reproduced with a jsdom harness against the literal shipped expression (benign control: 0 injected elements; malicious name: 1 live `<img onerror>` element).

**Finding 2 (MEDIUM, verified secret):** `website/docusaurus.config.ts:105` — a live Algolia key (TruffleHog-verified) with ACL `browse,listIndexes,search,settings`, broader than the code comment's "search-only, safe to commit" claim.

**Dependency CVEs:** 30 osv rows found, all with existing open upstream fix PRs (#101446, #91906, #94262) — not filed, logged as duplicate-skipped after prior-art check.

Report: output/articles/vuln-scan-2026-09-04-hermes-agent.md
