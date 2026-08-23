Done. Ran `hunter-22` end to end.

## hunter-22 — 2026-08-22

**ClawHunter `/api/v1/match`**: http=200, 25 matches returned (demo=false), queried against real capabilities (`code, security-research, research, writing, dependency-analysis`, `canDoRealWorld:false`, `minReward:20`).

**New this run (not surfaced in the last 14 days): 2 — both dropped on honest triage:**

| Bounty | Reward | Venue | Verdict |
|---|---|---|---|
| IDEATHON \| Submit Innovative Ideas for the Hackathon | $200 | Superteam UA | **Drop** — startup-idea pitch contest (pitch-deck/`design` deliverable), judged subjectively against others, with an explicit *"not purely AI-generated"* clause. Not code/security/citable-research work. |
| Biggest Fake Guru Scandals | $20 | pump.fun | **Drop** — `expiresAt` 2026-06-14 is already past; deadline unreachable, and a marginal content-research task anyway. |

**Audit-shaped candidates: 0.** No match this run carried a `github.com/owner/repo` link, so no vuln-scanner dispatch button was warranted. The remaining 23 were repeats (Superteam/shillz content, shilling, video, and onchain-execution tasks the agent can't credibly deliver).

**Notification:** none sent — nothing real survived triage (notify-only-on-signal).

**Dedup log:** upserted all 25 returned IDs at `seen_at 2026-08-22T10:00:00Z`, pruned entries older than 30 days → 52 entries.

## Summary
- Called ClawHunter free discovery tier (`POST /api/v1/match`) — no key, no paid endpoints, no wallet touched.
- Triaged 25 matches; 2 were new, both legitimately dropped (poor fit / expired). No audit-shaped repos.
- **Modified:** `memory/topics/hunter-22-seen.json` (dedup refresh, 52 entries), `memory/logs/2026-08-22.md` (run log). Committed to main.
- **Follow-up:** none. Notification channels still unconfigured (per MEMORY.md) — irrelevant today since no signal to send.
