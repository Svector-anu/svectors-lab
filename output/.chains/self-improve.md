Executed `self-improve` in default improve mode.

- Identified heartbeat’s persistent chronic-failure classification as the highest-impact issue.
- Proposed restricting it to currently unrecovered failures.
- Required dry-run failed: `non-zero exit (1)`.
- Reverted the proposed heartbeat change and opened no PR, as required.
- Logged the result in [memory/logs/2026-09-05.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-05.md).
- Preserved all pre-existing worktree changes.

## Summary

No production change was retained because the dry-run gate failed. The heartbeat chronic-failure signal remains a valid candidate for a future repair after diagnosing its dry-run failure.
