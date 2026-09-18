# PRD: F-006 Aeon Engineer

Full stories, acceptance criteria, and verification commands live in `docs/product/feature-map.md`; this file adds what that one doesn't carry: the actual setup instructions, and the engineering reasoning behind what's built versus what's deliberately deferred.

## Dependencies

- Depends on: `F-001` (dev-loop chain, the loop itself), `F-003` (pr-review, the independent verifier), `F-004` (skill-health/skill-repair, keeps the dependencies healthy), `F-005` (multi-surface dispatch, so capability scoping holds if this is ever triggered from somewhere other than a direct Actions dispatch).
- Blocks: nothing yet. Nothing else in this repo depends on Aeon Engineer having its own identity.

## What "Aeon Engineer" actually is

Not a new skill, not a new workflow, not a new agent. It's a name for a composition that already existed in pieces: `feature` builds, `pr-review` verifies independently, `dev-loop`'s bounded repair pass fixes what review catches, `skill-health`/`skill-repair` keep those three healthy. This PRD and `F-006`'s feature-map entry are the first place that composition got written down as one thing with one acceptance bar, rather than four separate features nobody was asked to think about together.

## How to point it at a repo today

This is the real, current, manual procedure. Nothing here is aspirational.

1. **Confirm push access.** The operator's GitHub account must have push access to the target repo. `scripts/dev-loop-pr.sh validate-owned-target` enforces this before anything runs; there's no way to dispatch against a repo you don't own.
2. **Dispatch the chain**, either via the GitHub Actions UI (`Actions` -> `Aeon · Chain Runner` -> `Run workflow`, fields `chain: dev-loop` and `target: external:<owner>/<repo>`), or:
   ```bash
   gh workflow run chain-runner.yml -f chain=dev-loop -f target=external:<owner>/<repo> --repo <this-repo>
   ```
   Use the workflow **filename** (`chain-runner.yml`), not the display name ("Aeon · Chain Runner") - the display name has spaces and a unicode character that are easy to mangle when typed or pasted, and `gh` will reject the resulting argument split with a confusing "accepts at most 1 arg(s)" error that has nothing to do with permissions or the workflow itself.
   When typing the `chain` and `target` fields directly into the GitHub web form, type them fresh rather than pasting - a single stray leading space fails the workflow's own strict `^[a-zA-Z0-9_-]+$` validation on the chain name (deliberate hardening against GHSA-h9v2-7m42-33m3, not a bug to work around).
3. **Wait.** `feature` typically takes 5-8 minutes to pick a task and open a PR; independent `pr-review` takes another 3-5 minutes once dispatched. A bounded repair pass, if review comes back actionable, adds roughly that much again. Budget 10-20 minutes for a full run.
4. **Read the result**, not just the exit status. `CHAIN_STATUS=success` requires a PR link, an independent PASS receipt, and a SHA-bound behavioral proof receipt. `CHAIN_STATUS=proof-missing` means review passed but the changed behavior was not exercised or no valid evidence was captured. `CHAIN_STATUS=no-action` means `feature` genuinely found nothing worth doing - not a failure. `CHAIN_STATUS=failed` means something else broke; the run's log names exactly what (a dead harness credential, a timeout, a verification mismatch), not a generic error.
5. **Merge is yours.** Nothing in this loop merges a PR on its own. That's a deliberate boundary, not a missing feature; see `ARCHITECTURE.md`'s note on Rule 3.

## What's deliberately not built yet

**Telegram-triggered chain dispatch.** The roadmap names "Telegram as primary interaction" as part of what packaging this feature should eventually mean. It doesn't today. The existing force-reply mechanism (`apps/webhook` -> `messages.yml` -> `aeon.yml -f skill=... -f var=...`) reaches exactly one skill per reply; `chain-runner.yml` is a different workflow with its own `chain`/`target` inputs that nothing currently populates from a Telegram reply. Building this is a real, scoped, separate piece of work: it needs `messages.yml`'s router to recognize a new marker shape (something like `[dev-loop::ship]`) and dispatch `chain-runner.yml` instead of `aeon.yml` when it sees one, plus something that actually offers that force-reply prompt in the first place. Not started. Reported here rather than built silently, per this system's own scope-control discipline.

**Proof outside this repository.** Three dispatches on 2026-09-18 targeted other operator-owned repositories. The strongest, `Svector-anu/headless-harness-bench#1`, exercised build, target CI, independent review, and the bounded repair pass. The chain stopped honestly when re-review found a second issue beyond its one allowed repair. A human fixed that issue, after which independent run 35335046187 returned `approve-ready` with zero issues and the target checks passed. The branch was then submitted manually as `aaronjmars/headless-harness-bench#1` for upstream maintainer review.

That last handoff is outside the current Dev Loop. `scripts/dev-loop-pr.sh validate-owned-target` requires the operator to have push access to the target repository. Aeon Engineer does not currently create or select a fork and then open a cross-repository PR against an independently owned upstream. Do not describe the upstream PR as autonomous proof. It is evidence that the generated branch can survive independent review and upstream submission, while also exposing a distinct missing workflow.

**Live behavioral proof.** The Dev Loop now has a `create-prove` gate after the final clean `pr-review` and before success. For the first supported target shape, a PR changing one runnable Aeon skill, it dispatches that changed skill from the PR head through the real `aeon.yml`, waits for the correlated run, requires a successful conclusion and non-empty captured output, rechecks the immutable PR SHA, and posts a machine-readable proof receipt. Missing, stale, failed, empty, unsafe, or unsupported evidence ends as `CHAIN_STATUS=proof-missing`, not success. Conventional applications and workflow-only changes remain unsupported and fail closed rather than receiving speculative proof.

The gate was proven on 2026-09-18. Outer run 35345681403 targeted `Svector-anu/svectors-lab#94` at SHA `d26c4e685298494e98130268d69f33d0246e3af5`. It dispatched correlated `idea-pipeline` run 35345785449 with `offer:Svector-anu/svectors-lab`. That run confirmed push access, queued the `[dev-loop::ship]` force-reply, and the delivery step recorded Telegram message 362. The PR head remained unchanged, `create-prove` posted `verdict: proven`, and `scripts/dev-loop-proof.sh verify` accepted the receipt. This proves the Aeon-skill path only; it does not claim a generic application launcher exists.

## Engineering notes

The credential-diagnosis work from this session's evidence (dead `CODEX_AUTH`, traced to the exact `tar czf | base64 | gh secret set` fix) is worth keeping in mind for anyone extending this: CI-side harness auth for `codex` and `kimi` is captured once via `aeon auth --harness <name>` (an interactive OAuth flow) and stored as a repo secret that does not auto-refresh. It will go dead again, on a timeline outside this system's control, and when it does, `feature`'s default harness dying looks identical to a real code regression until someone reads the actual error. Diagnosing that correctly cost real time this session; a health check that distinguishes "the loop is broken" from "the loop's credential expired" would be valuable, but is explicitly not built here, matching the same discipline: reported, not invented.
