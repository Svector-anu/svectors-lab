---
type: Article
title: "Vuln Scan — opengeos/GeoLibre (2026-07-31)"
description: Security audit of the GeoLibre cloud-native GIS monorepo. Clean audit — 6 code candidates triaged to false-positive/defended, dependency advisories confined to the browser WASM sandbox and already under the repo's own Dependabot scope.
tags: [security, vuln-scan, geolibre, gis, audit]
timestamp: 2026-07-31T00:00:00Z
---

# Vuln Scan — opengeos/GeoLibre

**Verdict: clean audit.** 6 code candidates + 72 CI-hardening candidates reviewed, **0 confirmed exploitable**. GeoLibre is an unusually security-conscious codebase — path confinement, XSS output-escaping, DNS-rebinding defenses, and per-container proxy tokens are all done correctly. The only dependency advisories live in the browser WASM (JupyterLite) sandbox and are already within the project's own Dependabot + `npm audit` + `pip-audit` scope.

## Repo metadata

| Field | Value |
|---|---|
| Repo | [opengeos/GeoLibre](https://github.com/opengeos/GeoLibre) |
| Stars | ~4,530 |
| Language | TypeScript (monorepo) + Python (FastAPI sidecar) + Rust (Tauri) |
| Description | Cloud-native GIS platform — web, desktop (Tauri v2), and Jupyter |
| PVR enabled | No |
| SECURITY.md | No |
| Selected via | github-trending chain (07-28), after skipping the 3 repos scanned in the last 30d |

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep 1.172.0 | ok | `p/security-audit`, `p/owasp-top-ten`, `p/secrets`; 79 results (72 GHA-hardening), 891 paths |
| trufflehog 3.96.0 | ok | `--only-verified` — **0 verified secrets** |
| osv-scanner 2.4.0 | ok | 70 advisory IDs across PyPI/crates.io (triaged below) |
| slither | n/a | no Solidity in repo |

## Candidate triage (code)

All 6 non-GHA semgrep candidates were read in context and dropped:

1. **`eval()` — `apps/geolibre-desktop/src/lib/pyodide/console_api.py:285`** — tab-completion helper. `base` is a regex-parsed dotted-identifier chain (`[A-Za-z_][\w]*(\.[…])*`), evaluated only inside the user's own browser Pyodide WASM sandbox. Not attacker-reachable. *(FP — already `noqa: S307` with reasoning.)*
2. **`subprocess.run` tainted env — `backend/geolibre_server/.../app/runtime.py:183`** — runs the `uv` installer as **list-form** `["sh", script]` (no `shell=True`). The "tainted" input is the `GEOLIBRE_UV_INSTALL_BASE_URL` **operator** env var (defaults to the official `https://astral.sh/uv`). Anyone who can set it already has code-exec. *(FP.)*
3. **dynamic urllib — `runtime.py:130`** — downloads the uv install script from the same operator-controlled env URL. Same reasoning as #2. *(FP.)*
4. **dynamic urllib ×2 — `backend/geolibre_server/notebook_client.py:134,192`** — fixed `http://` loopback relay URL; the file also escapes `<`/`>` against `</script>` breakout and targets the referrer origin rather than `*`. *(FP — `noqa: S310` with reasoning.)*
5. **nginx `$host` — `docker/nginx.conf:46`** — the flagged line is a **comment**; the live directive is `proxy_set_header Host 127.0.0.1` (hardcoded loopback). The sidecar's `TrustedHostMiddleware` + per-container `X-GeoLibre-Token` explicitly defend against DNS rebinding. *(FP.)*
6. **Dockerfile missing `USER` — `Dockerfile:117`** — nginx runtime image; standard hardening item, not an exploitable flaw. *(Hardening, dropped.)*

The **72 GitHub-Actions mutable-action-tag** warnings (`.github/workflows/*`) are supply-chain hardening (pin actions by SHA), not runtime vulnerabilities — dropped as a class, consistent with prior scans.

### Manual read of the real attack surface

The FastAPI sidecar's filesystem confinement (`GEOLIBRE_CONVERSION_ROOTS`) is textbook-correct (`conversion.py:_is_within_roots` / `_validate_paths`):
- `Path.resolve()` **before** the `is_relative_to` check (resolves `..` and symlinks — no traversal).
- The allowlist check runs **before** the existence test, so out-of-root paths always return `403` — no existence oracle.
- Canonical resolved paths are handed to the subprocess and the failure-cleanup `unlink`, so there's no TOCTOU between the approved path and the acted-on path.

No path-traversal, SSRF, or injection path survived review.

## Dependency advisories (osv-scanner)

- **PyPI `idna@3.9.0`, `nbconvert@7.9.2`** — sourced **only** from `apps/geolibre-desktop/jupyterlite/requirements.txt`, i.e. the **JupyterLite in-browser (Pyodide WASM) environment**. These run client-side, converting the user's own notebooks in their own browser sandbox — low impact, no server-side exposure. The **server** backend's committed `uv.lock` already pins `nbconvert@7.17.1` (current).
- **~66 crates.io advisories** — almost entirely the unmaintained `gtk-rs 0.18.x` bindings (`RUSTSEC-2024-04xx`) pulled in transitively by Tauri v2's Linux desktop build, plus low-severity `RUSTSEC` notices. Desktop-build-only, not remotely reachable.

Per repo `CLAUDE.md`, GeoLibre already runs **Dependabot** (npm/pip/cargo/actions) + a blocking **`npm audit --audit-level=high`** + non-blocking **`pip-audit`** in CI. These advisories are inside that automated scope.

## Disclosure

**Nothing to disclose.** No confirmed code flaw, no verified secret. The dependency advisories are (a) low-impact-by-context, and (b) already covered by the project's own automated dependency tooling. No routable external channel exists in any case — the scanning token cannot fork (HTTP 403, so no public dep-bump PR), and the repo has neither PVR nor a `SECURITY.md`.

## Dedup

`memory/vuln-scanned.json` updated (`channel: clean`); GeoLibre skipped for 30 days.
