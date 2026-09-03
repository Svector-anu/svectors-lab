HEALTH: CRITICAL(2)

- `vuln-scanner`: 7 consecutive failures.
- `pr-review`: 3 consecutive failures.
- Systemic cause: Grok Build returns HTTP 402 because its usage balance is exhausted.
- Degraded: 14 skills.
- Warning: 4 skills.
- Healthy: 9 skills.
- Open issues: 4; resolved this run: 0.

Filed [ISS-006](/home/runner/work/svectors-lab/svectors-lab/memory/issues/ISS-006.md) for `pr-review` and updated [ISS-005](/home/runner/work/svectors-lab/svectors-lab/memory/issues/ISS-005.md) with the new scanner failure signature. The [health snapshot](/home/runner/work/svectors-lab/svectors-lab/memory/skill-health/last-report.json) and issue index were updated and validated.

Notification delivery was attempted but failed because the external notification and json-render queues are read-only.

## Summary

- Status: critical
- Filed: `ISS-006`
- Updated: `ISS-005`, issue index, health snapshot, daily log
- Required action: replenish or reconfigure the Grok provider balance affecting both critical skills.
