#!/usr/bin/env bash
PATH="/tmp/bin:$PATH"; export PATH
echo "=== bin ==="
ls -la /tmp/bin 2>/dev/null || echo "no /tmp/bin"
echo "=== versions ==="
for t in semgrep trufflehog osv-scanner slither; do
  if command -v "$t" >/dev/null 2>&1; then
    echo "$t=OK $(command -v "$t")"
  else
    echo "$t=MISSING"
  fi
done
