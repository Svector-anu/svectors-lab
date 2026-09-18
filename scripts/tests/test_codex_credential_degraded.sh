#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/../.." || exit 1
RH="$(pwd)/harness-adapter/run-harness"
fail=0
pass() { echo "ok   - $1"; }
bad()  { echo "FAIL - $1"; fail=1; }

command -v jq >/dev/null 2>&1 || { echo "SKIP - jq not installed"; exit 0; }

BIN="$(mktemp -d)"
WS="$(mktemp -d)"
cleanup() { rm -rf "$BIN" "$WS"; }
trap cleanup EXIT

cat > "$BIN/codex" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "${CODEX_FAKE_STDERR:-}" >&2
printf '%s\n' '{"type":"thread.started","thread_id":"synthetic"}'
exit "${CODEX_FAKE_RC:-1}"
EOF
chmod +x "$BIN/codex"

run_failure() {
  local message="$1"
  (cd "$WS" && printf '%s\n' prompt \
    | PATH="$BIN:$PATH" CODEX_FAKE_STDERR="$message" \
      bash "$RH" codex --mode write --no-sandbox >/dev/null) 2>&1
}

out=$(run_failure 'Your access token could not be refreshed because your refresh token was revoked.'); rc=$?
{ [ "$rc" = 1 ] && grep -Fq 'CREDENTIAL_DEGRADED: codex: refresh token was revoked' <<<"$out"; } \
  && pass "revoked refresh token is classified as credential degradation" \
  || bad "revoked token was not classified (rc=$rc out=$out)"

out=$(run_failure 'WebSocket request failed: 401 Unauthorized, url: wss://chatgpt.com/backend-api/codex/responses'); rc=$?
{ [ "$rc" = 1 ] && grep -Fq 'CREDENTIAL_DEGRADED: codex: 401 Unauthorized from chatgpt.com/backend-api/codex' <<<"$out"; } \
  && pass "backend-api 401 is classified as credential degradation" \
  || bad "backend-api 401 was not classified (rc=$rc out=$out)"

out=$(run_failure 'fatal: repository checkout failed'); rc=$?
{ [ "$rc" = 1 ] && ! grep -Fq 'CREDENTIAL_DEGRADED:' <<<"$out" && grep -Fq 'codex exited 1:' <<<"$out"; } \
  && pass "unrelated failure remains generic" \
  || bad "generic failure was misclassified (rc=$rc out=$out)"

echo "---"
[ "$fail" = 0 ] && echo "ALL PASS" || echo "SOME FAILED"
exit "$fail"
