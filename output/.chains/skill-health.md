🚨 Skill Health — 2026-08-22

*Skill Health — 2026-08-22*
HEALTH: CRITICAL(3)  [systemic: zero-token harness — 3 skills, ISS-001]

🔴 CRITICAL — all ISS-001 zero-token signature (`total_cost_usd:0`)
- hunter-22 — 4 fails, ~1d down — WAIT-API (zero-token) → ISS-001
- digest — 3 fails, <1d down — WAIT-API (zero-token) → ISS-001
- vuln-scanner — 3 fails, <1d down (clean scan 06:08 then 3 zero-token) — WAIT-API → ISS-001

🟢 Recovered this audit: defi-overview, heartbeat (both cf=0, clean runs today)
🟢 HEALTHY: 9

The zero-token harness failure keeps rotating across the fleet — skills succeed then re-fail within a day, a different subset each audit. Intermittent harness/auth/rate transient, not per-skill logic.

Open issues: 1 · Resolved this run: 0