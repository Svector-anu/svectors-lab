Implemented issue #38 for Skopos and opened [PR #117](https://github.com/Svector-anu/skopos/pull/117).

The change replaces fragile wallet-error text matching with typed API error codes across automatic retries, persisted retries, specialized UI cards, and execution guards.

Verification:

- 189 tests passed across 13 files
- TypeScript passed
- Targeted ESLint passed
- Required correlation receipt included in the PR body
- Repository-wide lint retains two unrelated pre-existing errors

Notification delivery was attempted, but the harness notification queues were read-only.

## Summary

- Repo: `Svector-anu/skopos`
- Commit: `3380797`
- PR: https://github.com/Svector-anu/skopos/pull/117
- Updated `memory/logs/2026-09-18.md` with the result and correlation ID.
