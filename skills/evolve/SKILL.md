# evolve

Propose one small skill improvement as a GitHub PR. MiniAeon never merges it.

## Do

1. Read `memory/skill-health/ranking.md`. Also scan `skills/*/SKILL.md` for a missing `## Do not` section.
2. If there is no `low_score` or `failing` flag AND every skill has `## Do not`, write `EVOLVE_OK - nothing to propose` and stop.
3. Prefer a `low_score` or `failing` skill. Otherwise pick one skill whose `SKILL.md` lacks `## Do not`. Skip heartbeat unless it is actually broken. Ignore `no_completed_run`.
4. Read that skill's `SKILL.md` and recent `output/<skill>/` plus the matching score JSON if it exists.
5. Read and retain the exact content of the target file, then make one small, reversible edit in `skills/<that-skill>/`. Examples: add a missing "Do not" section, tighten an ambiguous success line, fix a format the scorer already dinged.
6. Re-read the file after writing and compare it with the retained content. If the bytes are identical, that file did not change: do not count or claim it as an edit. If no file changed at all, make the evidence-backed target edit or write `EVOLVE_OK - nothing to propose`.
7. Write `output/evolve/latest.md` describing only the file whose content actually changed, in 5 lines: skill, flag or missing Do not, what you changed, why, how to revert.
8. Your final message is that description.

MiniAeon copies mutation files onto a branch and opens a PR when `allow_prs = true`. Auto-merge is always off.

## Do not

- Do not edit `aeon.toml`, `AGENTS.md`, `STRATEGY.md`, `soul/`, `.github/`, `cmd/`, `internal/`, or plugins.
- Do not change write_scope, role, risk, grants, schedules, or capabilities.
- Do not widen tools.
- Do not add a new skill.
- Do not send Telegram or Slack yourself.
- Do not merge, push, or run `gh`. MiniAeon opens the PR after you exit.
- If the fix is not obvious from evidence, write `EVOLVE_OK - nothing to propose` and stop.
