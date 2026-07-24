#!/usr/bin/env bash
# Pre-fetch/install vuln-scanner's SAST tooling OUTSIDE the Claude sandbox.
#
# skills/vuln-scanner/SKILL.md's Arm A calls semgrep/trufflehog/osv-scanner/
# slither by bare name from /tmp/bin (see its Sandbox note) but never installs
# them itself — the sandbox blocks `pip install`/`curl | sh` once Claude starts.
# This script stages them here, with full network access, before that happens.
#
# Non-fatal by design: if a tool fails to install, log it and move on. The
# skill already handles a missing binary (VULN_SCANNER_SKIPPED, tool=fail in
# sources.txt) rather than treating it as a hard error.
set -uo pipefail   # NOT -e: one tool's install failure must not skip the rest.

SKILL="${1:-}"
BIN_DIR="/tmp/bin"

if [ "$SKILL" != "vuln-scanner" ]; then
  echo "vuln-scanner-prefetch: no prefetch needed for skill '$SKILL'"
  exit 0
fi

mkdir -p "$BIN_DIR"
export PATH="$BIN_DIR:$PATH"

# --- Semgrep OSS (pip-installed elsewhere on PATH; symlinked into BIN_DIR so
#     the sandboxed run finds it via the bare `semgrep` name from one dir) ---
if command -v semgrep >/dev/null 2>&1; then
  echo "vuln-scanner-prefetch: semgrep already present"
elif pip install --quiet --user semgrep 2>&1 | tail -5; then
  REAL_SEMGREP="$(python3 -m site --user-base 2>/dev/null)/bin/semgrep"
  if [ -x "$REAL_SEMGREP" ]; then
    ln -sf "$REAL_SEMGREP" "$BIN_DIR/semgrep"
    echo "vuln-scanner-prefetch: semgrep installed -> $BIN_DIR/semgrep"
  else
    echo "::warning::vuln-scanner-prefetch: semgrep installed but binary not found at $REAL_SEMGREP"
  fi
else
  echo "::warning::vuln-scanner-prefetch: semgrep install failed"
fi

# --- TruffleHog (official install script; goreleaser binary, pinned dir) ---
if command -v trufflehog >/dev/null 2>&1; then
  echo "vuln-scanner-prefetch: trufflehog already present"
elif curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh \
     | sh -s -- -b "$BIN_DIR" 2>&1 | tail -10; then
  echo "vuln-scanner-prefetch: trufflehog installed -> $BIN_DIR/trufflehog"
else
  echo "::warning::vuln-scanner-prefetch: trufflehog install failed"
fi

# --- osv-scanner (GitHub release binary; resolve latest tag dynamically so
#     this doesn't go stale the way hardcoded model/tool versions have this
#     week — see PR history) ---
if command -v osv-scanner >/dev/null 2>&1; then
  echo "vuln-scanner-prefetch: osv-scanner already present"
else
  OSV_TAG=$(curl -sf https://api.github.com/repos/google/osv-scanner/releases/latest | jq -r '.tag_name // empty')
  if [ -n "$OSV_TAG" ] && curl -sSfL -o "$BIN_DIR/osv-scanner" \
       "https://github.com/google/osv-scanner/releases/download/${OSV_TAG}/osv-scanner_linux_amd64"; then
    chmod +x "$BIN_DIR/osv-scanner"
    echo "vuln-scanner-prefetch: osv-scanner ${OSV_TAG} installed -> $BIN_DIR/osv-scanner"
  else
    echo "::warning::vuln-scanner-prefetch: osv-scanner install failed (tag lookup or download)"
  fi
fi

# --- Slither (optional; only exercised when a scan target has Solidity) ---
if command -v slither >/dev/null 2>&1; then
  echo "vuln-scanner-prefetch: slither already present"
elif pip install --quiet --user slither-analyzer 2>&1 | tail -5; then
  REAL_SLITHER="$(python3 -m site --user-base 2>/dev/null)/bin/slither"
  if [ -x "$REAL_SLITHER" ]; then
    ln -sf "$REAL_SLITHER" "$BIN_DIR/slither"
    echo "vuln-scanner-prefetch: slither installed -> $BIN_DIR/slither"
  else
    echo "::warning::vuln-scanner-prefetch: slither installed but binary not found at $REAL_SLITHER"
  fi
else
  echo "::warning::vuln-scanner-prefetch: slither install failed (non-fatal — optional, Solidity-only)"
fi

echo "vuln-scanner-prefetch: done"
ls -la "$BIN_DIR" 2>/dev/null || true
