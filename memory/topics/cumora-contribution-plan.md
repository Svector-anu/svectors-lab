---
title: cumora contribution plan
description: Ongoing, paced contribution strategy for yetone/cumora — credit status, pipeline, and cadence.
tags:
  - security
  - contribution-strategy
  - cumora
resource: https://github.com/yetone/cumora
timestamp: 2026-08-18T18:20:00Z
---

# cumora contribution plan

Goal: sustained, credited contribution to `yetone/cumora`, same spirit as the
eliza/asi grind loop but **not the same cadence** — the two repos aren't
comparable and treating them the same would burn the relationship. See
[eliza contribution notes] for the high-throughput model this deliberately
departs from.

## Why the pacing has to differ from eliza

- eliza/asi: large, heavily-automated review culture (bot reviewers like
  HomunculusLabs, dozens of contributors, high PR throughput is the norm).
  Sending many PRs a week blends in.
- cumora: 2,312 stars but only 2 watchers, **zero open PRs before ours**, no
  `CONTRIBUTING.md`/`CONTRIBUTORS.md`. yetone merged PR #8 himself, personally,
  same day. This reads as a solo (or near-solo) maintainer who ships fast but
  has no established outside-contributor pipeline yet.

Sending eliza-style volume (10+ PRs/week) here would look like farming, not
help. The lever that matters on a repo like this is **trust and
responsiveness**, not throughput. Pace to what one maintainer can absorb —
recalibrate upward only if his actual behavior (fast merges, engagement,
explicit "send more") signals he wants it, never assume it transfers from
eliza by default.

## Credit — status

- No `CONTRIBUTING.md` / `CONTRIBUTORS.md` / `AUTHORS` file exists on the
  repo — nothing to "add yourself to."
- Credit is automatic and already live: `Svector-anu` shows on the repo's
  GitHub contributors graph (`contributions: 1`) as of PR #8 merging
  2026-08-18T17:57:10Z.
- The only additional credit lever available is visibility — public X post
  tagging @yetone, which the operator is already doing per-merge.

## Pipeline (in priority order)

1. **User-reported open issues first** — highest relationship value; directly
   helps the maintainer, not just self-found scanner output. Check
   `gh issue list --repo yetone/cumora --state open` each pass.
   - **#2 "Login Issue on Google or Github Account"** (opened 2026-08-18) —
     a real bug report, live now. Strongest next candidate: reproduce, fix,
     PR referencing the issue directly.
   - #4 (Grok/xAI EngineAdapter for BYOA) and #7 (pi agent support) are
     feature requests, not bugs — lower priority unless scoped small and
     genuinely quick; don't force a feature PR just to pad volume.
2. **Security/dependency hygiene** (established pattern, already running via
   `vuln-scanner`'s 30-day dedup in `memory/vuln-scanned.json`) — re-scan
   periodically, catch newly-disclosed CVEs, catch anything that ages into
   PVR-eligible.
3. **The deferred tail from PR #8** — ~15 lower-severity/dev-tooling-only
   findings (esbuild, tar, ws, undici, shell-quote, protobufjs, ip-address,
   qs, brace-expansion, builder-util-runtime, app-builder-lib, @babel/core,
   @opentelemetry/core, body-parser, sharp) were deliberately left out to
   keep that PR reviewable. Revisit in a future pass, batched sensibly, not
   as 15 separate PRs.
4. **Electron upgrade — the flagship next contribution.** `electron@33.4.11`
   is flagged against 33 GHSAs, every fix needs **38.8.6+** (5 major
   versions). This is deliberately NOT a quick lockfile bump — it needs a
   real upgrade pass: breaking-change review across majors 34-38, full
   app build, manual smoke-test of the Electron shell, regression pass on
   anything touching `contextIsolation`/`sandbox`/IPC. Properly done, this
   is a much higher-trust contribution than a dependency PR — worth doing
   right rather than fast. Good candidate once the issue-#2 fix has landed
   and there's a read on how yetone responds to a second PR.
5. **Manual code-quality passes** — periodic deep review of a module
   (matching the general "break it, find it, fix it" ethos), but only file
   if a finding is real and defensible to yetone directly — never manufacture
   busywork to pad activity.

## Cadence

Target roughly **one well-verified PR every 1-2 weeks** to this repo
specifically, not a daily/eliza-style cadence. Re-evaluate after each PR:
fast merge + positive engagement → cadence can tighten; silence or friction →
slow down and stay high-signal only.

## Log

- 2026-08-18: PR #8 merged (axios/dompurify/nanoid/postcss CVE bumps),
  merged by yetone personally same-day. First contribution, credit live.
