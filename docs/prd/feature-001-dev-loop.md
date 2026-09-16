# PRD: F-001 Dev-loop chain

Full stories, acceptance criteria, and verification commands live in `docs/product/feature-map.md`; this file adds what that one doesn't carry.

## Dependencies

- Depends on: `F-003` (pr-review) as the review step; `scripts/skill_mode.sh` (`F-005`) for capability resolution on each dispatched step.
- Blocks: any future skill relying on a verified, self-repairing PR pipeline rather than a single-shot skill dispatch.

## Engineering notes

Implemented as a GitHub Actions workflow (`.github/workflows/chain-runner.yml`), not an agent-side loop: each step is a separate `aeon.yml` dispatch, correlated by a random hex ID embedded in the PR body as `<!-- aeon-dispatch:ID -->`. State between steps (feature output, review verdict) is passed via committed files under `output/.chains/`, not in-memory context, because each step is a genuinely separate process. `max_dispatches: 4` bounds the whole chain (feature, review, repair, re-review) so a misbehaving loop can't runaway-dispatch.

The repair-authorization chain is the part worth understanding before touching this: `scripts/dev-loop-review.sh verify` re-fetches the PR's current head SHA from GitHub and compares it to what was verified at dispatch time, so a repair can't be triggered by a review receipt that's gone stale (PR changed again since review posted) or forged (doesn't match what GitHub actually has on file).
