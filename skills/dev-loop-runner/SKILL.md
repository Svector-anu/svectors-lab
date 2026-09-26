# dev-loop-runner

Run the dev-loop's build → independent-review → bounded-repair → live-proof
guarantees from a single skill dispatch, on any surface that can dispatch a
skill — not only from `.github/workflows/chain-runner.yml`'s own
`workflow_dispatch` trigger.

> The `Operator var` — Required immutable target in the form
> `external:<owner/repo>` or `external:<owner/repo>#N`, exactly
> `scripts/dev-loop-pr.sh`'s own grammar. Empty or malformed var ends the run
> `invalid-dispatch` before anything is touched.

This is a second, skill-native path to the exact guarantees
`.github/workflows/chain-runner.yml`'s `dev-loop` chain already ships
(feature-map F-001): `feature` and the review step run as **separately
dispatched** GitHub Actions runs, never sharing one agent's context; the
review is bound to the PR's exact head SHA at dispatch time; at most one
repair pass runs, authorized only by a fresh SHA-matched actionable review; a
second actionable re-review ends the run failed, never looping; and a
supported PR shape gets a live SHA-bound proof receipt, otherwise the run
says `proof-missing` honestly. This skill does not reimplement any of those
guarantees — it calls the same four deterministic gate scripts
(`scripts/dev-loop-{pr,review,repair,proof}.sh`) that `chain-runner.yml`
calls, in the same order, and dispatches `feature` / `pr-review` /
`create-prove` the same way `chain-runner.yml` does: as separate
`gh workflow run aeon.yml` invocations it polls for, never as an in-context
subroutine. See `ARCHITECTURE.md`'s "Chain orchestration and independent
review" (Rule 3) — this skill is bound by the exact same invariant
`chain-runner.yml` enforces, and must never collapse the build step and the
review step into one shared agent context.

**Do not widen anything here.** `create-prove`'s target grammar
(`owner/repo#pr@sha`), `dev-loop-pr.sh validate-owned-target`'s push-access
requirement, and the single-bounded-repair rule are read from the gate
scripts as-is. This skill has no fork-and-cross-repo-PR path (F-006's
documented, accepted gap) and never dispatches `create-prove` against
anything but the exact PR/SHA this run itself verified.

## Preconditions

`gh` must already be authenticated (`gh auth status`) with `repo` +
`workflow` scopes — every gate script and every dispatch below fails closed
without it. Never place a token on a command line; `gh` reads its own
config/env.

## Steps

### 0. Resolve and validate the target — before any dispatch

The `Operator var` is the target, verbatim. Empty or not matching
`external:owner/repo` / `external:owner/repo#N` ends the run immediately:

```bash
TARGET="<the Operator var>"
if [ -z "$TARGET" ]; then
  echo "dev-loop-runner: empty target — expected external:owner/repo[#N]" >&2
  echo "DEV_LOOP_RUNNER_STATUS=invalid-dispatch"
  exit 1
fi
if ! bash scripts/dev-loop-pr.sh validate-target "$TARGET"; then
  echo "DEV_LOOP_RUNNER_STATUS=invalid-dispatch"
  exit 1
fi
```

Then the push-access gate. Reuse its exact refusal message; do not
paraphrase it, and refuse before touching anything else:

```bash
REPO=$(bash scripts/dev-loop-pr.sh validate-owned-target "$TARGET") || {
  # dev-loop-pr.sh already printed: "dev-loop: authenticated operator does
  # not have push access to $repo" — that exact line is the refusal.
  echo "DEV_LOOP_RUNNER_STATUS=invalid-dispatch"
  exit 1
}
echo "Target validated: $REPO (push access confirmed)"
```

### 1. Write the orchestration script once, run it once

The rest of this run is one long-lived shell process — `dispatch_skill`
below re-polls `gh run list` by exact `displayTitle` match (never the newest
run for a skill) exactly as `chain-runner.yml`'s helper of the same name
does, because that is the only way to bind a dispatch to the run it started
rather than to a coincidentally-concurrent one. Write it to a file and run it
under `timeout` so a stuck `gh` call cannot hang the skill run forever:

