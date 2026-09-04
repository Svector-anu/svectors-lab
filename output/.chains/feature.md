Fixed `Svector-anu/skopos#42` and opened [PR #109](https://github.com/Svector-anu/skopos/pull/109).

The change:

- Prevents SSR/client hydration mismatches by reading viewport and local storage after mount.
- Adds animation-frame cleanup.
- Removes unreachable default props and requires values already supplied by every call site.
- Includes the exact workflow correlation marker.

Verification passed: ESLint, TypeScript, 129/129 Vitest tests, and `git diff --check`. Vercel reported “Deployment was blocked,” while its Preview Comments check passed; this appears deployment-policy related rather than a code failure.

## Summary

- Created commit `42edd7a`
- Opened PR: https://github.com/Svector-anu/skopos/pull/109
- Updated [memory/logs/2026-09-04.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-04.md)
- Notification was attempted but external queues were read-only.
