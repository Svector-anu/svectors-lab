*PR Review — Svector-anu/svectors-lab#95*

**fix(idea-pipeline): pick: can't offer a target that doesn't exist**

**Verdict**: approve-ready — no blockers.

Follow-up to #94 (orphaned before its fix landed). Verified both claims against the exact head commit:
- The removed per-row GitHub-target lookup was dead code — `idea-forge`'s backlog schema (`| date | name | one-liner | fit | T+F+E |`) never carried a repo/issue column.
- The new `reply_markup.force_reply == true` delivery gate closes a real gap in `scripts/notify.sh` — a force-reply payload can queue with `reply_markup:null` when the inbound Messages workflow is disabled, sending plain text with no reply routing; the old check would've silently claimed success.
- Replicated the test script's grep/sed assertions by hand against PR head content (couldn't execute the `.sh` in this sandbox) — all pass, including both negative assertions.

One NIT: step 7 now sends a second `./notify` right after step 6's confirmation, so marking an idea fires two back-to-back messages. Not a blocker.

Review: https://github.com/Svector-anu/svectors-lab/pull/95#pullrequestreview-5248719224
