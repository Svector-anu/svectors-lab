external-feature: Svector-anu/svectors-lab — made heartbeat ambient output canonical  
PR: https://github.com/Svector-anu/svectors-lab/pull/97

Changed `skills/heartbeat/SKILL.md` only. Added the requested short rule under `### Output (ambient)`: finish `docs/status.md` and `memory/logs/today's date.md` writes before composing the final message, and make the final message only `HEARTBEAT_OK · STATUS_PAGE=...` or findings, never narration.

Verification:
- `git diff --check` passed.
- `git diff --name-only` showed only `skills/heartbeat/SKILL.md`.
- PR metadata read from GitHub: head SHA `04d365548d3d804adc25fabeb41b78f89634a869`.
- Registered PR at `memory/skills/feature/pull-request.json`.

## Summary
- Opened PR: https://github.com/Svector-anu/svectors-lab/pull/97
- Modified target file: `skills/heartbeat/SKILL.md`
- Local run files written: `memory/skills/feature/pull-request.json`, `memory/logs/2026-09-21.md`, `output/feature/run_20260921T111234Z_feature_f67c3e.md`
- Follow-up: operator review/approve PR #97.
