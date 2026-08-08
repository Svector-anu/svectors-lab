---
type: Playbook
title: Veilo bug-hunt playbook
description: Confirmed-live Solana/Anchor security tool stack + step-by-step vulnerability workflow for auditing VeiloSolana/privacy-program (Superteam Earn bounty, $2,000 USDC, fund-loss criticals only).
tags: [security, solana, anchor, veilo, bug-bounty, fuzzing, formal-verification]
resource: https://superteam.fun/earn/listing/veilo-bounty
timestamp: 2026-08-08T09:05:00Z
---

# Veilo bug-hunt playbook

## Target

- Repo: [VeiloSolana/privacy-program](https://github.com/VeiloSolana/privacy-program) (Anchor 0.32.1 / Solana 2.3.0, ~14.5k LoC Rust, Groth16 ZK privacy pool)
- Mainnet program ID: `GYy4kM6GHhpgLCUscuABbzkD2ZbJ2fneYryaZ6Ch7fFU`
- Bounty scope: **the deployed on-chain Solana program only** — website, extension, wallet UI, backend, APIs are explicitly out of scope
- Rules: analyze/simulate/local-fork-test only — never move real funds or touch live user balances
- $2,000 USDC total pool, 89 submissions already in as of 2026-07-31, deadline ~2026-08-20
- Prior pass: `vuln-scanner` ran a 5-pass manual LLM review (proof binding, Merkle/nullifier logic, access control, swap/positions/Phoenix/perps CPI accounting) + semgrep/trufflehog/osv — **0 confirmed findings**. Per [[project_ai-audit-methodology-2026]], treat that as "nothing found within that tooling's ceiling," not "confirmed safe" — it had no fuzzing and no formal verification behind it.

## Tools (verified live, July 2026)

| Tool | Link | What it is | Role |
|---|---|---|---|
| **Trident** | [ackee-blockchain/trident](https://github.com/ackee-blockchain/trident) | Solana/Anchor fuzzer, v0.11.1, 400★, Solana Foundation-funded. Stateful — chains multiple instructions into realistic tx sequences, ~12K tx/s. | **Priority 1.** Targets exactly what manual LLM review can't reach: adversarial instruction sequencing. |
| **Certora Prover** | [Certora/CertoraProver](https://github.com/Certora/CertoraProver) | Formal verification targeting sBPF bytecode directly, via CVL specs. Production-grade on Solana (clients: Solana Foundation, Kamino, Squads, Jito, Manifest). | **Priority 2, conditional** — strong fit if Veilo's ZK/Merkle/nullifier logic has provable invariants worth specifying. Real caught bugs: Jito Restaking (wrong-unit vault math), Manifest Vault (Token-2022 funds drained wrong direction on withdrawal). |
| **Certora Security Reports** | [Certora/SecurityReports](https://github.com/Certora/SecurityReports) | Real Solana bugs Certora has caught in production — reference for what this class of tool actually finds. | Read before writing CVL specs. |
| **cargo-audit** | [rustsec/rustsec](https://github.com/rustsec/rustsec) | Checks `Cargo.lock` against the RustSec advisory DB. | Cheap, run regardless — dependency hygiene, not vuln discovery. |
| **cargo clippy** | (Rust standard toolchain) | Rust-level lints. | Cheap, run regardless — catches Rust footguns Anchor-specific tools miss. |
| **solsec** | [hasip-timurtas/solsec](https://github.com/hasip-timurtas/solsec) | 8 Anchor-specific rules (missing signer/PDA checks, privilege escalation, reentrancy) — **regex-based, not AST-aware**. 21★. | First-pass CI linter only. Can't reason about control flow — treat findings as leads, not confirmations. |
| **anchor-sentinel** | [anchor-sentinel.vercel.app](https://anchor-sentinel.vercel.app) | Static analysis CLI for Anchor programs. Too new/small (8★) to rely on. | Low priority — sanity-check only. |
| **Trail of Bits Skills** | [trailofbits/skills](https://github.com/trailofbits/skills) | Claude Code skill marketplace — `building-secure-contracts` explicitly covers Solana. | Optional Claude Code augmentation. |
| **Slither-MCP** | [trailofbits/slither-mcp](https://github.com/trailofbits/slither-mcp) | EVM-only, doesn't apply to Veilo directly — but demonstrates the MCP tool-grounding pattern (deterministic `get_function_source` vs. LLM hallucinating codebase facts) worth replicating for any Solana-MCP equivalent. | Reference pattern, not a direct tool. |

**Ruled out:** sec3 X-ray and Soteria — both confirmed dead (404s across `sec3-service/xray`, `sec3.dev/xray`, zero GitHub results as of this writing). Every EVM-named tool (Slither, Echidna, Medusa, Foundry invariant testing, Mythril, Manticore, Aderyn, Halmos) does not parse Rust/Anchor at all — don't waste time trying to point them at this repo.

## The 6-step bug-finding workflow

Ordered roughly highest-frequency → highest-severity for Anchor programs generally. Steps 1–5 apply to any Anchor program; step 6 is Veilo-specific (ZK privacy pool).

1. **Full `#[derive(Accounts)]` struct first.** Paste the entire struct for the instruction under review. Ask: *"For every account that lacks an explicit constraint, what could an attacker pass in its place, and what would they gain?"* Surfaces missing signer checks, missing owner checks, and PDA substitution in one pass — the three most common Anchor criticals.

2. **CPI target validation.** Find every `invoke()` / `invoke_signed()` / Anchor CPI call. Ask: *"Is the target program address hardcoded, derived from a PDA, or passed in by the caller? If passed in, is it validated against a trusted list?"* Arbitrary CPI is Solana's rough equivalent of an EVM `delegatecall` to an arbitrary address — a recurring critical.

3. **PDA seed uniqueness.** For every `find_program_address` / `seeds = [...]` constraint, ask: *"Could two different users/states derive the same PDA from these seeds? What happens if they collide?"* If seeds lack a unique disambiguator (e.g. the user's own pubkey), collision is possible.

4. **Checked vs. unchecked arithmetic.** For any instruction moving lamports/tokens, ask: *"Which arithmetic ops use `checked_add`/`checked_sub`/`checked_mul`, and which use raw operators? Show the worst-case path if any wrap in a release build."* Sharpest on denomination/fee logic — Kamino's Certora-caught bug was exactly a rounding error in vault math.

5. **Reentrancy through CPI.** Ask: *"Does this program hold a mutable account-data borrow across a CPI call? If the called program calls back in, what state is inconsistent?"* Anchor's borrow checker usually blocks this at compile time, but custom `AccountInfo` usage can bypass it.

6. **ZK proof verification (Veilo's real critical surface).** Ask: *"Walk through the proof verification logic. What does the verifier actually check? What inputs can the user provide freely vs. what the circuit constrains? Can I supply a public input the circuit doesn't actually bind, and forge a valid proof?"* This is the exact shape of the Taylor Hornby / Zcash Orchard bug (Claude Opus 4.8, May 2026, 4-year-old bug, emergency hard fork) — the verifier code read correctly, the flaw was a missing constraint in the circuit itself. Also ask: *"Is the nullifier checked for double-spend before or after proof verification? If after, can a valid proof be replayed before the nullifier is recorded?"*

## Two evidence-backed cautions

- Don't treat multiple LLM/agent passes agreeing as independent confirmation — shared training data means shared blind spots (see [[project_ai-audit-methodology-2026]] for the documented 5-agent false-consensus failure). A genuinely different technique (Trident's fuzzing, Certora's formal proofs) adds real confidence; another LLM re-reading the same code does not.
- A scanner's headline detection-rate stat is meaningless without the true base rate — read tool output as leads to manually verify, not as confirmed findings, especially from regex-based tools like `solsec`.

## Trident fuzzing run (2026-08-08) — a hard scoping ceiling, not a tooling gap

Ran the step-1-priority tool end to end: full local toolchain (rustup, Solana CLI
2.3.0, Anchor 0.32.1 via avm, Trident CLI **0.12.0** — newer than the 0.11.1
verified above, current API is a hand-written `#[flow_executor]`/`#[flow]`
harness over an in-process SVM, not the enum-based `fuzz_instructions.rs` shape
older Trident docs/examples describe), program built clean, harness written
and run: 1000 iterations × ~100 flow calls, **0 panics, 0 invariant failures**.

**The result that actually matters:** every fund-moving instruction (`transact`,
the phoenix/jperp/prediction reissue paths, positions, swap, `ephemeral_*`) is
gated by `verify_transaction_groth16()` *before* any state mutation runs. Per
AUDIT.md, the Circom circuits / proving key / trusted-setup transcript are
intentionally excluded from this repo — so no valid proof can be forged
locally, and a fuzzer (Trident or otherwise) cannot get past that gate to
reach the nullifier-marking / merkle-insertion / fund-movement logic. That is
**exactly the surface step 6 above flags as fuzzing's highest-value target**.
This isn't a harness-writing shortfall — it's a hard ceiling specific to this
target's threat model (same blind spot AUDIT.md already names for on-chain-only
review of value-conservation bugs, now confirmed to extend to fuzzing too).

What Trident *could* reach and did fuzz: the non-proof-gated admin/setup
surface (`initialize_global_config`, `initialize`, `add_merkle_tree`,
`add_relayer`, `remove_relayer`, `update_pool_config`) via a hand-written
harness (not Trident's auto-generated skeleton) that tracks ground truth
per-iteration (a known "real admin" vs. an "attacker" key) and asserts the
expected outcome on every call — an authority check silently passing for the
attacker key panics immediately, which Trident reports as a crash. ~100k
instruction invocations, 0 assertion failures — confirms AUDIT.md's stated
admin-authority invariants hold under adversarial sequencing on that surface,
but this was already the best-covered ground from the 2026-07-31 manual passes.

**Where this leaves the bounty search:** Trident is now a dead end for this
target until circuit artifacts surface (ask the team directly, or check if a
testnet/devnet deployment leaks a usable proving key). Certora Prover
(priority 2) has the same problem in reverse — formal specs over the on-chain
verifier logic don't need a valid proof to *write*, only to trigger; a CVL
spec on `groth16.rs`'s pairing-check wiring and the pre-proof `require!` chain
is the more promising next step, not more fuzzing.

## Second manual pass (2026-08-08) — CPI target validation + position lifecycle, still 0 confirmed

Targeted follow-up per step 2 (CPI target validation) across areas not
individually named in the 2026-07-31 scan's notes:

- **`predictions.rs` (full file)** — ephemeral-wallet funding is paid from the
  relayer's own balance (capped at `PREDICTION_EPHEMERAL_SOL_FUNDING`), not the
  vault; reissue's "no profit cap" is intentional and bounded by a measured
  `ephemeral_ata_data.amount >= gross_outflow` check, not a trust assumption. Clean.
- **`swap.rs`** — `swap_program` checked against a hardcoded allowlist
  (Raydium CPMM/AMM, Jupiter) before every `invoke_signed`. No arbitrary-CPI path.
- **`perps.rs`** — `JUPITER_PERP_PROGRAM_ID` is a compile-time constant baked
  directly into the `Instruction`, not sourced from a caller-supplied account —
  stronger than an allowlist check, immune to substitution.
- **`close_position`** — the balance check is `swap_amount <= pos_pda.balance`
  (not `==`), and the position is unconditionally closed after. A partial
  close silently strands the difference in the shared vault with no PDA left
  to claim it. Not exploitable: `claimant` must sign (real `Signer`), so only
  the position's own owner can trigger it, and `vault_record.total_balance`
  (the only field this desyncs) is write-only — never read as an
  authorization or withdrawal cap anywhere in the program. Self-inflicted at
  worst. **Correction (see the 2026-08-08 git-diff pass below): this
  `<=` check is not a residual gap I found — it's the Veilo team's own
  2026-08-06 hardening commit, landed the day before this pass, replacing a
  prior state that had *no* on-chain balance check at all ("the only thing
  stopping one position from drawing on another's share of the vault was
  circuit soundness" — their commit message). It closed a real gap; what
  remains (self-only stranding, unread bookkeeping field) is genuinely inert.**
- **`merge_positions`** — enforces `merged_amount == pos0.balance + pos1.balance`
  (strict equality, not `<=`) and requires the same signer to own both closed
  positions via Anchor's `has_one` constraint. Clean.
- **`phoenix.rs` conditional-order paths** (`phoenix_create_conditional_orders_account`,
  `phoenix_place_position_conditional_order`, `phoenix_place_limit_order_with_conditionals`,
  `phoenix_cancel_conditional_order`, `phoenix_transfer_collateral`) — every one
  requires `claimant_signer.key() == claimant` (a real Signer) before it will
  drive that claimant's `phoenix_executor` PDA, so a relayer can never act on
  a victim's Phoenix position without the victim's own cosignature. Verified
  all 14 `remaining_accounts`-consuming functions in the file check
  `remaining[0] == PHOENIX_PROGRAM_ID` — no sibling function skips it (ruled
  out a copy-paste omission).
- **Unresolved, out-of-repo-scope observation:** beyond `remaining[0]`
  (the program ID) and whichever accounts are independently re-derived by
  seeds (e.g. `executor`), Veilo does not itself constrain most
  `remaining_accounts` slots (e.g. `dstTraderAccount` in
  `phoenix_transfer_collateral`) to any expected PDA — it forwards them
  positionally and relies entirely on Phoenix Eternal's own account
  validation to reject a wrong destination. This is a uniform pattern across
  every phoenix.rs CPI function, not a one-off gap, so it reads as a
  deliberate trust boundary rather than an oversight — but it's genuinely
  **contingent on Phoenix's own source**, which is out of this repo (same
  shape as the circuit-soundness caveat in AUDIT.md). Worth a look only if a
  future reviewer has Phoenix Eternal's IDL/source to check whether its
  `transferCollateral` (and similar) handlers actually derive `dstTraderAccount`
  from the signing `traderWallet`, or accept it as freely caller-supplied.
- `.unwrap()`-on-attacker-adjacent-data audit: `phoenix.rs:580/1023`,
  `positions.rs:1936` can panic on malformed relayer-supplied instruction
  bytes — reverts the tx atomically, no funds move, self-griefing only
  (the relayer supplies that data themselves). DoS-flavored, not fund-loss.

## Git-diff pass + Aeon's sanctioned scanner stack, fresh on current HEAD (2026-08-08)

The prior two passes above audited a point-in-time snapshot without ever
checking whether the snapshot was still current. It wasn't: the clone used
for this pass landed on `b9fee396` (2026-08-06) — **3 commits past** the
`e1b3bd0` AUDIT.md calls its last-reviewed source and past the 2026-07-31
scan. `gh api repos/VeiloSolana/privacy-program/compare/e1b3bd0...b9fee396`
(a plain git diff, not a scanner) is what surfaced this — worth running
**first**, before any tool, on every repeat visit to a target: a scanner
only tells you about the code it's pointed at, never whether that code is
stale.

The 3 commits:
1. `1b17ad43` — AUDIT.md/README/SECURITY.md docs only: corrected an inverted
   claim about nullifiers, disclosed the upgrade-authority-has-no-timelock
   and Jupiter-swap-route-not-proof-bound caveats explicitly. No code change.
2. `8decb20c` — **the fix** referenced in the `close_position` correction
   above. Also switched `position_vault_record.total_balance` from
   `saturating_sub` to `checked_sub` in both `close_position` and
   `close_position_to_sol` (an over-spend now errors instead of silently
   clamping to zero — closes a separate, smaller silent-desync path).
3. `b9fee396` — trivial: cross-margin trader `max_positions` 128→8 (rent
   optimization only).

Then ran Aeon's actual `vuln-scanner` Arm A tools (not generic `cargo-audit`/
`cargo install` improvisation — those aren't in this project's sanctioned
stack; see `scripts/prefetch-vuln-scanner.sh`) fresh against the current
HEAD, staged the same way the skill's prefetch script does:
- **osv-scanner v2.5.0** — identical 8 transitive/informational RustSec
  advisories to 2026-07-31 (unmaintained-crate warnings: `rand`, `keccak`,
  `bincode`, `borsh`, `libsecp256k1`, `paste`, `anyhow`, `derivative`). No
  new direct-dependency finding; nothing the 3 new commits touched shows up
  here (they didn't touch `Cargo.lock`).
- **semgrep** (`p/security-audit` + `p/owasp-top-ten` + `p/secrets`, same
  flags as `skills/vuln-scanner/SKILL.md` A3) — 0 findings.
- **trufflehog** (filesystem + git history, history deepened to 235 commits
  via `git fetch --deepen=200` to roughly match the skill's own
  `--depth 200` fork) — 0 verified secrets, 4713 chunks scanned.

**Takeaway for the next visit to this target:** run the compare-since-last-scan
check before anything else — `memory/vuln-scanned.json`'s `scanned_at` plus
this repo's current default-branch SHA is enough to know whether a scan is
against stale code. A future finding here is far more likely to come from
a newly-landed commit than from re-deriving what 3 tool categories and
7 manual/fuzz passes have already converged on as clean.

**Reusable toolchain notes for any future Anchor-program fuzz setup:**
- Host rustc newer than what a repo was built against can promote
  `deref_nullptr` to a hard error on any `ptr::addr_of!((*ptr::null::<T>())...)`
  offset-computation idiom (common in older zero-copy layout tests) —
  breaks anchor build's local IDL-generation step specifically, not the
  on-chain logic. Fix: rewrite to `core::mem::offset_of!` (stable since 1.77),
  local-build-only, don't touch audited semantics.
- `trident fuzz run <target>` must be invoked from inside the `trident-tests/`
  directory — its root-discovery walks up from CWD looking for `Trident.toml`,
  never down into subdirectories.
- `trident init` can hang or dyld-crash on rustfmt if `~/.rustup` already has a
  partially-installed nightly toolchain from an earlier interrupted run —
  `rustup toolchain uninstall nightly && rustup toolchain install nightly -c rustfmt`
  fixes it.
- TridentSVM's `process_transaction` builds transactions via
  `Transaction::new_with_payer` with **no signature step** — it doesn't verify
  real ed25519 signatures, just the `is_signer` AccountMeta flag. Signer
  fields only need a `Pubkey`, never a `Keypair` — simplifies harness-writing
  substantially versus a real validator/localnet setup.
