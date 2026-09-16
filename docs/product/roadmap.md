# Roadmap

What's being built now versus planned versus explicitly out of scope. This is a priority view over what `feature-map.md` already tracks in detail; reference the ID, don't duplicate the content.

## Now

| Feature | Status | Notes |
|---|---|---|
| `F-005` | partial | `apps/webhook`'s dispatch path hasn't been audited for the same capability/secret-scoping gap found and fixed on `apps/mcp-server` (2026-09-16). |

## Next

From the operator's own Aeon Engineer roadmap (tracked outside this file; see the operator's memory, not duplicated here since it predates and is broader than this feature map):

| Feature | Status | Notes |
|---|---|---|
| Aeon Engineer, Phase 2 (package) | planned | Package the proven dev-loop + skill-health/repair capabilities into a minimal, point-at-a-repo-and-leave pack for other repos. Not yet scoped as a feature-map entry; needs a PRD before work starts, per this system's own Rule 4. |
| Aeon Engineer, Phase 3 (prove unattended) | planned | Depends on Phase 2. |

## Later

None tracked in this file as of 2026-09-16. The Crypto & Markets and Productivity packs (30 skills combined) have no feature-map entries beyond the roster listing; that's not a roadmap gap so much as this file's own honest scope limit, see `feature-map.md`'s note at the top.

## Explicitly out of scope for now

- **Full PRDs for all 81 skills.** Not planned. Write one when a skill's behavior actually needs the discipline (an incident, a real bug, a significant change) rather than as a documentation exercise. See `references/scope-control.md` in the `product-feature-map` skill.
- **A dedicated "contribute upstream" skill.** Identified as a real gap in `user-story-map.md`; not built. See `docs/prd/proposed-upstream-contribution.md` for the actual proposal instead of silently building it here.

## Keeping this current

Update this file whenever a feature's status changes on `feature-map.md`. An entry that's been `shipped` or `deprecated` for a long time and is still listed here is drift Maintain mode's audit should catch.
