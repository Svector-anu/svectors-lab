## Tweet Drafts: Huge models become storage systems

### Tier 1 — One-liner

**1a. Sardonic**

> the next ai hardware flex might just be a really fast ssd

**1b. Data drop**

> 744b models on consumer hardware changes what local ai even means

### Tier 2 — Two-punch

**2a. Observation**

> colibri runs a 744b moe across vram, ram and storage. turns out the bottleneck was not model size, it was moving the right experts fast enough

**2b. Reframe**

> we kept asking how much vram a huge model needs. colibri asks a better question: which tiny part of the model needs to be in vram right now

### Tier 3 — Paragraph

**3a. Hot take**

> a 744b model sounds like datacenter-only infrastructure. colibri streams inactive experts from disk and keeps only the active ones close. huge local models are becoming a systems problem, not just a gpu budget

**3b. Observation**

> local ai does not need the whole model sitting in vram. it needs the right weights available at the right moment. vram, ram and storage are starting to look like one inference memory layer

### Tier 4 — Long tweet

**4a. Reframe**

> colibri running a 744b moe on consumer hardware is a useful reframe. the machine does not need every expert loaded at once. it needs to predict which experts will be used, keep the hot ones nearby and stream the rest from disk. once vram, ram and storage become one managed layer, model size stops mapping directly to gpu size. the next local ai breakthrough might look more like an operating system than a new model

**4b. Builder’s breakdown**

> everyone compares local ai setups by gpu memory. colibri makes that number less useful. a mixture-of-experts model only activates part of itself for each token, so inactive experts can live on disk while the useful ones move through ram and vram. that turns 744b inference from an impossible allocation into a scheduling problem. fast storage and good orchestration can beat buying enough gpu to hold everything

### Tier 5 — Thread opener

**5a. Technical thesis**

> colibri is running 744b mixture-of-experts models on consumer hardware by treating vram, ram and storage as one system. this is less about fitting a huge model and more about moving the right experts at the right time

---

- Why MoE models only activate selected experts
- How weights move between storage, RAM, and VRAM
- Why expert prediction and caching matter
- What this changes for local AI hardware

**5b. Reframe**

> huge local models might not require huge gpus. they might require better scheduling. colibri streams inactive experts from disk, keeps hot weights close and turns 744b inference into a storage orchestration problem

---

- The limits of comparing setups only by VRAM
- Storage bandwidth as part of inference performance
- Scheduling as the real systems challenge
- Why local AI may become more hardware-accessible

Best overall: **#4a**. Best per tier: **#1a, #2b, #3a, #4a, #5b**.

## Summary

- Generated 10 drafts across five size tiers.
- Saved the revisable version to [write-tweet-latest.md](/home/runner/work/svectors-lab/svectors-lab/memory/drafts/write-tweet-latest.md).
- Logged the run in [2026-09-13.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-13.md).
- External notification and revision prompt were attempted, but their queue was read-only.
