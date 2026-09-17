Self-improvement ran fail-closed.

- Targeted `vuln-scanner`’s rejected `grok-4.5` model routing.
- Proposed `grok-build-latest`, but the required synthetic dry-run failed: exit 124, empty output, and a control-plane-write violation.
- Reverted the configuration change.
- Opened no branch or PR.
- Logged the result in [memory/logs/2026-09-17.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-17.md).

## Summary

No production change was retained. Existing unrelated workspace changes were left untouched.
