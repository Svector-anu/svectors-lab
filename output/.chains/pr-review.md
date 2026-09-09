**Verdict**: blocked: bare shadow selectors bypass isolation

- [CRITICAL] `scripts/resolve-riva-capabilities.sh:7` — Bare `shadow` / `compare` selectors retain write tools and declared credentials, violating comparison-only isolation.
- Posted the consolidated review and [inline finding](https://github.com/aeonfun/aeon/pull/1039#discussion_r3970106537).
- All five Riva tests and the existing PoC-gate suite passed; direct selector testing exposed the bypass.
- Notification delivery failed because the external queue is read-only in this harness.
- Logged the review in [2026-09-09.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-09.md).

<!-- aeon-review:{"schema":1,"target":"aeonfun/aeon#1039","sha":"ae9a66834d8b30754d29c598bdc06c8a7e15c1ea","verdict":"blocked","critical":1,"issues":0} -->

## Summary

Reviewed 1 PR, skipped 0. One file was modified: `memory/logs/2026-09-09.md`. PR #1039 needs its selector guard and regression tests updated before merging.
