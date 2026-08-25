⚠️ Vuln Scanner — disclose hard-failed

## Vuln Scanner — disclose

**Hard-failed (email-failed):** amirh00sain/SpiderPanel → amirshaianfar@outlook.com

- Severity: high (CWE-798 default admin credentials + session/cookie hardening)
- Attempts: 3/3 — stopped retrying
- Resend: http=403 on `resend.dev` testing domain — third-party recipients are blocked until a real domain is verified
- Draft: `memory/pending-disclosures/amirh00sain-SpiderPanel-2026-08-25.md` (`status: email-failed`)

**Operator action:** verify a sending domain in Resend (https://resend.com/domains), set `RESEND_FROM` to an address on that domain (not `*@resend.dev`), then either re-arm this draft (`status: pending-operator-send`, reset `send_attempts`) or send the EMAIL-BODY manually.

Skipped (not armed): genspark-ai/genoffice, guillaumemeyer/watermarks-remover.