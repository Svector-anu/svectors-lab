## Tweet Drafts: AI agent token costs vs. autonomy

### Tier 1 — One-liner
**1a. Hot take**
> your agent's real cost isn't the subscription, it's the token meter

**1b. Data drop**
> openai researchers went $162/day to $600/day on agent tokens. one month. 4x.

### Tier 2 — Two-punch
**2a. Observation**
> openai's own researchers 4x'd their token spend in a month chasing agent throughput. top 10% burn $7k/day and still need a human to close the task.

**2b. Sardonic/ironic**
> 3.1 agent-workdays per human day sounds great until you see the bill. someone's paying $7k/day just to babysit a subagent across the finish line.

### Tier 3 — Paragraph
**3a. Reframe**
> everyone benchmarks agent output against human output. nobody benchmarks agent output against agent cost. openai's heaviest users burn $7k/day in tokens, and over half the long tasks still need a human to land them. that's not autonomy, that's an expensive intern.

**3b. Narrative**
> watched a dev orchestrate 49 subagents in parallel for 2.5 hours. estimated cost: $8k-15k. a finance team let 23 subagents run unattended for 3 days and racked up $47k. the agents worked fine. nobody was watching the meter.

### Tier 4 — Long tweet
**4a. Data-driven**
> openai's median researcher now spends $600/day running coding agents against openai's own models, up from $162/day in july. the heaviest 10% burn past $7,000/day. openai frames this as 3.1 agent-workdays per human 8-hour day since june. the catch buried in their own numbers: over half of the successful long-running agent tasks still needed a human to land them. running a fleet of these things is less "hire an intern" and more "hire an intern who bills by the token and still needs you to sign off." the productivity is real. so is the invoice.

**4b. Builder's breakdown**
> a dev orchestrated 49 subagents in parallel for 2.5 hours and burned an estimated $8k-15k in one session. a finance team let 23 subagents run unattended for 3 days and racked up $47k. agent costs don't look like chat costs, they stack: parallel calls, thinking tokens billed at output rates, long context reruns. the fix isn't fewer agents, it's actually watching the meter while they run. learned this running my own fleet across a few harnesses. credits disappear faster than you'd think.

### Tier 5 — Thread opener
**5a. Thesis-first**
> openai's own researchers 4x'd their agent token spend in a month. the heaviest users now burn $7k/day. and over half their long tasks still need a human to close them out. the bill for "autonomous" agents is arriving before the autonomy is.
---
- the numbers: $162/day → $600/day median researcher spend, 4x in one month (july to now)
- top 10% of users now burn past $7k/day
- openai's framing: 3.1 "agent-workdays" logged per human 8-hour day since june
- the catch buried in their own report: over half of successful 4-8hr agent tasks still needed a human to land them
- outside proof it's not just openai: 49 subagents/2.5hrs = $8-15k one session, 23 unattended subagents/3 days = $47k

**5b. Question**
> if an agent needs a human to land the task half the time, is it still autonomous, or just an expensive assistant with a token bill?
---
- openai's own admission: over half of successful 4-8hr agent tasks needed human intervention to close
- meanwhile spend 4x'd in a month, top users now past $7k/day chasing throughput
- real-world proof outside openai: 49 subagents/2.5hrs = $8-15k, 23 unattended subagents = $47k/3 days
- the pattern: cost is scaling faster than autonomy is
- running my own fleet across harnesses — the credits math matters as much as which model you pick

---

**Best overall:** 3a — sharpest reframe, fully self-contained, lands the "expensive intern" line without needing the numbers spelled out.
**Best per tier:** 1a (one-liner, cleanest hook) · 2b (two-punch, sharpest wit) · 3a (paragraph) · 4b (long tweet, ties in personal fleet-operator experience) · 5a (thread opener, strongest concrete hook)

**Sources:** OpenAI internal token-spend disclosure via Startup Fortune / IT Pro (median researcher $162→$600/day, top 10% >$7k/day, 3.1 agent-workdays/human-day since June, >50% of long tasks needed human intervention); CloudZero / Finout Claude Code pricing writeups (49-subagent $8-15k single session; 23-subagent $47k/3-day finance-team overrun). Path A (XAI x_search) attempted, failed http-403 billing-exhausted (10th+ consecutive failure today across the fleet) — fell back to WebSearch per skill fallback rules.
