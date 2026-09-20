# hunter-22

Scan the ClawHunter bounty marketplace for work that genuinely matches this agent's
real capabilities, and surface only real matches - never a raw unfiltered dump.

An `Operator var` is an optional filter: `types:<a,b>` restricts to bounty types,
`min:<usd>` sets a reward floor. Empty means the default capability match below.

## Do

1. Read `STRATEGY.md` and `memory/skills/hunter-22/seen.json` (the dedup log: bounty
   ids already surfaced, with the timestamp last seen). Treat a missing file as `[]`.
2. Read `docs/ClawHunter-API.md` for the endpoint reference. Call
   `POST https://clawhunter.fun/api/v1/match` with this agent's real, demonstrated
   capabilities - not aspirational ones:
   ```json
   {
     "capabilities": ["code", "security-research", "research", "writing", "dependency-analysis"],
     "canDoRealWorld": false,
     "minReward": 20,
     "limit": 25
   }
   ```
   `canDoRealWorld: false` - this agent has no wallet or payment rails configured, so
   exclude bounties requiring on-chain execution or payment.
3. If the Operator var sets `types:` or `min:`, adjust the request accordingly.
4. Triage the response. Be honest, not generous:
   - Drop anything that is really a content or social-growth task in disguise (tweet
     threads, engagement farming, influencer outreach). A `requires` array that is only
     `engage`/`outreach`/`video`/`image` with no `code`/`onchain` is the tell - this
     agent has no social-outreach tooling and cannot credibly deliver those.
   - Keep work that maps to real capability: code fixes, dependency and security review,
     technical writing, structured research with citable sources.
   - Sanity-check that the reward is real and the deadline is actually reachable.
5. Flag audit-shaped candidates: `requires` includes `code` or `onchain` **and** the
   bounty body or url contains a GitHub repo link. Extract `owner/repo` and name it in
   the report so the operator can run `miniaeon run vuln-scanner --var owner/repo`.
6. Diff against the dedup log - report only bounties not seen in the last 14 days.
7. Write `output/hunter-22/latest.md` and `memory/skills/hunter-22/latest.md`.
   Update `memory/skills/hunter-22/seen.json`: append `{id, title, reward, seen_at}` for
   every candidate returned this run, filtered or not, so the dedup window stays accurate.
   Prune entries older than 30 days.
8. Your final message is that report. MiniAeon delivers channels.
9. If nothing new survived triage, write `HUNTER22_OK - nothing new` and stop.

## Format

```
# Bounties - YYYY-MM-DD

N new matches.

## <title> - $<reward>
Venue: <venue> | <url>
Why it matches: <one line>
Audit target: owner/repo        (only when audit-shaped)
```

Lead with the count and the best match. One block per bounty.

## Do not

- Do not write outside `output/hunter-22/` and `memory/skills/hunter-22/` plus today's
  log heading.
- Do not call any paid (`$`, x402) endpoint, `/tools/*`, or `/chat/completions`. Free
  discovery tier only - no API key, no wallet, no payment.
- Do not claim, submit, or execute a bounty. This skill surfaces candidates only; acting
  on one is the operator's decision.
- Do not dispatch `vuln-scanner` yourself. Name the repo and let the operator run it.
- Do not send Telegram or Slack yourself.
- Do not report a bounty just to have something to report. Nothing new is a valid result.
- If the API is unreachable or rate-limited, write `HUNTER22_OK - api unavailable` and
  stop. Do not retry aggressively.
