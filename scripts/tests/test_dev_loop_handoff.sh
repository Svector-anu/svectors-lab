#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
CHECK="$ROOT/scripts/dev-loop-pr.sh"
CONFIG="$ROOT/aeon.yml"
RUNNER="$ROOT/.github/workflows/chain-runner.yml"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/bin"
cat > "$TMP/bin/gh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
[ "$1" = api ]
[ "$2" = repos/acme/demo/pulls/42 ]
printf 'open\thttps://github.com/acme/demo/pull/42\n'
EOF
chmod +x "$TMP/bin/gh"

output="$TMP/feature.md"
printf 'PR: https://github.com/acme/demo/pull/42\n' > "$output"

grep -Fq 'target:' "$RUNNER"
grep -Fq '_INPUT_TARGET: ${{ inputs.target }}' "$RUNNER"
grep -Fq 'var: "$chain_target"' "$CONFIG"
grep -Fq 'var: "$feature_pr"' "$CONFIG"

[ "$(bash "$CHECK" validate-target external:acme/demo#7)" = 'acme/demo' ]
[ "$(PATH="$TMP/bin:$PATH" bash "$CHECK" verify-pr external:acme/demo "$output")" = 'acme/demo#42' ]

printf 'No PR was needed.\n' > "$output"
if PATH="$TMP/bin:$PATH" bash "$CHECK" verify-pr external:acme/demo "$output"; then
  echo 'missing PR URL unexpectedly verified' >&2
  exit 1
else
  [ "$?" -eq 3 ]
fi

printf 'PR: https://github.com/other/demo/pull/42\n' > "$output"
if PATH="$TMP/bin:$PATH" bash "$CHECK" verify-pr external:acme/demo "$output"; then
  echo 'wrong repository PR unexpectedly verified' >&2
  exit 1
fi

if bash "$CHECK" validate-target watched; then
  echo 'implicit watched target unexpectedly validated' >&2
  exit 1
fi

echo 'dev-loop handoff tests passed'
