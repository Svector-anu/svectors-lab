## GitHub Trending — 2026-09-26

**Top pick** — [google/ax](https://github.com/google/ax)
Declarative "agent orchestration as its own infra layer" story, not a framework feature — Google's kubectl-shaped control plane for running agent workloads at fleet scale is being adopted faster (150K+ devs in 48h, #1 on HN) than any agent-framework release this year.

**Infra**
• [google/ax](https://github.com/google/ax) — ★ 1,379t today (11.7k total) · Go · [ACCELERATING]
Kubernetes-shaped agent orchestrator hit #1 on HN with 150K+ devs registering in 48 hours.

**Devtools**
• [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) — ★ 83t today (37.0k total) · Python · [ACCELERATING]
Anthropic's official plugin directory launched a submission portal Sep25 — now the on-ramp for the 2,000+-connector Claude Marketplace.

• [mattpocock/skills](https://github.com/mattpocock/skills) — ★ 583t today (270k total) · Shell · [ACCELERATING]
Its /grill-me skill makes the agent interrogate your spec for 45 minutes before writing a line of code.

• [derv82/wifit3](https://github.com/derv82/wifit3) — ★ 183t today (1.1k total) · Python · [RETURNING]
Ships userspace ports of Linux Wi-Fi drivers over USB, bypassing Windows NDIS and kernel driver locks entirely.

**AI/ML**
• [paperclipai/paperclip](https://github.com/paperclipai/paperclip) — ★ 2,109t today (85.7k total) · TypeScript · [ACCELERATING]
Runs AI agents like a company — org chart, per-agent budgets, approval gates — not just another agent wrapper.

• [androoAGI/starnet](https://github.com/androoAGI/starnet) — ★ 93t today (581 total) · JavaScript · [RETURNING]
Pixel-art rooms are literal capability grants — placing an agent in a room is how you scope its permissions.

**Web/Apps**
• [dream-num/univer](https://github.com/dream-num/univer) — ★ 1,050t today (18.9k total) · TypeScript · [RETURNING]
v1.0 merges six office editors — Sheets, Docs, Slides, Boards, Bases, PDFs — into one programmable SDK for agents.

---
sources: trending=ok(curl) · gh_api=ok · kept 7/16

## Summary
- Ran github-trending skill, GitHub branch, empty Operator var (no language filter).
- Fetched `github.com/trending?since=daily` via curl (16 candidates); enriched all survivors with `gh api` metadata (created_at/pushed_at/stargazers_count) plus targeted web search for non-paraphrased catalyst detail.
- Deduped 3 repos featured in the last 2 days (obra/superpowers, pbakaus/impeccable — 09-24; vectorize-io/hindsight — 09-25). Dropped anthropics/skills as a redundant judgment call (3 other picks already cover the agent-skills/plugins ecosystem story with dated catalysts). Dropped kelseyhightower/kubernetes-the-hard-way (17mo stale, bare-tutorial in spirit), rohitg00/ai-engineering-from-scratch (course bundle, repeat drop from 09-25), NVIDIA/Model-Optimizer (release notes explicitly say no user-facing changes), and 2 low-activity repos (shy3130/tick-stock-panel, openbao/openbao, both <50★ today and not new).
- Kept 7 of 16 across 4 buckets (Infra, Devtools ×3, AI/ML ×2, Web/Apps): google/ax (top pick), anthropics/claude-plugins-official, mattpocock/skills, derv82/wifit3, paperclipai/paperclip, androoAGI/starnet, dream-num/univer.
- Files modified: `memory/logs/2026-09-26.md` (appended `### github-trending` entry with branch, dedupe/drop reasoning, tags, buckets, top pick, source status, exit code `GITHUB_TRENDING_OK`).
- No follow-up actions needed; delivery to Telegram handled by MiniAeon after this run.
