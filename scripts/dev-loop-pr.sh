#!/usr/bin/env bash
# Deterministic handoff checks for the dev-loop chain.
# The feature skill's prose is not proof that it opened a PR: verify the claimed
# GitHub URL against the API before asking pr-review to comment on it.
set -euo pipefail

usage() {
  echo "usage: $0 validate-target <external:owner/repo[#issue]> | verify-pr <target> <feature-output>" >&2
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
  verify-pr)
    [ "$#" -eq 3 ] || usage
    repo=$(target_repo "$2") || exit $?
    output="$3"
    [ -f "$output" ] || { echo "dev-loop: feature output is missing: $output" >&2; exit 1; }

    urls=()
    while IFS= read -r url; do
      [ -n "$url" ] && urls+=("$url")
    done < <(grep -oE 'https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+/pull/[1-9][0-9]*' "$output" | sort -u || true)
    if [ "${#urls[@]}" -eq 0 ]; then
      echo "dev-loop: feature completed without a PR URL; review will be skipped" >&2
      exit 3
    fi
    if [ "${#urls[@]}" -ne 1 ]; then
      echo "dev-loop: feature output names ${#urls[@]} distinct PR URLs; refusing ambiguous review handoff" >&2
      exit 1
    fi

    url="${urls[0]}"
    path="${url#https://github.com/}"
    url_repo="${path%/pull/*}"
    number="${path##*/}"
    if [ "$url_repo" != "$repo" ]; then
      echo "dev-loop: feature claimed PR $url outside requested repository $repo" >&2
      exit 1
    fi

    live=$(gh api "repos/$repo/pulls/$number" --jq '[.state, .html_url] | @tsv') || {
      echo "dev-loop: could not read claimed PR $url from GitHub" >&2
      exit 1
    }
    state="${live%%$'\t'*}"
    live_url="${live#*$'\t'}"
    if [ "$state" != "open" ] || [ "$live_url" != "$url" ]; then
      echo "dev-loop: claimed PR is not the requested open PR (state=$state url=$live_url)" >&2
      exit 1
    fi
    printf '%s#%s\n' "$repo" "$number"
    ;;
  *) usage ;;
esac
