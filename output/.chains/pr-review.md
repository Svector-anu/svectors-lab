🚨 PR Review: svectors-lab#70

*PR Review — 2026-09-16*
Reviewed 1, skipped 0.
- Svector-anu/svectors-lab#70: **blocked** — 1 critical, 0 issues

PR merged at 13:28 UTC before this review ran, so the verdict is for traceability, not a merge gate.

Previously-flagged critical (bare `shadow`/`compare` selector bypassing the read-only guard) is fixed — commit `7e94c624` closes it with a regression test.

New CRITICAL, live on `main` now: `apps/mcp-server/src/skill-executor.ts` never sources the new `scripts/resolve-riva-capabilities.sh`. It resolves vuln-scanner to `mode=write` and passes the full ambient environment, so running `var=shadow` or `var=compare` through the MCP server (not GitHub Actions) bypasses Riva's entire isolation guarantee — full write tools, every live secret. Needs an urgent fast-follow PR.

Full review comment: https://github.com/Svector-anu/svectors-lab/pull/70#pullrequestreview-5223451897

🔗 https://github.com/Svector-anu/svectors-lab/pull/70