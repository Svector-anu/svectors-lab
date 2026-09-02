## Tweet Drafts: coding agent context is a privilege boundary

### Tier 1 — One-liner

**1a. Observation**

> your coding agent's context is part of the attack surface

**1b. Sardonic**

> we sandbox agent tools then hand random markdown root access

### Tier 2 — Two-punch

**2a. Reframe**

> a coding agent reads repo instructions before it touches code. if that context is untrusted, the tool permissions come second.

**2b. Observation**

> prompt injection is not just a chatbot problem anymore. once the model can run tools, inherited context becomes executable influence.

### Tier 3 — Paragraph

**3a. Hot take**

> we audit what coding agents can execute but barely audit what they can inherit. repo instructions, saved memory, issue text and tool output all shape the next action. context needs trust levels too.

**3b. Question**

> your agent can have perfect tool permissions and still make the wrong privileged call. the missing control is provenance: where did each instruction come from, and was that source allowed to steer this action?

### Tier 4 — Long tweet

**4a. Narrative**

> spent a lot of time making skills portable across agent harnesses. the security lesson is becoming obvious: context is not passive data. repo instructions, saved memory, issue bodies and tool output can all steer a privileged action. if the harness merges them into one prompt with no provenance or trust boundary, a tool sandbox only protects half the system.

**4b. Reframe**

> coding agent security cannot stop at “which tools can it call?”
>
> the harder question is “who can influence the call?”
>
> a restricted shell means little if untrusted repo text, persisted memory or fetched content can quietly become instructions. every context source needs a trust level, provenance and a clear rule for what it is allowed to steer.

### Tier 5 — Thread opener

**5a. Observation**

> coding agents do not just execute code. they execute context. repo instructions, memory and fetched text can all steer the same privileged tools, but most harnesses still flatten every source into one prompt.

---

- How context sources acquire different trust levels
- Why tool permissions address only half the attack surface
- How provenance should follow instructions into tool calls
- Practical isolation rules for production harnesses

**5b. Prediction**

> i think context provenance will become a core agent primitive. not another warning banner. every instruction should carry where it came from, how much it is trusted and which actions it can influence.

---

- Why flat prompts erase security boundaries
- A capability model for context sources
- How inherited instructions should be constrained
- What harness builders can enforce today

Best overall: **#4a**. It connects hands-on harness portability work to a concrete security model.

Saved to [write-tweet-latest.md](/home/runner/work/svectors-lab/svectors-lab/memory/drafts/write-tweet-latest.md). Character limits and repository checks passed. The required X lookup returned HTTP 403; public search found no useful current discussion. Notification and revision-offer delivery were attempted but the external queue was read-only, and the outcome was recorded in [2026-09-02.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-02.md).
