#!/usr/bin/env bash
# Regression test for dev-loop telemetry: a completed run with no verified PR
# must emit a distinct no-action status and skip reliability bookkeeping. Real
# failures and reviewed successes must keep their existing status/write paths.
set -uo pipefail

WORKFLOW="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/.github/workflows/chain-runner.yml"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Extract the final-status block verbatim. Anchors make workflow reflow fail the
# test rather than silently exercising a hand-maintained copy.
awk '
  /^          # --- Final status ---$/ { on=1; next }
  on && /^      - name: Update cron state$/ { exit }
  on { print }
' "$WORKFLOW" | sed 's/^          //' > "$TMP/status.sh"
grep -q 'CHAIN_NO_ACTION' "$TMP/status.sh" && grep -q 'CHAIN_STATUS=success' "$TMP/status.sh" \
  || { echo "FAIL: final-status extraction anchor drifted" >&2; cat "$TMP/status.sh" >&2; exit 1; }

# Extract the cron-state gate verbatim, then add a sentinel for the real write.
awk '
  /^          # env-bound \+ allowlisted, same as the Run chain step\./ { on=1 }
  on && /^          STATE_FILE="memory\/cron-state\.json"$/ { exit }
  on { print }
' "$WORKFLOW" | sed 's/^          //' > "$TMP/guard.sh"
grep -q 'invalid-dispatch' "$TMP/guard.sh" && grep -q 'no-action' "$TMP/guard.sh" \
  || { echo "FAIL: cron-state extraction anchor drifted" >&2; cat "$TMP/guard.sh" >&2; exit 1; }
printf 'echo REACHED_STATE_WRITE\n' >> "$TMP/guard.sh"

run_status() {
  local failed="$1" no_action="$2" env_file="$TMP/env"
  : > "$env_file"
  CHAIN="dev-loop" CHAIN_FAILED="$failed" CHAIN_NO_ACTION="$no_action" \
    GITHUB_ENV="$env_file" bash "$TMP/status.sh"
  local rc=$?
  STATUS_RESULT="$(sed -n 's/^CHAIN_STATUS=//p' "$env_file" | tail -1)"
  return "$rc"
}

run_guard() {
  _INPUT_CHAIN="dev-loop" CHAIN_STATUS="$1" bash "$TMP/guard.sh"
}

fail=0
pass() { echo "ok   - $1"; }
bad() { echo "FAIL - $1"; fail=1; }

# Completed with no PR: distinct status, successful job, excluded from ratio.
run_status false true; rc=$?
[ "$rc" -eq 0 ] && [ "$STATUS_RESULT" = "no-action" ] \
  && pass "no-action emits CHAIN_STATUS=no-action" \
  || bad "no-action should emit no-action and exit 0 (status=$STATUS_RESULT rc=$rc)"
out=$(run_guard "$STATUS_RESULT"); rc=$?
[ "$rc" -eq 0 ] && ! echo "$out" | grep -q 'REACHED_STATE_WRITE' \
  && pass "no-action skips the cron-state reliability write" \
  || bad "no-action must not reach cron-state write (rc=$rc)"

# Genuine failure: unchanged failed status and normal reliability write path.
run_status true false; rc=$?
[ "$rc" -eq 1 ] && [ "$STATUS_RESULT" = "failed" ] \
  && pass "failure still emits CHAIN_STATUS=failed" \
  || bad "failure path changed (status=$STATUS_RESULT rc=$rc)"
out=$(run_guard "$STATUS_RESULT"); rc=$?
[ "$rc" -eq 0 ] && echo "$out" | grep -q 'REACHED_STATE_WRITE' \
  && pass "failure still reaches the cron-state write" \
  || bad "failure must reach cron-state write (rc=$rc)"

# Normal reviewed completion: unchanged success status and reliability write.
run_status false false; rc=$?
[ "$rc" -eq 0 ] && [ "$STATUS_RESULT" = "success" ] \
  && pass "reviewed completion still emits CHAIN_STATUS=success" \
  || bad "success path changed (status=$STATUS_RESULT rc=$rc)"
out=$(run_guard "$STATUS_RESULT"); rc=$?
[ "$rc" -eq 0 ] && echo "$out" | grep -q 'REACHED_STATE_WRITE' \
  && pass "success still reaches the cron-state write" \
  || bad "success must reach cron-state write (rc=$rc)"

echo "---"
[ "$fail" -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit "$fail"
