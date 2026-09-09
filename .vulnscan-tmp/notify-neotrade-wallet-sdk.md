*Vuln Scanner — NeoSoul-AI/neotrade-wallet-sdk*
2 confirmed findings (1 medium code flaw, 1 already-public dependency CVE).

Medium: AES-256-GCM keystore decrypt accepts truncated auth tags (missing `authTagLength`), verified empirically — practical exploit is gated to infeasibility by the keystore's own scrypt cost, so this is a real defense-in-depth gap, not a live exploit. No PVR/SECURITY.md on the repo, so a private disclosure email is staged (auto_send armed) with a working fix already pushed to a fork-only branch for the maintainer to cherry-pick.

Dependency CVE (GHSA-82fw-gwwq-j7x9, vitest/@vitest/mocker, devDependency-only, unreachable in this repo's usage): bump attempted but not filed — `pnpm` wasn't available in this session to regenerate the lockfile safely. Flagged for a follow-up run.

Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip (no Rust), agentic=ok. PoC gate: not-required (both findings graded medium).

Report: output/articles/vuln-scan-2026-09-09-neotrade-wallet-sdk.md
