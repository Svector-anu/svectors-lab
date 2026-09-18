Shipped [nightshift-game PR #1](https://github.com/Svector-anu/nightshift-game/pull/1).

The pause menu now:

- Toggles with `Escape` or `P`
- Exposes proper labeled modal semantics
- Moves focus to Resume when opened
- Restores focus when gameplay resumes
- Documents the new control in-game and in the README

Verification passed:

- 15 unit tests
- Production build
- Full Playwright delivery flow with pause/focus assertions

The PR includes the required correlation receipt: `chain-90dc6fc5e336d16194f6289debc049e6`.

## Summary

- Created branch `ai/accessible-pause-dialog`
- Committed `b50c451`
- Opened PR #1 against `game/initial-import`
- Updated `memory/logs/2026-09-18.md`
- Queued the feature notification through the writable fallback queue
