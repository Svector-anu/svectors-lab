tweet drafts: coding agent context is a privilege boundary

— one-liner —
1a. your coding agent's context is part of the attack surface
1b. we sandbox agent tools then hand random markdown root access

— two-punch —
2a. a coding agent reads repo instructions before it touches code. if that context is untrusted, the tool permissions come second.
2b. prompt injection is not just a chatbot problem anymore. once the model can run tools, inherited context becomes executable influence.

— paragraph —
3a. we audit what coding agents can execute but barely audit what they can inherit. repo instructions, saved memory, issue text and tool output all shape the next action. context needs trust levels too.
3b. your agent can have perfect tool permissions and still make the wrong privileged call. the missing control is provenance: where did each instruction come from, and was that source allowed to steer this action?

— long tweet —
4a. spent a lot of time making skills portable across agent harnesses. the security lesson is becoming obvious: context is not passive data. repo instructions, saved memory, issue bodies and tool output can all steer a privileged action. if the harness merges them into one prompt with no provenance or trust boundary, a tool sandbox only protects half the system.
4b. coding agent security cannot stop at "which tools can it call?"

the harder question is "who can influence the call?"

a restricted shell means little if untrusted repo text, persisted memory or fetched content can quietly become instructions. every context source needs a trust level, provenance and a clear rule for what it is allowed to steer.

— thread opener —
5a. coding agents do not just execute code. they execute context. repo instructions, memory and fetched text can all steer the same privileged tools, but most harnesses still flatten every source into one prompt.
5b. i think context provenance will become a core agent primitive. not another warning banner. every instruction should carry where it came from, how much it is trusted and which actions it can influence.

best: #4a — connects hands-on harness portability work to a concrete security model
