# Vuln Scan — NeoSoul-AI/neotrade-skills — 2026-09-09

## Repo metadata

- **Repo:** NeoSoul-AI/neotrade-skills (fork: Svector-anu/neotrade-skills)
- **Selection:** forced target via `var=NeoSoul-AI/neotrade-skills` (bare `owner/repo` → Arm A scan; not auto-selected from trending)
- **Stars:** 0 · **Language:** JavaScript · **Size:** 186 KB · **Pushed:** 2026-09-03
- **Audited commit:** `014b97c63d2cce6eda554cf656a62272b41f0902`
- **What it is:** a Markdown skill library for NeoSoul's local agent runtime ("neoclaw") — 35 `SKILL.md` files documenting prediction-market trading playbooks and analytical patterns, plus 7 standalone `.mjs` scripts that fetch public read-only market/reference data (Binance klines, USGS earthquakes, Open-Meteo forecasts, WHO outbreak news, IMF PortWatch chokepoint transits). No server, no auth, no database, no package.json/lockfile.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep (`p/security-audit`, `p/owasp-top-ten`, `p/secrets`) | `ok` | 0 findings |
| trufflehog (filesystem, `--only-verified`) | `ok` | 0 verified secrets |
| trufflehog (git history, bounded 300s) | `ok` | 0 verified secrets, completed well under the timeout |
| osv-scanner | `none` | No `package.json`/lockfile anywhere in the repo — clean n/a, not a scan failure. The `.mjs` scripts use only native `fetch`, zero dependencies |
| slither | `not-applicable` | No Solidity in the repo |
| fuzz (cargo-fuzz) | `skip` | Not a Rust repo, no fuzz harness |
| agentic source-to-sink pass | `ok` | N=15 budget, CODE_FILES=7 — all 7 entrypoint scripts reviewed line-by-line in full (585 lines total) |

## Candidate count

1 candidate surfaced during the agentic pass, triaged, and dismissed. 0 candidates from semgrep/trufflehog/osv.

## Confirmed findings

**0 confirmed.**

### Dismissed candidate (for transparency)

`skills/chokepoint-disruption/portwatch-transits.mjs:38` builds an ArcGIS FeatureServer `where` clause by interpolating a CLI-supplied chokepoint name into a SQL-like string literal:

```js
const where = `portname='${chokepoint.replace(/'/g, "''")}'`;
```

**Attacker-control claim:** a caller-supplied `chokepoint` argument flows into a query filter with only a single-quote-doubling escape.

**Why it doesn't survive triage:** doubling embedded single quotes is the textbook-correct escape for a SQL string literal (equivalent to standard `O''Brien`-style escaping), and it correctly neutralizes any attempt to break out of the quoted string. Even in a hypothetical bypass, ArcGIS's REST query grammar exposes one filter expression against one already-public, read-only `FeatureServer` layer — no stacked statements, no `UNION` across other data, no file or OS access. The only reachable outcome of a successful break-out would be altering which rows of the same public transit dataset come back. No attacker-controls → attacker-achieves claim clears the bar (do not weaken the assertion), so this was discarded rather than escalated to a provisional severity.

### Supply-chain sweep (repo-specific)

Since this repo is itself a library of Markdown instructions loaded directly into an agent's context (a prompt-injection supply-chain surface distinct from normal code), all 35 `SKILL.md` files were additionally swept for:
- embedded prompt-injection language ("ignore previous instructions", "you are now...", etc.) — 0 hits
- secrets / API keys — 0 hits
- hidden or invisible Unicode (zero-width space, RTL/LTR override, tag characters) — 0 hits

All "override" string matches found were legitimate trading-strategy prose (e.g. "catalyst stop overrides price stop").

## PoC gate status

`not-required` — no HIGH/CRITICAL code candidate survived triage, so the A4.5 verification gate does not apply.

## Dedup note

Logged to `memory/vuln-scanned.json` as `NeoSoul-AI/neotrade-skills`, `channel: clean`, `findings: 0`. Future runs will skip this repo for 30 days per the dedup window.
