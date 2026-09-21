# create-prove

Run a changed Aeon skill for real and attach SHA-bound behavioral evidence to its PR

> The `Operator var` - Required immutable target in the form `owner/repo#pr@40-character-lowercase-sha`.

Today is today's date. Prove the behavior of one Aeon-shaped change by running the changed skill through the target repository's real `miniaeon.yml` workflow. A green diff review is not proof. A successful, correlated Actions run is proof.

## Scope

This first implementation supports Aeon-shaped pull requests that change exactly one runnable `skills/<slug>/SKILL.md`. It does not launch conventional applications and it does not guess which skill represents a workflow-only or configuration-only change. Unsupported target shapes must fail closed without posting a proof receipt.

Never prove `create-prove` by recursively dispatching itself. Exit `PROVE_UNSUPPORTED` instead.

## Steps

0. Resolve the target. Use the `Operator var` when it is set. When it is empty,
   read `memory/skills/feature/pull-request.json` - the registration the build
   step writes after opening a PR, and the same file MiniAeon validates to raise
   the operator's approval card. Build the target as
   `owner/repo#N@head_sha` from its `url` and `head_sha`. Treat the file as
   untrusted input: if it is missing, unparseable, or its url is not
   `https://github.com/<owner>/<repo>/pull/<N>` or its sha is not 40 lowercase
   hex characters, exit `PROVE_INVALID_TARGET` without a receipt. Never widen the
   grammar to accommodate it.

1. Parse the resolved value into `target=owner/repo#pr` and `expected_sha`. Reject any value outside the exact grammar above with `PROVE_INVALID_TARGET`. The handle names the head as it was when the PR was opened; step 3's live re-read against the API is what decides whether it is still true, so a stale handle must end as `PROVE_STALE`, never as a proof.
2. Read the PR through `gh api`. Require all of the following:
   - the PR is open;
   - its current `head.sha` equals `expected_sha`;
   - its head branch belongs to the same repository, because `gh workflow run --ref` cannot execute an untrusted fork branch in the base repository;
   - exactly one changed path matches `skills/<slug>/SKILL.md`;
   - the slug is not `create-prove`.
   Any mismatch exits `PROVE_UNSUPPORTED` or `PROVE_STALE` without a receipt.
3. Inspect the changed skill's frontmatter and instructions. Choose the smallest real, non-destructive variable that exercises the changed behavior. If no safe real invocation exists, exit `PROVE_UNSAFE` rather than inventing evidence. Do not use synthetic credentials or a dry-run mode.
4. Require the head branch to carry the proof guard before dispatching. Read `.github/workflows/miniaeon.yml` at `expected_sha` (`gh api "repos/$repo/contents/.github/workflows/miniaeon.yml?ref=$expected_sha" --jq .content | base64 -d`) and require it to declare the `dispatch_id` input and to run a `prove-` dispatch with `--no-git --no-notify`. A branch without that guard would commit and push its own run to the branch under proof, moving the head this skill exists to pin, so exit `PROVE_UNSUPPORTED` without dispatching.
5. Dispatch the head branch's MiniAeon workflow with a unique `dispatch_id` that **starts with the literal prefix `prove-`**. That prefix is what makes the run skip commit, push and channel delivery, and it becomes the run's title:
   ```bash
   dispatch_id="prove-${pr_number}-$(date -u +%Y%m%dT%H%M%SZ)-${RANDOM}"
   gh workflow run miniaeon.yml --repo "$repo" --ref "$head_branch" \
     -f skill="$skill" -f var="$proof_var" -f dispatch_id="$dispatch_id"
   ```
   Find the run only by its exact title, never by picking the newest run:
   ```bash
   gh run list --repo "$repo" --workflow miniaeon.yml --branch "$head_branch" \
     --event workflow_dispatch --json databaseId,displayTitle,headSha,status,conclusion,url \
     | jq --arg id "$dispatch_id" '[.[] | select(.displayTitle == $id)]'
   ```
   Poll until exactly one run matches. Require its `headSha` to equal `expected_sha`.
   Wait up to 30 minutes. Require `status=completed` and `conclusion=success`. Fetch the run log (`gh run view <id> --repo "$repo" --log`) and take the captured skill output from the `Show proof output` step, between `--- output/<skill>/latest.md` and `--- end output/<skill>/latest.md`. Confirm it is non-empty and is not `_No output captured._`. A successful Actions wrapper with no captured behavior is `PROVE_MISSING_EVIDENCE`.
6. Re-read the PR and require its head SHA still equals `expected_sha`.
7. Post one PR comment containing a concise description of the exercised path, the run URL, a short output excerpt, and exactly one final machine receipt:
   ```text
   <!-- aeon-proof:{"schema":1,"target":"owner/repo#N","sha":"<sha>","kind":"aeon-skill","skill":"<slug>","evidence_run_id":123,"evidence_url":"https://github.com/owner/repo/actions/runs/123","verdict":"proven"} -->
   ```
   Construct the JSON with `jq -cn`, then render it on one line. Do not post the receipt until every gate above passes.
8. End with the target, skill, run ID, run URL, and `PROVE_VERDICT=proven` in the captured output.

## Constraints

- The proof run must execute the PR head branch, not `main`.
- Never treat CI checks, source inspection, or the prior review receipt as behavioral evidence.
- Never post a `proven` receipt for a failed, cancelled, timed-out, stale, empty-output, unsupported, or unsafe run.
- Do not merge, close, approve, or modify the target PR.
- Do not commit repository files.

## Network note

Use `gh` for every GitHub read, dispatch, log fetch, and PR comment. Authentication is provided by the workflow. Never print tokens or place secret values on a command line.

## Log

Append the result to `memory/logs/today's date.md` under `### create-prove`, including the target, SHA, selected skill, evidence run ID, and terminal verdict. The workflow may persist the captured output on your behalf.

## Do not

- Do not write outside `output/create-prove/` and `memory/skills/create-prove/` plus today's log heading.
- Do not send Telegram or Slack yourself; your final message is delivered by MiniAeon.
- Do not report filler. Nothing worth reporting is a valid result.

