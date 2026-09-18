#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
SKILL="$ROOT/skills/idea-pipeline/SKILL.md"

grep -Fq -- '--context "dev-loop::ship"' "$SKILL"
grep -Fq -- '.permissions.push // false' "$SKILL"
grep -Fq 'require exactly one candidate' "$SKILL"
grep -Fq 'This prompt does not dispatch work.' "$SKILL"
grep -Fq 'no target, multiple targets, an API failure, or no push access' "$SKILL"
grep -Fq 'FORCE_REPLY_OFFERED: dev-loop::ship target=' "$SKILL"
grep -Fq 'starts with `offer:`' "$SKILL"
grep -Fq 'explicit operator-invoked producer path' "$SKILL"

if sed -n '/### 0\. Force-reply interception/,/### 1\. Load the idea backlog/p' "$SKILL" \
  | grep -Eq 'gh workflow run|dispatch_dev_loop'; then
  echo 'idea-pipeline pick handler must not dispatch the chain itself' >&2
  exit 1
fi

echo 'idea-pipeline dev-loop offer contract tests passed'
