⚠️ PR Review — aeonfun/aeon#1009

*PR Review — 2026-09-01*

Reviewed 1, skipped 0.

- aeonfun/aeon#1009: **blocked** — 1 critical, 0 issues

**Verdict**: blocked: multiline PR bodies break dispatch-marker verify

**Findings**:
- [CRITICAL] `scripts/dev-loop-pr.sh:46` — raw multi-line PR bodies are serialized into line-oriented TSV, so the `<!-- aeon-dispatch:… -->` marker misses `$2 == actor`, verify exits 3, and the chain soft-succeeds without running pr-review. Happy-path handoff silently no-ops on every real feature PR (tests only cover single-line bodies).

https://github.com/aeonfun/aeon/pull/1009

🔗 https://github.com/aeonfun/aeon/pull/1009