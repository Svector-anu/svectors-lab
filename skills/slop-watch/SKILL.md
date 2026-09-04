---
name: slop-watch
description: Every morning, report which slop.cash contribution lanes are actually worth working today - per-lane liveness (is anyone merging?), the operator's current ordinal and what their NEXT merge is worth there, review feedback waiting on their open PRs, and any dormant lane waking back up. Discovery only - never opens, edits, or merges a PR.
metadata:
  title: Slop Watch
  mode: write
  category: productivity
  var: ""
  tags: [contribution, discovery, leaderboard, oss]
  requires: []
schedule: "0 8 * * *"
---

> **${var}** - optional scope. Empty → every tracked project. A project slug (`eliza`, `asi`, `delta-star`, `heir-elements-sdk`) → that lane only.

Today is ${today}.

## What this is

slop.cash pays for merged contributions across several tracked projects. Effort is worth wildly different amounts depending on **which lane** it goes into, and that changes week to week. This skill answers one question each morning: **where should today's effort go?**

It is **discovery only**. It never opens a PR, never edits code, never merges, never comments. It reports, and the operator decides.

## Why the ranking works the way it does

Two mechanics drive everything (both verified against `leaderboard.ts` in `elizaOS/army`, not assumed):

- **Merge points diminish within a project-month**: `max(1, ceil(10 / sqrt(ordinal)))` → 10, 8, 6, 5, 5, 5, 4… floor 1. The **ordinal resets every UTC month**, so the first merge of a new month is worth 10 again.
- **Caps are per project.** 25 merges spread over 3 projects far outscores 75 in one.

That makes "which lane, and what's my ordinal there" the whole game. But a high point value is worthless if nothing merges - so **liveness gates the recommendation**, always.

## What to do

1. Read `memory/topics/slop-watch-state.json` (prior snapshot, for change detection). Create as `{}` if missing.

2. **Resolve the tracked projects live - never hardcode repo paths.** List `projects/` in `SlopDotCash/slopdotcash` and read each `project.json`:
   ```bash
   gh api repos/SlopDotCash/slopdotcash/contents/projects --jq '.[].name'
   # Raw media type returns the decoded file directly - no local decode step.
   gh api "repos/SlopDotCash/slopdotcash/contents/projects/<slug>/project.json" \
     -H "Accept: application/vnd.github.raw"
   ```
   Record each project's `status`, `listingTier`, and `authority.state`. **This resolution step is not optional**: `elizaOS/asi` was transferred to `SlopDotCash/asi` (same repo id `1332593244`) and a hardcoded path would have silently tracked a redirect or nothing at all.

3. For each in-scope project, resolve its **actual repository** from the manifest, then gather (always pass `--limit 200`; `gh` silently truncates at 30 and every count then reads low):
   - **Lane liveness**: merged PRs by *anyone* in the last 7 days, and the date of the most recent merge.
   - **Merge rate**: `merged / (merged + closed-unmerged)` all-time. A low rate means PRs pile up unmerged.
   - **Operator's ordinal**: their merged PR count in that repo **this UTC month**.
   - **Their open PRs** there, and whether any carries a `CHANGES_REQUESTED` review.

4. Compute, per lane:
   - `next_merge_points = max(1, ceil(10 / sqrt(ordinal + 1)))` - what the operator's *next* merge there is worth.
   - `liveness`: **live** (merges by anyone in last 7d) · **slowing** (8-21d) · **dormant** (>21d or none).

5. **Rank by expected value, not raw points.** A dormant lane is not a recommendation no matter how high its `next_merge_points` - that is the trap this skill exists to prevent (`delta-star` looked like a 4x opportunity on points alone while sitting at a 36% merge rate with nothing merged in 12 days). Rank live lanes by `next_merge_points`, then list slowing lanes as watch-items, then dormant ones as one-liners only.

6. **Surface the things that are time-sensitive**, regardless of ranking:
   - any `CHANGES_REQUESTED` on the operator's open PRs (this is the highest-value action available - a near-merged PR beats a new one)
   - any lane that moved **dormant → live** since the last snapshot (a fresh uncapped lane waking up is the single best opportunity the scoring allows)
   - any project whose `authority.state` is not `verified`, or whose `status` is not `active` - flag once, don't repeat daily

7. Diff against the prior snapshot. **Notify only on signal** (per CLAUDE.md): a new `CHANGES_REQUESTED`, a liveness transition, a new tracked project, or the first run of a UTC month (ordinals reset - worth saying once). If nothing changed and nothing is waiting, write the state file and exit `SLOP_WATCH_QUIET` **without notifying**.

8. Write `memory/topics/slop-watch-state.json` with this run's snapshot per lane (`{slug, repo, ordinal, next_merge_points, liveness, last_merge_at, open_prs, changes_requested, checked_at}`) and commit it.

9. Keep the brief in captured output too, not just the notification - the dashboard, chains, and health scoring read captured output.

## Report shape

Lead with the single recommended lane and why. Then a compact table, then time-sensitive items. Decision-grade, not a data dump:

```
today: eliza — next merge worth 10 pts (ordinal 0, new month), 92 merges by others in 7d

| lane      | next | ordinal | liveness | last merge |
|-----------|------|---------|----------|------------|
| eliza     |   10 |       0 | live     | today      |
| asi       |   10 |       0 | dormant  | 15d ago    |
| delta-star|   10 |       0 | dormant  | 12d ago    |

waiting on you: PR #19330 has CHANGES_REQUESTED (2d)
```

## Guardrails

- **Read-only against every tracked project.** Never open, edit, comment on, review, or merge a PR. The only writes are this fork's own `memory/topics/slop-watch-state.json`.
- **Never recommend a dormant lane** on point value alone. Liveness gates the recommendation; say plainly when a high-value lane is not currently merging.
- **Never fabricate a rank, payout figure, or leaderboard position.** slop.cash is a client-rendered SPA that cannot be read by WebFetch - if a standing is not obtainable from the GitHub API, report it as unavailable rather than estimating.
- Never recommend volume for its own sake. Past ~25 merges in one project-month the marginal merge is worth 1 point; say so instead of encouraging a grind that reads as slop.
- If the manifest cannot be read, exit `SLOP_WATCH_TOOL_ERROR` with the real reason. Do not fall back to hardcoded repo paths - a stale path is how a moved repo goes silently untracked.

## Exit taxonomy

- `SLOP_WATCH_OK` - reported, notification sent.
- `SLOP_WATCH_QUIET` - checked, nothing changed and nothing waiting; no notification.
- `SLOP_WATCH_NO_PROJECTS` - manifest read but no active tracked projects found.
- `SLOP_WATCH_TOOL_ERROR` - the manifest or GitHub API could not be read.