```bash
cat > /tmp/dev-loop-runner.sh <<'SCRIPT'
#!/usr/bin/env bash
set -uo pipefail

TARGET="$1"
REPO=$(bash scripts/dev-loop-pr.sh validate-owned-target "$TARGET") || exit 1

status() { echo "DEV_LOOP_RUNNER_STATUS=$1"; }

# --- dispatch_skill / wait_for_runs: ported verbatim from
# .github/workflows/chain-runner.yml so the correlation contract
# (displayTitle match, dispatch-id regex, poll cadence, two-line stdout of
# "dispatch_id=<id>" then the run id) stays identical.
dispatch_skill() {
  local skill="$1" var="${2:-}" ctx_file="${3:-}" expected_sha="${4:-}"
  local before_ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  local dispatch_id="chain-$(openssl rand -hex 16)"

  local args=(-f skill="$skill" -f dispatch_id="$dispatch_id")
  [ -n "$var" ] && args+=(-f var="$var")
  [ -n "$ctx_file" ] && args+=(-f chain_context_file="$ctx_file")
  [ -n "$expected_sha" ] && args+=(-f expected_sha="$expected_sha")

  local expected_title="skill: $skill"
  [ -n "$var" ] && expected_title+=" ($var)"
  expected_title+=" [dispatch: $dispatch_id]"

  echo "  Dispatching: $skill (var=$var)" >&2
  gh workflow run aeon.yml "${args[@]}" || return 1

  # Gotcha: a fresh dispatch takes a few seconds to appear in `gh run list` —
  # 12 attempts, 5s apart, is chain-runner.yml's own proven cadence. Don't
  # invent a tighter one.
  local run_id=""
  for i in $(seq 1 12); do
    sleep 5
    run_id=$(gh run list --workflow=aeon.yml -L 100 \
      --json databaseId,displayTitle,createdAt | \
      jq -r --arg expected_title "$expected_title" \
        --arg dispatch_id "$dispatch_id" --arg before_ts "$before_ts" \
        '[.[] | select(.displayTitle == $expected_title and
          (.displayTitle | contains($dispatch_id)) and
          .createdAt >= $before_ts) | .databaseId] |
         if length == 1 then .[0] else empty end' \
      2>/dev/null || true)
    [ -n "$run_id" ] && [ "$run_id" != "null" ] && break
    run_id=""
  done

  if [ -z "$run_id" ]; then
    echo "::error::Failed to discover run ID for skill: $skill (dispatch: $dispatch_id)" >&2
    return 1
  fi
  echo "  Run ID: $run_id (dispatch: $dispatch_id)" >&2
  echo "dispatch_id=$dispatch_id"
  echo "$run_id"
}

wait_for_runs() {
  local timeout=1800
  local start=$(date +%s)
  local run_ids=("$@")
  while true; do
    local all_done=true
    for id in "${run_ids[@]}"; do
      local st=$(gh run view "$id" --json status -q '.status' 2>/dev/null || echo "unknown")
      [ "$st" != "completed" ] && { all_done=false; break; }
    done
    $all_done && break
    [ $(( $(date +%s) - start )) -ge "$timeout" ] && { echo "::error::timed out waiting for ${run_ids[*]}" >&2; return 1; }
    sleep 30
  done
  local failed=0
  for id in "${run_ids[@]}"; do
    local c=$(gh run view "$id" --json conclusion -q '.conclusion' 2>/dev/null || echo "failure")
    [ "$c" != "success" ] && { echo "::warning::run $id concluded $c" >&2; failed=1; }
  done
  return "$failed"
}

build_context() {
  local target_skill="$1"; shift
  local ctx_file="output/.chains/.chain-context-${target_skill}.md"
  mkdir -p output/.chains
  : > "$ctx_file"
  for dep in "$@"; do
    local f="output/.chains/${dep}.md"
    { echo "### ${dep}"; echo; [ -s "$f" ] && cat "$f" || echo "_Output not available._"; echo; echo "---"; echo; } >> "$ctx_file"
  done
  echo "$ctx_file"
}

commit_and_push() {
  local msg="$1"
  git add output/.chains/ 2>/dev/null || true
  git diff --staged --quiet 2>/dev/null && return 0
  git commit -m "$msg"
  bash scripts/git-push-retry.sh
}

# --- 1. Snapshot open PRs before feature runs ---
FEATURE_OPEN_BEFORE=$(mktemp)
bash scripts/dev-loop-pr.sh snapshot "$TARGET" > "$FEATURE_OPEN_BEFORE" || {
  echo "::error::could not snapshot open PRs before feature" >&2
  status failed; exit 1
}

# --- 2. Dispatch feature, wait, verify it opened exactly one new PR ---
FEATURE_OUT=$(dispatch_skill feature "$TARGET") || { status failed; exit 1; }
FEATURE_RUN_ID=$(echo "$FEATURE_OUT" | tail -1)
FEATURE_DISPATCH_ID=$(echo "$FEATURE_OUT" | sed -n 's/^dispatch_id=//p' | tail -1)
[ -n "$FEATURE_RUN_ID" ] && [ -n "$FEATURE_DISPATCH_ID" ] || { echo "::error::feature dispatch has no correlation ID" >&2; status failed; exit 1; }
wait_for_runs "$FEATURE_RUN_ID" || { echo "::error::feature run failed" >&2; status failed; exit 1; }
git pull --rebase origin main 2>/dev/null || true

VERIFY_RC=0
FEATURE_PR=$(bash scripts/dev-loop-pr.sh verify-new-pr "$TARGET" "$FEATURE_OPEN_BEFORE" "$FEATURE_DISPATCH_ID") || VERIFY_RC=$?
case "$VERIFY_RC" in
  0) echo "Verified feature PR: $FEATURE_PR" ;;
  3) echo "feature completed without a verified open PR — nothing to review" >&2; status no-action; exit 0 ;;
  *) echo "::error::could not verify feature's claimed PR" >&2; status failed; exit 1 ;;
esac

# --- 3. Bind checks to the feature PR's head, wait for them to go green ---
FEATURE_SHA=$(bash scripts/dev-loop-repair.sh head "$FEATURE_PR") || { echo "::error::could not bind checks to feature PR head" >&2; status failed; exit 1; }
CHECKS_OK=false
for attempt in $(seq 1 60); do
  CR=0
  RESULT=$(bash scripts/dev-loop-repair.sh verify-checks "$FEATURE_PR" "$FEATURE_SHA" 2>&1) || CR=$?
  if [ "$CR" -eq 0 ]; then echo "Verified feature checks: $RESULT"; CHECKS_OK=true; break; fi
  [ "$CR" -ne 3 ] && { echo "::error::$RESULT" >&2; status failed; exit 1; }
  sleep 30
done
[ "$CHECKS_OK" = true ] || { echo "::error::timed out waiting for feature checks" >&2; status failed; exit 1; }

# --- 4. Dispatch pr-review, bound to FEATURE_SHA, never the mutable head ---
REVIEW_CTX=$(build_context pr-review feature)
commit_and_push "chore(dev-loop-runner): context for pr-review"
REVIEW_OUT=$(dispatch_skill pr-review "$FEATURE_PR" "$REVIEW_CTX" "$FEATURE_SHA") || { status failed; exit 1; }
REVIEW_RUN_ID=$(echo "$REVIEW_OUT" | tail -1)
wait_for_runs "$REVIEW_RUN_ID" || { echo "::error::pr-review run failed" >&2; status failed; exit 1; }
git pull --rebase origin main 2>/dev/null || true

REVIEW_RESULT=$(bash scripts/dev-loop-review.sh verify "$FEATURE_PR" "$FEATURE_SHA") || { echo "::error::could not verify the review receipt against GitHub" >&2; status failed; exit 1; }
echo "Verified review receipt: $REVIEW_RESULT"

REPAIRED_SHA=""
REPAIR_RUN_ID=""
REREVIEW_RUN_ID=""
if [ "$(jq -r '.actionable' <<<"$REVIEW_RESULT")" = "true" ]; then
  # --- 5. Exactly one bounded repair pass, authorized only by this receipt ---
  REPAIR_VAR=$(bash scripts/dev-loop-repair.sh repair-target "$FEATURE_PR" "$FEATURE_SHA") || { echo "::error::review became stale before repair" >&2; status failed; exit 1; }
  REPAIR_CTX="output/.chains/.chain-context-feature-repair.md"
  mkdir -p output/.chains
  bash scripts/dev-loop-review.sh body "$FEATURE_PR" "$FEATURE_SHA" > "$REPAIR_CTX"
  commit_and_push "chore(dev-loop-runner): context for bounded repair"

  REPAIR_OUT=$(dispatch_skill feature "$REPAIR_VAR" "$REPAIR_CTX") || { status failed; exit 1; }
  REPAIR_RUN_ID=$(echo "$REPAIR_OUT" | tail -1)
  wait_for_runs "$REPAIR_RUN_ID" || { echo "::error::bounded repair run failed" >&2; status failed; exit 1; }
  git pull --rebase origin main 2>/dev/null || true

  REPAIRED_SHA=$(bash scripts/dev-loop-repair.sh verify-change "$FEATURE_PR" "$FEATURE_SHA") || { echo "::error::repair did not produce a verifiable new PR head" >&2; status failed; exit 1; }

  CHECKS_OK=false
  for attempt in $(seq 1 60); do
    CR=0
    RESULT=$(bash scripts/dev-loop-repair.sh verify-checks "$FEATURE_PR" "$REPAIRED_SHA" 2>&1) || CR=$?
    if [ "$CR" -eq 0 ]; then echo "Verified repaired checks: $RESULT"; CHECKS_OK=true; break; fi
    [ "$CR" -ne 3 ] && { echo "::error::$RESULT" >&2; status failed; exit 1; }
    sleep 10
  done
  [ "$CHECKS_OK" = true ] || { echo "::error::timed out waiting for checks on repaired SHA" >&2; status failed; exit 1; }

  # --- 6. Exactly one re-review, bound to the repaired SHA ---
  REREVIEW_CTX=$(build_context pr-review feature)
  commit_and_push "chore(dev-loop-runner): context for re-review"
  REREVIEW_OUT=$(dispatch_skill pr-review "$FEATURE_PR" "$REREVIEW_CTX" "$REPAIRED_SHA") || { status failed; exit 1; }
  REREVIEW_RUN_ID=$(echo "$REREVIEW_OUT" | tail -1)
  wait_for_runs "$REREVIEW_RUN_ID" || { echo "::error::re-review run failed" >&2; status failed; exit 1; }
  git pull --rebase origin main 2>/dev/null || true

  FINAL_REVIEW=$(bash scripts/dev-loop-review.sh verify "$FEATURE_PR" "$REPAIRED_SHA") || { echo "::error::could not verify the re-review receipt" >&2; status failed; exit 1; }
  if [ "$(jq -r '.actionable' <<<"$FINAL_REVIEW")" = "true" ]; then
    # Never a second repair. One bounded pass, no loop — a second actionable
    # re-review is a terminal failed result for this run.
    echo "::error::re-review remains actionable after the one bounded repair pass — stopping, not looping" >&2
    echo "Final re-review receipt: $FINAL_REVIEW" >&2
    status failed
    exit 1
  fi
  echo "Verified re-review receipt: $FINAL_REVIEW"
fi

# --- 7. Live-proof gate: honest proof-missing beats a false success ---
PROOF_SHA="${REPAIRED_SHA:-$FEATURE_SHA}"
PROOF_VAR="${FEATURE_PR}@${PROOF_SHA}"
PROOF_OUT=$(dispatch_skill create-prove "$PROOF_VAR")
PROOF_RUN_ID=$(echo "$PROOF_OUT" | tail -1)
PROOF_OK=false
if [ -n "$PROOF_RUN_ID" ] && wait_for_runs "$PROOF_RUN_ID"; then
  git pull --rebase origin main 2>/dev/null || true
  if PROOF_RESULT=$(bash scripts/dev-loop-proof.sh verify "$FEATURE_PR" "$PROOF_SHA" 2>&1); then
    echo "Verified live behavioral proof: $PROOF_RESULT"
    PROOF_OK=true
  else
    echo "No verified live behavioral proof for ${FEATURE_PR}@${PROOF_SHA}: $PROOF_RESULT" >&2
  fi
else
  echo "create-prove run did not complete successfully (expected for an unsupported PR shape, e.g. PROVE_UNSUPPORTED on a multi-file PR)" >&2
fi

echo "dev-loop-runner evidence: pr=$FEATURE_PR feature_run=$FEATURE_RUN_ID review_run=$REVIEW_RUN_ID repair_run=${REPAIR_RUN_ID:-none} rereview_run=${REREVIEW_RUN_ID:-none} proof_run=${PROOF_RUN_ID:-none}"
if [ "$PROOF_OK" = true ]; then
  status success-proven
else
  status proof-missing
fi
exit 0
SCRIPT
chmod +x /tmp/dev-loop-runner.sh
timeout 2400 bash /tmp/dev-loop-runner.sh "$TARGET"
```

