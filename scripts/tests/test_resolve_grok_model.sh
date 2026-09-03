#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
RESOLVE="$ROOT/scripts/resolve-grok-model.sh"
WORKFLOW="$ROOT/.github/workflows/aeon.yml"

if [ -n "$(bash "$RESOLVE" native-key grok-4.5)" ]; then
  echo 'native-key path unexpectedly forced the oauth model' >&2
  exit 1
fi
if [ -n "$(bash "$RESOLVE" native-key claude-sonnet-5)" ]; then
  echo 'native-key path unexpectedly forwarded the config model' >&2
  exit 1
fi
[ "$(bash "$RESOLVE" native-oauth claude-sonnet-5)" = grok-4.5 ]
[ "$(bash "$RESOLVE" native-oauth grok-custom)" = grok-custom ]
if bash "$RESOLVE" openrouter grok-4.5; then
  echo 'unsupported grok auth mode unexpectedly resolved' >&2
  exit 1
fi

grep -Fq 'RH_AUTH_MODE: ${{ steps.harness.outputs.AUTH_MODE }}' "$WORKFLOW"
[ "$(grep -Fc 'resolve-grok-model.sh' "$WORKFLOW")" -eq 2 ]

echo 'grok auth-specific model tests passed'
