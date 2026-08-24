🚨 Heartbeat: fleet DEGRADED

🔴 **Fleet DEGRADED — ISS-001 zero-token failure recurred**

The harness zero-token failure that *cleared yesterday* came back on this morning's cron batch (08:49–09:14 UTC). All runs returned empty-usage, same signature as the open critical **ISS-001**.

**🔴 API degradation (cf ≥ 3):**
- defi-overview — cf 4
- narrative-tracker — cf 3
- vuln-scanner — cf 3

**🔴 Re-failed today (was clean yesterday):**
- fear-divergence — cf 2
- github-trending — cf 1
- picks-tracker — cf 1

Root cause = ISS-001 (open, critical). Fixing/closing is skill-repair's job — flagging the regression so it isn't mistaken for the recovered state. Healthy today: digest, hunter-22, token-pick, skill-health.

_Status page: 🔴 DEGRADED. Weeks-old stalled PRs (#30/#22/#20/#5/#4/#3) and x402-monitor staleness unchanged — already logged, not re-alerted._