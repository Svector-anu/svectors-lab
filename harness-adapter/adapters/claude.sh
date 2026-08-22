#!/usr/bin/env bash
# claude adapter — the identity adapter. Claude Code already speaks the contract;
# this just maps RH_* env to flags and folds structured output into .result.
set -uo pipefail
. "$RH_LIB/envelope.sh"

command -v claude >/dev/null 2>&1 || {
  echo "claude CLI not found (npm i -g @anthropic-ai/claude-code)" >&2; exit 1; }

ARGS=(-p - --output-format json)
[ -n "${RH_MODEL:-}" ] && ARGS+=(--model "$RH_MODEL")
[ -n "${RH_ALLOWED_TOOLS:-}" ] && ARGS+=(--allowedTools "$RH_ALLOWED_TOOLS")
if [ -n "${RH_MCP_CONFIG:-}" ] && [ -f "${RH_MCP_CONFIG:-}" ]; then
  ARGS+=(--mcp-config "$RH_MCP_CONFIG" --strict-mcp-config)
fi
[ -n "${RH_MAX_TURNS:-}" ] && ARGS+=(--max-turns "$RH_MAX_TURNS")
[ -n "${RH_JSON_SCHEMA:-}" ] && ARGS+=(--json-schema "$RH_JSON_SCHEMA")
[ -n "${RH_APPEND_SYSTEM_PROMPT:-}" ] && ARGS+=(--append-system-prompt "$RH_APPEND_SYSTEM_PROMPT")

OUT="$RH_TMPDIR/claude-out.json"
claude "${ARGS[@]}" < "$RH_PROMPT_FILE" > "$OUT"
rc=$?
if [ $rc -ne 0 ]; then
  # 300 chars was silently discarding the actual error/result content on any
  # response longer than that -- e.g. a full completed-turn JSON envelope with
  # a non-zero exit, where the real signal (result/subtype/api_error_status)
  # sits earlier in the file than the last 300 bytes. Widened to match the
  # 4000-char precedent aeon.yml's own harness-stderr logging already uses.
  echo "claude exited $rc: $(tail -c 4000 "$OUT" | tr '\n' ' ')" >&2
  exit $rc
fi

# With --json-schema Claude puts the object in .structured_output and may leave
# .result empty; the contract says .result carries the payload — normalize that.
if jq -e 'type == "object"' "$OUT" >/dev/null 2>&1; then
  jq -c '
    if (.structured_output // null) != null and ((.result // "") == "")
    then .result = (.structured_output | tojson)
    else . end' "$OUT"
else
  echo "warning: claude output was not a JSON object — wrapping raw stdout" >&2
  wrap_raw_output < "$OUT"
fi
