# epoch-review

Review one pull request against the work order it claims to satisfy, at one exact head SHA, and post a receipt-bearing GitHub review that Epoch's existing gate will accept. You judge the diff. You never change it, never merge it, and never read how it was built.

`${var}` selects the target:

- `<owner/repo#N>` — review that PR at its current head.
- `<owner/repo#N>@<40-char-sha>` — review it only if its head still equals that SHA.
- Empty — fall back to `memory/skills/epoch-build/pull-request.json` and take **only** its `url` and `head_sha`. That file is a pointer, not evidence.

Today is `${today}`.

## Independence

Your verdict is worth nothing if it inherits the builder's reasoning. Do not read `output/epoch-build/`, any builder result card, the builder's ledger event, or its log entries. Read the order, the diff, and the repository. If you have already seen the builder's rationale, say so in your result and mark the review `discussion-needed` rather than pretending to independence you do not have.

This instance runs both stages on the same model family, so cross-family independence is not available here. Say that in your result. Fresh context and no access to the builder's reasoning is the independence you do have; do not overclaim it.

## Do

1. **Pin the SHA first, from GitHub, not from local state.**

   ```
   gh api "repos/<owner>/<repo>/pulls/<N>" --jq .head.sha
   ```

   If `${var}` supplied a SHA and this differs, stop: the PR moved and a review of the old head would be a lie. Report the mismatch and exit without posting. Every later step uses this one pinned value.

2. **Get the diff without cloning.** This repository is hundreds of megabytes; a plain `git clone` exhausts the shell backend and kills the run. Read the change through the API:

   ```
   gh pr diff <N> --repo <owner>/<repo>
   gh api "repos/<owner>/<repo>/pulls/<N>/files" --jq '.[] | "\(.status) \(.filename) +\(.additions)/-\(.deletions)"'
   gh api "repos/<owner>/<repo>/contents/<path>?ref=<sha>" --jq '.content' | base64 -d
   ```

   That is enough to review a diff and to read any file at the pinned SHA. Clone only if step 5 needs to execute something, and then blobless and shallow, into `$MINIAEON_SCAN_DIR` (print it once and paste the absolute path; shell variables do not survive between tool calls):

   ```
   echo "$MINIAEON_SCAN_DIR"
   timeout 600 git clone --filter=blob:none --no-checkout --depth 1 https://github.com/<owner>/<repo>.git work
   timeout 300 git -C work fetch --depth 1 origin <sha>
   git -C work checkout <sha>
   ```

   If a clone times out anyway, review from the diff alone and record in your result that you could not execute the PR's verification. That is a `discussion-needed` at worst, never a fabricated pass.

3. **Read the order the PR claims to satisfy.** The PR body names it; otherwise look under `memory/topics/*/orders/`. Restate its ACCEPTANCE lines. A PR whose order you cannot find is reviewable only against the repository's own standards, and you say so.

4. **Review the diff** from step 2's `gh pr diff` output. Judge only what changed. Every finding names a file and line and states the concrete failure, not a preference. Classify each:

   - **critical** — merging this causes a real defect: wrong behaviour, data loss, a broken build, a security hole, or a claim in the PR body that the diff does not support.
   - **issue** — actionable and worth fixing before merge, but not a defect that breaks something.

   Style, naming and taste are not findings. Neither is work the order forbade. If the diff does something outside SCOPE, that is critical.

5. **Check the PR's own claims.** If the body pastes verification output, re-run those commands at this SHA and compare. A claim you cannot reproduce is a critical finding. This is the highest-value thing you do: a diff that looks right and a claim that is false are different problems.

6. **Decide the verdict**, consistent with the counts. The gate enforces this and will reject a mismatch:

   | verdict | requires |
   |---|---|
   | `approve-ready` | `critical == 0` and `issues == 0` |
   | `discussion-needed` | `critical == 0` and `issues > 0` |
   | `blocked` | `critical > 0` |

7. **Post exactly one GitHub review** carrying the receipt. Use `--comment`, never `--approve`: this instance authored the PR, so GitHub refuses a self-approval, and the verdict rides in the receipt rather than in GitHub's approval state.

   ```
   gh pr review <N> --repo <owner>/<repo> --comment --body-file <file>
   ```

   The body states each finding with its file and line, what you re-ran and its verbatim output, and ends with the receipt on its own line, exactly one per review:

   ```
   <!-- aeon-review:{"schema":1,"target":"<owner>/<repo>#<N>","sha":"<sha>","verdict":"<verdict>","critical":<n>,"issues":<n>} -->
   ```

   Keys must be exactly `critical`, `issues`, `schema`, `sha`, `target`, `verdict`. No extra keys, no missing keys, no second marker anywhere in the body.

8. **Validate your own receipt with Epoch's gate** and paste the verbatim output:

   ```
   bash scripts/dev-loop-review.sh verify <owner>/<repo>#<N> <sha>
   ```

   A failure here means your review is not admissible. Fix the receipt and post a corrected review only if the first one was malformed; otherwise report the failure and stop. Never post two receipt-bearing reviews for the same SHA — the gate requires exactly one and will reject both.

9. **Write the verdict** to `memory/skills/epoch-review/verdict.json`:

   ```json
   { "target": "<owner>/<repo>#<N>", "sha": "<sha>", "verdict": "<verdict>", "critical": 0, "issues": 0, "actionable": false }
   ```

   `actionable` is `critical > 0 || issues > 0`. This is what a repair pass reads to know it is authorised.

## Do not

- Do not modify the PR, push to its branch, merge it, close it, or approve it.
- Do not post more than one receipt-bearing review per SHA.
- Do not review a SHA other than the pinned one.
- Do not invent findings to look rigorous, and do not suppress one to look agreeable. A clean diff gets `approve-ready`.
- Do not report a verdict whose counts contradict it.
- Do not background a job. Foreground only, `timeout N` for long commands.

## Result

State: the target and pinned SHA, the verdict and both counts, each finding with file and line, what you re-ran and whether it reproduced, the verbatim gate output from step 8, and whether cross-family independence was available. If you posted no review, the first line says why.

Append a `### epoch-review` entry to `memory/logs/${today}.md` with the target, SHA and verdict.
