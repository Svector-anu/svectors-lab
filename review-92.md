## PR Review — Svector-anu/svectors-lab#92

**fix(aeon.yml): restore cross-model independence for pr-review**

**Verdict**: approve-ready — no blockers.

Verified independently: CI run 35338667251 is a real, successful dispatch of `pr-review` against `headless-harness-bench#1`, matching the PR's claim that `harness: claude` was proven live before flipping the default. `claude` is a valid, wired harness value, and `feature` stays pinned to `codex` — so the two dev-loop halves are now genuinely different models instead of one reviewing its own sibling's work. Docs addition checks out and cites the same run ID.

Review posted inline on the PR.
