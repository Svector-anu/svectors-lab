Scan completed for `tinyhumansai/openhuman`.

One confirmed HIGH dependency vulnerability was found: mobile Tauri `2.10.3` is affected by origin confusion ([GHSA-7gmj-67g7-phm9](https://github.com/advisories/GHSA-7gmj-67g7-phm9)). I updated it to `2.11.1` and opened [PR #5814](https://github.com/tinyhumansai/openhuman/pull/5814).

- OSV: 174 rows / 79 unique advisories triaged
- TruffleHog: 0 verified secrets
- Agentic review: top 6 exposure classes reviewed, 0 code vulnerabilities confirmed
- Semgrep: failed to initialize because its configuration path was read-only
- Fuzzing: skipped; no repository fuzz harness
- Prior art: no matching report or fix found

Full report: [vuln-scan-2026-08-26.md](/home/runner/work/svectors-lab/svectors-lab/output/articles/vuln-scan-2026-08-26.md)

## Summary

- Updated scan state and daily log.
- Opened upstream dependency-fix PR #5814.
- Notification and local commit were attempted, but external queue and `.git` metadata were read-only. The report and state files remain saved in the workspace.
