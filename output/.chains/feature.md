Shipped [Svector-anu/dieena PR #65](https://github.com/Svector-anu/dieena/pull/65).

The mobile client now requires enrolled device biometrics before submitting confirmation tokens for risky actions. Failed or canceled authentication remains fail-closed and preserves the token for an explicit retry.

Verification:

- Mobile TypeScript, formatting, and ESLint passed; one unrelated existing warning remains.
- Workspace typecheck and lint passed.
- All 390 tests passed.
- Logged in `memory/logs/2026-09-01.md`.
- Notification delivery was attempted but its external queue is read-only in this harness.

## Summary

- Branch: `external`
- Repo: `Svector-anu/dieena`
- Commit: `660832b`
- PR: https://github.com/Svector-anu/dieena/pull/65
- Follow-up: physical-device biometric and MWA verification remains required.
