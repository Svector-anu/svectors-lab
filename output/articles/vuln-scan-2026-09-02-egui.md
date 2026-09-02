# Vuln scan — emilk/egui (2026-09-02)

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [emilk/egui](https://github.com/emilk/egui) |
| Stars | ~30,354 |
| Language | Rust |
| Description | Immediate-mode GUI that runs on native and web |
| Audited commit | `7c38c552e4d5ee19c0dad0586dc96d2be404c619` |
| PVR | enabled |
| SECURITY.md | absent (PVR is the disclosure channel) |
| Selection | github-trending chain (2026-09-02); first unscanned trending repo with a safe channel |
| Fork | Svector-anu/egui |

## Threat model (agentic framing)

egui is a GUI toolkit embedded by host apps. An attacker most wants: (1) memory corruption / soundness bugs reachable from untrusted fonts/images/text, (2) SSRF or filesystem reads if the host forwards untrusted URIs into image loaders, (3) abuse of the optional inspection TCP debug port. Trust boundaries: host-app-controlled widget APIs and loaders; browser sandbox for WASM; opt-in `EGUI_INSPECTION` for the debug peer.

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok | 59 hits — all `github-actions-mutable-action-tag` WARNING in `.github/workflows` |
| trufflehog (fs + git) | ok | 0 verified secrets |
| osv-scanner | ok | 5 unique advisories in `Cargo.lock` |
| fuzz | skip | no `fuzz/fuzz_targets` |
| agentic | ok | CODE_FILES=387 → N=10; 5 candidates written, 0 confirmed as novel code vulns |
| slither | n/a | no Solidity |
| PoC gate | not-required | published dependency advisory only (no HIGH/CRITICAL code claim) |

## Candidates reviewed

- **Semgrep (59):** CI mutable-tag hardening only. Not filed (noise for this mature repo; not an exploitable product flaw).
- **OSV (5):**
  - `RUSTSEC-2026-0221` `event-listener@5.4.1` — **confirmed**, patched by bump to `5.4.2`
  - `RUSTSEC-2025-0141` bincode unmaintained — already ignored in `deny.toml`
  - `RUSTSEC-2026-0206` rustybuzz unmaintained — already ignored in `deny.toml`
  - `RUSTSEC-2026-0192` ttf-parser unmaintained — already ignored in `deny.toml`
  - `RUSTSEC-2024-0320` yaml-rust unmaintained — already ignored in `deny.toml`
- **Agentic (5 candidates, all discarded after triage):** FileLoader absolute/`../` paths (app-controlled by design); EhttpLoader SSRF (app-controlled URIs); `open_url_in_browser` scheme pass-through (app Hyperlink output); inspection bind to non-loopback (opt-in env, defaults `127.0.0.1:5719`); font parse panic (host-supplied fonts, fail-fast).

Entrypoints deep-reviewed (top exposure): `FileLoader`, `EhttpLoader`, `open_url_in_browser`, `egui_inspection` TCP plugin, font/TTF load path, image/gif/webp/svg loaders, web event installers, file_storage persistence, dropped-file reader, localStorage RON memory. Remaining inventory noted as not-deep-reviewed within budget N=10.

## Confirmed findings

### 1. Transitive `event-listener` unsoundness (RUSTSEC-2026-0221) — public PR

| | |
|--|--|
| Severity | Unsound (informational) — categories: memory-corruption, thread-safety |
| Package | `event-listener` 5.4.1 → 5.4.2 |
| Path | egui-winit → accesskit_winit → accesskit_unix → zbus → async-broadcast → event-listener |
| Channel | **Public PR** (advisory already public) |
| Prior-art | No matching open/merged PR or issue for `RUSTSEC-2026-0221` / `event-listener 5.4.2` |
| PoC gate | not-required (published advisory) |
| Link | https://github.com/emilk/egui/pull/8481 |

## Dedup

Appended `memory/vuln-scanned.json` with `channel: public-pr` — skip re-scan for 30 days.
