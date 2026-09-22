Log entry appended. Now the final deliverable — captured output goes in the terminal message per A8 format.

## GitHub Trending — 2026-09-22

**Top pick** — [mvt-project/mvt](https://github.com/mvt-project/mvt)
Amnesty International's Pegasus-forensics toolkit shipped a breaking v3 release yesterday — the closest thing the security community has to a standard for detecting nation-state mobile spyware.

**AI/ML**
• [akitaonrails/ai-memory](https://github.com/akitaonrails/ai-memory) — ★ 167 today (7.9k total) · Rust · [ACCELERATING]
Cross-agent, cross-machine memory lives in a git-backed markdown wiki, with zero LLM calls by default.

• [zhouxiaoka/autoclip](https://github.com/zhouxiaoka/autoclip) — ★ 250 today (8.6k total) · Python · [RETURNING]
Latest release adds full 8-language UI support while keeping highlight-detection pluggable across cloud or local Ollama models.

**Devtools**
• [mvt-project/mvt](https://github.com/mvt-project/mvt) — ★ 169 today (13.7k total) · Python · [RETURNING]
Amnesty International's spyware-forensics CLI just shipped v3 with breaking changes — the tool journalists use to detect Pegasus-style compromise.

**Infra**
• [Crosstalk-Solutions/project-nomad](https://github.com/Crosstalk-Solutions/project-nomad) — ★ 394 today (38.1k total) · TypeScript · [ACCELERATING]
Self-hosted offline server bundling Wikipedia, Khan Academy, maps and a local LLM into one Docker box — zero telemetry.

---
sources: trending=ok · gh_api=ok · kept 4/12

## Summary

- Ran the GitHub branch (empty Operator var → no language filter, `since=daily`).
- Fetched 12 candidates via `curl` (thin day, third in a row); verified survivors against `gh api` (`created_at`, `releases`) rather than trusting descriptions.
- Dedup-dropped 5 against the last 2 days of logs (09-20/09-21): `anthropics/financial-services`, `BuilderIO/agent-native`, `trycua/cua`, `Open-Dev-Society/OpenStock`, `coder/coder`.
- Noise-dropped 2: `cloudflare/quiche` (32★ today, 7-year-old repo — fails low-activity filter), `ruanyf/weekly` (link/news digest, not software).
- Judgment-call drop outside the listed filter patterns: `yynxxxxx/Codex-X` — bundles explicitly branded "破甲/unrestricted" (jailbreak) prompt templates; declined on principle regardless of star count.
- Shipped 4 curated picks (below the 5-8 target but above the 3-pick floor) across AI/ML, Devtools, Infra.
- Files modified: `memory/logs/2026-09-22.md` (appended `### github-trending` entry, in write scope).
- No follow-up actions needed; exit `GITHUB_TRENDING_OK`.
