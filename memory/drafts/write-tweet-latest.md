tweet drafts: agent fleets are infrastructure

— one-liner —
1a. one agent is a tool. a fleet is an operating system.
1b. the model is replaceable. the workflow around it is the moat.

— two-punch —
2a. running ten coding agents is easy. knowing what each changed, why it changed, and what is safe to merge is the actual product.
2b. everyone wants more agents. then agent #4 overwrites agent #2 and suddenly the hottest feature is isolation.

— paragraph —
3a. the next leap in coding agents will not come from a smarter chat box. it will come from the boring layer around the model: isolated worktrees, shared memory, review gates, retries, and a clean handoff when one harness fails.
3b. i can swap codex for claude code faster than i can rebuild the workflow around either one. that is the point. models will keep changing. skills, memory, coordination, and recovery should survive the switch.

— long tweet —
4a. running one coding agent feels like using a tool. running several feels like operating a small engineering system.

you need task boundaries, isolated worktrees, shared context, review gates, failure recovery, and a record of who changed what. without that layer, adding agents just creates faster confusion.

the model matters. the control plane decides whether the fleet actually ships.

4b. people compare coding agents by benchmark scores. i care about a less glamorous test: can i move the same skill from codex to claude code to another harness without rewriting the whole workflow?

models change. credits run out. providers fail. the durable asset is the work encoded around them—instructions, memory, verification, and recovery.

harness portability is not a nice extra. it is how an agent fleet stays alive.

— thread opener —
5a. i started running multiple coding agents for more throughput. the real lesson was not about speed. once agents work concurrently, coordination becomes the product.

---
- why concurrency breaks single-agent workflows
- isolation, ownership, and merge safety
- shared memory without shared confusion
- recovery when a harness or provider fails

5b. the most important part of an agent fleet is not the smartest model. it is everything that still works when you replace that model.

---
- why model churn makes portability necessary
- what belongs in a reusable skill
- memory and verification across harnesses
- the control plane as durable infrastructure

best: #3b — turns daily harness switching into a clear case for portable skills
