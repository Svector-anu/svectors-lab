**Verdict**: blocked: unrelated live model credentials can reach candidate skill code

- [CRITICAL] `scripts/dry-run.sh:45` — both credential families are globally exempted from synthesis, exposing unrelated real model credentials.
- [ISSUE] `scripts/dry-run.sh:155` — leading flag-shaped inputs such as `--survey` are misparsed as runner options.

Inline comments and consolidated review were posted. Exact-head tests and both CI checks passed.

<!-- aeon-review:{"schema":1,"target":"aeonfun/aeon#1029","sha":"14980edac3a772f577c94acb837d040ded7664f0","verdict":"blocked","critical":1,"issues":1} -->

## Summary

- Reviewed 1 PR; skipped 0.
- Updated `memory/logs/2026-09-05.md`.
- Notification delivery failed because the external queue filesystem is read-only.
