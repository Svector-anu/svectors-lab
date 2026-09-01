Ran `self-improve` in default improve mode.

Identified heartbeat’s lifetime success-rate calculation as the highest-impact issue. A targeted fix was proposed, but the mandatory synthetic dry-run failed with `non-zero exit (1)`. Per the fail-closed gate, the edit was reverted and no PR or notification was created.

The outcome was recorded in [memory/logs/2026-09-01.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-01.md:58). Pre-existing workspace changes were left untouched.

## Summary

- Proposed change: prevent historical harness failures from permanently marking recovered skills as chronically failed.
- Dry-run: failed.
- Final code changes: none.
- PR: none.
- Follow-up: diagnose the heartbeat dry-run failure before retrying this improvement.
