#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
cd "$ROOT"

export AEON_PENDING_DIR="$TMP/pending"
output="$TMP/review.md"
printf '%s\n' 'Reviewed Svector-anu/example#1.' '**Verdict**: approve-ready' > "$output"

bash scripts/ensure-pr-review-notification.sh "$output" >/dev/null
count=$(find "$AEON_PENDING_DIR/notify-queue" -type f -name '*.json' | wc -l | tr -d ' ')
[ "$count" = "1" ] || { echo "expected one queued notification, got $count" >&2; exit 1; }

bash scripts/ensure-pr-review-notification.sh "$output" >/dev/null
count=$(find "$AEON_PENDING_DIR/notify-queue" -type f -name '*.json' | wc -l | tr -d ' ')
[ "$count" = "1" ] || { echo "existing notification was duplicated" >&2; exit 1; }

rm -rf "$AEON_PENDING_DIR"
printf '%s\n' 'PR_REVIEW_OK — no eligible pull requests' > "$output"
bash scripts/ensure-pr-review-notification.sh "$output" >/dev/null
if [ -d "$AEON_PENDING_DIR/notify-queue" ]; then
  count=$(find "$AEON_PENDING_DIR/notify-queue" -type f -name '*.json' | wc -l | tr -d ' ')
else
  count=0
fi
[ "$count" = "0" ] || { echo "no-signal review unexpectedly queued a notification" >&2; exit 1; }

rm -rf "$AEON_PENDING_DIR"
if bash scripts/ensure-pr-review-notification.sh "$TMP/missing.md" >/dev/null 2>&1; then
  echo "missing review output unexpectedly passed" >&2
  exit 1
fi

echo "pr-review-notification-gate: PASS"
