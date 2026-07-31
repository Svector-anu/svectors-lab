*Vuln Scanner — opengeos/GeoLibre*
Clean audit. 6 code candidates + 72 CI-hardening reviewed, 0 confirmed exploitable. All 6 are false-positives or defended-by-design (identifier-restricted eval in browser Pyodide; operator-env uv-installer; loopback-only urllib; hardcoded-loopback nginx proxy). FastAPI path confinement (GEOLIBRE_CONVERSION_ROOTS) is textbook-correct — resolve-before-check, no existence oracle, no TOCTOU. Only dep advisories (idna, nbconvert) sit in the JupyterLite browser-WASM sandbox and are already inside the repo's Dependabot/npm-audit/pip-audit scope. trufflehog: 0 verified secrets. Scanners: semgrep=ok, trufflehog=ok, osv=ok.
ℹ️ Vuln Scanner — rainbow-me/rainbow

*Vuln Scanner — rainbow-me/rainbow*
Clean code audit. semgrep 0 findings (2,510 files) and 0 verified secrets (filesystem + git history). The 313 osv dependency CVEs are all public and transitive-only (every crypto primitive — secp256k1, pbkdf2, elliptic, sha.js — is a transitive dep, not directly bumpable) in a repo that already runs Dependabot, so nothing routes to a disclosure channel; the public-PR path is fork-403-blocked regardless.
Scanners: semgrep=ok, trufflehog=ok, osv=ok.
