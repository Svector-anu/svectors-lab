#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
WF="$ROOT/.github/workflows/aeon.yml"
SKILL="$ROOT/skills/vuln-scanner/SKILL.md"

grep -q 'SHADOW_MODE=1' "$WF"
grep -q 'SKILL_MODE=read-only' "$WF"
grep -q 'SHADOW_MODE.*!=.*1' "$WF"
grep -q 'unset ALL_SECRETS GH_GLOBAL GH_TOKEN GITHUB_TOKEN' "$WF"
grep -q 'If `KERNEL=shadow`' "$SKILL"
grep -q 'do not execute A5' "$SKILL"
echo "ok - Riva shadow mode is workflow-isolated and comparison-only"
