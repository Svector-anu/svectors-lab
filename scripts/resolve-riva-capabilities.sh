#!/usr/bin/env bash
# Source from the Aeon runner after SKILL_NAME and SKILL_VAR are exported.
# Resolves the capability tier before MCP or skill-secret setup.
set -u

# The selector check itself now lives in scripts/skill_mode.sh (is_shadow_selector),
# the one place every dispatch surface consults - this used to keep its own copy of
# the pattern, which is how apps/mcp-server/src/skill-executor.ts missed it entirely.
SHADOW_MODE=0
if [ "$(bash scripts/skill_mode.sh is-shadow "${SKILL_NAME:-}" "${SKILL_VAR:-}")" = "true" ]; then
  SHADOW_MODE=1
  SKILL_MODE=read-only
  echo "Riva shadow mode: forcing read-only capability tier"
else
  SKILL_MODE=$(bash scripts/skill_mode.sh mode "${SKILL_NAME:-}" "${SKILL_VAR:-}")
fi
ALLOWED=$(bash scripts/skill_mode.sh allowed-tools "$SKILL_MODE")
export SHADOW_MODE SKILL_MODE ALLOWED
echo "RIVA_SHADOW_MODE=$SHADOW_MODE" >> "${GITHUB_ENV:-/dev/null}"
echo "SKILL_MODE=$SKILL_MODE" >> "${GITHUB_ENV:-/dev/null}"
echo "Capability mode: $SKILL_MODE"
