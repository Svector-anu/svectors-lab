I'll read the skill definition and the usual Aeon context (memory, strategy, soul) so the run stays aligned.Next I'll load market context, soul voice, beat tracker, and today's log.F&G is 26 (≥ 25), so this run skips with no notification. Logging the skip.## Summary

**Skill:** fear-divergence  
**Result:** skipped — no notification

| Check | Value |
|--------|--------|
| Source | `memory/topics/market-context.md` (as of **2026-07-11**) |
| Fear & Greed | **26 (Fear)** |
| Trigger | F&G **&lt; 25** required to fire |
| Action | **FEAR_DIVERGENCE_SKIP** — above threshold |

**Details:**
- Condition not met (`26 >= 25`), so no divergence scan, no `./notify`.
- `market-context.md` is **17 days stale** (flagged in the log). Fresher narrative-tracker data from today still shows F&G **29** — would also skip.
- `beat-tracker.md` not present; not needed for a skip path.
- Soul files are empty templates; no voice override applied.

**Files modified:**
- `memory/logs/2026-07-28.md` — appended skip entry under `### fear-divergence`

**Follow-up:** Re-enable / refresh `market-context` so F&G and movers stay current. This skill only acts when F&G drops below 25.
