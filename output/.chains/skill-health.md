HEALTH: CRITICAL(20) — 19 enabled skills share a ChatGPT Codex WebSocket `401 Unauthorized` failure.

- Filed [ISS-007](/home/runner/work/svectors-lab/svectors-lab/memory/issues/ISS-007.md) covering 18 affected skills.
- Updated ISS-006 for `pr-review`’s new 401 signature.
- `vuln-scanner` remains separately critical due to the unknown `grok-4.5` model.
- 5 skills degraded, 2 warning, 3 healthy.
- Open issues: 4; resolved this run: 0.
- Notification queued after redirecting around the read-only workflow queue.
- Updated the issue index, health snapshot, and today’s activity log.

## Summary

Files modified:

- `memory/issues/INDEX.md`
- `memory/issues/ISS-006.md`
- `memory/issues/ISS-007.md`
- `memory/skill-health/last-report.json`
- `memory/logs/2026-09-17.md`

Primary action: restore the Codex/ChatGPT authentication session, then fix or replace the configured `grok-4.5` model.
