#!/usr/bin/env bash
# Select the Grok CLI model without crossing native auth catalogs.
set -euo pipefail

[ "$#" -eq 2 ] || { echo "usage: $0 <native-key|native-oauth> <requested-model>" >&2; exit 64; }
auth_mode="$1"
requested="$2"

case "$auth_mode" in
  native-key)
    # The xAI API-key catalog is not the Grok Build OAuth catalog. Let the CLI
    # select its authenticated default instead of forcing an OAuth-only id.
    printf '\n'
    ;;
  native-oauth)
    case "$requested" in
      ""|claude-*) printf '%s\n' grok-4.5 ;;
      *) printf '%s\n' "$requested" ;;
    esac
    ;;
  *)
    echo "resolve-grok-model: unsupported auth mode: $auth_mode" >&2
    exit 2
    ;;
esac
