#!/usr/bin/env bash
# Deterministic state gates for the single repair pass in dev-loop.
set -euo pipefail

usage() {
  echo "usage: $0 head <owner/repo#pr> | repair-target <owner/repo#pr> <expected-sha> | verify-change <owner/repo#pr> <old-sha> | verify-checks <owner/repo#pr> <sha>" >&2
  exit 64
}

validate_target() {
  [[ "${1:-}" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+#[1-9][0-9]*$ ]] || {
    echo "dev-loop repair: target must be owner/repo#pr" >&2
    return 2
  }
}

validate_sha() {
  [[ "${1:-}" =~ ^[0-9a-f]{40}$ ]] || {
    echo "dev-loop repair: sha must be 40 lowercase hex characters" >&2
    return 2
  }
}

pr_json() {
  local target="$1" repo number
  repo=${target%#*}
  number=${target##*#}
  gh api "repos/$repo/pulls/$number"
}

case "${1:-}" in
  head)
    [ "$#" -eq 2 ] || usage
    validate_target "$2"
    state=$(pr_json "$2")
    [ "$(jq -r '.state' <<<"$state")" = open ] || {
      echo "dev-loop repair: PR is not open" >&2
      exit 1
    }
    jq -er '.head.sha | select(test("^[0-9a-f]{40}$"))' <<<"$state"
    ;;
  repair-target)
    [ "$#" -eq 3 ] || usage
    validate_target "$2"
    validate_sha "$3"
    current=$("$0" head "$2")
    [ "$current" = "$3" ] || {
      echo "dev-loop repair: PR head changed before repair (expected $3, found $current)" >&2
      exit 1
    }
    printf 'repair:%s@%s\n' "$2" "$3"
    ;;
  verify-change)
    [ "$#" -eq 3 ] || usage
    validate_target "$2"
    validate_sha "$3"
    current=$("$0" head "$2")
    [ "$current" != "$3" ] || {
      echo "dev-loop repair: repair completed without changing the PR head" >&2
      exit 1
    }
    printf '%s\n' "$current"
    ;;
  verify-checks)
    [ "$#" -eq 3 ] || usage
    validate_target "$2"
    validate_sha "$3"
    repo=${2%#*}
    pages=$(gh api --paginate --slurp "repos/$repo/commits/$3/check-runs?per_page=100")
    statuses=$(gh api "repos/$repo/commits/$3/status")
    checks=$(jq '[.[].check_runs[]]' <<<"$pages")
    total=$(jq 'length' <<<"$checks")
    reported=$(jq '.[0].total_count // 0' <<<"$pages")
    [ "$total" -eq "$reported" ] || {
      echo "dev-loop repair: check-runs pagination was incomplete (received $total of $reported)" >&2
      exit 1
    }
    pending=$(jq '[.[] | select(.status != "completed")] | length' <<<"$checks")
    [ "$pending" -eq 0 ] || {
      echo "dev-loop repair: repaired SHA still has $pending pending check(s)" >&2
      exit 3
    }
    failed=$(jq '[.[] | select(.conclusion != "success" and .conclusion != "neutral" and .conclusion != "skipped")] | length' <<<"$checks")
    [ "$failed" -eq 0 ] || {
      echo "dev-loop repair: repaired SHA has $failed unsuccessful check(s)" >&2
      exit 1
    }
    successful=$(jq '[.[] | select(.conclusion == "success")] | length' <<<"$checks")
    status_pending=$(jq '[.statuses[] | select(.state == "pending")] | length' <<<"$statuses")
    [ "$status_pending" -eq 0 ] || {
      echo "dev-loop repair: SHA still has $status_pending pending commit status(es)" >&2
      exit 3
    }
    status_failed=$(jq '[.statuses[] | select(.state == "failure" or .state == "error")] | length' <<<"$statuses")
    [ "$status_failed" -eq 0 ] || {
      echo "dev-loop repair: SHA has $status_failed unsuccessful commit status(es)" >&2
      exit 1
    }
    status_successful=$(jq '[.statuses[] | select(.state == "success")] | length' <<<"$statuses")
    [ $((successful + status_successful)) -gt 0 ] || {
      echo "dev-loop repair: SHA has no successful check or commit status" >&2
      exit 1
    }
    status_total=$(jq '.statuses | length' <<<"$statuses")
    jq -cn --arg target "$2" --arg sha "$3" --argjson checks "$total" --argjson statuses "$status_total" \
      '{schema:1,target:$target,sha:$sha,checks:$checks,statuses:$statuses,status:"passed"}'
    ;;
  *) usage ;;
esac
