#!/usr/bin/env bash
# Source from the Aeon runner after SKILL_NAME and SKILL_VAR are exported.
# Resolves the capability tier before MCP or skill-secret setup.
set -u

SHADOW_MODE=0
if [ "${SKILL_NAME:-}" = "vuln-scanner" ] && [[ "${SKILL_VAR:-}" == shadow:* || "${SKILL_VAR:-}" == compare:* ]]; then
  SHADOW_MODE=1
  SKILL_MODE=read-only
  echo "Riva shadow mode: forcing read-only capability tier"
else
  SKILL_MODE=$(bash scripts/skill_mode.sh mode "${SKILL_NAME:-}")
fi
ALLOWED=$(bash scripts/skill_mode.sh allowed-tools "$SKILL_MODE")
export SHADOW_MODE SKILL_MODE ALLOWED
echo "RIVA_SHADOW_MODE=$SHADOW_MODE" >> "${GITHUB_ENV:-/dev/null}"
echo "SKILL_MODE=$SKILL_MODE" >> "${GITHUB_ENV:-/dev/null}"
echo "Capability mode: $SKILL_MODE"
