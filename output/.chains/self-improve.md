Executed `self-improve` in default improve mode.

- Found a `hunter-22` run that attempted notification before final triage/dedup, despite zero reportable matches.
- Proposed a sequencing guard.
- Mandatory dry-run failed with invalid JSON handling, `non-zero exit`, and `empty output`.
- Reverted the proposed change and opened no PR, as required by the fail-closed gate.
- Logged the outcome in [memory/logs/2026-09-01.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-01.md).

## Summary

No production skill changes remain. Pre-existing `CLAUDE.md` deletion and untracked notification wrappers were left untouched.
