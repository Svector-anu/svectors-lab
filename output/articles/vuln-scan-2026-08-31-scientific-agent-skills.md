# Vuln Scan — K-Dense-AI/scientific-agent-skills — 2026-08-31

## Repo metadata

| Field | Value |
|-------|-------|
| Repo | [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) |
| Stars | ~40.2k (trending 2026-08-30 chain) |
| Language | Python |
| Description | Agent Skills library for science (163 skills + bundled scripts + CI security scanning) |
| HEAD | `cc37669ed0f354619b1ae586e958609a87680718` (upstream `main`) |
| PVR | enabled |
| SECURITY.md | yes (PVR; explicit in-scope: bundled scripts, prompt injection, credential handling, repo tooling/workflows) |
| Selection | Auto from github-trending chain; skipped corsair (scanned 08-30), FrontierAgent (scanned earlier today), OpenMAIC (PVR off + SECURITY.md only points at disabled advisory form), open-seo/vphone-cli/microduck_rl (no safe channel) |

## Threat model (agentic framing)

This repo distributes Agent Skills — markdown instructions plus scripts an AI agent may execute on the operator's machine — plus CI that scans PRs. An attacker most wants: (1) local code execution when a documented skill script runs (shared `/tmp`, planted artifacts), (2) GitHub Actions RCE via PR-controlled path/name interpolation into `run:` steps (token abuse), (3) skill content that exfiltrates secrets when installed. Trust boundaries: user installs/runs skills with their privileges; `pull_request` CI checks out untrusted heads with limited permissions; weekly scanner commits reports with `contents: write`.

## Scanner sources

| Tool | Status | Notes |
|------|--------|-------|
| semgrep | ok | 43 ERROR/WARNING candidates; all but agentic-confirmed paths dropped in triage |
| trufflehog | ok | filesystem + git; 0 verified secrets (`verified_secrets: 0`) |
| osv-scanner | ok | reported idna@3.9 via opentrons requirements — **false attribution** (files pin only `opentrons==9.x`; PyPI `opentrons` has no `idna` dependency). Dropped. |
| slither | skip | no Solidity |
| fuzz | skip | no `fuzz/fuzz_targets` |
| agentic | ok | CODE_FILES=682 → budget N=10; deep-reviewed top exposure entrypoints |

## Candidates reviewed

- Semgrep: 43 unique ERROR/WARNING (mutable Actions tags, subprocess argv, defusedxml advice, dynamic urllib, MD5, nginx Host in docs)
- OSV: 1 unique CVE group (dropped as misattribution)
- Agentic: 3 candidates emitted; 2 confirmed (Actions injection counted as one bundled finding with two workflow sites)

**Confirmed: 2** (bundled into one PVR)

## Confirmed findings

| # | Severity | Channel | Summary |
|---|----------|---------|---------|
| 1 | high | PVR | Predictable `/tmp` LibreOffice profile + trust-if-substring macro in docx `accept_changes.py` → local RCE on shared hosts |
| 2 | high | PVR | Actions script injection via unquoted `${{ }}` of PR-controlled skill paths/names in `pr-skill-scan.yml` and `skill-tests.yml` |

File/line and exploit detail redacted here — see private advisory.

**Advisory:** [GHSA-3jvm-qqmm-hp97](https://github.com/K-Dense-AI/scientific-agent-skills/security/advisories/GHSA-3jvm-qqmm-hp97)

**Draft patch (fork only, no public PR):** `Svector-anu/scientific-agent-skills` branch `private/fix-libreoffice-profile-and-actions-injection`

## Triage drops (representative)

| Candidate | Why dropped |
|-----------|-------------|
| `dangerous-subprocess-use` on generate_*.py | argv list form, `shell=False`; prompt/output are data not shell |
| `use-defused-xml` across paper/citation parsers | Python 3.13 `ElementTree` does not expand external entities; docx already imports `defusedxml` |
| dynamic urllib | fixed HTTPS API hosts or documented caller URL with scheme constraints |
| mutable Actions tags | hardening noise, not exploitable alone |
| osv idna on opentrons requirements | scanner mislabeled package; file content is `opentrons==9.x` |
| nginx `$host` in open-notebook docs | documentation example, not shipped config |

## Entrypoints deep-reviewed (N=10)

1. `docx/scripts/accept_changes.py` — LibreOffice macro profile (**confirmed**)
2. `.github/workflows/pr-skill-scan.yml` — skill_dirs interpolation (**confirmed**)
3. `.github/workflows/skill-tests.yml` — skills interpolation (**confirmed**, bundled)
4. `docx/scripts/office/helpers/__init__.py` — `safe_extract` / `opc_target` (zip-slip hardened)
5. `pptx|xlsx|docx/scripts/office/soffice.py` — LD_PRELOAD shim (already fixed per security-triage)
6. `xlsx/scripts/recalc.py` — TemporaryDirectory profile (good pattern; used as fix template)
7. `infographics|scientific-slides/.../generate_*.py` — subprocess argv (FP)
8. `autoskill/scripts/backends.py` — endpoint allowlist (already fixed)
9. `get-available-resources/scripts/detect_resources.py` — fixed argv tuple, no shell
10. `scan_skills.py` / `scan_pr_skills.py` — report generation; PR loader skips missing SKILL.md

Not deep-reviewed beyond inventory (noted): remaining ~150 skill script packages under `skills/*/scripts/` — prioritized production CI + office conversion paths over science-library helpers.

## Prior-art check

Searched `libreoffice_docx_profile`, `accept_changes`, `UserInstallation`, `skill_dirs`, `script injection`, `GITHUB_OUTPUT` — 0 matching issues/PRs.

## Dedup

Appended `memory/vuln-scanned.json` with `channel: pvr` (30-day skip). Audit lead appended to `memory/topics/audit-leads.md`.
