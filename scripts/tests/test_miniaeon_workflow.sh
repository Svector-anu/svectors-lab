#!/usr/bin/env bash
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
if not re.search(r"(?ms)^  workflow_dispatch:\n    inputs:\n(?:.*?\n)      var:\n", text):
    raise SystemExit("workflow_dispatch is missing the var input")

lines = text.splitlines()
for i, line in enumerate(lines):
    if line == "      - name: Run skill":
        step_start = i
        break
else:
    raise SystemExit("Run skill step not found")

run_start = None
for i in range(step_start + 1, len(lines)):
    if lines[i].startswith("      - name: "):
        break
    if lines[i] == "        run: |":
        run_start = i + 1
        break
if run_start is None:
    raise SystemExit("Run skill step has no shell body")

body = []
for line in lines[run_start:]:
    if line.startswith("      - name: "):
        break
    if line.startswith("          "):
        body.append(line[10:])
    elif line == "":
        body.append("")
    else:
        break

open(sys.argv[2], "w", encoding="utf-8").write("\n".join(body) + "\n")
PY

chmod +x "$RUN_SCRIPT"
LOG="$SANDBOX/miniaeon.log"
cat > "$SANDBOX/miniaeon-bin" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$MINIAEON_TEST_LOG"
SH
chmod +x "$SANDBOX/miniaeon-bin"

run_case() {
  : > "$LOG"
  env \
    RUNNER_TEMP="$SANDBOX" \
    MINIAEON_TEST_LOG="$LOG" \
    OPENROUTER_API_KEY="stub" \
    "$@" \
    bash "$RUN_SCRIPT" >/dev/null
}

assert_log() {
  expected=$1
  actual=$(cat "$LOG")
  if [ "$actual" != "$expected" ]; then
    echo "expected miniaeon argv: $expected" >&2
    echo "actual miniaeon argv:   $actual" >&2
    exit 1
  fi
}

run_case GITHUB_EVENT_NAME=workflow_dispatch INPUT_SKILL=feature INPUT_VAR=external:Svector-anu/svectors-lab
assert_log "run feature --var external:Svector-anu/svectors-lab"

run_case GITHUB_EVENT_NAME=workflow_dispatch INPUT_SKILL=feature INPUT_VAR=
assert_log "run feature"

run_case GITHUB_EVENT_NAME=schedule INPUT_SKILL= INPUT_VAR=external:Svector-anu/svectors-lab
assert_log "run-due"

run_case GITHUB_EVENT_NAME=repository_dispatch INPUT_SKILL=feature INPUT_VAR=external:Svector-anu/svectors-lab
assert_log "run-due"

echo 'miniaeon workflow var tests passed'
