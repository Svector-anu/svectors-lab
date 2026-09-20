# propose-work

Surface the highest-leverage work the operator's projects need next, scored so the scheduler and the operator can pick what to actually do. This skill only PROPOSES; it never does the work. Candidates it writes are ranked by `miniaeon rank` and can be turned into runs.

## What to do

1. Read `STRATEGY.md` (the north-star), `memory/me.md` if present (operator preferences), and recent `memory/logs/` so you do not re-propose something already done or already queued.
2. List existing candidates under `memory/candidates/` first. Do not create a duplicate for work already proposed; a repeat of the same subject is the same candidate.
3. Identify a small number (at most 5) of concrete, actionable units of work that advance the strategy. Each must be specific enough to run: a clear title and, when it maps to an existing skill, that skill and the request to pass it.

## Score each candidate (RISE)

Give every candidate a RISE score. Each component is an integer 0-25 (25 = best):

- **reach**: how much / how many this affects.
- **impact**: the magnitude of the effect. This is the number that decides whether it is worth a click - be honest.
- **strategic_fit**: alignment with `STRATEGY.md`.
- **ease**: how easy it is (higher = easier / cheaper / less risky).

## Write candidates

Write one JSON file per candidate to `memory/candidates/<id>.json`, where `<id>` is a short kebab-case slug of the title. Shape:

```json
{
  "id": "publish-x402-changelog",
  "title": "Publish the x402 affiliation changelog entry",
  "skill": "changelog",
  "var": "x402 affiliation split shipped",
  "score": { "reach": 12, "impact": 18, "strategic_fit": 20, "ease": 22 },
  "created_at": "2026-09-15T00:00:00Z"
}
```

`skill` and `var` are optional (omit when the work has no existing skill). Use the run's date for `created_at`. Do not fabricate scores to inflate a candidate - the ranking is only as honest as the impact number.

## Output

Write `output/propose-work/latest.md` with the candidates you added or updated, each with its impact points (`round(impact / 2.5)`) and one line on why it matters. If nothing new is worth proposing, say so and write no candidates.

## Do not

- Do not do the proposed work; only propose it.
- Do not duplicate an existing candidate or re-propose recently completed work.
- Do not write outside `memory/candidates/`, this skill's memory, and its output.
- Do not invent impact; an honest low score is better than a padded high one.
