# Roadmap

What's being built now versus planned versus explicitly out of scope. This is a priority view over what `feature-map.md` already tracks in detail; reference the ID, don't duplicate the content.

## Now

`F-006` (Aeon Engineer) is `partial`. This is Aeon Engineer Phase 2 (package the
proven `dev-loop` + `pr-review` + `skill-health`/`skill-repair` capabilities into
one named, documented thing), scoped as a real feature-map entry with a PRD on
2026-09-18, per this system's own Rule 4 rather than left as an undocumented
intention.

## Next

| Feature | Status | Notes |
|---|---|---|
| `F-006` -> `shipped` | in-progress | Needs `AC-006.1.1` exercised against a genuinely external repo (not this fork), not just re-confirmed here again. |
| Telegram-triggered chain dispatch | proposed | See `docs/prd/proposed-telegram-chain-dispatch.md`. Not started. |
| Aeon Engineer, Phase 3 (prove unattended) | planned | Depends on `F-006` reaching `shipped` first. |

## Later

None tracked in this file as of 2026-09-18. The Crypto & Markets and Productivity packs (30 skills combined) have no feature-map entries beyond the roster listing; that's not a roadmap gap so much as this file's own honest scope limit, see `feature-map.md`'s note at the top.

## Explicitly out of scope for now

- **Full PRDs for all 81 skills.** Not planned. Write one when a skill's behavior actually needs the discipline (an incident, a real bug, a significant change) rather than as a documentation exercise. See `references/scope-control.md` in the `product-feature-map` skill.
- **A dedicated "contribute upstream" skill.** Identified as a real gap in `user-story-map.md`; not built. See `docs/prd/proposed-upstream-contribution.md` for the actual proposal instead of silently building it here.
- **Telegram-triggered chain dispatch.** Identified while packaging `F-006`; not built. See `docs/prd/proposed-telegram-chain-dispatch.md`.
- **A standalone repo or public launch for Aeon Engineer.** Considered and deliberately declined on 2026-09-18: it stays inside this fork as `F-006`, one feature among the others, not a separate product with its own repo and marketing surface. See `docs/aeon-engineer.md` for the honest showcase instead.

## Keeping this current

Update this file whenever a feature's status changes on `feature-map.md`. An entry that's been `shipped` or `deprecated` for a long time and is still listed here is drift Maintain mode's audit should catch.
