#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
state="$tmp/state"
response="$tmp/response.json"

PATH="$PWD/scripts/tests/fixtures:$PATH" \
FAKE_CURL_STATE="$state" \
  ./scripts/secretcurl.sh -s -o "$response" -w '%{http_code}' \
    --max-time 1 -X POST "https://api.x.ai/v1/responses" \
    -H 'Authorization: Bearer {XAI_API_KEY}' -d @/dev/null \
    >"$tmp/http" 2>"$tmp/diag"

[ "$(cat "$state")" = 2 ] || { echo "FAIL - expected two attempts"; exit 1; }
[ "$(cat "$tmp/http")" = 200 ] || { echo "FAIL - expected final HTTP 200"; exit 1; }
grep -q '"text":"ok"' "$response" || { echo "FAIL - final response was not retained"; exit 1; }
grep -q 'attempt=1/3 http=503 .*reason=http-503' "$tmp/diag" || { echo "FAIL - missing first-attempt diagnostic"; exit 1; }
grep -q 'attempt=2/3 http=200 .*reason=ok' "$tmp/diag" || { echo "FAIL - missing success diagnostic"; exit 1; }
echo 'ALL PASS - xai retries transient HTTP failures with diagnostics'
