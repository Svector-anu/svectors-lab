---
title: Vuln Scan — NeoSoul-AI/evoevo-contracts
date: 2026-09-09
mode: scan
repo: NeoSoul-AI/evoevo-contracts
---

# Vuln Scan — NeoSoul-AI/evoevo-contracts

## Repo metadata

- **Repo:** NeoSoul-AI/evoevo-contracts (forced target via `var`, bare `owner/repo` → Arm A scan)
- **Stars:** 0 · **Language:** Solidity (Foundry project)
- **Description:** on-chain business layer for EvoEvo agent workflows — agent identity binding (ERC-8004), reasoning/memory commitments, prediction judgement, committee-based oracle settlement, deployed on BSC and 0G
- **Audited commit:** `d8c81580cb3fe786248d6b666d712ff81b8f4adf` (default branch `main`)
- **PVR status:** disabled (`private-vulnerability-reporting.enabled == false`)
- **SECURITY.md:** present, but names no explicit contact channel — just "report it privately to the project maintainers" (moot for this run: 0 confirmed findings, nothing to route)

## Notable context

The repo ships its own prior third-party audit response at `docs/audit/scalebit-2026-08-21-responses.md` (ScaleBit, 2026-08-21, re-reviewed 2026-08-24). It documents 13 findings, almost all Fixed, one (`ECO-9`, config bounds vs. in-flight prediction isolation) explicitly **Partially Fixed** and accepted as Medium/privileged-only risk pending a future snapshot-into-lifecycle-record fix and a GOVERNOR_ROLE → multisig/timelock migration. This scan treats that finding as already known/disclosed by the project and does not re-report it.

## Scanner sources

| Tool | Status | Note |
|---|---|---|
| semgrep | fail | staged at `/tmp/bin/semgrep`, invocation blocked by this session's permission layer (fresh binary requires interactive approval unavailable here) — same failure mode observed on today's earlier `stripe/openapi` run, not a target-repo issue |
| trufflehog (filesystem) | fail | same blocking; supplemented with a manual regex sweep for private-key / API-key / AWS-key patterns across `src/` — 0 hits (not a substitute for a verified TruffleHog pass) |
| trufflehog (git history) | fail | same blocking, never invoked |
| osv-scanner | fail | same blocking; moot regardless — repo has no `package.json`/lockfile/npm manifest for a JS-ecosystem scan, and Foundry deps are git submodule-based (no `osv-scanner`-readable manifest either way) |
| slither | fail | same blocking — this is the highest-value loss for a Solidity repo; no automated static-analysis dataflow pass was possible this run |
| agentic (source-to-sink, manual) | ok | full-surface pass, see below |

**All four automated scanners were staged and available but denied execution by the session's permission layer** — this is a session-infra issue (identical to today's `stripe/openapi` scan), not a signal about the target repo. The agentic manual pass below is the primary evidence for this run's verdict, not a fallback.

## Agentic audit (A3.6)

