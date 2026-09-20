# skill-writer

Draft one new MiniAeon skill for operator review from a natural-language request. Do not rely on conversation history: the operator's `--var` text and files in this workspace are the source of truth.

## Inputs and boundaries

1. Read `memory/MEMORY.md` if it exists and inspect `skills/` before choosing a name.
2. Treat `--var` as the request. It should state the outcome, inputs or sources, expected output, cadence if any, and constraints.
3. If the request is missing an outcome, or it would require a capability, secret, schedule, or write scope that cannot be chosen safely, do not create files. Return a short list of the specific missing decisions.
4. Derive a concise lowercase kebab-case name. Check that it is unused and valid under MiniAeon's skill-name rules. Never overwrite or modify an existing skill.
5. Write only the new `skills/<name>/SKILL.md`, `skills/<name>/skill.toml`, and `output/skill-writer/`. Do not edit `aeon.toml`. Creating draft files does not install or schedule the skill; describe configuration and enablement as operator steps after review.

## Create the skill

1. Translate the request into a focused, executable `SKILL.md`. Include inputs, a bounded workflow, durable-memory instructions where needed, the required output shape, and a `## Do not` section.
2. Use the least-privileged manifest:
   - default to `write_scope = "own-memory"`, `risk = "low"`, no capabilities, and `tools = ["read", "write"]`;
   - choose a broader scope, a capability, a secret, or a notification only when the request explicitly needs it; record a requested schedule as an operator configuration step;
   - if the request needs repository writes, external services, or notifications, explain the required MiniAeon grant instead of assuming it exists.
3. Use the standard manifest fields: `name`, `entrypoint`, `runtime`, `role`, `risk`, `model`, `write_scope`, `feedback_mode`, `on_missed_run`, `capabilities`, and `tools`. Set `entrypoint = "SKILL.md"`: it is a path relative to the skill's own `skills/<name>/` directory, so never prefix it with the skill name (`entrypoint = "<name>/SKILL.md"` doubles the path to `skills/<name>/<name>/SKILL.md` and makes the skill unloadable).
4. Set `on_missed_run = "skip_stale"` unless the request gives a reason to catch up. Do not add a schedule to `aeon.toml`.
5. Validate that the skill body does not instruct edits outside its declared scope and that its manifest name matches its directory.

## Proposal handoff

On the normal git-enabled run path, MiniAeon saves skill mutations under `memory/proposals/<run-id>/` and restores the workspace. It structurally verifies every proposal; with `[maintenance] allow_prs = true` it then runs the gate and attempts to open a PR, otherwise the saved proposal remains for operator review. MiniAeon never auto-merges.

The final response is written before that post-run processing. Describe the files as a draft, not an installed skill or a confirmed PR. Tell the operator to inspect the run's recorded outcome and saved proposal, review and merge an opened PR (or manually apply an approved saved proposal), then configure or enable the skill as needed. Do not instruct the operator to run it before the approved files are present. `--no-git` bypasses this automatic proposal flow; do not claim it created a proposal or PR.

## Output

Write `output/skill-writer/latest.md` containing:

1. the new skill name and purpose;
2. draft files written;
3. requested versus selected scope, tools, capabilities, and schedule behavior;
4. proposal review/application steps, followed by any required grants, secrets, configuration, or enablement;
5. a short example command explicitly labeled for use after the approved skill is present: `miniaeon run <name> --var "..."`.

Your final message must summarize the drafted skill and the review/application steps still required. Do not claim that publication or installation has already succeeded. If requirements were incomplete, state that no skill was created and list only the missing decisions.

## Do not

- Do not edit `aeon.toml`, `AGENTS.md`, `STRATEGY.md`, `soul/`, or MiniAeon source.
- Do not edit, replace, or enable an existing skill.
- Do not invent grants, secrets, schedules, external access, or a capability the request did not establish.
- Do not use bash or git.
