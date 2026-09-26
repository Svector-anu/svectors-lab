# Epoch

Epoch is this repo's dev-loop lifecycle: build a change, review it
independently, repair what review flags, prove the result behaves live, then
watch and ship it. The lifecycle has seven stages, always in this order:

1. **spec** — write the work order: goal, scope, acceptance criteria, and
   the exact commands that verify it.
2. **build** — execute one work order in an isolated checkout, verify it
   locally, and open one pull request.
3. **review** — an independent pass over that pull request, pinned to its
   exact head commit, separate from whoever built it.
4. **repair** — one bounded pass that addresses only what review flagged,
   authorized only by a review verdict bound to that same head commit.
5. **prove** — confirm the change behaves correctly against live, real
   behavior, not just a local check.
6. **watch** — observe the shipped change over time for regressions or
   drift.
7. **ship** — the operator merges. No stage in this lifecycle merges on its
   own behalf.

## What exists today

- **spec** and **build** exist, as the `epoch-spec` and `epoch-build` skills.
- **review**, **repair**, **prove**, **watch**, and **ship** do not exist yet
  as skills in this repository.

`epoch-build` also carries a bounded repair worker inside its own
`repair:<owner/repo#N>@<sha>` form, but a standalone `repair` stage, and the
`review`, `prove`, `watch`, and `ship` stages, remain unbuilt.
