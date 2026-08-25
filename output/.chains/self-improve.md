The self-improvement run completed fail-closed.

It identified `shiplog`’s incomplete captured output as the best targeted fix: the generated article was substantive, but the final response omitted its digest and evidence, resulting in a 2/5 quality score.

The proposed prompt fix was tested with synthetic credentials. The required dry-run failed with `non-zero exit (1)`, so the edit was reverted and no PR was opened. Existing unrelated workspace changes were untouched.

## Summary

- Logged the run in [2026-08-25.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-08-25.md).
- Dry-run verdict: `passed: false`.
- Source changes retained: none.
- PR created: none.
