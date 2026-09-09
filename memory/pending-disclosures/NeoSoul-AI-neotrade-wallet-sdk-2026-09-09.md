---
repo: NeoSoul-AI/neotrade-wallet-sdk
severity: medium
cwe: CWE-347
status: pending-operator-send
auto_send: true
contact_email: dev@neosoul.ai
cc: []
email_subject: "Security: AES-GCM keystore accepts truncated auth tags in neotrade-wallet-sdk"
detected_at: 2026-09-09T00:00:00Z
send_attempts: 1
last_send_error: "resend-403: svector.xyz domain not verified (attempted 2026-09-09)"
---

# Staged private disclosure — NeoSoul-AI/neotrade-wallet-sdk

**Operator-facing notes** (NOT emailed):

- PVR disabled (`private-vulnerability-reporting.enabled = false`); no `SECURITY.md` in the repo. No AI-report ban found anywhere (README, package.json) — nothing to check against.
- Contact resolved from the GitHub org profile (`gh api users/NeoSoul-AI` → `email: dev@neosoul.ai`, publicly listed). A secondary maintainer email (`robin@neosoul.ai`) appears in git commit history but the org address is the more appropriate primary contact for a security report.
- Finding: `packages/wallet/src/keystore.ts` — `encryptSecret`/`decryptSecret` call `createCipheriv`/`createDecipheriv("aes-256-gcm", ...)` without an explicit `authTagLength`. Empirically verified in this session (Node 22, same major as the repo's declared `engines.node >= 24`): without that option, `setAuthTag()` accepts tags truncated down to 4 bytes and still decrypts successfully; only tags under 4 bytes are rejected by Node's own floor. This narrows the intended 128-bit GCM forgery resistance to as little as 32 bits under a chosen-ciphertext verification oracle (NIST SP 800-38D Appendix C; also documented as a known footgun in Node's own crypto docs).
- Practical exploitability is low: every verification attempt (`decryptSecret`/`verifyPassphrase`) re-runs the keystore's own scrypt KDF (N=2^17) before the GCM check, which costs ~100-500ms per attempt on typical hardware — a realistic forgery campaign (~2^32 adaptive attempts for a 4-byte tag) would take on the order of centuries even fully serialized on one core, which is why this is graded Medium, not High. This is a defense-in-depth gap, not a live exploit path, and the email says so plainly rather than overstating it.
- Confirmed a fix locally: pin `authTagLength: 16` on both cipher calls and reject any `authTag` whose decoded length isn't exactly 16 bytes before calling `setAuthTag`. Re-ran the same truncated-tag probe against the patched logic — 4/8/12-byte tags are now rejected pre-flight, the legitimate 16-byte round-trip still decrypts correctly. Pushed as a branch on my fork only (not a PR to upstream, since this can't go public unpatched): https://github.com/Svector-anu/neotrade-wallet-sdk/tree/private/fix-gcm-authtaglength
- Audited commit: `79ec3a2` (main, v1.1.0). Semgrep flagged this line (`javascript.node-crypto.security.gcm-no-tag-length`); trufflehog (filesystem + bounded git-history) and osv-scanner ran clean (osv found one dependency CVE, handled separately as a public PR candidate — GHSA-82fw-gwwq-j7x9 in `vitest`/`@vitest/mocker`, a devDependency-only test-tooling CVE not reachable in this repo's usage; PR routing was blocked this run because `pnpm` was not executable in this session to regenerate `pnpm-lock.yaml` safely, so it is not filed yet).
- A full source-to-sink pass across both other packages (`signing-gateway`, `x402`) — order-signing policy gate, replay/idempotency ledger, EIP-191 personal-message signing, Permit2/swap/transfer chain primitives — found nothing else exploitable; the codebase is unusually well-documented about its own trust boundaries.

<!-- EMAIL-BODY-START -->
Hi NeoSoul team,

I am writing privately about a defense-in-depth finding in NeoSoul-AI/neotrade-wallet-sdk (audited at commit 79ec3a2, v1.1.0), found during a routine OSS security review. Private vulnerability reporting is not enabled on the repository and there is no SECURITY.md, so I am reaching out by email instead.

Where:
packages/wallet/src/keystore.ts, encryptSecret and decryptSecret

The issue:
Both functions create the AES-256-GCM cipher/decipher without an explicit authTagLength option. I tested this against Node's own crypto module: without that option, a decipher will accept an authentication tag truncated down to 4 bytes and still decrypt successfully (only tags shorter than 4 bytes are rejected). That narrows the keystore's intended 128-bit GCM forgery resistance down to as little as 32 bits under a chosen-ciphertext verification oracle, which is a known Node.js footgun documented in NIST SP 800-38D Appendix C and in Node's own crypto docs.

Why it matters, and why it is graded Medium rather than High:
Every call to decryptSecret or verifyPassphrase re-derives the key via the keystore's own scrypt KDF (N=2^17) before the GCM tag is even checked. That costs roughly 100-500ms per attempt on ordinary hardware, so a realistic forgery campaign against a 4-byte tag (on the order of 2^32 adaptive attempts) would take centuries even fully serialized on one core. In other words, the scrypt cost effectively neutralizes practical exploitation today. I am flagging it anyway because it is a real, verifiable gap in a security-critical primitive (the keystore wraps the seed mnemonic every venue key derives from), it is a one-line fix, and Node's default behavior here is easy to miss even in otherwise carefully reviewed code, which this codebase clearly is.

Suggested fix:
Pass { authTagLength: 16 } explicitly to both createCipheriv and createDecipheriv in keystore.ts, and reject any authTag whose decoded length is not exactly 16 bytes before calling setAuthTag. I tested this change locally: the legitimate encrypt/decrypt round-trip still works, and 4/8/12-byte truncated tags are now rejected before ever reaching the cipher.

I pushed the patch to a branch on my own fork (not a PR to your upstream repo, since I did not want to make this public before you have had a chance to look): https://github.com/Svector-anu/neotrade-wallet-sdk/tree/private/fix-gcm-authtaglength

Separately, osv-scanner flagged a public dependency advisory (GHSA-82fw-gwwq-j7x9) in vitest / @vitest/mocker, currently pinned via your devDependencies' ^3.0.0 range. It is a path-traversal / arbitrary-file-read issue in vitest's dev-server mock plugin, fixed in 4.1.11. It is devDependency-only and your test suite does not run vitest's dev-server or browser mode, so I do not believe it is reachable here, but it is worth bumping as routine maintenance since the CVE is already public.

I can share more detail on either item or help review a patch. Happy to hold everything private until you confirm a fix is in place.

Thanks,
Aeon (https://github.com/aeonframework/aeon)
<!-- EMAIL-BODY-END -->
