---
type: Reference
repo: genspark-ai/genoffice
severity: low
cwe: CWE-22
status: submitted
auto_send: false
human_only: true
channel: github-pvr-form
pvr_form_url: https://github.com/genspark-ai/genoffice/security/advisories/new
ghsa_id: GHSA-23q3-cxcv-ccc9
submitted_at: 2026-08-13T00:00:00Z
detected_at: 2026-08-13T00:00:00Z
---

# Staged private disclosure — genspark-ai/genoffice

**Operator action required.** This is a real, verified finding but it could NOT be
auto-submitted: PVR is enabled on the repo (`private-vulnerability-reporting.enabled = true`),
so the responsible channel is GitHub's private advisory form — but the Aeon
GitHub token is a restricted fine-grained PAT that returns `403 "Resource not
accessible by personal access token"` on both `POST /repos/.../security-advisories/reports`
and repo fork. Nothing is wrong with the target repo; it's our token.

**This is NOT an email disclosure** — do not arm it for the disclose arm (Arm C).
The correct action is for a human with GitHub access to paste the advisory below
into the private-reporting form:

  https://github.com/genspark-ai/genoffice/security/advisories/new

Severity is intentionally **low** (defense-in-depth; requires a prior
renderer-compromise precondition; not reachable from untrusted document content
or the AI agent in shipping code paths). Frame it deferentially — it's a
hardening consistency fix, not a live exploit.

Suggested form fields:
- Title: Path traversal in docs:save-new IPC handler — unsanitized filename escapes the default save directory
- Severity: Low
- CWE: CWE-22 (Improper Limitation of a Pathname to a Restricted Directory)
- Affected: apps/docs (Electron main process)

<!-- ADVISORY-BODY-START -->
## Summary

The `docs:save-new` IPC handler in the Docs app writes a renderer-supplied
filename into the default save directory with `path.join(dir, name)` and no path
confinement, so a filename containing `..` segments (or an absolute path) escapes
the intended directory. Because this is the silent first-save path (no save
dialog, no user confirmation), a renderer that supplies a traversal name causes
fully attacker-controlled bytes to be written to an attacker-chosen location.

This is a defense-in-depth / trust-boundary finding: the app's current renderer
code always sanitizes the name before calling this channel, so it is NOT
triggerable by merely opening a malicious document or via the AI agent. The
impact requires the renderer to be compromised first (e.g. a script-execution
bug in the local SPA). It's worth fixing because the app's own hardening model
(contextIsolation: true, sandbox: true, "renderers reach main only through
typed, validated IPC") is explicitly designed to contain a compromised renderer
— and this handler hands that renderer an arbitrary-path, arbitrary-content
file-write primitive, which is exactly what the sandbox is meant to prevent. The
sibling write handlers already validate; this one is the outlier.

## Location

apps/docs/src/main/docs-main.ts

- `docs:save-new` handler — builds the target with `uniquePathIn(defaultSaveDir(), defaultName)`, where `defaultName` is the untrusted IPC argument.
- `uniquePathIn(dir, fileName)` — `let candidate = join(dir, fileName)` with no `..` / absolute-path / containment check.

Reached from preload `saveDocxNew` → `ipcRenderer.invoke('docs:save-new', defaultName, data)`.

## Why the silent path specifically

- `docs:save-as` passes its `defaultName` into the OS save dialog as `defaultPath`; the user confirms the final location, so a traversal string is harmless there.
- The Slides equivalent runs the draft name through `sanitizeDraftBaseName` in the main process before writing.
- `docs:save-new` is the only write path that is both silent (no dialog) and does not re-validate the name in main — the two properties that make the missing check matter.

## Impact

A compromised/misbehaving renderer can invoke `saveDocxNew` with, e.g.,
`../../../../<user-home>/.config/autostart/x.desktop` (Linux) or a Windows Startup
path, or any path traversing out of the default folder. `data` is an arbitrary
ArrayBuffer (not constrained to valid .docx), so both the path and the file
contents are fully attacker-controlled — an arbitrary file-write primitive that
can lead to persistence or code execution. Severity is kept low because it
depends on a prior renderer-compromise precondition and is not reachable from
untrusted document content in the shipping code paths.

## Suggested fix

Confine the target to the default directory in the main process, mirroring the
sibling handlers — validate the resolved path stays inside `defaultSaveDir()`
and/or reduce the name to its basename before joining. For example, reject any
name where `path.basename(name) !== name`, or assert `resolve(dir, name)` starts
with `resolve(dir) + sep` before writing. Applying the same `sanitize*BaseName`
used by Slides / the Docs renderer inside the handler would also close it.

### Verification
- Reproduced locally: no (static review; no build run in the sandbox)
- Method: read `apps/docs/src/main/docs-main.ts` (`docs:save-new` handler + `uniquePathIn`), compared against `docs:save-as` (dialog-confirmed) and the Slides `sanitizeDraftBaseName` main-process check; traced the renderer callers (`file-actions.ts` `saveDocxNew(autoName ?? doc.fileName, buffer)`) to confirm current callers always pass a sanitized or constant name.
- Before: `uniquePathIn(defaultSaveDir(), "../../x")` → `join(dir, "../../x")` resolves outside `dir`; `atomicWriteFile` writes there.
- After (proposed): handler rejects/normalizes the name; write stays inside `defaultSaveDir()`.
- Environment: source at commit dc4d7e5 (Sync snapshot 2026-08-12, #87).

## Detected by

Manual security review (audit of main-process IPC file sinks). Semgrep OSS and
TruffleHog runs on this repo were clean; this is a logic-level finding not
flagged by those rule sets.
<!-- ADVISORY-BODY-END -->
