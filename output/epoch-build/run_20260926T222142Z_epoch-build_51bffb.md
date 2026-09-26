Log appended, PR registered. Full deliverable below.

## Result

**Order:** free-text operator instruction (no `order:` path). GOAL: add one short paragraph to `CHANGELOG.md` under `[Unreleased] -> Added`, recording that `epoch-spec`, `epoch-build`, and `epoch-review` landed with one clause each on what each does. SCOPE: `CHANGELOG.md` only. FORBIDDEN: `aeon.toml`, any skill, workflow, or script.

**Branch:** `epoch/changelog-epoch-skills`
**PR:** https://github.com/Svector-anu/svectors-lab/pull/103
**Head SHA:** `6cbf68648ee157eb811c436970b8324943bcdaf0`

**ACCEPTANCE:**
- Entry under `[Unreleased] -> Added` — met.
- One short paragraph, not separate bullets per skill — met.
- Names all three skills with one clause each — met.
- Only `CHANGELOG.md` touched — met, confirmed by `git status --porcelain`.
- `aeon.toml`/skills/workflows/scripts untouched — met, diff contains only `CHANGELOG.md`.

**VERIFY (verbatim):**
```
$ grep -n -i epoch CHANGELOG.md
14:- **Epoch engineering lifecycle skills: `epoch-spec`, `epoch-build`, and
15:  `epoch-review`.** `epoch-spec` turns an intent into durable project knowledge
16:  (map, spec, work orders) and a ranked candidate, never touching product code;
17:  `epoch-build` executes exactly one work order in an isolated checkout, proves
18:  it locally against the order's VERIFY line, and opens one PR for operator
19:  approval; `epoch-review` independently judges that PR against the order at a
20:  pinned head SHA and posts a receipt-bearing GitHub review the gate can act
21:  on.

$ git status --porcelain
 M CHANGELOG.md
```

**Left out:** nothing — the order's full scope (one paragraph) is fully delivered.

**Follow-up worth its own order:** none identified.

**Note:** `epoch-review` was already present in the repo at `main` HEAD (`eba00a2`, commit message names only `epoch-spec` and `epoch-build`, but the tree at that SHA already contains `skills/epoch-review/SKILL.md`) — confirmed by reading the file before writing the changelog clause, not inferred.

## Summary
- Cloned `Svector-anu/svectors-lab` blobless/shallow into `$MINIAEON_SCAN_DIR`, branched `epoch/changelog-epoch-skills`.
- Edited `CHANGELOG.md` only: one paragraph under `Unreleased -> Added` describing `epoch-spec`, `epoch-build`, `epoch-review`.
- Ran VERIFY (grep + git status) locally before pushing — both passed.
- Committed, pushed, opened PR #103, registered `memory/skills/epoch-build/pull-request.json`.
- Appended `### epoch-build` entry to `memory/logs/2026-09-26.md`.
- Follow-up: none. Merge is the operator's via `miniaeon approve`.
