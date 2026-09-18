# Feature map

The canonical map of what this instance does. Source of truth for status; if code or a conversation disagrees with this file, this file is what gets corrected toward, except for scope and acceptance-criteria content, which only a human changes.

ID scheme: `F-NNN` for a feature, `US-NNN.S` for a story within it, `AC-NNN.S.C` for a criterion within that story. Status is one of `planned`, `in-progress`, `blocked`, `partial`, `shipped`, `deprecated`. Full definitions in the `product-feature-map` skill's `references/repo-memory.md`.

**Honest scope note:** this instance runs 81 skills across 6 packs. Five below are documented to full feature depth (real acceptance criteria, real verification commands, cross-referenced against this session's own work on them). The rest are listed at roster level: real slug and description pulled from `catalog/skills.json`, status `shipped` because they are live and scheduled, no fabricated acceptance criteria. Writing genuine ACs for all 81 would take real per-skill investigation this pass didn't do; claiming otherwise would be exactly the kind of invented completeness this system exists to prevent.

---

## Initiative: Autonomous software engineering (Dev & Code pack)

### F-001: Dev-loop chain

**Status:** shipped

**Epic:** Dev & Code
**Who it's for:** the operator, indirectly. Directly, it's for every other feature: this is the mechanism by which a feature PR gets built, reviewed, and (bounded) self-repaired without the operator driving each step.
**Problem it solves:** an agent that writes code and also declares its own code correct is not a trustworthy loop. A human reviewing everything an agent produces doesn't scale either.

**Stories**

- `US-001.1`: As the operator, I want a feature built and independently reviewed with no human in the loop, so a PR is either ready to merge or clearly blocked with a reason.
  - `AC-001.1.1`: `feature` and `pr-review` run as separately dispatched GitHub Actions runs, not one agent invocation.
  - `AC-001.1.2`: The review is bound to the PR's exact head SHA at dispatch time; if the SHA changes before review posts, the review aborts rather than reviewing stale or newer state.
  - `AC-001.1.3`: The chain's final status distinguishes success, failure, and no-action (feature produced no verified PR), not just pass/fail.

- `US-001.2`: As the operator, I want one bounded repair attempt when review comes back actionable, so a precisely-diagnosed issue doesn't require my manual intervention.
  - `AC-001.2.1`: Repair is authorized only by a fresh review receipt bound to the PR's current head SHA; a stale or mismatched receipt is refused.
  - `AC-001.2.2`: Exactly one repair pass runs. If re-review after the fix is still actionable, the chain fails; it does not loop.
  - `AC-001.2.3`: Dev-loop never dispatches against a repository the authenticated operator lacks push access to.

**Verification**

```text
AC-001.1.2: bash scripts/dev-loop-review.sh verify <owner/repo#N> <sha>
Expected: fails closed if head SHA has moved since dispatch

AC-001.2.1: scripts/tests/test_dev_loop_repair.sh
Expected: gate logic rejects stale/mismatched SHA and receipt, all cases pass

AC-001.2.3: scripts/tests/test_dev_loop_handoff.sh
Expected: "dev-loop: authenticated operator does not have push access to X" on an unowned target
```

**Evidence this session:** traced a real successful run (Actions run 34581075511, PR #76: feature, verify, review, no-action-needed, recorded, zero repair dispatched since review was clean). Separately, fixed a real bug in the review-result parsing on this fork (`fix(chain): stop jq consuming a corrupted REVIEW_RESULT default`, this fork's PR #80: a bash `${VAR:-{}}` gotcha corrupted the JSON `jq` parsed). That specific bug does not exist upstream; the version of this feature later ported upstream (this fork's own repair-pass work, dated before the buggy pattern was introduced) already used a safer form. What *was* missing upstream was the entire bounded-repair-pass feature itself, ported as aeonfun/aeon#1070 after finding upstream's chain-runner.yml lacked it completely (535 lines vs this fork's 701 at the time).

---

### F-002: vuln-scanner

**Status:** shipped

**Epic:** Dev & Code
**Who it's for:** open-source maintainers whose repos get scanned; indirectly, the operator, who owns disclosure decisions.
**Problem it solves:** most automated vuln scanning either drowns maintainers in false positives (pattern-match-only tools) or requires a human to manually reproduce every claim before it can be trusted.

**Stories**

- `US-002.1`: As a maintainer, I want a claimed High/Critical finding to come with actual reproduction, not just a pattern match, so I don't have to re-verify the scanner's own claims.
  - `AC-002.1.1`: A High/Critical finding cannot be filed without passing the PoC-verification gate (`scripts/vuln-poc-gate.sh`).
  - `AC-002.1.2`: An unreproducible finding is held as needs-verification, not silently downgraded or silently filed.

- `US-002.2`: As the operator, I want a stronger, structured research pass evaluated against the existing scanner without risking a live disclosure, so a genuine improvement can be adopted deliberately rather than by accident.
  - `AC-002.2.1`: `vuln-scanner var=shadow:<repo>` runs the Riva research kernel in parallel as a private comparison artifact; legacy scanning remains authoritative and no disclosure, PR, or PVR action fires.
  - `AC-002.2.2`: Shadow mode is credential-isolated on every dispatch surface: the harness gets `read-only` capability and every disclosure-capable credential is stripped from its environment before it starts, not merely told not to use them.

**Verification**

```text
AC-002.1.1: scripts/tests/test_vuln_poc_gate.sh
Expected: pass

AC-002.2.1: scripts/tests/test_riva_shadow_compare.sh, test_riva_shadow_guard.sh
Expected: pass, comparison-only, no side effects

AC-002.2.2: bash scripts/skill_mode.sh is-shadow vuln-scanner shadow  →  true
            bash scripts/skill_mode.sh mode vuln-scanner shadow      →  read-only
Expected: identical result on the aeon.yml path and the MCP-server dispatch path
```

**Evidence this session:** `AC-002.2.2` was false on the MCP-server path until 2026-09-16. Found via independent `pr-review` verification after this fork's PR #70 (Riva kernel) merged: the MCP dispatch surface never consulted the shadow-selector check, so a shadow run through MCP got full write tools and every live credential. Fixed in this fork's PR #81, ported upstream as aeonfun/aeon#1067. See `ARCHITECTURE.md`'s secret-scoping section for the general lesson.

---

## Initiative: Trust infrastructure (Basics pack, this specific skill)

### F-003: pr-review

**Status:** shipped

**Epic:** Basics
**Who it's for:** the operator, and any downstream repo whose PRs get reviewed.
**Problem it solves:** the same weakness F-001 names at the chain level applies standalone: a review from the same agent that wrote the code is not independent verification.

**Stories**

- `US-003.1`: As the operator, I want a fresh-context review that reads only requirements, the diff, and test results, so its verdict isn't contaminated by the implementer's own reasoning.
  - `AC-003.1.1`: Default mode reviews a specific PR (or every PR in `memory/watched-repos.md`) with severity-tagged findings and one verdict per PR.
  - `AC-003.1.2`: A verdict is posted as a structured, machine-checkable receipt (`<!-- aeon-review:{...} -->`), not only as prose.
  - `AC-003.1.3`: `--survey` mode produces a risk-tiered triage digest across every open PR on a target, bucketed by blast radius (CORE_REVIEW > INFRA_REVIEW > SKILL_*), for when the operator needs the morning-brief view instead of a per-PR verdict.

**Verification**

```text
AC-003.1.2: dispatched Actions run 35102570598 against this fork's PR #70
Expected: posted review contains a parseable aeon-review JSON comment with verdict/critical/issues fields
Actual: verdict=blocked, critical=1, issues=0, with a file:line-cited finding
```

**Evidence this session:** dispatched `pr-review` for genuine independent verification, not as a demonstration, three times today: once against PR #70 (harness `codex` failed on a dead CI credential, retried on `claude`, succeeded, run 35102570598, returned the receipt above), and twice against this fork's own fix PR #81 (both attempts failed on a `claude`/`bankr` gateway outage unrelated to the PR's content; that fix was merged on the strength of manual verification instead, noted honestly rather than claiming a review that didn't complete). The successful PR #70 review's specific, file:line-cited CRITICAL finding is what led directly to F-002's fix.

---

## Initiative: Self-maintenance (Evolution pack)

### F-004: skill-health + skill-repair

**Status:** shipped

**Epic:** Evolution
**Who it's for:** the operator, as a floor under every other skill.
**Problem it solves:** a fleet of 81 independently-scheduled skills will have some fraction silently degrading at any given time (an expired credential, an upstream API shape change) unless something is actively watching for it.

**Stories**

- `US-004.1`: As the operator, I want silent degradation detected and, where possible, fixed automatically, so I don't discover a broken skill only when I go looking for its output and find nothing.
  - `AC-004.1.1`: `skill-health` classifies every scheduled skill's recent runs, files an issue in `memory/issues/` on new failure, and resolves it automatically on recovery.
  - `AC-004.1.2`: `skill-repair` triages systemically first (a shared root cause across N skills gets one fix, not N patches) before attempting a per-skill fix.
  - `AC-004.1.3`: A repair run reports one of a fixed set of outcome codes (`REPAIR_OK_FIXED`, `REPAIR_OK_SYSTEMIC`, `REPAIR_DIAGNOSED_NO_FIX`, `REPAIR_NO_TARGETS`, `REPAIR_DRY_RUN`, `REPAIR_BLOCKED`), never free-form prose alone.

**Evidence this session:** this pattern (phased triage, a closed outcome-code vocabulary, systemic-before-per-skill) is what `references/self-maintenance.md` in the `product-feature-map` skill is directly modeled on. Read the real `skill-health`/`skill-repair` `SKILL.md` files while researching Maintain mode's design, rather than inventing a self-healing pattern from scratch.

---

## Initiative: Platform (Core pack)

### F-005: Multi-surface skill dispatch

**Status:** shipped

**Epic:** Core
**Who it's for:** every skill; this is the shared substrate they all run on.
**Problem it solves:** a skill's behavior (capability tier, secret access) needs to be identical regardless of which entry point dispatched it - a cron schedule, a chain step, an MCP tool call, a webhook - or the security model that holds on one path is fiction on another.

**Stories**

- `US-005.1`: As the operator, I want capability resolution to be one shared function every dispatch surface calls, not N independently-maintained copies, so a rule that holds on one path holds on all of them.
  - `AC-005.1.1`: `scripts/skill_mode.sh` is the single source of truth for a skill's capability tier, consulted identically by `aeon.yml`, `chain-runner.yml`, and `apps/mcp-server/src/skill-executor.ts`.

**Verification**

```text
AC-005.1.1: bash scripts/tests/test_skill_mode.sh
             bash scripts/tests/test_webhook_capability_path.sh
Expected: direct runners resolve through scripts/skill_mode.sh; the webhook remains
          a relay into aeon.yml and preserves the runtime selector (`var`)
```

**Evidence this session:** `aeon.yml` and `apps/mcp-server` both resolve direct
skill runs through `scripts/skill_mode.sh`. The webhook audit completed on
2026-09-17 and found no parallel skill executor: authenticated updates are
classified into `messages.yml`, its router dispatches `aeon.yml` with both the
skill and `var`, and that canonical workflow applies capability resolution,
secret scoping, and the harness sandbox. `test_webhook_capability_path.sh` now
locks that convergence and fails if the Worker grows a direct execution path.

---

## Initiative: Aeon Engineer (composition, Core + Dev & Code + Evolution)

### F-006: Aeon Engineer

**Status:** partial

**Epic:** cross-cutting (composes `F-001`, `F-003`, `F-004`, `F-005`; not a new subsystem)
**Who it's for:** an operator who wants a real task done on a repo they own, without driving each step themselves.
**Problem it solves:** `F-001` through `F-005` are each independently real and independently proven, but nothing before this named them as one coherent thing an operator could point at a task and use. This feature is that packaging, not new capability.

**Stories**

- `US-006.1`: As an operator, I want to point Aeon Engineer at any repo I own and get a verified result back, so I don't have to drive feature build, review, and repair myself.
  - `AC-006.1.1`: Given a target repo the operator has push access to, dispatching the `dev-loop` chain against it produces either a merge-ready PR carrying an independent PASS verdict, an honest no-action result, or a clearly blocked result. Never a silent failure.
  - `AC-006.1.2`: Setup requires no code changes to the target repo itself, only push access for the operator and a chain dispatch.

- `US-006.2`: As an operator, I want the skills Aeon Engineer depends on to self-monitor and self-heal, so a degraded dependency doesn't silently break it.
  - `AC-006.2.1`: `F-004` (skill-health/skill-repair) covers `feature` and `pr-review`, the two skills `F-006` depends on directly, with the same systemic-first triage as every other skill.

**Verification**

```text
AC-006.1.1: gh workflow run chain-runner.yml -f chain=dev-loop -f target=external:<owner/repo>
Expected: CHAIN_STATUS=success with a verified PR + PASS receipt, CHAIN_STATUS=no-action,
          or CHAIN_STATUS=failed with a specific error - never an unexplained hang or silent drop
```

**Evidence this session:** dispatched for real against this fork (2026-09-17, run 35255721576). Found the CI-side `CODEX_AUTH` credential dead (blocking the `feature` step entirely), diagnosed the exact fix (`tar czf - -C $HOME .codex/auth.json | base64 | gh secret set CODEX_AUTH`), the operator applied it, and the re-dispatch ran clean end to end: `feature` opened PR #83 in ~6 minutes, independent `pr-review` (a genuinely separate run) returned `verdict: approve-ready, critical: 0, actionable: false` in ~4.5 more minutes, no repair pass was needed, the operator reviewed and merged. The task itself was not staged: `feature` picked up the real `F-005` "remaining" note from this file and closed it out on its own.

CI harness failures now preserve an explicit credential classification when Codex reports either of the two observed authentication signatures: a revoked refresh token, or `401 Unauthorized` from `chatgpt.com/backend-api/codex`. The adapter emits a terminal `CREDENTIAL_DEGRADED:` marker, and the existing failure path persists that marker as cron-state's `last_error` for `skill-health`. `scripts/tests/test_codex_credential_degraded.sh` proves both known signatures classify distinctly while an unrelated checkout failure remains generic. Kimi, Hermes, Cursor, and Vibe are deliberately not classified without a repository-backed failure signature. This detects a dead credential but does not repair it; the operator must still run `aeon auth --harness codex` and replace `CODEX_AUTH`.

External-repository proof was attempted against three operator-owned repositories on 2026-09-18, and every run produced a specific blocked result rather than a silent drop. Run 35330238984 opened `Svector-anu/headless-harness-bench#1`; initial review found a missing verdict-value validation, the bounded repair passed both target checks, and re-review found a new case-insensitive `.ENV.production` bypass, so the chain stopped after its one allowed repair with `CHAIN_STATUS=failed`. Run 35331519526 opened `Svector-anu/nightshift-game#1` but correctly refused to dispatch review because the target repository reported no successful check or commit status. Run 35331968595 opened `Svector-anu/skopos#117` but correctly refused review because the required Vercel commit status failed. These attempts prove cross-repo intake, PR creation, target-check enforcement, independent review, and bounded repair can execute outside this repository. They do not prove the acceptance criterion's merge-ready branch: all three PRs remain open and blocked for human review.

**Remaining, stated honestly:**
- **Telegram has a chain route but no producer prompt.** A `[dev-loop::ship]` force-reply now routes an owned `owner/repo` or GitHub issue URL into `chain-runner.yml -f chain=dev-loop -f target=external:<owner/repo[#N]>`, distinct from the existing single-skill route. `scripts/tests/test_telegram_route.sh` covers repository normalization, issue URL normalization, and rejection of unscoped free text. No current skill emits that prompt: the documented `repo-scanner` sender no longer exists, and the closest current producer (`idea-pipeline`) deliberately marks a backlog choice without selecting an owned repository. Telegram therefore still cannot initiate Aeon Engineer from a normal product flow until a real producer is separately approved and built.
- **The CI-side harness credentials are not reliably up.** This session alone hit a dead `CODEX_AUTH` and a `claude`/`bankr` gateway outage, on two separate days. `F-006` inherits whatever reliability the underlying harnesses have; it doesn't add any credential-monitoring of its own — though credential *degradation* is now at least distinguishable from a real regression, see above.

---

## Roster: everything else, by pack

Real slugs and descriptions from `catalog/skills.json`. Status `shipped` (live, scheduled) unless otherwise noted. No fabricated acceptance criteria; write a real PRD via `templates/prd-feature.md` before claiming detailed feature status for any of these.

### Core (12)

`aeon-update`, `auto-merge`, `auto-workflow`, `fleet-control`, `fork-fleet`, `heartbeat`, `memory-flush`, `narrative-convergence`, `shiplog`, `soul-builder`, `spawn-instance`, `strategy-builder`

### Evolution (9, minus F-004's two)

`aeon-doctor`, `autoresearch`, `create-skill`, `install-skill`, `pack-submit`, `search-skill`, `self-improve`

### Basics (18, minus F-003's `pr-review`)

`action-converter`, `article`, `bd-radar`, `digest`, `executor-mcp`, `fetch-tweets`, `github-trending`, `glim-mcp`, `idea-forge`, `last30`, `price-alert`, `skill-article`, `token-movers`, `tx-explain`, `video-script`, `write-tweet`, `you-web-search`

### Dev & Code (12, minus F-001/F-002)

`changelog`, `deploy-prototype`, `github-monitor`, `inbox-triage`, `posthog-errors`, `pr-triage`, `rightstack`, `seo-audit`, `spend-watch`, `vuln-tracker`

### Crypto & Markets (18)

`base-mcp`, `defi-overview`, `deploy-uni-hook`, `distribute-tokens`, `fear-divergence`, `finance-district-mcp`, `investigation-report`, `monitor-polymarket`, `narrative-tracker`, `onchain-monitor`, `picks-tracker`, `pm-manipulation`, `robinhood-mcp`, `taskmarket-delegate`, `token-pick`, `unlock-monitor`, `verdikta-hunter`, `x402-monitor`

### Productivity (12)

`competitor-monitor`, `higgsfield`, `hunter-22`, `idea-pipeline`, `mention-radar`, `operator-scorecard`, `remotion`, `reply-maker`, `schedule-ads`, `send-email`, `slop-watch`, `weekly-aeoncard`
