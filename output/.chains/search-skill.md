SEARCH_SKILL_OK_CANDIDATES

Gap: ambient fleet heartbeat monitoring is chronically degraded.

Candidate: `session-heartbeat` from `thrillmade/agent-skills` — gap-fit 3/5, score 15/15, UNTRUSTED/WEAK. It handles long-session checkpointing, not fleet-health monitoring, so it was not installed.

Manual review/install:

```bash
bin/add-skill thrillmade/agent-skills session-heartbeat
```

Catalogs: npx=fail, Vercel=9, Anthropic=20, Bankr=37, skills.sh=ok. The existing `heartbeat` skill was dropped as a duplicate. Notification delivery failed because the harness queue is read-only.

## Summary

- Installed: none
- Updated: [memory/logs/2026-09-08.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-08.md)
- Follow-up: manually review `session-heartbeat` before considering installation.
