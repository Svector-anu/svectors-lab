#!/usr/bin/env bash
# Structural regression test for F-005: the webhook must remain a relay into the
# canonical aeon.yml skill runner, never grow a parallel executor that bypasses
# scripts/skill_mode.sh or drops the runtime selector (`var`).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
WORKER="$ROOT/apps/webhook/src/worker.js"
MESSAGES="$ROOT/.github/workflows/messages.yml"
ROUTER="$ROOT/scripts/telegram-route.sh"
RUNNER="$ROOT/.github/workflows/aeon.yml"

grep -Fq 'event_type: eventType, client_payload: clientPayload' "$WORKER"
grep -Fq 'types: [telegram-message, discord-message, slack-message, cron-tick, telegram-command, telegram-callback, telegram-reply]' "$MESSAGES"
grep -Fq 'bash scripts/telegram-route.sh reply    "$REPLY_TO" "$TEXT"' "$MESSAGES"
grep -Fq 'gh workflow run aeon.yml -f skill="$skill" -f var="$var"' "$ROUTER"
grep -Fq 'source scripts/resolve-riva-capabilities.sh' "$RUNNER"
grep -Fq 'bash scripts/skill_mode.sh mode' "$ROOT/scripts/resolve-riva-capabilities.sh"
grep -Fq 'bash scripts/skill_mode.sh allowed-tools' "$ROOT/scripts/resolve-riva-capabilities.sh"

# The relay must not become its own harness or capability resolver. If the
# webhook ever executes skills directly, this test should fail until that new
# surface is explicitly wired to the shared resolver and sandbox.
if grep -Eq 'run-harness|skill_mode\.sh|child_process|spawn(Sync)?\(' "$WORKER"; then
  echo "FAIL - webhook contains a direct skill-execution path" >&2
  exit 1
fi

echo "ok - webhook skill dispatch converges on aeon.yml capability resolution with var preserved"
