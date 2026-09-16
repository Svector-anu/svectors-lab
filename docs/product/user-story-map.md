# User story map

How the operator actually experiences this instance, left to right across the journey. See `feature-map.md` for what exists; this shows how it connects into one experience.

```text
                              OPERATOR JOURNEY ->
        Configure -> Schedule/Enable -> Run -> Review Output -> Fix or Extend

MVP      [###############################################################]

Later    [...............................................................]
```

There is no meaningful "Later" or "Future" row for this instance in the MVP-planning sense the source document describes: this is a running production system, not a product being built toward a first release. The journey below is the actual current shape.

## Configure

| Step | Task | Feature | Status |
|---|---|---|---|
| Set north star | Write `STRATEGY.md` | roster: `strategy-builder` | shipped |
| Set voice | Populate `soul/` | roster: `soul-builder` | shipped |
| Set instructions | Edit `CLAUDE.md` | this repo's own hot memory | shipped |

## Schedule / enable

| Step | Task | Feature | Status |
|---|---|---|---|
| Pick capabilities | Enable a pack, flip individual skills on | roster: dashboard (`apps/dashboard`) | shipped |
| Wire multi-step work | Define a chain in `aeon.yml` | `F-001` | shipped |
| Connect entry points | Configure MCP server / webhook alongside cron | `F-005` | partial |

## Run

| Step | Task | Feature | Status |
|---|---|---|---|
| Scheduled or manual dispatch | Cron fires, or an operator triggers "Run now" | `F-005` | partial |
| Capability + secret resolution | Correct tier and only declared secrets, on every entry point | `F-005` | partial |
| Skill executes | Harness runs the skill's own `SKILL.md` instructions | roster (all 81) | shipped |

## Review output

| Step | Task | Feature | Status |
|---|---|---|---|
| Read the result | `./notify` fan-out, dashboard feed, `memory/logs/` | roster: various notify/dashboard paths | shipped |
| Independent check on a code change | Fresh-context review, not self-review | `F-003` | shipped |
| Cross-repo recap | What shipped, what's degrading | roster: `shiplog`, `skill-health` (`F-004`) | shipped |

## Fix or extend

| Step | Task | Feature | Status |
|---|---|---|---|
| Ship a feature/bugfix PR | Dev-loop chain, bounded repair | `F-001` | shipped |
| Self-heal a degrading skill | Systemic-first triage, per-category fix | `F-004` | shipped |
| Add a new capability | `create-skill`, `search-skill`, `install-skill` | roster (Evolution pack) | shipped |
| Contribute upstream | Port a genuine gap back to `aeonfun/aeon` | no dedicated skill; done manually this session (4 PRs, see `roadmap.md`) | n/a |

## What this map is missing, honestly

"Contribute upstream" has no dedicated skill, no scheduled cadence, and no feature-map entry of its own; it happened this session because a human asked for it, not because the system does it routinely. That's a real gap in the journey, worth a `templates/proposed-feature.md` entry rather than silently treating manual work as if it were a shipped capability.
