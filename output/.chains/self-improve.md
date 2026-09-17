Self-improve ran in default `improve` mode.

The highest-impact viable fix was a writable notification-queue fallback for `vuln-tracker`. The required synthetic dry-run timed out with exit 124 and empty output, so the change was reverted and no PR or notification was created.

## Summary

- Dry-run verdict: failed closed
- Production changes: none
- Log updated: [2026-09-17.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-17.md)
- Follow-up: investigate why `vuln-tracker` cannot complete the synthetic dry-run before retrying the delivery fix.
