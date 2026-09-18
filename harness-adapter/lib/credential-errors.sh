#!/usr/bin/env bash

credential_degraded_reason() {
  local harness="${1:-}"
  shift || true

  case "$harness" in
    codex)
      if grep -Fqi 'refresh token was revoked' "$@" 2>/dev/null; then
        printf '%s\n' 'refresh token was revoked'
        return 0
      fi
      if tr '\n' ' ' < "$1" 2>/dev/null \
          | grep -Eqi '401 Unauthorized.*chatgpt\.com/backend-api/codex|chatgpt\.com/backend-api/codex.*401 Unauthorized'; then
        printf '%s\n' '401 Unauthorized from chatgpt.com/backend-api/codex'
        return 0
      fi
      ;;
  esac

  return 1
}
