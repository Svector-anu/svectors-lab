⚠️ Vuln Scanner blocked

---
type: Log
---

# 2026-07-24

### vuln-scanner
- Mode: scan
- Target: none selected — aborted before target pick (tools unavailable)
- SCAN_TOOLS_MISSING: no `scripts/prefetch-vuln-scanner.sh` in repo; scanner bare names (`semgrep`, `trufflehog`, `osv-scanner`, `slither`) not granted by `scripts/skill_mode.sh` allowlist. `semgrep --version` returns "requires approval" under non-interactive `claude -p`, so the binaries are neither staged nor runnable.
- Candidates: 0 | Confirmed: 0
- Scanner status: semgrep=fail trufflehog=fail osv=fail slither=fail (all unavailable)
- Action: skipped scan cleanly per SKILL Sandbox note (do not fork/scan a repo with no working scanner). Notified operator once — this is a config gap blocking the whole scan arm (ref ISS-001).
- Fix needed: operator must add `scripts/prefetch-vuln-scanner.sh` to stage binaries into `/tmp/bin` AND ensure the scanner bare names are on the write-tier allowlist in `scripts/skill_mode.sh`.