## Result reporting

The captured output for every run ends with exactly one
`DEV_LOOP_RUNNER_STATUS=<value>` line, one of:

- `invalid-dispatch` — empty/malformed target, or the operator does not have
  push access. The refusal reason (`dev-loop-pr.sh`'s own message) is in the
  output verbatim.
- `no-action` — `feature` ran but opened no verified PR. Nothing else was
  dispatched.
- `failed` — a gate could not be verified, a dispatched run itself failed, or
  the bounded repair's re-review is still actionable (never a second
  repair). The failing gate's own error line is in the output verbatim.
- `proof-missing` — the PR was built and reviewed clean (or clean after the
  one bounded repair), but no live SHA-bound proof receipt could be verified
  — most commonly because the PR does not match `create-prove`'s supported
  shape (a single changed `skills/<slug>/SKILL.md`). This is an honest
  result, not a failure: report the verified PR and say plainly that proof
  was not produced and why.
- `success-proven` — the PR was built, reviewed clean (or clean after one
  bounded repair), and a live SHA-bound proof receipt was verified.

State the target, the verified PR URL (if any), every dispatched run's ID
(feature/review/repair/re-review/proof), the final gate result each script
call returned, and the terminal status above. Never claim `success-proven`
or `no-action` without having run the gate script that verifies it — the
captured stdout of that script call is the evidence.

## Log

Append the result to `memory/logs/<today's date>.md` under `### dev-loop-runner`:
target, verified PR (if any), every dispatched run ID, and the terminal
`DEV_LOOP_RUNNER_STATUS`.

## Do not

- Do not merge, close, approve, or modify the target PR yourself — that is
  `feature`'s (build/repair) and `pr-review`'s job, each running as its own
  separately dispatched skill.
- Do not run `feature` and `pr-review` in this same run's context. Every
  build and every review is a separate `gh workflow run aeon.yml` dispatch
  this skill polls for — never an in-context tool call pretending to be one.
- Do not dispatch a second repair pass. One bounded repair, ever, per run.
- Do not widen `create-prove`'s target grammar, `dev-loop-pr.sh`'s
  push-access check, or add a fork-and-cross-repo-PR path.
- Do not place a GitHub token on a command line.
