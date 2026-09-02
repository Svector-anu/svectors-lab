# Vuln Scan — crmne/fastpotify

**Date:** 2026-09-02  
**Target:** [crmne/fastpotify](https://github.com/crmne/fastpotify)  
**Commit:** `60ff32b8789466a3bc2f21432a096a48c64974b1` (main tip at scan time)  
**Stars / language:** ~1922 / Rust  
**Mode:** scan (auto-select; trending candidates already scanned today; PVR-enabled)

## Repo metadata

- Native Spotify desktop client (egui + librespot). Handles OAuth PKCE loopback login, token storage (`0o600` on Unix), Spotify Connect / mDNS Zeroconf credential handoff, Winamp skins, optional MilkDrop, and GitHub release update checks.
- **PVR enabled** — used for the code finding below.
- No dedicated `SECURITY.md` contact beyond GitHub private reporting.

## Threat model (brief)

Attacker wants Spotify session/token theft, XSS/phishing during login, DoS via crafted skins or protocol data, or supply-chain/update abuse. Trust boundaries: loopback OAuth listener, local single-instance control port, mDNS receivers, untrusted `.wsz` skin zips, Spotify TLS sessions.

## Scanner sources

| Source | Status | Notes |
|--------|--------|-------|
| semgrep | ok | 33 findings — all GitHub Actions mutable-tag warnings; 0 non-GHA |
| trufflehog | ok | 0 verified secrets (filesystem + git history) |
| osv-scanner | ok | see dependency notes |
| fuzz (cargo) | skip | no `fuzz/fuzz_targets` |
| agentic | ok | budget N=15 on 75 code files; top-exposure entrypoints reviewed |

## Candidates reviewed

- Semgrep GHA mutable tags (hardening-class) — not filed this run
- OSV: `quick-xml` 0.38.4 (RUSTSEC-2026-0194/0195) via librespot `ProductInfo` XML and build-time wayland-scanner; `rustls-webpki` 0.102.8 via unused `hyper-proxy2` path (documented in `Cargo.toml`); `rsa` Marvin (no fix); unmaintained `ttf-parser` / `rustls-pemfile`
- Agentic: OAuth callback HTML reflection (confirmed); auth token file perms (already `0o600`); updates check (informational URL only); skin zip `ENTRY_LIMIT` 64 MiB; Zeroconf credential encryption path reviewed

## Confirmed findings

### 1. Medium — OAuth localhost callback reflected XSS (CWE-79)

- **Channel:** PVR → [GHSA-hqg7-6gj3-g28w](https://github.com/crmne/fastpotify/security/advisories/GHSA-hqg7-6gj3-g28w)
- **PoC gate:** not-required (medium; local construction + source-order check reproduced the reflection claim)
- **Draft fix (fork only, no upstream PR):** https://github.com/Svector-anu/fastpotify/tree/private/fix-oauth-callback-html-escape
- Details redacted here — see private advisory.

## Dependency notes (not separately filed)

- **quick-xml:** runtime use is librespot parsing Spotify `ProductInfo` over the authenticated session; bump lives in the `crmne/librespot` `fastpotify-0.8` fork pin (`0.38`), not a simple root lockfile-only PR.
- **rustls-webpki 0.102:** maintainers already document it as compiled-but-unused (proxy path never configured); patched 0.103.x is what live TLS uses.
- **GHA mutable tags:** hardening-class; skipped to keep signal on the XSS disclosure.

## Dedup

Appended `memory/vuln-scanned.json` with `channel: pvr` (30-day skip). Also backfilled missing `firecrawl/pdf-inspector` row from earlier same-day scan (PR #485).
