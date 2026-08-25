# Vulnerability scan — AprilNEA/OpenLogi

## Repository

- Repository: `AprilNEA/OpenLogi`
- Snapshot: `master` @ `84aa1ed` (v0.7.10 workspace)
- Stars: ~15,870
- Primary language: Rust
- Product: local-first Logitech Options+ alternative (HID++ / UVC) — agent + GUI over local IPC, plain TOML config, minisign-signed updater
- Disclosure channel: GitHub PVR **enabled** (no `SECURITY.md`); author contact `dev@aprilnea.me`
- Review size: 427 production-language source files; agentic budget N=10

## Threat model

OpenLogi is a same-user desktop stack. Highest-value attacker outcomes are: (1) arbitrary command execution as the logged-in user, (2) keystroke/HID injection beyond intended remaps, (3) malicious update / asset supply-chain compromise, (4) local cross-user abuse of the agent IPC socket on a shared machine. Trust boundaries: user-owned TOML config, USB/HID device reports, local Unix socket / Windows named pipe IPC, HTTPS asset/update mirrors (checksum + minisign), and GitHub Actions for release signing.

## Scanner sources

| Source | Status | Result |
|---|---|---|
| Semgrep security-audit / OWASP / secrets | ok | 96 candidates — overwhelmingly mutable GitHub Actions tags; 2× `run-shell-injection` ERROR, 1× `secrets-inherit` |
| TruffleHog filesystem | ok | 0 verified secrets |
| TruffleHog git history | ok | 0 verified secrets |
| osv-scanner | ok | 13 advisory/package rows in `Cargo.lock` |
| Slither | n/a | No Solidity |
| cargo-fuzz | skip | No `fuzz/fuzz_targets` |
| Agentic source-to-sink review | ok | Top 10 exposure surfaces deep-reviewed; 0 code vulns confirmed |

## Triage summary

- **Candidates reviewed:** 96 Semgrep + 13 OSV + agentic pass over IPC/config/inject/updater/HID++/CI
- **Confirmed:** 4 dependency advisories with available patches (public PR)
- **Dropped:** Semgrep CI shell-injection (boolean `inputs.sign` / workflow matrix / `$GITHUB_REF_NAME` in PowerShell assignment — not attacker-controlled code exec); mutable action tags (hardening noise); `RunShellCommand` / `RunAppleScript` (intentional user-config feature); unauthenticated local IPC (FS-permission / documented Windows DACL design, not a remote vuln); unmaintained crate notices; `quick-xml@0.30` blocked by `xcb` ← `zed-scap`

## Confirmed findings

### 1–4. Transitive RustSec advisories (lockfile bumps)

| Package | From → To | Advisory | Notes |
|---|---|---|---|
| `h2` | 0.4.14 → 0.4.16 | RUSTSEC-2026-0258 / GHSA-q83h-524g-xf6h | Low; unbounded empty DATA frames (DoS). Via `hyper` / `zed-reqwest` (GUI HTTP) |
| `memmap2` | 0.9.10 → 0.9.11 | RUSTSEC-2026-0186 | Unchecked pointer offset in advise/flush range APIs. Via `fontdb` / `xkbcommon` |
| `event-listener` | 5.4.1 → 5.4.2 | RUSTSEC-2026-0221 | `!Send` tag soundness via `StackSlot`. Also on CLI path through `openlogi-hidpp` |
| `crossbeam-epoch` | 0.9.18 → 0.9.20 | RUSTSEC-2026-0204 | Invalid ptr deref in `fmt::Pointer` for null `Atomic`/`Shared` |

**Channel:** public PR (already-disclosed dep CVEs) — https://github.com/AprilNEA/OpenLogi/pull/956

**Not filed:** `quick-xml@0.30.0` (RUSTSEC-2026-0194 / 0195, CVSS A:H DoS) — required by `xcb@1.7.0` ← `zed-scap`; no in-tree bump path. Unmaintained notices (`bincode`, `paste`, `instant`, `rustls-pemfile`, `rustybuzz`, `ttf-parser`, `proc-macro-error2`) — informational; `bincode` already ignored with rationale in `.cargo/deny.toml`.

## Agentic review (top 10)

1. **IPC server** (`openlogi-ipc` / `openlogi-agent` server) — local socket, bincode/tarpc; Unix path under XDG config; Windows named-pipe DACL documented as same-user+admin. No remote network listener.
2. **Config reload → action dispatch** — TOML `RunShellCommand` / `RunAppleScript` execute via `/bin/sh -c` / `osascript`; intentional power-user feature, same privilege as writing `~/.config/openlogi/config.toml`.
3. **Asset HTTP fetch** — `ureq` + SHA-256 verify before write; `safe_component_path` rejects `..` / separators (tested).
4. **Updater** — `gpui-updater` with embedded minisign public key from release build.
5. **HID++ report parsing** — fixed-size short/long reports; no unbounded alloc from wire length fields observed in protocol layer.
6. **CI build.yml shell interpolation** — triaged false positive (see above).
7. **Pairing / passkey RPC** — agent-driven; GUI is client only.
8. **Overlay / Actions Ring IPC** — same local trust domain as GUI.
9. **Binary watch / takeover** — local process lifecycle, not untrusted input.
10. **Camera / UVC path** — local device I/O; LED-off-when-idle design; no network sink.

Entrypoints past N noted but not deep-reviewed: packaging/xtask release signing helpers, Windows MSI/ Authenticode path, Litra light command paths, Wayland foreign-toplevel watcher.

## Dedup

Recorded in `memory/vuln-scanned.json` with `channel: public-pr` (30-day skip).

## Advisory / PR links

- https://github.com/AprilNEA/OpenLogi/pull/956
