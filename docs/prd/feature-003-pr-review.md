# PRD: F-003 pr-review

Full stories, acceptance criteria, and verification commands live in `docs/product/feature-map.md`; this file adds what that one doesn't carry.

## Dependencies

- Depends on: nothing internal; it only needs a target PR to exist.
- Blocks: `F-001` (dev-loop) uses it as the review step; `auto-merge` (roster, Core pack) reads its verdict before merging.

## Engineering notes

`--survey` mode's risk-tiered bucketing (`CORE_REVIEW` > `INFRA_REVIEW` > `SKILL_PASS`/`SKILL_WARN_OR_BLOCK`) uses first-match-wins precedence deliberately: a PR touching both `aeon.yml` and a `skills/*/SKILL.md` is `CORE_REVIEW`, not `SKILL_PASS`, because the higher-blast-radius signal should win the categorization even though the PR also happens to touch something lower-risk. Getting this ordering wrong doesn't cause an error; it just quietly under-classifies risk, which is a harder failure mode to notice than a crash.

The SHA-pinning behavior (`AC-003.1.2`'s receipt binds to an exact commit) matters more than it looks: without it, a review dispatched against commit A could end up posting its verdict after commit B has already landed, silently reviewing the wrong code while claiming to have reviewed the PR.
