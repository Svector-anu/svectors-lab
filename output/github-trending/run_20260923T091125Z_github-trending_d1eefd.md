## GitHub Trending — Sep 23, 2026

**Top pick** — [google/ax](https://github.com/google/ax)
Google open-sourced its internal agent-orchestration stack this week — the kubectl-of-agents story every team running agent fleets has been waiting for; 2,305 stars today (25x its next-closest competitor on the list) plus HN front-page and InfoQ coverage in the last ~20h.

**AI/ML**
• [anthropics/financial-services](https://github.com/anthropics/financial-services) — ★ 438t today (36.6k total) · Python · RETURNING
20 production finance-agent plugins — DCF/LBO models, KYC review, CIM drafts — shipped as plain, editable Markdown/YAML.

• [browser-use/video-use](https://github.com/browser-use/video-use) — ★ 191t today (26.2k total) · Python · ACCELERATING
Drop raw footage in a folder, chat with Claude Code, get a graded, subtitled final.mp4 back.

**Devtools**
• [superdesigndev/treg](https://github.com/superdesigndev/treg) — ★ 230t today (2.4k total) · Python · ACCELERATING
3,000+ paid API endpoints (SEO, scraping, enrichment) callable per-request instead of $99+/mo subscriptions — no vendor signup.

**Infra**
• [google/ax](https://github.com/google/ax) — ★ 2,305t today (8.1k total) · Go · ACCELERATING
Kubectl-shaped orchestrator for agent workloads — treats agents as stateful actors, not microservices, with sub-second suspend/resume.

• [agent-substrate/substrate](https://github.com/agent-substrate/substrate) — ★ 245t today (3.2k total) · Go · RETURNING
The sandboxing runtime google/ax depends on — gVisor-isolated, 500+ suspend/resume ops/sec, 10x denser than standard containers.

**Web/Apps**
• [dream-num/univer](https://github.com/dream-num/univer) — ★ 255t today (15.9k total) · TypeScript · RETURNING
One runtime for sheets/docs/slides where agents work in isolated worktrees — you review the diff before merging, git-style.

---
sources: trending=ok · gh_api=ok · kept 6/8

## Summary

- Ran Branch A (GitHub trending, empty Operator var → no language filter).
- Fetched `github.com/trending?since=daily` via `curl` — only 8 candidates today (thinnest day of the last several runs).
- Dropped 1 for same-2-day dedupe (mvt-project/mvt, featured 09-22), dropped 1 for weak/stale signal despite passing the formal star filter (davila7/claude-code-templates — no concrete new hook, would've been a paraphrase).
- Enriched all 6 survivors via `gh api` (created_at/stars/description) plus targeted web search per repo to get primary-source "why notable" lines instead of paraphrasing descriptions — including catching that `agent-substrate` is an independent org, not Google, despite being google/ax's dependency.
- Two tags (google/ax, superdesigndev/treg) are documented judgment calls: both undercut the letter of the lifetime-average velocity formula (46/day and 34/day, vs the 50 threshold) but show clear single-day spikes (25–30x their averages) — tagged ACCELERATING with the discrepancy flagged in the log rather than silently forcing a clean formula match.
- Files touched: appended `### github-trending` entry to `memory/logs/2026-09-23.md` (branch, dedupe/drop reasoning, judgment calls, source status, exit code `GITHUB_TRENDING_OK`). No other memory/output writes needed for this branch.
- Follow-up: none required; MiniAeon delivers this message to Telegram.
