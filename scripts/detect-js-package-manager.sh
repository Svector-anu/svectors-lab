#!/usr/bin/env bash
set -euo pipefail

repo="${1:?usage: detect-js-package-manager.sh owner/repo head-sha}"
sha="${2:?usage: detect-js-package-manager.sh owner/repo head-sha}"

tree=$(gh api "repos/$repo/git/trees/$sha?recursive=1" --jq '.tree[].path')

for candidate in \
  'pnpm:pnpm-lock.yaml' \
  'npm:package-lock.json' \
  'yarn:yarn.lock' \
  'bun:bun.lock' \
  'bun:bun.lockb'; do
  manager=${candidate%%:*}
  lockfile=${candidate#*:}
  if grep -Fxq "$lockfile" <<<"$tree"; then
    printf '%s\t%s\n' "$manager" "$lockfile"
    exit 0
  fi
done

printf 'none\t-\n'
