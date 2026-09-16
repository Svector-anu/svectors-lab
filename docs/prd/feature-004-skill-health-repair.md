# PRD: F-004 skill-health + skill-repair

Full stories, acceptance criteria, and verification commands live in `docs/product/feature-map.md`; this file adds what that one doesn't carry.

## Dependencies

- Depends on: `memory/issues/` as the shared state store between the two skills (`skill-health` files and resolves, `skill-repair` reads and acts).
- Blocks: nothing directly, but every other skill's reliability signal flows through this pair; a bug here degrades the whole fleet's observability, not just itself.

## Engineering notes

The load-bearing design choice is systemic-first triage in `skill-repair`: before attempting a per-skill fix, it checks whether the same failure signature appears across multiple skills, and if so applies one shared fix (or files one shared issue) instead of N near-duplicate patches. This matters because the alternative (fix each symptom independently) produces a pile of small PRs that all touch the same root cause differently, which is worse for the codebase than one correct fix, not just slower.

The closed outcome-code vocabulary (`REPAIR_OK_FIXED`, `REPAIR_OK_SYSTEMIC`, `REPAIR_DIAGNOSED_NO_FIX`, `REPAIR_NO_TARGETS`, `REPAIR_DRY_RUN`, `REPAIR_BLOCKED`) exists so a repair run's outcome is scannable and comparable across runs, not a fresh paragraph of prose every time. `REPAIR_DIAGNOSED_NO_FIX` is the honest-failure case worth noting specifically: when the root cause needs operator action (an expired credential, an upstream outage), the skill says so and stops, rather than attempting a fix it can't actually make.
