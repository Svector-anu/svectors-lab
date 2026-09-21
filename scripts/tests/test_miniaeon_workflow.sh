#!/usr/bin/env bash
# Exercises the Run skill step of .github/workflows/miniaeon.yml against a stub
# miniaeon binary, so the argv each dispatch shape produces is pinned: var is
# forwarded, and a prove- dispatch never commits, pushes or notifies (a proof
# run that published would move the head SHA it is proving).
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
WORKFLOW="$ROOT/.github/workflows/miniaeon.yml"
SANDBOX=$(mktemp -d)
trap 'rm -rf "$SANDBOX"' EXIT

RUN_SCRIPT="$SANDBOX/run-skill.sh"
python3 - "$WORKFLOW" "$RUN_SCRIPT" <<'PY'
import re
import sys

text = open(sys.argv[1], encoding="utf-8").read()
for inp in ("skill", "var", "dispatch_id"):
    if not re.search(rf"(?ms)^  workflow_dispatch:\n    inputs:\n.*?^      {inp}:\n", text):
        raise SystemExit(f"workflow_dispatch is missing the {inp} input")
if "run-name: ${{ inputs.dispatch_id || 'MiniAeon' }}" not in text:
    raise SystemExit("run-name must carry dispatch_id so callers can find the exact run")


def step(name):
    m = re.search(rf"(?ms)^      - name: {re.escape(name)}\n(.*?)(?=^      - name: |\Z)", text)
    if not m:
        raise SystemExit(f"step {name!r} not found")
    return m.group(1)


if "if: ${{ !cancelled() && !startsWith(inputs.dispatch_id, 'prove-') }}" not in step("Push publication"):
    raise SystemExit("Push publication must run after a failed skill and be skipped for prove- dispatches")
if "startsWith(inputs.dispatch_id, 'prove-')" not in step("Show proof output"):
    raise SystemExit("Show proof output must run only for prove- dispatches")

lines = step("Run skill").splitlines()
start = lines.index("        run: |") + 1
body = []
for line in lines[start:]:
    if line.startswith("          "):
        body.append(line[10:])
    elif line == "":
        body.append("")
    else:
        break
open(sys.argv[2], "w", encoding="utf-8").write("\n".join(body) + "\n")
PY

LOG="$SANDBOX/miniaeon.log"
cat > "$SANDBOX/miniaeon-bin" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$MINIAEON_TEST_LOG"
SH
chmod +x "$SANDBOX/miniaeon-bin"

run_case() {
  : > "$LOG"
  env -i PATH="$PATH" \
    RUNNER_TEMP="$SANDBOX" \
    MINIAEON_TEST_LOG="$LOG" \
    OPENROUTER_API_KEY="stub" \
    "$@" \
    bash "$RUN_SCRIPT" >/dev/null 2>&1
}

assert_log() {
  local expected=$1 actual
  actual=$(cat "$LOG")
  if [ "$actual" != "$expected" ]; then
    echo "expected miniaeon argv: $expected" >&2
    echo "actual miniaeon argv:   $actual" >&2
    exit 1
  fi
}

run_case GITHUB_EVENT_NAME=workflow_dispatch INPUT_SKILL=feature INPUT_VAR=external:Svector-anu/svectors-lab
assert_log "run feature --var external:Svector-anu/svectors-lab"

run_case GITHUB_EVENT_NAME=workflow_dispatch INPUT_SKILL=feature
assert_log "run feature"

run_case GITHUB_EVENT_NAME=workflow_dispatch INPUT_SKILL=heartbeat INPUT_DISPATCH_ID=prove-12-20260921T000000Z-1
assert_log "run heartbeat --no-git --no-notify"

run_case GITHUB_EVENT_NAME=workflow_dispatch INPUT_SKILL=heartbeat INPUT_VAR="status check" INPUT_DISPATCH_ID=prove-12-20260921T000000Z-1
assert_log "run heartbeat --var status check --no-git --no-notify"

run_case GITHUB_EVENT_NAME=workflow_dispatch INPUT_SKILL=heartbeat INPUT_DISPATCH_ID=chain-7
assert_log "run heartbeat"

if run_case GITHUB_EVENT_NAME=workflow_dispatch INPUT_DISPATCH_ID=prove-12-20260921T000000Z-1; then
  echo "a prove- dispatch without a skill must fail instead of running every due skill" >&2
  exit 1
fi
assert_log ""

run_case GITHUB_EVENT_NAME=schedule INPUT_VAR=external:Svector-anu/svectors-lab
assert_log "run-due"

run_case GITHUB_EVENT_NAME=repository_dispatch INPUT_SKILL=feature INPUT_VAR=external:Svector-anu/svectors-lab
assert_log "run-due"

echo 'miniaeon workflow dispatch tests passed'
