---
repo: jlcodes99/cockpit-tools
severity: critical
cwe: CWE-798
status: sent
auto_send: true
contact_email: lijie15910739914@163.com
cc: [jlcodes@163.com]
email_subject: "Security: hardcoded Google OAuth client secret in cockpit-tools"
detected_at: 2026-09-02T19:40:00Z
---

# Staged private disclosure — jlcodes99/cockpit-tools

**Operator-facing notes** (NOT emailed):

- PVR disabled; SECURITY.md is the unused GitHub template (no contact). Resolved maintainer emails from git history (primary author).
- No AI-report ban found in SECURITY.md / README.
- Finding: hardcoded Google OAuth client secret for `antigravity_enterprise` in `src-tauri/src/modules/oauth.rs` and `crates/cockpit-core/src/modules/oauth.rs`. Verified live against `https://oauth2.googleapis.com/token` (HTTP 400 `invalid_grant` = client accepted). Scopes include `cloud-platform`.
- Do **not** put the secret value in this draft or in git — path + verification only.
- Related (same disclosure email): VS Code GitHub OAuth client credentials embedded (TruffleHog verified); unauthenticated WS SwitchAccount/GetAccounts + README vs `0.0.0.0` bind mismatch (medium); weak default `report_token`.
- Public dep PR already filed separately: https://github.com/jlcodes99/cockpit-tools/pull/2217
- Audited commit: `a8781980106e3fb1cd8ff4ea74281db836cd0e0f` (v1.3.36)

<!-- EMAIL-BODY-START -->
Hi JieLi,

I am writing privately about a security issue in jlcodes99/cockpit-tools (audited at commit a878198 / v1.3.36). Private vulnerability reporting is not enabled on the repository, and SECURITY.md does not list a contact, so I am reaching out by email.

Where:
src-tauri/src/modules/oauth.rs and crates/cockpit-core/src/modules/oauth.rs

The issue:
A Google OAuth client secret (GOCSPX- prefix) for the antigravity_enterprise client id is committed in source as a string constant. I verified the client credentials are still accepted by Google's token endpoint (a deliberately invalid authorization code returns invalid_grant rather than invalid_client). The authorized scopes include https://www.googleapis.com/auth/cloud-platform in addition to profile/email scopes.

Why it matters:
Severity: critical (CWE-798 Use of Hard-coded Credentials). Anyone who clones the public repository can use the client credentials to complete OAuth code exchanges for this Google Cloud OAuth app, which enables phishing-style consent flows and token issuance under that client. The secret should be treated as compromised.

Suggested fix:
1. Rotate/revoke the Google Cloud OAuth client secret immediately in Google Cloud Console.
2. Stop shipping the secret in the repository. Prefer a public OAuth client with PKCE, or distribute secrets via a private build-time channel that is not committed.
3. Enable GitHub Private Vulnerability Reporting so future reports can go through advisories.

Related observations (lower severity, same audit):
- src-tauri/src/modules/github_copilot_oauth.rs embeds the well-known VS Code GitHub OAuth client id/secret (TruffleHog verified). Prefer a first-party GitHub OAuth App.
- WebSocket SwitchAccount / GetAccounts / GetCurrentAccount do not require the session auth_token that was added for token export/add/delete, and accept_async does not check Origin. Combined with binding 0.0.0.0 (README still says 127.0.0.1) and a loopback allowlist, a DNS-rebinding page can enumerate account emails and switch accounts. Consider requiring auth_token for switch/list as well, binding 127.0.0.1, and validating Origin.
- default_report_token is the literal string change-this-token; if report_enabled is turned on without rotating it, the 0.0.0.0 report listener is trivially guessable.

Separately I opened a public dependency bump PR for already-disclosed HIGH Rust advisories (openssl / rustls-webpki and related transitive bumps):
https://github.com/jlcodes99/cockpit-tools/pull/2217

I can share a minimal patch for the WebSocket auth/Origin hardening if that would help. Happy to coordinate disclosure timing.

Thanks,
Aeon (https://github.com/aeonframework/aeon)
<!-- EMAIL-BODY-END -->
