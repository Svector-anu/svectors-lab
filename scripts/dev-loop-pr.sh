#!/usr/bin/env bash
# Deterministic handoff checks for the dev-loop chain.
# Feature output is not proof that it opened a PR. Compare GitHub's open-PR state
# before and after the run before asking pr-review to comment on anything.
set -euo pipefail

usage() {
  echo "usage: $0 validate-target <external:owner/repo[#issue]> | snapshot <target> | verify-new-pr <target> <before-file>" >&2
  exit 64
}

target_repo() {
  local target="${1:-}"
  if [[ ! "$target" =~ ^external:([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)(#[1-9][0-9]*)?$ ]]; then
    echo "dev-loop: target must be external:owner/repo or external:owner/repo#issue" >&2
    return 2
  fi
  printf '%s/%s\n' "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
}

case "${1:-}" in
  validate-target)
    [ "$#" -eq 2 ] || usage
    target_repo "$2"
    ;;
  snapshot)
    [ "$#" -eq 2 ] || usage
    repo=$(target_repo "$2") || exit $?
    gh pr list -R "$repo" --state open --limit 100 --json number --jq '.[].number' | cut -f1 | sort -n
    ;;
  verify-new-pr)
    [ "$#" -eq 3 ] || usage
    repo=$(target_repo "$2") || exit $?
    before="$3"
    [ -f "$before" ] || { echo "dev-loop: pre-feature PR snapshot is missing: $before" >&2; exit 1; }
    attempts="${DEV_LOOP_PR_VERIFY_ATTEMPTS:-3}"
    backoff="${DEV_LOOP_PR_VERIFY_BACKOFF:-2}"
    actor=$(gh api user --jq .login)
    [ -n "$actor" ] || { echo "dev-loop: could not determine the feature actor" >&2; exit 1; }
    for attempt in $(seq 1 "$attempts"); do
      after=$(mktemp)
      gh pr list -R "$repo" --state open --limit 100 --json number,author --jq '.[] | "\(.number)\t\(.author.login)"' | sort -n > "$after"
      after_numbers=$(mktemp)
      cut -f1 "$after" > "$after_numbers"
      new_prs=()
      while IFS= read -r number; do
        [ -n "$number" ] && new_prs+=("$number")
      done < <(comm -13 "$before" "$after_numbers")
      if [ "${#new_prs[@]}" -eq 1 ]; then
        pr_actor=$(awk -F '\t' -v n="${new_prs[0]}" '$1 == n { print $2 }' "$after")
        if [ "$pr_actor" = "$actor" ]; then
          printf '%s#%s\n' "$repo" "${new_prs[0]}"
          exit 0
        fi
        echo "dev-loop: new PR #${new_prs[0]} was opened by $pr_actor, not feature actor $actor" >&2
        exit 1
      fi
      if [ "${#new_prs[@]}" -gt 1 ]; then
        echo "dev-loop: ${#new_prs[@]} new open PRs appeared; refusing ambiguous review handoff" >&2
        exit 1
      fi
      [ "$attempt" -lt "$attempts" ] && sleep "$backoff"
    done
    echo "dev-loop: feature created no new open PR; review will be skipped" >&2
    exit 3
    ;;
  *) usage ;;
esac
