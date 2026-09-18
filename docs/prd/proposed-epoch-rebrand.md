# Proposed: Epoch rebrand + estack rigor pack

Per `references/scope-control.md`: a naming and scope decision surfaced mid-conversation, recorded here rather than acted on unilaterally. Status: **naming decided in conversation, execution not started** — one blocking decision (below) is still open.

## Where this came from

An operator conversation with a different assistant (not this one) researched Devin and its competitors, then proposed a product identity for an Aeon-native equivalent, then proposed stealing specific workflow discipline from Lauren Tan's `pstack` (a Cursor plugin: router + playbooks + proof loop). Every claim below was independently checked against this repo's real code before being written down here — several of the external proposal's claims turned out to be false as stated, or already true in a different shape than proposed.

## Naming (decided, not yet executed anywhere public)

| Layer | Name | Status |
|---|---|---|
| Platform | Aeon | already the name |
| Product (the autonomous engineer) | Epoch | decided; **conflicts with already-shipped `docs/aeon-engineer.md` and the public Aeon Engineer landing page** |
| Internal rigor/discipline layer | estack | decided; never user-facing |
| User-facing command | `/epoch` | decided; not built |

**Blocking decision, not mine to make:** this repo already has a public landing page and `docs/aeon-engineer.md` published under the name "Aeon Engineer." The Epoch naming proposal explicitly rejects that name as "generic or copied." Renaming those live artifacts is a real, visible action (not a local file edit) and needs an explicit go-ahead before it happens. Until that happens, `F-006` in `docs/product/feature-map.md` and `docs/prd/feature-006-aeon-engineer.md` keep the Aeon Engineer name.

**Naming collisions found while checking this:**
- "Radar" (proposed for outer-loop ticket intake) is already two different things in this catalog: `bd-radar` (biz-dev lead-finding) and `mention-radar` (social mention monitoring). A third meaning under the same word is a real collision inside this repo's own skill roster, not just a vibe clash.
- "Fleet" (proposed for parallel agent slicing) isn't a new name to invent — `fleet-control` and `fork-fleet` already exist as real skills doing this.
- "Epoch" as a public product name has a plausible external collision (Epoch AI, a known name in AI research/forecasting). Not verified as a hard blocker, but worth an actual check before it's used publicly.

## Capability audit: what's real, what isn't (checked against code, not assumed)

| Proposed piece | Verdict | Evidence |
|---|---|---|
| Fleet (parallel agents) | **Already exists** | `fleet-control`, `fork-fleet` skills in `catalog/skills.json`; multi-harness dispatch already real |
| Nightshift (overnight/autonomous loop) | **Already exists, different name** | `aeon.yml` cron scheduling + `skill-health`/`skill-repair`'s self-heal loop is this mechanism today |
| Router (`/epoch`) | **Partially exists** | `chain-runner.yml` already dispatches a named sequence of skills; what's missing is a task-type classifier (bug vs. feature vs. investigate) in front of it |
| Atlas (feature map) | **Different from what exists, not a duplicate** | `docs/product/feature-map.md` (`product-feature-map` skill) is backlog/status truth. What's proposed as Atlas — path to reach a feature, how to drive it live, known traps — is an operational/verification runbook. Different job; worth building as a separate artifact, not merging into the feature map. |
| Restate-task-first, repro-before-fix | **Genuinely absent** | Grepped `feature/SKILL.md` and `pr-review/SKILL.md` for both — zero hits. Cheap, real gap. |
| "Uses the product map" | **Was false, now fixed** | Zero references existed in `feature/SKILL.md` as of 2026-09-18 morning. Fixed same day, merged as [#87](https://github.com/Svector-anu/svectors-lab/pull/87), verified via a live independent `pr-review` dispatch (not just CI) — see `docs/prd/feature-006-aeon-engineer.md`. |
| "Self improves" | **More true than first assessed — with a precise scope limit** | `self-improve` reads the same `memory/logs/` stream that `feature`/`pr-review` write to, on its own two-day cadence, and nothing excludes their `SKILL.md` files from what it can edit. Confirmed via real run history: two successful runs on 2026-09-17, each correctly identified a real problem (vuln-scanner model routing; vuln-tracker notification delivery), proposed a fix, and **correctly reverted both after a fail-closed synthetic dry-run gate rejected them** — it did not ship a broken fix either time. It has not happened to target `feature`/`pr-review` specifically yet (it picks the highest-impact issue fleet-wide, and something else was worse both times), and it explicitly cannot touch `.github/workflows/*.yml` — so it can fix Epoch's skill prompts but not `chain-runner.yml`'s orchestration. Both facts matter for an honest claim. |
| Prove (live evidence capture) | **Confirmed real gap — the one genuine miss in the whole proposal** | `pr-review` only deducts score for a missing screenshot/GIF; nothing runs the app and captures behavioral evidence. Everything downstream in the proposed plan (router, canons, merge gate) assumes this exists. It doesn't. See `docs/prd/feature-006-aeon-engineer.md`'s "Live behavioral proof" gap. |
| Epoch can start a task on its own | **Confirmed false** | `feature` and the `dev-loop` chain are both `schedule: "workflow_dispatch"` in `aeon.yml` — manual-trigger-only, no cron, and `chain-runner.yml` has no `issues:`/`issue_comment:`/`schedule:` trigger. `bd-radar` and `mention-radar` don't feed it either — checked, neither writes anything `feature` or `dev-loop` reads. This is the real gap the "Radar" idea correctly points at; it doesn't exist today in any form. |

## Recommended build order (narrower than the external proposal's 4-week plan)

The external proposal's instinct to gate Fleet/Nightshift-as-a-program behind proven trust is correct, and matches a discipline this codebase already has (`dev-loop`'s bounded repair pass: fail closed, never loop). But most of its v1 scope — router, canons/runs directory structure, Atlas — is inert without Prove; building ceremony around a hole isn't useful.

1. **Prove alone, first.** One skill (`create-prove` or similar) that, for a given app, launches it, drives one real user-facing path, and captures evidence (log, screenshot, or CLI output) as pass/fail. Wire it into `dev-loop` as a gate after `pr-review`, before merge.
2. Everything else — `/epoch` router, canons, runs, Atlas, task-starting intake — waits until that's proven on a real PR. Not because the ideas are bad, but because none of them have value until the one thing they all assume (proof) actually exists.

## Explicitly not started

`/epoch` SKILL.md, the four canons, the five runs, `create-prove`, `maintain-atlas`, the rename of Aeon Engineer to Epoch. Nothing here has been built except the one product-map fix noted above. Reported as a proposal, per this repo's scope-control discipline, not built silently.
