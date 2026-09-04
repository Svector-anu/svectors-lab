#!/usr/bin/env bash
# Deterministic local verifier for finding-1 (avatar.tsx blobMarkup attribute
# breakout). Runs with cwd = the audited repo clone (set by vuln-poc-gate.sh).
# Reads the real shipped source, does not modify any repo file.
set -euo pipefail

REPO_ROOT="$(pwd)"
SRC="$REPO_ROOT/apps/desktop/src/plugins/hermes-bots/avatar.tsx"
HARNESS="/home/runner/work/svectors-lab/svectors-lab/vuln-scan-tmp/poc-env/harness.js"

[ -f "$SRC" ] || { echo "source file missing: $SRC" >&2; exit 1; }
[ -f "$HARNESS" ] || { echo "harness missing: $HARNESS" >&2; exit 1; }

node "$HARNESS" "$SRC"
