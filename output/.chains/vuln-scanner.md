ℹ️ Vuln Scanner: hashicorp/vault

*Vuln Scanner — hashicorp/vault*
Clean audit. 8,011 candidates reviewed (7,746 were a single systemic Ember-template false-positive), 0 confirmed. Scanners: semgrep=ok, trufflehog=ok, trufflehog-git=ok, osv=ok, fuzz=skip, agentic=ok. 178 dependency findings duplicate-skipped against Vault's own active Dependabot. ACL/auth-bypass threat model reviewed (acl.go, token_store.go, OIDC provider, approle login) — no bypass found.