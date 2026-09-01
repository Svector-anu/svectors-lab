#!/usr/bin/env bash
# Regression test for chain-runner's run-name correlation.
# Two same-skill dispatches must resolve their own runs when GitHub lists both.
set -uo pipefail

WORKFLOW="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/.github/workflows/chain-runner.yml"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin"

cat > "$TMP/bin/gh" <<'FAKE_GH'
#!/usr/bin/env bash
set -euo pipefail
STATE=${FAKE_GH_STATE:?}
if [ "${1:-} ${2:-}" = "workflow run" ]; then
  shift 2; skill=''; var=''; dispatch_id=''
  while [ "$#" -gt 0 ]; do
    if [ "$1" = '-f' ]; then
      key=${2%%=*}; value=${2#*=}
      case "$key" in skill) skill=$value ;; var) var=$value ;; dispatch_id) dispatch_id=$value ;; esac
      shift 2
    else shift; fi
  done
  printf '%s\t%s\t%s\n' "$skill" "$var" "$dispatch_id" >> "$STATE"
  exit 0
fi
if [ "${1:-} ${2:-}" = "run list" ]; then
  for _ in $(seq 1 100); do [ "$(wc -l < "$STATE" | tr -d ' ')" -ge 2 ] && break; sleep 0.01; done
  while IFS=$'\t' read -r skill var dispatch_id; do
    [ "$var" = alpha ] && db_id=1001 || db_id=1002
    jq -cn --arg id "$db_id" --arg skill "$skill" --arg var "$var" --arg dispatch_id "$dispatch_id" \
      '{databaseId:($id|tonumber),displayTitle:("skill: "+$skill+" ("+$var+") [dispatch: "+$dispatch_id+"]"),createdAt:"2099-01-01T00:00:00Z"}'
  done < "$STATE" | jq -s 'reverse'
  exit 0
fi
exit 2
FAKE_GH
chmod +x "$TMP/bin/gh"

sed -n '/^          dispatch_skill() {/,/^          }$/p' "$WORKFLOW" | sed 's/^          //' > "$TMP/helper.sh"
sleep() { :; }
# shellcheck source=/dev/null
source "$TMP/helper.sh"
export PATH="$TMP/bin:$PATH" FAKE_GH_STATE="$TMP/dispatches"
: > "$FAKE_GH_STATE"
dispatch_skill digest alpha > "$TMP/alpha" & a=$!
dispatch_skill digest beta > "$TMP/beta" & b=$!
wait "$a"; wait "$b"
[ "$(tail -1 "$TMP/alpha")" = 1001 ]
[ "$(tail -1 "$TMP/beta")" = 1002 ]
ids=$(cut -f3 "$FAKE_GH_STATE")
[ "$(printf '%s\n' "$ids" | sort -u | wc -l | tr -d ' ')" = 2 ]
while IFS= read -r id; do [[ "$id" =~ ^chain-[0-9a-f]{32}$ ]]; done <<< "$ids"
echo 'chain-runner correlation tests passed'
