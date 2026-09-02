---
title: Vuln scan — browser-use/video-use
description: Security audit of trending video-use agent video editor; private Medium CWE-22 disclosure filed via PVR.
tags: [security, vuln-scanner, video-use, browser-use]
timestamp: 2026-09-02T15:26:00Z
---

# Vuln scan — browser-use/video-use

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [browser-use/video-use](https://github.com/browser-use/video-use) |
| Stars | ~23,397 |
| Language | Python |
| Commit audited | `9575612f066aa517354790a645fd90f9f95a743b` |
| Selected from | `output/.chains/github-trending.md` (OpenMAIC already scanned earlier today) |
| PVR | **enabled** |
| SECURITY.md | none |
| License | MIT |

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok | 0 findings (`p/security-audit` + `p/owasp-top-ten` + `p/secrets`) |
| trufflehog | ok | 0 verified secrets (filesystem + git history) |
| osv-scanner | none | No lockfiles/manifests with pinned deps (`pyproject.toml` only, unpinned); N/A |
| fuzz | skip | no `fuzz/fuzz_targets` |
| agentic | ok | `CODE_FILES=8`, budget N=15; deep-reviewed all production helpers |
| slither | n/a | no Solidity |
| PoC gate | not-required | confirmed finding is Medium (gate applies to HIGH/CRITICAL code claims only) |

## Threat model (brief)

video-use is a local Claude Code skill for conversation-driven video editing: ffmpeg extract/grade/concat/composite, ElevenLabs Scribe transcription, timeline filmstrips. Attacker goals against a user who opens an untrusted `edl.json` (or an agent that materializes attacker-controlled EDL fields): arbitrary file read/write via path fields, ffmpeg filter/concat injection, and API-key theft from `.env`. Trust boundary: the EDL and CLI args are the untrusted input surface; there is no network-facing server.

## Entrypoints deep-reviewed

1. `helpers/render.py` — EDL → ffmpeg (`extract_segment`, `concat_segments`, `build_final_composite`, `resolve_path`, `resolve_grade_filter`)
2. `helpers/transcribe.py` / `transcribe_batch.py` — local video → ElevenLabs upload (fixed URL; key from `.env`)
3. `helpers/grade.py` — auto/preset/raw filter application
4. `helpers/timeline_view.py` — ffmpeg frame/envelope extract + PIL composite
5. `helpers/pack_transcripts.py` — transcript JSON → markdown (no sinks of interest)
6. `skills/manim-video/scripts/setup.sh` — prerequisite checks only

Not deep-reviewed beyond skim: markdown skill docs, static assets, `poster.html` (static marketing page).

## Candidates reviewed

| # | Source | Verdict |
|---|--------|---------|
| 1 | Agentic — EDL source **key** embedded in `seg_NN_<key>.mp4` write path | **Confirmed Medium** → PVR |
| 2 | Agentic — concat demuxer single-quote breakout | **Duplicate** of open [PR #54](https://github.com/browser-use/video-use/pull/54) |
| 3 | Agentic / prior art — `resolve_path()` absolute/`../` read traversal on source/subtitle/overlay **values** | **Duplicate** of open [PR #93](https://github.com/browser-use/video-use/pull/93) |
| 4 | Agentic — raw ffmpeg `grade` filter passthrough | Dropped — intentional power-user escape hatch; same local trust model |
| 5 | Semgrep | 0 candidates |
| 6 | TruffleHog | 0 verified secrets |
| 7 | OSV | N/A (no package sources) |

## Confirmed findings

### 1. EDL source-key path traversal (write) — Medium — PVR

- **CWE:** CWE-22
- **Channel:** Private Vulnerability Report
- **Advisory:** [GHSA-79fj-7f7h-8gxx](https://github.com/browser-use/video-use/security/advisories/GHSA-79fj-7f7h-8gxx) (triage)
- **PoC gate:** not-required (Medium)
- **Public detail:** redacted. Maintainers have the private advisory with location, impact, suggested fix, and a minimal path-only reproduction. Related open PR #93 covers read-side `resolve_path()` only; this write sink is a separate key→filename issue.

## Dedup note

- Repo recorded in `memory/vuln-scanned.json` with `channel: pvr` — skip for 30 days.
- Audit lead appended to `memory/topics/audit-leads.md`.
