**PR Review — Svector-anu/svectors-lab#94**

**Verdict: discussion-needed** — 0 critical, 2 issues

"feat: offer dev loop from selected ideas" extends `idea-pipeline` with two new Telegram force-reply entry points into `dev-loop::ship`: an `offer:<owner/repo>` producer boundary and an extension of the existing `pick:<idea>` handler. The `offer:` path — the one this PR's live proof run actually exercised — checks out: push-permission gated, and it verifies a real queued notification payload before claiming success.

The `pick:` extension is weaker:
- `skills/idea-pipeline/SKILL.md:46` — it inspects the selected backlog row for a GitHub target field, but the row schema (5 columns: date/name/one-liner/fit/T+F+E) never stores one — same schema in its only producer, `idea-forge`. The offer will never actually fire through this path.
- `skills/idea-pipeline/SKILL.md:54` — its `FORCE_REPLY_OFFERED` log claim has no delivery-verification gate, unlike the `offer:` path added in the same PR. Even that stricter gate can pass with `reply_markup:null` if the inbound Messages workflow is disabled — a real state `scripts/notify.sh` already handles elsewhere.

Posted 2 inline comments + 1 consolidated review: https://github.com/Svector-anu/svectors-lab/pull/94#pullrequestreview-5248258105
