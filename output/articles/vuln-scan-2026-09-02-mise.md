# Vuln Scan — jdx/mise — 2026-09-02

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [jdx/mise](https://github.com/jdx/mise) |
| Stars | ~33,385 |
| Language | Rust |
| Description | Dev tools, env vars, task runner |
| Audited commit | `6ff7b1af6bc69cee44db8d64e6327175dc4fc384` |
| PVR | enabled |
| SECURITY.md | present (`security@mise.jdx.dev` + PGP) |
| Selection | Auto from `output/.chains/github-trending.md` (preferred over already-scanned trending peers) |

## Threat model (agentic framing)

mise is a local developer CLI that installs tools, loads project env from `mise.toml` / `.env`, runs tasks, and optionally exposes an MCP server over **stdio**. Highest-value attacker goals: RCE via untrusted project config without a trust prompt, supply-chain compromise via malicious tool/plugin downloads, secret exfil via env/MCP, sandbox escape, and DoS on the self-update path. Trust boundaries: config trust prompts / `MISE_SAFE`, registry-trusted plugins, signature/checksum verification on aqua tools, and the local MCP client process.

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok | 21 candidates |
| trufflehog (fs + git) | ok | 0 verified secrets |
| osv-scanner | ok | 7 advisory rows across Cargo.lock + bun.lock |
| fuzz | skip | no `fuzz/fuzz_targets` |
| agentic | ok | CODE_FILES≈540 → N=10; top exposure reviewed |
| slither | n/a | no Solidity |

## Candidates reviewed

**Semgrep (21):** GHA `curl \| bash` installers, workflow-level `env:` secret exposure, Dockerfile missing `USER`, and `Open3.capture3` in `src/system/packages/brew/cask_shim.rb`. All dropped — CI hardening / false positive (argv-form Open3 already forces non-shell execution).

**OSV (7):**

| ID | Package | Severity | Disposition |
|----|---------|----------|-------------|
| RUSTSEC-2026-0194 | quick-xml@0.38.4 via self_update@0.44 | HIGH (CVSS 7.5 DoS) | **Confirmed** → public PR |
| RUSTSEC-2026-0195 | quick-xml@0.38.4 via self_update@0.44 | HIGH (CVSS 7.5 DoS) | **Confirmed** → public PR |
| RUSTSEC-2023-0071 | rsa@0.9.10 (Marvin) via age/pgp | MEDIUM | Dropped — already in `deny.toml`, no safe upgrade |
| RUSTSEC-2026-0173 | proc-macro-error2 unmaintained | informational | Dropped — already in `deny.toml` |
| GHSA-fx2h-pf6j-xcff | vite@5.4.21 via vitepress | HIGH | Dropped — docs-only; no patched 5.x; needs vitepress major |
| GHSA-4w7w-66w2-5vf9 | vite@5.4.21 | MODERATE | Dropped — same |
| GHSA-v6wh-96g9-6wx3 | vite/launch-editor | MODERATE | Dropped — same |

**Agentic (top-N):** config trust / `_.source` / `_.file`, tera `exec`/`read_file` (disabled under `MISE_SAFE`), MCP `run_task` + `mise://env` (stdio-local by design), HTTP client TLS defaults, sandbox landlock/seccomp/seatbelt. No confirmed exploitable code flaws beyond intentional trusted-config capabilities.

## Confirmed findings

### 1. Transitive quick-xml DoS via self_update (HIGH)

- **Type:** published dependency CVE
- **Advisories:** [RUSTSEC-2026-0194](https://rustsec.org/advisories/RUSTSEC-2026-0194), [RUSTSEC-2026-0195](https://rustsec.org/advisories/RUSTSEC-2026-0195)
- **Reachability:** `self_update` is a default feature; used by `mise self-update` / auto-update (GitHub Releases XML/API path historically pulled quick-xml 0.38.4)
- **Fix:** bump `self_update` 0.44 → 1.3.0 (released 2026-09-02); 1.x gates quick-xml behind optional `s3`, which mise does not enable
- **PoC gate:** `not-required` (published advisory severity quoted)
- **Prior-art:** #10717 previously *ignored* these advisories pending upstream; no open bump PR. This PR *removes* those ignores after the graph is clean.
- **Channel:** public PR [#12714](https://github.com/jdx/mise/pull/12714)

## Channels used

| Channel | Count | Links |
|---------|-------|-------|
| public PR | 1 | https://github.com/jdx/mise/pull/12714 |
| PVR | 0 | — |
| skipped | 0 | — |

## PoC gate status

- Confirmed finding: `not-required` — published dependency CVEs (severity from OSV/RustSec)
- No provisional HIGH/CRITICAL *code* findings requiring `./scripts/vuln-poc-gate.sh`

## Dedup

Appended `memory/vuln-scanned.json` with `channel=public-pr` — skip `jdx/mise` for 30 days.

## Not deep-reviewed (past N)

Lower-exposure surfaces noted but not fully traced: OCI layout edge cases, forgejo/gitlab token helpers, every individual aqua backend verifier, Windows-only shim paths. Covered at inventory level only.
