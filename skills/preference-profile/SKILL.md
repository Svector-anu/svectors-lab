# preference-profile

Keep an inferred profile of the operator (`memory/me.md`) current, learning from what they actually approve and upvote versus reject and downvote. The profile helps every other skill lead with what this operator repeatedly cares about. Each run may be a fresh process with no conversation history; the ledger and `memory/me.md` are the source of truth.

## Inputs and boundaries

- The reward signal is the operator's own history, not your guess. Run `miniaeon profile` to read the reaction/approval tally (per skill, plus recent signals) and `miniaeon profile --json` when you want the raw numbers.
- Read the current `memory/me.md` first if it exists. You are updating it, not rewriting it from scratch.
- Write only `memory/me.md` and this skill's own memory. Do not edit `aeon.toml`, `AGENTS.md`, `STRATEGY.md`, `soul/`, other skills, or MiniAeon source. Do not send Telegram or Slack.

## What to infer

From the signal, update `memory/me.md` with what the evidence supports:

- **Cares about**: skills and topics the operator consistently upvotes or approves. Weight recent signals over old ones.
- **Avoids / dislikes**: what they consistently downvote or reject, and any pattern in why (if the run records or approval detail show it).
- **Working preferences**: cadence, depth-vs-breadth, format, tone - only where repeated behavior shows it, not from a single run.
- **Constraints**: hard limits the operator's decisions reveal (a spend ceiling implied by rejected costly work, channels they never engage).

## How to write it

- Keep `memory/me.md` concise and skimmable: short bullet lines under clear headings, newest-relevant first.
- Label every inference as inferred and date it, e.g. `- (inferred 2026-09-15, 4 approvals) prefers verified small wins over broad speculative sweeps`. A fact the operator stated directly can be unlabeled.
- Cite the evidence count so a reader can weigh it. One signal is an anecdote, not a preference; do not promote a single reaction to a rule.
- Never invent goals, secrets, or constraints. When the signal is too thin to conclude anything, say the profile is still forming and stop. Do not pad.
- Correct, do not accumulate contradictions: when new evidence overturns an old inference, update or remove the stale line rather than leaving both.

## Output

Write `output/preference-profile/latest.md` with:

1. what changed in `memory/me.md` this run (added, updated, removed);
2. the strongest current signals (top skills by approve/upvote and by reject/downvote);
3. what is still too thin to conclude.

If there were no new signals since the last run and `memory/me.md` already reflects the history, write a short silent-success result and change nothing.

## Do not

- Do not treat a single reaction as a durable preference.
- Do not invent preferences, goals, deadlines, or constraints the history does not support.
- Do not write anything but `memory/me.md`, this skill's memory, and its output.
- Do not include secrets or private third-party data in the profile.
