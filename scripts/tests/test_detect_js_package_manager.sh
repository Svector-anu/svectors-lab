#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

cat > "$TMP/gh" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' package.json pnpm-lock.yaml app/page.tsx
EOF
chmod +x "$TMP/gh"

actual=$(PATH="$TMP:$PATH" bash "$ROOT/scripts/detect-js-package-manager.sh" owner/repo deadbeef)
[ "$actual" = $'pnpm\tpnpm-lock.yaml' ] || {
  echo "expected pnpm detection, got: $actual" >&2
  exit 1
}

cat > "$TMP/gh" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' package.json app/page.tsx
EOF
chmod +x "$TMP/gh"

actual=$(PATH="$TMP:$PATH" bash "$ROOT/scripts/detect-js-package-manager.sh" owner/repo deadbeef)
[ "$actual" = $'none\t-' ] || {
  echo "expected no lockfile, got: $actual" >&2
  exit 1
}

echo "detect-js-package-manager: PASS"
