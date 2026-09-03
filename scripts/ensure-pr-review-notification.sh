#!/usr/bin/env bash
set -euo pipefail

output_file="${1:-output/.chains/pr-review.md}"
queue_root="${AEON_PENDING_DIR:-${RUNNER_TEMP:-/tmp}/aeon-pending}"
queue="$queue_root/notify-queue"

shopt -s nullglob
queued=("$queue"/*.json)
if [ ${#queued[@]} -gt 0 ]; then
  echo "pr-review notification already queued"
  exit 0
fi

if [ ! -s "$output_file" ] || [ "$(head -n 1 "$output_file")" = "_No output captured._" ]; then
  echo "pr-review produced no usable output to notify" >&2
  exit 1
fi

SKILL_NAME=pr-review bash scripts/notify.sh -f "$output_file"

queued=("$queue"/*.json)
if [ ${#queued[@]} -eq 0 ]; then
  echo "pr-review notification was not queued" >&2
  exit 1
fi

echo "pr-review notification queued from captured output"
