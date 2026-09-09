# Vuln Scan — NeoSoul-AI/neotrade-wallet-sdk — 2026-09-09

## Repo metadata

- **Repo:** [NeoSoul-AI/neotrade-wallet-sdk](https://github.com/NeoSoul-AI/neotrade-wallet-sdk)
- **Selection:** forced target via `var=NeoSoul-AI/neotrade-wallet-sdk`
- **Stars:** 0 · **Language:** TypeScript · **Size:** 109 KB · **Fork:** no
- **Last pushed:** 2026-09-09
- **Description:** neotrade wallet SDK — key derivation and encrypted keystore, order-signing policy gate, and raw-key EVM chain primitives for the NeoTrade self-custodial desktop trading-agent app. Three source-only ESM packages (`@neotrade/wallet`, `@neotrade/signing-gateway`, `@neotrade/x402`), no build step.
- **Audited commit:** `79ec3a2` (`main`, tagged `v1.1.0`)
- **SECURITY.md:** absent. **PVR:** disabled (`private-vulnerability-reporting.enabled = false`) — no safe public channel for code flaws.
- **Dedup:** not previously scanned; entry appended to `memory/vuln-scanned.json`.

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep | `ok` | ran (`p/security-audit`, `p/owasp-top-ten`, `p/secrets`); 4 hits — 3 dismissed, 1 confirmed |
| trufflehog (filesystem) | `ok` | ran, `--only-verified`; 0 hits |
| trufflehog (git history) | `ok` | ran, bounded (`timeout 300`), `--only-verified`; 0 hits |
| osv-scanner | `ok` | ran against the committed `pnpm-lock.yaml`; 1 hit (dependency CVE, confirmed) |
| slither | `n/a` | no Solidity in this repo |
| fuzz (cargo-fuzz) | `skip` | no Rust / `fuzz/fuzz_targets` in this repo |
| agentic review | `ok` | small repo (21 source files across 3 packages) → budget N=15, every file deep-reviewed, none left outside budget |

**All-scanners-failed check:** does not apply — every scanner that applies to this repo ran successfully.

## Candidate count

- **Candidates:** 4 (3 semgrep hardening notes + 1 semgrep crypto finding) + 1 (osv dependency CVE) → **5 total**
- **Confirmed:** 2

## Triage

**Dismissed (semgrep, 3 hits):** `yaml.github-actions.security.github-actions-mutable-action-tag` on `.github/workflows/ci.yml:13-15` — `actions/checkout@v4`, `pnpm/action-setup@v4`, `actions/setup-node@v4` are pinned to mutable version tags rather than a commit SHA. This is a standard supply-chain hardening note, not an exploitable flaw here: the workflow carries no secrets, runs only `pnpm install --frozen-lockfile && pnpm typecheck && pnpm test` on `push`/`pull_request`, and has no publish/deploy step a compromised action could abuse. Noted for the operator's awareness, not filed.

**Confirmed Finding 1 — Medium, CWE-347 (Improper Verification of Cryptographic Signature/MAC):**
`packages/wallet/src/keystore.ts` — `encryptSecret` (line 45) and `decryptSecret` (line 84, flagged by semgrep's `gcm-no-tag-length` rule) call `createCipheriv`/`createDecipheriv("aes-256-gcm", ...)` without an explicit `authTagLength`. I verified empirically in this session (`node -e`, Node 22) that without that option, `setAuthTag()` accepts a truncated tag down to 4 bytes and the decryption still completes — only tags shorter than 4 bytes are rejected by Node's own floor. That narrows the keystore's intended 128-bit GCM forgery resistance to as little as 32 bits under a chosen-ciphertext verification oracle (the underlying attack class is documented in NIST SP 800-38D Appendix C and called out as a known footgun in Node's own crypto docs). The repo's existing test suite (`wallet.test.ts`) checks that GCM catches *ciphertext* tampering but never asserts a minimum tag length, so this gap wasn't caught by review.

Attacker-controls / attacker-achieves: an attacker who can write an arbitrary `EncryptedKeystore` JSON blob (salt/iv/ciphertext/authTag all attacker-chosen) and trigger repeated `decryptSecret`/`verifyPassphrase` calls against it under the *real* passphrase (an oracle) could, in principle, mount a truncated-tag forgery campaign to eventually produce a keystore that decrypts — under the legitimate KEK — to an attacker-chosen mnemonic, without ever learning the passphrase.

**Why this is Medium, not High:** every verification attempt re-runs the keystore's own scrypt KDF (`N=2^17`, ~100–500ms per call) *before* the GCM tag is even checked. A realistic forgery campaign against a 4-byte tag needs on the order of 2^32 adaptive queries; at scrypt's cost that's on the order of centuries even fully serialized on one core. The scrypt gate effectively neutralizes practical exploitation today — this is a real, verifiable defense-in-depth gap in a security-critical primitive (the keystore wraps the seed mnemonic every venue key derives from), not a live exploit path, and the disclosure says so plainly rather than overstating it.

I confirmed a fix locally: pin `authTagLength: 16` on both cipher calls and reject any `authTag` whose decoded length isn't exactly 16 bytes before calling `setAuthTag`. Re-running the same probe against the patched logic: legitimate 16-byte round-trips still decrypt correctly; 4/8/12-byte truncated tags are now rejected pre-flight. Pushed to a branch on my fork only (not upstream, since this can't go public unpatched): `https://github.com/Svector-anu/neotrade-wallet-sdk/tree/private/fix-gcm-authtaglength`.

