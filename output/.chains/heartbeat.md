🚨 Heartbeat — Fleet DEGRADED

🔴 FLEET DEGRADED — zero-token harness failure persists (ISS-001, open since 07-19)

The 07-28 grok re-auth didn't hold. Fleet re-failing on the same `input_tokens=0 / total_cost_usd=0` signature — the model never starts (auth/routing, not skill logic).

🔴 FAILING (consecutive):
- skill-health ×138 · price-alert ×8 · defi-overview ×6 · narrative-tracker ×6 · heartbeat ×3 · vuln-scanner ×3 (failed today 12:17 UTC)
- New isolated fails: auto-merge (07-29), hunter-22 (07-29, first run)
- Fleet success rates 1–7%; last clean successes cluster 07-28

🟡 STALLED PRs: #24 (~1d), #22 & #20 (~2d), #5/#4/#3 (10–11d). Repo issues disabled.

🔵 MEMORY: "Configure notification channels" still flagged in Next Priorities.

→ Fix: verify GROK_CREDENTIALS / XAI_API_KEY + harness routing. Status page: 🔴 DEGRADED.