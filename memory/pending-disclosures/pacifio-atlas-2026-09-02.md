---
repo: pacifio/atlas
severity: high
cwe: CWE-22
status: sent
auto_send: true
contact_email: adibmohsin.root@gmail.com
cc: []
email_subject: "Security: ACP filesystem escape and browser-reader XSS in Atlas"
detected_at: 2026-09-02T18:20:00Z
---

# Staged private disclosure — pacifio/atlas

Operator notes (NOT emailed):
- PVR disabled; SECURITY.md asks for private email to adibmohsin.root@gmail.com.
- No AI-report ban in SECURITY.md → auto_send armed.
- Audited commit: 4b2aa8a027df8cb9c1deb8566be891f4e1bd55f2
- PoC gate verified for both HIGH findings (local-command).
- Separately opened public dep-bump PR #220 for already-disclosed CVEs (gix/vite/mermaid/tar/js-yaml).
- Do not publish exploit details; PoCs stay under /tmp only.

<!-- EMAIL-BODY-START -->
Hi Adib,

I ran a good-faith security review of pacifio/atlas at commit 4b2aa8a027df8cb9c1deb8566be891f4e1bd55f2 (aligned with your SECURITY.md scope: agents acting without approval, or reaching outside the granted project). Two HIGH issues reproduced cleanly, plus a couple of related mediums.

1) ACP fs/write_text_file and fs/read_text_file have no project bind and no permission gate

Where: crates/atlas-agent-servers/src/handlers.rs — handle_write_text_file / handle_read_text_file / write_text_file

After a session-id check, the handlers call std::fs::write / read_to_string on the agent-supplied path with no canonicalize/strip_prefix against the project root and no request_permission step. A connected ACP agent can therefore read or overwrite files outside the workspace the user granted.

Impact: arbitrary host filesystem read/write from a malicious or compromised installed agent (credential files, overwrite of binaries/configs). This matches the "outside the project you granted" case in SECURITY.md.

Suggested fix: resolve the path, require it stays under the session/project root (or an explicit allowlist), and route fs writes (and ideally sensitive reads) through the same permission prompt path you already use for other agent actions. Same class of bound should apply to terminal/create, which currently spawns CommandTerminal with attacker-chosen argv/env/cwd and no permission gate either.

2) Browser reader XSS: sanitize_html leaves inline event handlers; CSP is null

Where: src-tauri/src/commands/knowledge.rs sanitize_html (used by fetch_readable); rendered in src/features/browser/components/browser-panel.tsx via dangerouslySetInnerHTML; src-tauri/tauri.conf.json sets csp: null

sanitize_html removes script/iframe/img/etc. and style attributes, but does not strip on* handlers. A page such as <p onclick="..."> survives sanitization and executes in the main webview. With CSP disabled, that script can call privileged Tauri IPC (filesystem, BYOK reveal, agent mode changes).

Impact: a user who opens a hostile page in the Atlas browser reader can lose local secrets and arbitrary file access through the already-exposed IPC surface.

Suggested fix: strip all on* attributes (or switch to a real HTML sanitizer allowlist such as ammonia), and set a strict CSP for the webview that blocks inline event handler execution. Treat the webview as untrusted relative to Rust.

Related mediums (same report, lower urgency):

- clone_github_repo / delete_cloned_repo / read_repo_readme join unsanitized repo_name under .atlas/repos (src-tauri/src/commands/github.rs). Frontend usually passes owner-repo from GitHub search, but the Rust side should still reject .. and absolute segments — especially once XSS can forge IPC.
- Registry install_archive only verifies SHA-256 when a digest is present (crates/atlas-agent-store/src/archive.rs). Prefer failing closed when the registry omits a digest.

I also opened a public dependency-only PR for already-disclosed CVEs (gix, vite, mermaid, tar, js-yaml): https://github.com/pacifio/atlas/pull/220 — that one is intentionally public because the advisories are already public.

Happy to share a minimal patch branch on my fork for the ACP path bind and the sanitizer fix if useful. I will hold any public write-up until you have had a chance to look.

Thanks,
Aeon (https://github.com/aeonframework/aeon)
<!-- EMAIL-BODY-END -->
