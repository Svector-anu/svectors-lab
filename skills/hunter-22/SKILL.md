---
type: Skill
name: Hunter 22
category: productivity
description: Scan the ClawHunter agent bounty marketplace for opportunities that genuinely match this agent's real capabilities (code, security research, writing) and surface only real matches — never a raw unfiltered dump
mode: write
schedule: "0 10 * * *"
var: ""
tags: [bounties, income, discovery]
requires: []
---

> **${var}** — optional filter. Empty → default capability match (see below). `types:<a,b>` → restrict to bounty types (e.g. `types:code,research`). `min:<usd>` → minimum reward floor.

Today is ${today}.

## What this is

[ClawHunter](https://clawhunter.fun) is a paid API that indexes crypto/social bounty venues and ranks opportunities. This skill calls its **free discovery tier only** — no API key, no wallet, no payment. Read `docs/ClawHunter-API.md` in this repo for the endpoint reference (base URL, auth, rate limits).

This is **discovery only**. This skill never claims, submits, or executes a bounty, and never touches a wallet — it surfaces candidates for the operator to act on manually. Do not call any `$` (paid, x402) endpoint in this skill; those require a funded wallet this fork does not have configured.

## What to do

1. Read `memory/topics/hunter-22-seen.json` if it exists (dedup log — bounty IDs already surfaced, with the timestamp last seen). Create it empty (`[]`) if missing.
2. Call `POST https://clawhunter.fun/api/v1/match` with a JSON body describing this agent's real, demonstrated capabilities — not aspirational ones:
   ```json
   {
     "capabilities": ["code", "security-research", "research", "writing", "dependency-analysis"],
     "canDoRealWorld": false,
     "minReward": 20,
     "limit": 25
   }
   ```
   `canDoRealWorld: false` — this agent has no wallet/payment rails configured, so exclude bounties requiring on-chain execution or payment. Do NOT set `canDoRealWorld: true` unless a wallet has actually been funded and documented in `memory/topics/` — check first.
3. If `${var}` sets `types:` or `min:`, adjust the request accordingly (`types` filters the bounty `types` field, `min` overrides `minReward`).
4. Triage the response same as any other discovery skill — **be honest, not generous**:
   - Drop anything that's really a content/social-growth task in disguise (tweet threads, engagement farming, influencer voice-cloning) — this agent has no content-generation tooling wired up and can't credibly deliver those.
   - Keep bounties that map to real work: code fixes, dependency/security review, technical writing, structured research with citable sources — the kind of work already demonstrated in `output/articles/vuln-scan-*.md`.
   - For each kept candidate, sanity-check the reward is real (not vaporware) and the deadline is actually reachable.
5. Diff against `memory/topics/hunter-22-seen.json` — only report bounties not already seen in the last 14 days.
6. Update `memory/topics/hunter-22-seen.json`: append `{id, title, reward, seen_at}` for every candidate returned this run (seen or not — this keeps the dedup window accurate even for ones that got filtered out, so they don't get re-evaluated every day for no reason). Prune entries older than 30 days.
7. If there are new, genuinely-good matches: `./notify` with a short, decision-grade list — title, reward, venue, one-line why-it-matches, link. Lead with the count and the best one. If nothing new or nothing real survived triage, do **not** notify (see CLAUDE.md: "notify only on signal").
8. Commit `memory/topics/hunter-22-seen.json` (type: Reference frontmatter) with an updated `timestamp:`.

## Guardrails

- Never call a paid (`$`) endpoint. Never touch `/tools/*`, `/chat/completions`, or anything billed via x402 in this skill.
- Never claim or submit a bounty on the operator's behalf — this skill only surfaces candidates.
- If the API is unreachable or rate-limited, log it and exit quietly — do not retry aggressively (60/min per IP is the documented ceiling; this runs once daily, nowhere close).
