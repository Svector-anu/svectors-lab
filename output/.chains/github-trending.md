Now the notification output (the skill's `./notify` target — delivered to you here in the CLI):

*GitHub Trending — 2026-08-26*

*Top pick* — [openai/codex](https://github.com/openai/codex)
OpenAI's flagship terminal coding agent — the real, open-source engine behind the Codex product, not a wrapper.

*AI/ML*
• [openai/codex](https://github.com/openai/codex) — ★ 1.2k today (119k total) · Rust · [ACCELERATING]
Lightweight terminal coding agent you can self-host; the actual core of OpenAI's Codex product.
• [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) — ★ 830 today (207k total) · [ACCELERATING]
A single CLAUDE.md distilling Karpathy's engineering instincts into copy-paste agent behavior.
• [TauricResearch/TradingAgents](https://github.com/TauricResearch/TradingAgents) — ★ 218 today (101k total) · Python · [ACCELERATING]
Multi-agent LLM framework that simulates an analyst/PM/trader desk for financial decisions.
• [tinyhumansai/openhuman](https://github.com/tinyhumansai/openhuman) — ★ 542 today (38k total) · Rust · [ACCELERATING]
Local-first "personal AI superintelligence" that builds a persistent life model from your data.
• [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) — ★ 982 today (112k total) · JS · [ACCELERATING]
Makes your AI agent think like the laziest senior dev — minimal-effort, high-leverage prompting.

*Devtools / Infra*
• [basecamp/omarchy](https://github.com/basecamp/omarchy) — ★ 1.1k today (32k total) · Shell · [ACCELERATING]
Basecamp's opinionated, beautiful Arch setup — a one-command modern Linux dev environment.
• [MadsLorentzen/ai-job-search](https://github.com/MadsLorentzen/ai-job-search) — ★ 1.3k today (36k total) · Python · [ACCELERATING]
Fully local AI agent that hunts, tailors, and auto-submits job applications on your machine.
• [asciimoo/hister](https://github.com/asciimoo/hister) — ★ 98 today (3k total) · Go · [RETURNING]
Self-hostable search engine that runs entirely on your own infrastructure — renewed interest.

---
sources: trending=ok · gh_api=ok (unauthenticated curl) · kept 8/14 · dropped 2 meta-lists

Notes:
- `${var}` was empty → GitHub branch, no language filter. 14 repos cleared the noise filter; I cut to a tight 8.
- 2 dropped for being meta-lists (`awesome-gpt-image-2`, `awesome-llm-apps`). The remaining 6 (claude-plugins-community, claude-obsidian, ai-engineering-from-scratch, apache/maka, marin, claude-plugins-official) were solid but lower-signal than the slate above.
- `gh api` was token-unavailable (read-only harness), so I used unauthenticated `curl` to the public REST API for `created_at`/velocity — momentum tags held up fine.
- First run: no `memory/logs/` existed, so no dedup against prior days. The run log was written to `/tmp/github-trending-2026-08-26.md` (repo is read-only, so it couldn't live in `skills/github-trending/memory/logs/`).

Exit: GITHUB_TRENDING_OK
