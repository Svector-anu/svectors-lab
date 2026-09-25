FEAR_DIVERGENCE_SKIP: no market-context.md — enable market-context first.

`memory/skills/fear-divergence/` doesn't exist at all — the upstream `market-context` skill hasn't run/populated it yet. No trigger data to evaluate F&G threshold against. No notification sent (nothing to report).

## Summary
- Checked `memory/skills/fear-divergence/market-context.md` — not found; directory itself doesn't exist.
- Per SKILL.md step 1, stopped without evaluating F&G trigger.
- Logged `FEAR_DIVERGENCE_SKIP: no market-context.md — enable market-context first` to `memory/logs/2026-09-25.md`.
- Follow-up: enable/verify `market-context` skill so it writes `memory/skills/fear-divergence/market-context.md` before this skill can run.
