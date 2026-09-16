# PRD: F-002 vuln-scanner

Full stories, acceptance criteria, and verification commands live in `docs/product/feature-map.md`; this file adds what that one doesn't carry.

## Dependencies

- Depends on: `F-005` (multi-surface dispatch) for shadow mode's capability isolation to actually hold on every entry point, not just the one it was originally built against.
- Blocks: nothing else in this repo; other skills don't depend on vuln-scanner's internals.

## Engineering notes

Two research modes coexist deliberately: `legacy` (the existing, already-trusted scan logic, still authoritative by default) and `riva`/`shadow` (a more structured threat-modeling kernel, `skills/vuln-scanner/riva.md`, evaluated without risk via the `shadow` selector). Neither `riva` mode bypasses the existing PoC-verification or disclosure gates; Riva supplies the threat model and exploration discipline, the existing skill remains the authority on triage, verification, and disclosure.

The isolation bug found this session (`AC-002.2.2`) was a two-copies-of-the-same-check problem: `scripts/resolve-riva-capabilities.sh` (the `aeon.yml` path) had the shadow-selector regex; `apps/mcp-server/src/skill-executor.ts` (the MCP path) had no way to know about it. Fixed by moving the check into `scripts/skill_mode.sh` as `is_shadow_selector`, a single function both paths now call. See `ARCHITECTURE.md`'s secret-scoping section. The general engineering lesson, not specific to this feature: a security-relevant check duplicated across two files is a bug waiting for the second file to be forgotten, not a design choice.
