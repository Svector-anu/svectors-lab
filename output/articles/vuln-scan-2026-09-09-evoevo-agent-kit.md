# Vuln Scan — NeoSoul-AI/evoevo-agent-kit — 2026-09-09

## Repo metadata

- **Repo:** [NeoSoul-AI/evoevo-agent-kit](https://github.com/NeoSoul-AI/evoevo-agent-kit)
- **Selection:** forced target via `var=NeoSoul-AI/evoevo-agent-kit`
- **Stars:** 0 · **Language:** Python + TypeScript · **Size:** 74 KB · **Fork:** no
- **Last pushed:** 2026-06-24
- **Description:** reference client/SDK kit for the EvoEvo/OpenClaw ERC-8004 prediction-agent platform — a Python polling agent client with pluggable strategy adapters, a viem-based TypeScript SDK for on-chain agent register/bind/reputation-feedback (ERC-8004 identity + EvoEvo binding contracts on 0G), a small wallet-connected demo frontend, and one Postgres schema file.
- **Audited commit:** `eb599a9a8b0e32696a6dc4591e16a51a02964040`
- **SECURITY.md:** present but names no explicit contact channel (just "report privately to the project maintainers"). **PVR:** disabled (`403` on `private-vulnerability-reporting`) — moot here, no confirmed finding to route.
- **Dedup:** not previously scanned; entry appended to `memory/vuln-scanned.json`.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | `ok` | ran (`p/security-audit`, `p/owasp-top-ten`, `p/secrets`); 4 hits, 0 confirmed |
| trufflehog (filesystem) | `fail` | upstream only ships `.tar.gz` release archives (no raw single-binary asset), and `tar` is not on the in-run capability allowlist — could not stage. Supplemented with a manual regex sweep for common secret patterns (API keys, private-key headers, tokens): 0 hits. This is **not** a substitute for a verified trufflehog pass. |
| trufflehog (git history) | `fail` | same staging failure as above |
| osv-scanner | `none` | ran; `package.json` exists under `frontend-sdk/` and `examples/frontend-register-and-bind/`, but no lockfile is committed anywhere in the repo — nothing for a lockfile-based scanner to read (exit 128, correctly classified as n/a, not a tool failure) |
| slither | `n/a` | no Solidity source in this repo (the SDK calls existing on-chain contracts via ABI, it doesn't ship any `.sol`) |
| fuzz (cargo-fuzz) | `skip` | no Rust / `fuzz/fuzz_targets` in this repo |
| agentic review | `ok` | small repo (8 source files total) → budget N=15, all files reviewed in full |

**All-scanners-failed check:** does not apply — semgrep, osv-scanner, and the agentic pass all completed; only trufflehog could not be staged in this environment.

## Candidate count

- **Candidates:** 4 (all from semgrep) + 0 from the agentic pass → **4 total**
- **Confirmed:** 0

## Triage

1. `dockerfile.security.missing-user` — `agent-client/Dockerfile:11`. The reference client's Docker image has no `USER` directive, so it runs as root by default. This is a container-hardening note, not an exploitable flaw: the image ships no network-facing service (it's a polling CLI client that makes outbound calls only), so there's no remote input that would let an attacker leverage the root context. Dropped as sub-threshold for disclosure; noted here for the operator's awareness rather than filed.
2–4. `python.lang.security.audit.dynamic-urllib-use-detected` — `agent-client/scripts/{http_json_strategy,openai_compatible_strategy,reference_client}.py`. These fire because each script builds a `urllib.request.Request` from a URL read out of an environment variable (`HTTP_JSON_STRATEGY_URL`, `OPENAI_COMPAT_BASE_URL`, `EVOEVO_API_BASE_URL`). The URL is set by the person deploying the agent, not supplied by any remote/untrusted party at runtime — there's no code path where response data or attacker input feeds back into the request URL. Reviewed and dismissed as non-exploitable in this context (the semgrep rule can't see that the "dynamic" value is operator config, not attacker input).

**Agentic source-to-sink review** (threat model: this kit's two real attacker goals are (a) getting the demo frontend to execute attacker-controlled script via unsanitized data reaching the DOM, and (b) getting a connected wallet to sign a transaction whose parameters were manipulated by attacker-controlled input):

- `agent-client/scripts/reference_client.py` — `run_strategy_command()` builds a subprocess argv via `shlex.split()` from `config.strategy_command`, which is only ever set from `EVOEVO_STRATEGY_COMMAND`/`--strategy-command` — both operator-controlled, not remote input. Candidate content/topic data from the polled API flows only into `print()`/JSON serialization, never into a shell or template sink.
- `examples/frontend-register-and-bind/src/main.ts` — the one wallet-connected surface. All dynamic content is written via `textContent`/property assignment or DOM APIs (`createElement`, `.append`), never `innerHTML` with interpolated data — the one `innerHTML` assignment (`app.innerHTML = ...`) is a static template with no user data spliced in. Every form field that reaches a transaction call is validated first: addresses go through viem's `getAddress` (checksums/throws on malformed input), numeric fields are regex-checked (`^\d+$`) before `BigInt()`, and URLs are protocol-allowlisted (`https:`/`ipfs:`/`data:`) before use as an agent URI or feedback URI. `giveReputationFeedback` explicitly blocks self-feedback (compares `agentOwner === account` and throws). No path lets attacker-supplied data reach a signing call unvalidated.
- `frontend-sdk/src/index.ts` / `abis.ts` — every address argument passed to a contract call is run through `getAddress()` before use; no string concatenation into calldata, no `eval`/dynamic code execution anywhere in the SDK.
- `schemas/agent_onchain_identity.sql` — a single `CREATE TABLE` statement; no application code included that would build queries against it, so no SQL-injection surface exists in this repo.

No candidate survived triage as attacker-controllable → dangerous-sink. **0 findings confirmed.**

## PoC gate status

`not-required` — no candidate reached provisional HIGH/CRITICAL, so the A4.5 PoC-verification gate was not invoked.

## Dedup note

New entry appended to `memory/vuln-scanned.json`: `{"repo": "NeoSoul-AI/evoevo-agent-kit", "channel": "clean", "findings": 0}`. Repo will be skipped on future scans for 30 days per the standard dedup window.

## Summary

Clean audit — 4 candidates reviewed, 0 confirmed. This is a small, carefully-written reference SDK/client kit (no server component in-repo); its one interactive surface (the wallet demo) validates every field before it reaches a signing call and avoids unsafe DOM sinks. The only gap in scanner coverage was TruffleHog, which this environment couldn't stage (upstream ships no raw binary release asset, and `tar` isn't on the in-run allowlist) — a manual secret-pattern sweep found nothing, but that is not a verified-secret guarantee. Nothing to disclose; no channel needed.
