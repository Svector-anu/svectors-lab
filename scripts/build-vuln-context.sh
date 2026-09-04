#!/usr/bin/env bash
# Read-only compact dossier builder for the Riva research kernel.
set -euo pipefail

usage() { echo "usage: $0 --repo DIR --out FILE [--history FILE]" >&2; exit 2; }
REPO=""; OUT=""; HISTORY=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --repo) REPO="${2:-}"; shift 2 ;;
    --out) OUT="${2:-}"; shift 2 ;;
    --history) HISTORY="${2:-}"; shift 2 ;;
    *) usage ;;
  esac
done
[ -d "$REPO/.git" ] || { echo "RIVA_CONTEXT_ERROR repo-not-git" >&2; exit 3; }
[ -n "$OUT" ] || usage
command -v jq >/dev/null 2>&1 || { echo "RIVA_CONTEXT_ERROR jq-missing" >&2; exit 3; }

json_lines() { jq -R -s 'split("\n") | map(select(length > 0))'; }
repo_name="$(git -C "$REPO" remote get-url origin 2>/dev/null | sed -E 's#.*github.com[:/]##; s#\.git$##' || true)"
[ -n "$repo_name" ] || repo_name="$(basename "$REPO")"
commit="$(git -C "$REPO" rev-parse HEAD)"
files="$(find "$REPO" -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.go' -o -name '*.rs' -o -name '*.sol' -o -name '*.java' -o -name '*.php' \) -not -path '*/node_modules/*' -not -path '*/vendor/*' -not -path '*/dist/*' -not -path '*/build/*' -not -path '*/.git/*' 2>/dev/null | wc -l | tr -d ' ')"
languages="$(find "$REPO" -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.go' -o -name '*.rs' -o -name '*.sol' \) -not -path '*/node_modules/*' -not -path '*/vendor/*' -not -path '*/.git/*' 2>/dev/null | sed -E 's/.*\.//' | sort -u | json_lines)"
manifests="$(find "$REPO" -maxdepth 3 -type f \( -name 'package.json' -o -name 'Cargo.toml' -o -name 'go.mod' -o -name 'pyproject.toml' -o -name 'requirements*.txt' -o -name 'foundry.toml' \) -not -path '*/node_modules/*' -not -path '*/.git/*' 2>/dev/null | sed "s#^$REPO/##" | sort | json_lines)"
security_docs="$(find "$REPO" -maxdepth 3 -type f \( -iname 'SECURITY.md' -o -iname 'AUDIT.md' -o -iname 'THREATMODEL.md' -o -iname 'THREAT-MODEL.md' \) -not -path '*/.git/*' 2>/dev/null | sed "s#^$REPO/##" | sort | json_lines)"
changed="$(git -C "$REPO" log -n 20 --format='%h %s' --all -- . ':!*.lock' | json_lines)"
entrypoints="$( (rg -l -i 'route|handler|webhook|graphql|mcp|ipc|spawn|exec|deserialize|upload|oauth|jwt|token|redirect|proxy' "$REPO" --glob '!node_modules/**' --glob '!vendor/**' --glob '!dist/**' --glob '!build/**' --glob '!*lock*' 2>/dev/null || true) | sed "s#^$REPO/##" | sed -n '1,80p' | json_lines)"
history_json='[]'
if [ -n "$HISTORY" ] && [ -f "$HISTORY" ]; then
  history_json=$(jq -c 'if type=="array" then . else (.scans // []) end | map(select((.repo // null) == $repo) | {scanned_at, findings, severity, channel, note}) | .[-10:]' --arg repo "$repo_name" "$HISTORY" 2>/dev/null || echo '[]')
fi

mkdir -p "$(dirname "$OUT")"
jq -n --arg repo "$repo_name" --arg commit "$commit" --argjson code_files "${files:-0}" \
  --argjson languages "$languages" --argjson manifests "$manifests" \
  --argjson security_docs "$security_docs" --argjson recent_changes "$changed" \
  --argjson likely_entrypoint_files "$entrypoints" --argjson previous_scans "$history_json" \
  '{schema_version:1,repo:$repo,commit:$commit,code_files:$code_files,
    languages:$languages,manifests:$manifests,security_docs:$security_docs,
    recent_changes:$recent_changes,likely_entrypoint_files:$likely_entrypoint_files,
    previous_scans:$previous_scans,
    research_fields:{assets:[],attacker_controls:[],attacker_exclusions:[],
      trust_boundaries:[],invariants:[],selected_slices:[],unresolved_questions:[]}}' > "$OUT"
echo "RIVA_CONTEXT_OK repo=$repo_name commit=$commit out=$OUT"
