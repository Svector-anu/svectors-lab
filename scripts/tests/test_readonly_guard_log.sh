#!/usr/bin/env bash
# Regression test for aeon.yml's "Read-only capability guard" step: a
# successful read-only skill's run-log entry must carry its real captured
# output under a "### <skill>" heading (the shape every read-only SKILL.md's
# own instructions look for on the next run's dedup/diff), not a
# content-free stub — while a failed or output-less run must still fall back
# to the stub so nothing stale gets logged as this run's result.
set -uo pipefail

WORKFLOW="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/.github/workflows/aeon.yml"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Extract the guard verbatim from the "Read-only capability guard" step: from
# the SKILL= assignment up to (excluding) the CODE_PATHS revert logic — same
# anchored-sed extraction pattern as test_chain_runner_invalid_dispatch.sh.
awk '
  /^          # \(incl\. \.chains\/\) are preserved for the commit step\.$/ { on=1; next }
  on && /^          SKILL=/ { print; next }
  on && /^          CODE_PATHS=/ { exit }
  on { print }
' "$WORKFLOW" | sed 's/^          //' > "$TMP/guard.sh"
grep -q 'CAPTURED="output/.chains' "$TMP/guard.sh" && grep -q 'RUN_OUTCOME' "$TMP/guard.sh" \
  || { echo "FAIL: extraction anchor drifted — expected content missing from extracted guard" >&2; cat "$TMP/guard.sh" >&2; exit 1; }

fail=0
pass() { echo "ok   - $1"; }
bad() { echo "FAIL - $1"; fail=1; }

run_guard() {
  # $1 = steps.skill.outputs.name, $2 = steps.run.outcome
  local skill="$1" outcome="$2"
  local workdir="$TMP/run-$RANDOM"
  mkdir -p "$workdir/memory/logs" "$workdir/output/.chains"
  if [ -n "${3:-}" ]; then printf '%s' "$3" > "$workdir/output/.chains/${skill}.md"; fi
  (
    cd "$workdir" || exit 1
    sed "s|\${{ steps.skill.outputs.name }}|$skill|; s|\${{ steps.run.outcome }}|$outcome|" "$TMP/guard.sh" > guard.sh
    bash guard.sh
  )
  cat "$workdir/memory/logs/$(date -u +%Y-%m-%d).md" 2>/dev/null
}

# Successful run with real captured output → the log entry carries the real
# content under a "### <skill>" heading (3-hash — what narrative-tracker,
# github-trending, token-pick, etc.'s own SKILL.md all instruct diffing
# against), not the old content-free "## <skill> (read-only)" stub.
out=$(run_guard narrative-tracker success '*Narrative Tracker — 2026-09-08*
TRANSITIONS
• NEW: ZCAT/privacy')
echo "$out" | grep -q '^### narrative-tracker$' && pass "success: writes a 3-hash '### <skill>' heading" \
  || bad "success: missing '### narrative-tracker' heading"
echo "$out" | grep -q 'NEW: ZCAT/privacy' && pass "success: real captured output lands in the log" \
  || bad "success: captured output missing from the log entry"

# Failed run → falls back to the stub (no stale/wrong content masquerading as
# this run's real output).
out=$(run_guard narrative-tracker failure '')
echo "$out" | grep -q '^## narrative-tracker (read-only)$' && pass "failure: falls back to the stub heading" \
  || bad "failure: should fall back to the stub, not fabricate content"
echo "$out" | grep -q 'outcome=failure' && pass "failure: stub records the real outcome" \
  || bad "failure: stub should record outcome=failure"

# Successful run but nothing was captured (empty/missing output/.chains file)
# → also falls back to the stub rather than logging an empty heading.
out=$(run_guard narrative-tracker success '')
echo "$out" | grep -q '^## narrative-tracker (read-only)$' && pass "success-but-empty: falls back to the stub" \
  || bad "success-but-empty: should fall back to the stub, not log an empty '### ' heading"

echo "---"
[ "$fail" -eq 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit "$fail"
