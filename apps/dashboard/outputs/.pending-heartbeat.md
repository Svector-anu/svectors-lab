🚨 Heartbeat: fleet DEGRADED

🔴 FAILED: fleet-wide zero-token harness failure (input_tokens=0, total_cost_usd=0) — shared across nearly all enabled skills
• heartbeat (failed ~36m ago · 141 consec · last_success Jul 19 · self-check CRITICAL)
• narrative-tracker (146 consec · 2% success)
• defi-overview (137 consec · 2%)
• fear-divergence (139 consec · 1%)
• price-alert (132 consec · 4%)
• digest (132 consec · 0%)
• skill-health stuck ~7h (dispatched 01:06 UTC, no report)
• token-pick stuck ~7h
• x402-monitor · picks-tracker · github-trending · vuln-scanner (chronic 0–1% success)

🟡 STALLED: PR #5 (8d), #4 (9d), #3 (9d) open; issues disabled on repo
🔵 MEMORY: still flagged — configure notification channels; run first digest
🔴 ISSUE: ISS-001 critical open since Jul 19 (zero-token harness)

Action: verify gateway/model path (aeon.yml harness=claude post Jul 26 revert) — zero tokens = model never starts, not skill logic.