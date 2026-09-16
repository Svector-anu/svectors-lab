# Architecture

The structural rules this repo actually enforces, and how. Scope: the capability and skill-integrity boundaries that hold regardless of which skill is running. This does not attempt to document every one of the 81 skills' own internal logic; each skill's `SKILL.md` is the authority on itself.

## The dispatch path

```text
skills/<slug>/SKILL.md
        |
        v
   Dispatch (aeon.yml schedule, chain-runner.yml chain,
             apps/mcp-server, apps/webhook)
        |
        v
   Capability resolution (scripts/skill_mode.sh)
        |
        v
   Harness execution (harness-adapter/run-harness:
             claude | codex | grok | glm | pi | vibe | kimi | fx | cursor | hermes)
        |
        v
   Enforcement: allowedTools + OS sandbox + post-run revert
```

Every entry point (a scheduled cron run, a manual dispatch, an MCP tool call, a webhook trigger) is supposed to converge on the same capability resolution and the same harness dispatcher, so a skill behaves identically regardless of who invoked it. Where that convergence has broken in practice, it has been a real security gap, not a theoretical one (see "Where this has actually failed" below).

## Capability tiers (read-only vs write)

Every skill declares `mode: read-only` or `mode: write` (default) in its `SKILL.md` frontmatter. `scripts/skill_mode.sh mode <skill>` resolves the tier; `scripts/skill_mode.sh allowed-tools <mode>` resolves the concrete tool allowlist for it.

Enforcement is three layers deep, not one:

1. **`--allowedTools`**: the harness only exposes the tools the resolved tier grants. `write` adds `Write`, `Edit`, `Bash(git:*)`, `Bash(gh:*)`, and a python interpreter on top of the read-only base.
2. **OS sandbox**: `run-harness --mode read-only` write-locks the entire workspace at the OS level (`bwrap` on Linux runners, `sandbox-exec` locally), so even a tool-allowlist gap or a shell redirection around it still can't mutate the repo.
3. **Post-run revert**: a workflow step reverts any stray writes that landed anyway, on the theory that the allowlist and the sandbox were never assumed sufficient on their own.

A `read-only` skill physically cannot write to `memory/` or `output/`, call `gh` (even a GET), or commit. It produces its output via its own final message and `./notify`.

## Secret scoping

A skill only receives the API keys it declares in its `requires:` frontmatter (`scripts/skill_requires.sh`), injected directly into the run environment for that run. A skill that doesn't declare a key doesn't get it.

**Where this has actually failed:** as of 2026-09-16, this scoping only ran correctly on the GitHub Actions dispatch path. The MCP-server dispatch path (`apps/mcp-server/src/skill-executor.ts`) resolved capability mode from `scripts/skill_mode.sh` directly, with no knowledge of a runtime selector some skills use to force a stricter tier at the moment of dispatch (vuln-scanner's Riva shadow/compare evaluation mode). A skill dispatched through MCP with that selector got full write tools and the complete ambient environment instead of the intended read-only, credential-stripped run. Fixed by moving the selector check into `scripts/skill_mode.sh` itself as a single shared function (`is_shadow_selector`) both dispatch surfaces now call, instead of each dispatch surface keeping its own copy. See `docs/prd/feature-002-vuln-scanner.md` for the full account. The general lesson: any capability rule enforced by two independently-maintained copies is a matter of time before one drifts.

## Skill content integrity (the eyebrow gate)

`eyebrowlock.json` fingerprints every `skills/<slug>/SKILL.md`: its content hash and its declared network egress (hosts reached from a `./secretcurl`/`curl`/`WebFetch` line). `ci-skill-integrity` re-derives that fingerprint on every PR touching a skill and fails only when a skill gains a new egress host, or introduces a new critical-severity finding. Wording changes, refactors, and prose edits are reported but do not fail the build. This repo edits skills constantly, and a gate that fired on every byte would get disabled within a week. Regenerate with `eyebrow scan --path . --lockfile eyebrowlock.json` and commit the diff in the same PR when a skill legitimately changes its reach.

This gate has produced at least one confirmed false positive in practice: a skill's own prose explaining that `curl | sh` is *not* an allowed pattern was itself flagged as the dangerous pattern, because the scanner can't distinguish explanation from usage (fixed both in this fork and upstream, 2026-09-16).

## Skill categorization

Every skill declares exactly one `category:` from six values: `core`, `evolution`, `basics`, `dev`, `crypto`, `productivity`. `ci-skill-category` fails any skill missing or misdeclaring this. A skill's category is the single source of truth for which dashboard "pack" it belongs to (`catalog/packs.config.json` derives pack membership from category, not the reverse). See `docs/skill-packs.md` for the full mechanism, which this file does not duplicate.

## Chain orchestration and independent review

Multi-step work (the `dev-loop` chain: `feature` → `pr-review` → an optional bounded `repair` → `re-review`) runs through `chain-runner.yml`, not a single skill invocation. Each step is a separately dispatched GitHub Actions run with fresh context; a step's output is handed to the next via `output/.chains/<skill>.md`, and a machine-checked `<!-- aeon-dispatch:ID -->` marker in a PR body binds it to its originating dispatch, so the chain can verify, not just trust, that the PR it's reviewing is the one it asked for.

This is Rule 3 (do not let the implementer be the only reviewer) as running infrastructure, not just a written policy: `pr-review` is dispatched as a genuinely separate run, with no access to the implementing agent's reasoning, and its verdict is pinned to the PR's exact head SHA. If the SHA moves between dispatch and review, the review aborts rather than silently reviewing stale or newer state it wasn't asked to review. See `docs/prd/feature-001-dev-loop.md`.

## Verification stack in practice

`ci-tests` (script-level test suites), `ci-shellcheck` (error-severity floor across `scripts/**`, `bin/**`, `harness-adapter/**`), `ci-skill-integrity` (eyebrow), `ci-skill-category`, and `ci-packs-json` all gate every relevant PR. None of these substitute for a human or an independent-review pass judging whether the *change* is correct. They catch drift and structural violations, not whether the work was the right work. `docs/product/feature-map.md`'s acceptance criteria and `pr-review`'s independent verdict are what close that remaining gap for a given feature.
