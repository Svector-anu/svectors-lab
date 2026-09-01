Executing Arm D (PoC gate smoke): checking recent logs and the smoke script, then running it.Foundry is available. Running the live PoC gate smoke test.## Vuln Scanner — PoC Gate Smoke

**Selector:** `var=poc-smoke` → **Arm D** (no audit, no disclosure, no notify)

**Command:** `bash scripts/tests/live_vuln_poc_gate.sh`

**Output:**
```
VULN_POC_VERIFIED id=live-fork-smoke verifier=foundry-fork chain=base block=50723125 result=/tmp/tmp.l17pEDhDZQ/live-fork-smoke.json
live-vuln-poc-gate: PASS
```

| Check | Result |
|-------|--------|
| `VULN_POC_VERIFIED` | yes |
| `verifier` | `foundry-fork` |
| `chain` | `base` (id **8453**) |
| `block` | **50723125** (numeric, > 0) |
| `live-vuln-poc-gate: PASS` | yes |
| Redacted execution evidence | yes (result JSON asserted before PASS) |

**Verdict: `VULN_POC_SMOKE_OK`** — Foundry fork path reads live Base state (WETH bytecode present), pins a real block, runs the temp-only test, and emits correlated evidence. Not a security finding.

No notification sent (smoke arm rule).

## Summary

- Ran Arm D PoC gate smoke against a benign synthetic Base-fork fixture.
- Smoke passed: `VULN_POC_SMOKE_OK` at Base block **50723125**.
- Logged under `### vuln-scanner` in `memory/logs/2026-09-01.md` with `Mode: poc-smoke`.
- No scan, disclosure, watchlist, or notify side effects.
