# Aeon Engineer

An unattended software engineer that lives in a repository: point it at a task, it plans, builds, gets independently reviewed, fixes what review catches, and hands you a PR ready to merge.

This page is an honest showcase, not a pitch. It says what's proven, what isn't, and links to real evidence instead of asking you to trust a description.

## What it actually is

Not a new agent, not a new framework. It's four things this repo already built separately, named as one thing for the first time on 2026-09-18:

- **`feature`** plans and builds against a real target.
- **`pr-review`**, dispatched as a genuinely separate run with no access to the implementer's reasoning, verifies the result independently.
- **The `dev-loop` chain** binds those two together with one bounded repair pass: if review comes back actionable, one fix attempt, one re-review, then it's done, pass or fail, it never loops.
- **`skill-health` / `skill-repair`** watch the pieces this depends on and fix them when they degrade.

Full technical detail: [`docs/prd/feature-006-aeon-engineer.md`](prd/feature-006-aeon-engineer.md). Current status and acceptance criteria: [`docs/product/feature-map.md`](product/feature-map.md#f-006-aeon-engineer).

## The evidence, not just the claim

On 2026-09-17, dispatched for real against this repository. It found a dead CI credential blocking it entirely, that got diagnosed and fixed mid-session, then a clean run: `feature` read this project's own product docs, found a real, previously-flagged gap (an unaudited dispatch surface), built a fix for it, and opened [PR #83](https://github.com/Svector-anu/svectors-lab/pull/83). Independent review, a completely separate process with no visibility into how the fix was built, came back clean: `verdict: approve-ready, critical: 0, issues: 0, actionable: false`. No repair pass was needed. A human read it and merged it.

Total elapsed time from dispatch to a mergeable PR: about eleven minutes.

## What's not proven yet

- **It's only ever run against this repository**, which the operator already owns and knows well. Pointing it at a repo nobody's babysitting is a different, harder claim, and hasn't been tested.
- **You can't trigger it from Telegram yet**, despite that being the eventual goal. Today it's a GitHub Actions dispatch, manual, no exceptions. See the proposal at [`docs/prd/proposed-telegram-chain-dispatch.md`](prd/proposed-telegram-chain-dispatch.md).
- **The CI harness credentials it depends on go stale**, on a schedule outside this system's control, and nothing here detects that automatically yet. When they die, the failure looks like a code regression until someone reads the actual error. This session hit that twice, on two different harnesses, in two days.

## Try it, on a repo you own

```bash
gh workflow run chain-runner.yml \
  -f chain=dev-loop \
  -f target=external:<owner>/<repo> \
  --repo Svector-anu/svectors-lab
```

Budget 10-20 minutes. Read the result honestly when it's done: a real PR with a real independent PASS is success, a clean "nothing worth doing" is success, and a specific named failure is more useful than a silent one. Full walkthrough in the PRD linked above.