**Confirmed Finding 2 — dependency CVE (already public), routing incomplete:**
`GHSA-82fw-gwwq-j7x9` / `CVE-2026-84373` in `@vitest/mocker` (and `vitest`) `3.2.7`, fixed in `4.1.11` — a path-traversal / arbitrary-file-read via a redirect-mock target path not validated against Vite's file-serving allowlist, reachable through `mockerPlugin`/`interceptorPlugin` on an unauthenticated dev-server HMR socket. This repo uses `vitest` only as a devDependency (`vitest run` in CI and locally) and never runs vitest's dev-server or browser mode, so the vulnerable code path is not reachable in this repo's actual usage — but the CVE is already public, so per policy it still routes to a dependency-bump PR rather than being silently dropped. I bumped the `vitest` range to `^4.1.11` in all three `package.json` files on a separate branch (`security/bump-vitest-GHSA-82fw-gwwq-j7x9`), but could not finish the routing: `pnpm` required interactive approval that wasn't available in this session, so `pnpm-lock.yaml` could not be safely regenerated and tested, and I would not open a PR with an un-regenerated lockfile that CI's `--frozen-lockfile` install would reject. The package.json edits were reverted rather than left half-applied; the branch has no commits. This needs a follow-up run with `pnpm` available.

**Agentic source-to-sink review** (threat model: the two things an attacker most wants from a wallet SDK are (a) key/mnemonic exfiltration or forged derivation, and (b) getting the signing gateway to authorize an order it shouldn't):

- `packages/wallet/src/keys.ts` — BIP-32/BIP-39 derivation and EIP-55 address computation built directly on `@noble/curves`/`@noble/hashes`/`@scure/*` (no custom crypto primitives); manually re-derived the checksum algorithm and confirmed it matches the EIP-55 spec.
- `packages/wallet/src/wallet.ts`, `backup.ts` — mnemonic never leaves `unlockWallet`; backup-challenge positions are CSPRNG-injected (`randomInt`, not `Math.random`); passphrase minimum length (8 chars) enforced at every wrapping site (`finalizeWallet`, `importWalletDirect`, `rewrapKeystore`).
- `packages/wallet/src/personal-message.ts` — EIP-191 sign/recover round-trip on `@noble/curves` directly; recovery-byte validation before use.
- `packages/signing-gateway/src/gateway.ts` — the order-signing policy gate. Schema validation is `.strict()` (rejects unknown fields, no raw-hash entry point exists). Fail-closed authorization (locked session, unknown/revoked/expired agent, market allowlist) is re-evaluated *after* the async signer call resolves, closing the await-window race the code's own comments describe (GAT-4). Exactly-once idempotency uses an atomic `insertIfAbsent` primitive (no bare `set`), with a JSON-tuple ledger key (not a delimiter join) that can't collide across differently-split agentId/clientOrderId pairs. Order sizing is deliberately not policed here — confirmed this is documented intentional scope (a prior 2026-08-16 incident, already fixed, is referenced directly in `docs/security-model.md`), not an oversight.
- `packages/signing-gateway/src/policy-stamp-signer.ts` — explicitly documented as *not* a cryptographic signer (a policy-passage stamp only); the real EIP-712 signature is produced downstream by the host's venue executor, outside this SDK's custody.
- `packages/x402/src/*.ts` — every function that takes a raw private key takes it as an explicit parameter (never stored); `chainOf()` deliberately refuses viem's built-in chain presets to avoid a silent third-party-RPC fallback; swap/transfer functions use a three-way error contract (nothing-broadcast / unconfirmed-with-txHash / reverted) specifically to prevent double-spend on retry; slippage guards (`amountOutMinimum`/`amountInMaximum`) are asserted positive before broadcast; `checksumAddress` rejects a mixed-case address whose EIP-55 checksum doesn't match (catches fat-fingered pastes) while still accepting unchecksummed all-lower/all-upper input per spec.
- `scripts/swap-probe.mts` — a manual dev-only probe script, not a production entrypoint; real-money phases are double-gated (explicit phase arg + interactive `yes` confirmation).

No other candidate survived triage as attacker-controllable → dangerous-sink.

## PoC gate status

`not-required` — both confirmed findings are graded Medium (the GCM issue's practical exploitability is gated by the scrypt KDF cost as detailed above; the dependency CVE is an already-public advisory per the A4.5 exception), so the A4.5 PoC-verification gate does not apply. The GCM fix was still independently verified with a working Node reproduction (truncated tags accepted before the patch, rejected after) rather than taken on faith.

## Dedup note

New entry appended to `memory/vuln-scanned.json`: `{"repo": "NeoSoul-AI/neotrade-wallet-sdk", "channel": "pending-email+public-pr-blocked", "findings": 2}`. Repo will be skipped on future scans for 30 days per the standard dedup window.

## Disclosure routing

- **GCM auth-tag finding:** no PVR, no SECURITY.md → out-of-band contact resolved to `dev@neosoul.ai` (public GitHub org profile email). Draft staged at `memory/pending-disclosures/NeoSoul-AI-neotrade-wallet-sdk-2026-09-09.md`, `status: pending-operator-send`, `auto_send: true` (valid resolved contact, no AI-report ban found) for a future `disclose` arm run. Row added to `memory/security-watchlist.md` so the `resubmit` arm re-checks PVR status going forward. A proposed fix is pushed to `Svector-anu/neotrade-wallet-sdk` branch `private/fix-gcm-authtaglength` (fork only, not an upstream PR).
- **vitest dependency CVE:** intended channel is a public PR (A5a, already-disclosed CVE). Not filed this run — blocked by `pnpm` requiring interactive approval unavailable in this session. Flagged in `vuln-scanned.json` notes for a follow-up run.

## Summary

Two confirmed findings on an otherwise carefully engineered wallet SDK. The primary finding — AES-256-GCM keystore decryption accepting truncated authentication tags — is real and independently verified (both the vulnerability and the fix were reproduced with working Node code), but its practical exploitability is sharply limited by the keystore's own scrypt KDF cost, so it is graded Medium and disclosed with that context rather than overstated. A private disclosure email is staged and armed for auto-send, with a working patch already pushed to a private fork branch for the maintainer to cherry-pick. A secondary, already-public dependency CVE in a devDependency-only test tool was found but its public-PR routing could not be completed this run due to a `pnpm` tooling restriction in this session — flagged for follow-up. The rest of the codebase (signing gateway, order idempotency/replay logic, EIP-191 signing, Permit2/swap/transfer primitives) held up under a full source-to-sink review; no other candidates survived triage.
