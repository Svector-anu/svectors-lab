# Proposed feature

Per `references/scope-control.md`: an idea noticed mid-task, reported rather than built.

---

**Potential improvement discovered:** route a Telegram force-reply into a `chain-runner.yml` dispatch (e.g. `dev-loop`), not only into a single `aeon.yml` skill dispatch.

**Status:** Not currently in product map.

**Where this came from:** packaging `F-006` (Aeon Engineer) and checking the roadmap's own claim that "Telegram is the primary interaction" against what's actually wired. It isn't: `apps/webhook` forwards a classified update as a `repository_dispatch` event, `messages.yml` parses the `[skill::intent]` marker embedded in the prompt it's replying to, and dispatches exactly one skill via `aeon.yml -f skill=... -f var=...`. There is no path from a Telegram reply to `chain-runner.yml -f chain=... -f target=...`.

**Why it might be worth doing:** `dev-loop` (the chain that makes `F-006` real) currently requires the operator to open a GitHub Actions page or run a CLI command. Everything else about the "primary interaction is Telegram" story already works for single-skill dispatch; the chain is the one thing that doesn't fit it.

**Rough scope, if approved:**
- Extend `messages.yml`'s marker parser to recognize a chain-shaped marker (e.g. `[dev-loop::ship]`) distinctly from a skill-shaped one, and have it call `gh workflow run chain-runner.yml -f chain=... -f target=...` instead of `aeon.yml` when it sees one.
- Something needs to actually *offer* that force-reply prompt in the first place, mirroring the existing pattern `skills/feature/SKILL.md` already documents for its own `build:` marker (its comment names the sender as "`repo-scanner`'s offer," which does not match any current skill slug; that reference itself looks stale and is worth checking before building on it).
- Explicitly out of scope for this proposal: any change to how the chain itself runs, verifies, or merges. This is purely about the trigger surface.

**Action:** report as a proposed feature. Do not implement unless explicitly approved.

---
