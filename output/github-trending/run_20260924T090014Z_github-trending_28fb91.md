Fetched GitHub's daily trending page (17 candidates, recovered from three thin days), deduped against the last 2 days, filtered noise, verified survivors via `gh api` + README pulls for concrete detail. 8 picks across 4 buckets.

## GitHub Trending — Sep 24, 2026

**Top pick** — [obra/superpowers](https://github.com/obra/superpowers)
290,917 stars for a skills framework that runs unmodified across 15 different coding agents — Claude Code, Codex, Cursor, Devin, Kimi, Qwen and more — the harness-portability thesis proven at scale, not just argued.

**AI/ML**
• [obra/superpowers](https://github.com/obra/superpowers) — ★ 474t today (291k total) · Shell · ACCELERATING
Same skill set now drives 15 different coding agents — Claude Code to Codex to Kimi — no rewrite per harness.

• [DeusData/codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp) — ★ 190t today (44.7k total) · C · ACCELERATING
Indexes the 28M-line Linux kernel in 3 minutes, sub-1ms query answers — benchmarked at 10x fewer tokens than file-by-file.

• [strands-agents/harness-sdk](https://github.com/strands-agents/harness-sdk) — ★ 115t today (8k total) · Python · RETURNING
Python, TypeScript, and CLI releases all shipped within 24 hours — an agent SDK moving at daily-release cadence.

**Devtools**
• [pbakaus/impeccable](https://github.com/pbakaus/impeccable) — ★ 304t today (70.6k total) · JavaScript · ACCELERATING
61 deterministic rules catch every AI-slop tell — Inter font, purple gradients, cards-in-cards — without calling an LLM.

• [HKUDS/CLI-Anything](https://github.com/HKUDS/CLI-Anything) — ★ 57t today (50.1k total) · Python · ACCELERATING
Community-built CLI wrappers make CAD, Obsidian, and Rekordbox agent-drivable — install one, any coding agent can operate it.

• [BuilderIO/agent-native](https://github.com/BuilderIO/agent-native) — ★ 87t today (6.7k total) · TypeScript · RETURNING
Define a capability once — the agent uses it as a tool, the UI calls the same code.

**Web/Apps**
• [Open-Dev-Society/OpenStock](https://github.com/Open-Dev-Society/OpenStock) — ★ 344t today (19k total) · TypeScript · ACCELERATING
AGPL-licensed Bloomberg-lite: real-time prices, alerts, and company insights, free and self-hostable instead of a paid terminal subscription.

**Other** (doesn't fit AI/ML or Devtools — creative/graphics tooling, not agent/language AI or dev workflow)
• [harry7557558/spirula-studio](https://github.com/harry7557558/spirula-studio) — ★ 69t today (838 total) · C++ · RETURNING
Trains 3D Gaussian Splats on NVIDIA, AMD, Intel, or Apple GPUs via Vulkan — no Python or COLMAP needed.

---
sources: trending=ok · gh_api=ok · kept 8/17

## Summary

- Ran Branch A (GitHub trending, empty Operator var → no language filter).
- Fetched `github.com/trending?since=daily` via `curl` — 17 candidates (recovered from three consecutive thin days).
- Dedup-dropped 7 against the last 2 days of logs (09-22/09-23 picks): google/ax, anthropics/financial-services, agent-substrate/substrate, dream-num/univer, superdesigndev/treg, browser-use/video-use, mvt-project/mvt.
- Weak-signal drop 1: davila7/claude-code-templates (389★ today but only automated bot-commit churn behind it, same call as yesterday).
- Judgment-call drop 1 to stay inside the picks cap: TNT-Likely/PanWatch (stale 3-day-old release, Chinese-only README, couldn't write a non-paraphrase line).
- Enriched all 8 survivors via `gh api` (created_at/stargazers/releases) plus README fetches to pull concrete, non-paraphrased "why notable" details (benchmark numbers, harness counts, release cadence) rather than restating descriptions.
- Two tags are documented judgment calls: BuilderIO/agent-native and strands-agents/harness-sdk fall under the 50★/day lifetime-average threshold (34.2 and 16/day) despite being >90 days old and shipping releases today/yesterday — tagged RETURNING rather than forced into ACCELERATING.
- Files touched: appended `### github-trending` entry to `memory/logs/2026-09-24.md` (branch, dedupe/drop reasoning, judgment calls, buckets, source status, exit code `GITHUB_TRENDING_OK`). No other memory/output writes needed.
- Follow-up: none required; MiniAeon delivers this message to Telegram.
