## Tweet Drafts: agent skills are dependencies, not prompts

### Tier 1 — One-liner

**1a. Reframe**

> agent skills are dependencies with prose as executable code

**1b. Sardonic**

> if a skill can touch your shell, “just a markdown file” is doing a lot of work

### Tier 2 — Two-punch

**2a. Reframe**

> we keep reviewing agent skills like prompts. they can read files, call tools and run code, so the right model is a dependency with privileges

**2b. Observation**

> portable skills are great until trust becomes portable too. verify the author, pin the version and inspect what the skill can actually touch

### Tier 3 — Paragraph

**3a. Data drop**

> 26.1% of 31,132 agent skills in one study had at least one vulnerability. skills with scripts were 2.12x more likely to be vulnerable. the install button needs to become a security boundary

The figures come from a [large-scale empirical study of agent skills](https://arxiv.org/abs/2601.10338).

**3b. Reframe**

> signing proves who shipped a skill. it does not prove the skill behaves like its description. agent registries need both provenance and a claim-to-behavior check before install

### Tier 4 — Long tweet

**4a. Builder’s breakdown**

> an agent skill is not “just markdown” once the model can turn its instructions into shell commands, network calls and file access. traditional scanning catches suspicious code. it can miss a clean-looking instruction that makes the agent create the payload at runtime. verification has to cover metadata, scripts and natural-language behavior together

**4b. Observation**

> portable skills are the right direction. i want the same workflow to run across codex, claude code, grok, kimi and whatever comes next. but portability raises the trust requirement: pin the exact artifact, declare capabilities, scan code and instructions, then enforce those capabilities at runtime. otherwise we just made supply-chain risk portable too

### Tier 5 — Thread opener

**5a. Reframe**

> agent skills are becoming package dependencies, except one executable layer is written in natural language. our security tooling still mostly understands only the other layer

---

- How instructions become executable behavior
- Where code-only scanners go blind
- Why signatures solve integrity, not intent
- Controls that close the install-time and runtime gaps

**5b. Builder’s breakdown**

> the next useful primitive for agent skills is not another marketplace. it is a receipt proving the installed skill matches what was reviewed and stayed inside its declared capabilities

---

- Bind review results to an exact artifact
- Compare declared capabilities with observed behavior
- Enforce least privilege during execution
- Preserve evidence across updates and harnesses

Best overall: **#4b**  
Best per tier: **#1a, #2b, #3a, #4b, #5b**

## Summary

- Saved the revisable batch to [write-tweet-latest.md](/home/runner/work/svectors-lab/svectors-lab/memory/drafts/write-tweet-latest.md).
- Logged the run in [2026-09-03.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-03.md).
- xAI search returned HTTP 403, so public-search fallback was used.
- Notification delivery was attempted but failed because the harness’s external queue is read-only.
