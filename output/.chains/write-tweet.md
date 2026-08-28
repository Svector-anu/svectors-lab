## Tweet Drafts: agent fleets are infrastructure

### Tier 1 — One-liner

**1a. Observation**

> one agent is a tool. a fleet is an operating system.

**1b. Reframe**

> the model is replaceable. the workflow around it is the moat.

### Tier 2 — Two-punch

**2a. Observation**

> running ten coding agents is easy. knowing what each changed, why it changed, and what is safe to merge is the actual product.

**2b. Sardonic**

> everyone wants more agents. then agent #4 overwrites agent #2 and suddenly the hottest feature is isolation.

### Tier 3 — Paragraph

**3a. Reframe**

> the next leap in coding agents will not come from a smarter chat box. it will come from the boring layer around the model: isolated worktrees, shared memory, review gates, retries, and a clean handoff when one harness fails.

**3b. Builder insight**

> i can swap codex for claude code faster than i can rebuild the workflow around either one. that is the point. models will keep changing. skills, memory, coordination, and recovery should survive the switch.

### Tier 4 — Long tweet

**4a. Structural critique**

> running one coding agent feels like using a tool. running several feels like operating a small engineering system.
>
> you need task boundaries, isolated worktrees, shared context, review gates, failure recovery, and a record of who changed what. without that layer, adding agents just creates faster confusion.
>
> the model matters. the control plane decides whether the fleet actually ships.

**4b. Reframe**

> people compare coding agents by benchmark scores. i care about a less glamorous test: can i move the same skill from codex to claude code to another harness without rewriting the whole workflow?
>
> models change. credits run out. providers fail. the durable asset is the work encoded around them—instructions, memory, verification, and recovery.
>
> harness portability is not a nice extra. it is how an agent fleet stays alive.

### Tier 5 — Thread opener

**5a. Narrative**

> i started running multiple coding agents for more throughput. the real lesson was not about speed. once agents work concurrently, coordination becomes the product.

---

- Why concurrency breaks single-agent workflows
- Isolation, ownership, and merge safety
- Shared memory without shared confusion
- Recovery when a harness or provider fails

**5b. Reframe**

> the most important part of an agent fleet is not the smartest model. it is everything that still works when you replace that model.

---

- Why model churn makes portability necessary
- What belongs in a reusable skill
- Memory and verification across harnesses
- The control plane as durable infrastructure

Best overall: **#3b**. Best per tier: **1a, 2b, 3b, 4a, 5a**.

## Summary

- Generated ten drafts across all five tiers, informed by current X discussion.
- Saved the revisable batch to [write-tweet-latest.md](/home/runner/work/svectors-lab/svectors-lab/memory/drafts/write-tweet-latest.md).
- Logged the run in [2026-08-28.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-08-28.md).
- Notification and revision prompt were attempted, but the external notification queue was read-only.
