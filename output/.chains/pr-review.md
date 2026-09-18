⚠️ PR Review: svectors-lab#93

*PR Review — 2026-09-18*
Reviewed 1, skipped 0.
- Svector-anu/svectors-lab#93: blocked — 1 critical, 1 issue

**Verdict**: blocked: dead commit-safety guard in create-prove's nested dispatch

[CRITICAL] `skills/create-prove/SKILL.md:48` — the nested target-skill dispatch never sets a `prove-`-prefixed `dispatch_id`, so `aeon.yml`'s new commit-skip guard (`!startsWith(inputs.dispatch_id, 'prove-')`) never engages for it. The skill run being proved can still commit/push to the contributor's PR head branch that the proof is supposed to leave immutable — the SHA recheck in step 6 stops a false "proven" receipt, but the unwanted commit would already have landed.

[ISSUE] `.github/workflows/chain-runner.yml:640` — `proof-missing` isn't excluded from the skill-health lifetime ratio the way `no-action` is, even though create-prove's current scope (single-skill-file PRs only) means most real feature PRs — multi-file changes like this PR itself — will hit `PROVE_UNSUPPORTED` and land here as `proof-missing` on every run, dragging down `chain:dev-loop`'s recorded reliability for scope reasons, not regressions.

Everything else checked out clean: dispatch budget accounting, receipt schema/parsing, the codex pending-dir write fix, and the doc/catalog counts.

Review: https://github.com/Svector-anu/svectors-lab/pull/93#pullrequestreview

🔗 https://github.com/Svector-anu/svectors-lab/pull/93