- **Budget:** `CODE_FILES=21` (small repo) → `N=15`; all 21 `.sol` files exist, of which 5 are the core business-logic contracts, 5 are single-purpose interfaces, 11 are `test/`/`script`/`mocks` (excluded per scope). **All 5 core contracts were deep-reviewed in full — no entrypoint fell outside the budget.**
- **Threat model:** this is an upgradeable (UUPS), role-gated agent-identity/prediction-settlement system. The two things an attacker most wants: (1) forge or hijack an agent binding / judgement / evolution commitment on behalf of someone else's NFT-held identity, and (2) manipulate committee oracle settlement (juror selection, quorum tally, challenge-bond payout) to force a false or profitable resolution. Trust boundaries: `msg.sender` vs. NFT owner/approved-operator (checked per-call against the identity registry), role-gated privileged actions (`GOVERNOR_ROLE`, `ADMIN_ROLE`, `AUTOMATION_ROLE`, `EMERGENCY_GUARDIAN_ROLE`, `CHALLENGE_ROLE`, `JUROR_MANAGER_ROLE`/`JUROR_APPROVER_ROLE`), and a `trustedRouter`-only "on behalf of actor" forwarding pattern used by `EvoBindingRegistry`, `EvoEvolutionRegistry`, and `EvoPredictionRegistry`.
- **Entrypoints enumerated and reviewed** (all reachable, non-test, non-privileged-or-role-gated-as-designed):
  - `EvoUserActionRouter`: `bindExistingAgent(V2)`, `intakeReasoning(V2)`, `judge(V2)` — thin forwarders that preserve `_msgSender()` as the downstream `actor`. No local validation logic to bypass; the actual authorization lives downstream.
  - `EvoBindingRegistry`: `bindExistingAgent(For)(V2)`, `unbind(V2)`, `forceUnbind(V2)` — every path gates on `_requireAgentControllerV2` (actor must be current NFT owner/approved/approved-for-all on the identity registry), the `For`/`V2` router-forwarded paths additionally require `msg.sender == trustedRouter`, and V2 paths check `supportedIdentityRegistries` (allowlist) **before** any external call into the caller-supplied `identityRegistry_` address — correct ordering, prevents an attacker from pointing at an arbitrary malicious "identity registry" contract.
  - `EvoEvolutionRegistry`: `intakeReasoning(For)(V2)` — requires a live EIP-712 signature from a `SIGNER_ROLE` holder over `(updater, [identityRegistry], tokenId, ..., nonce, deadline)`, replay-protected by a monotonic per-`(registry,tokenId)` nonce and a deadline, additionally requires the calling `actor` to be the current NFT owner/approved on the target registry and the agent to be currently bound. `ECDSA.tryRecoverCalldata` (OpenZeppelin) rejects malleable/invalid signatures. No bypass found.
  - `EvoPredictionRegistry`: `recordJudgement(For)(V2)` — same owner/approved-operator + binding + allowlist-before-external-call pattern; `bindPredictionSettlementSummary` is intentionally callable by anyone once a prediction is resolved and snapshotted (it only hashes already-public, already-immutable on-chain data into a settlement checkpoint — no state it protects, no privilege it grants).
  - `EvoCommitteeOracle`: `registerJuror` (signature-gated by `JUROR_APPROVER_ROLE`), `submitJurorResolution` (open, but gated on primary/reserve-member assignment + NFT-owner check + one-submission-per-member via `_memberSubmissionHashes`), `challengePendingResult` (role-gated `CHALLENGE_ROLE`, payable bond, checks-effects-interactions correct), `withdraw` (pull-payment pattern, zeroes `pendingWithdrawals[msg.sender]` before the external `.call`, the one ETH-transfer sink in the whole codebase — no reentrancy).
- **Randomness/selection:** `finalizeSelectionForPrediction` seeds juror selection from `blockhash(selectionTargetBlock)`. This is influenceable in principle by a block proposer, but (a) `retrySelectionForPrediction` is intentionally gated to require the *original* entropy to have already expired (>256 blocks) before a retry — this is the same design the project's own audit response (`ECO-7`) already discusses and accepts — and (b) selection/finalization are both `AUTOMATION_ROLE`-gated, not attacker-callable, so this is not a new externally-triggerable finding.
- **Governance/config risk:** `EvoCommitteeOracle._setProtocolConfig` (bounds-checked) can still be changed by `GOVERNOR_ROLE` mid-flight for predictions in `SelectionPending`/`PendingFinality`, per the already-disclosed and accepted `ECO-9` (Partially Fixed, Medium, privileged-actor-only). Confirmed present in the audited commit; not re-reported as this scan's own finding since it is upstream-acknowledged, in-scope-tracked, and requires a privileged role to trigger (not an external-attacker path).
- **No use of** `tx.origin`, `delegatecall`, `selfdestruct`, or `unchecked{}` anywhere in `src/`. Only one raw external call in the whole surface (`withdraw`'s ETH transfer), and it is safe.
- **Secrets:** manual regex sweep (BEGIN PRIVATE KEY / `sk-`/AWS/Google API key patterns, `0x`+64-hex literals) across `src/` and repo root — 0 hits.

## Candidates / Confirmed

- **Candidates surfaced:** 0 (agentic pass produced no provisional HIGH/CRITICAL/MEDIUM candidate beyond the already-disclosed `ECO-9` governance-timing item, which is dispositioned above, not re-raised)
- **Confirmed:** 0
- **PoC gate:** not-required (no HIGH/CRITICAL candidate survived triage — A4.5 gate never invoked)

## Channels used

PVR: 0 · Public PR: 0 · Skipped: 0 (clean audit — nothing to route; PVR is disabled and SECURITY.md names no out-of-band contact, but this is moot since there is nothing to disclose)

## Prior-art check

Not run — no candidate reached the filing stage.

## Dedup note

Logged to `memory/vuln-scanned.json` as `channel: "clean"`; this repo is now skipped for further scans for 30 days.
