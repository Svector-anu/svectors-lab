HEALTH: CRITICAL(1)

- `vuln-scanner`: 14 consecutive failures; configured Grok model `grok-4.5` is unknown. Existing ISS-005 updated.
- Systemic: the same configuration error affects `pr-review`, now WARNING after its prior critical streak reset.
- Fleet: 14 degraded, 9 warning, 5 healthy, 0 no-data.
- Issues: 4 open, 0 filed, 0 resolved.
- Notification attempted but external queues were read-only; the previous notification timestamp was preserved for retry.

## Summary

Updated:

- `memory/skill-health/last-report.json`
- `memory/issues/ISS-005.md`
- `memory/issues/ISS-006.md`
- `memory/logs/2026-09-03.md`

Follow-up: replace or remove the invalid `grok-4.5` model configuration for `vuln-scanner` and `pr-review`.
