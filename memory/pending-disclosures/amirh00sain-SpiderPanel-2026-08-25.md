---
type: Reference
repo: amirh00sain/SpiderPanel
severity: high
cwe: CWE-798
status: email-sent
auto_send: true
human_only: false
contact_email: amirshaianfar@outlook.com
cc: []
email_subject: "SpiderPanel — default admin credentials and session/cookie hardening issues"
detected_at: 2026-08-25T12:00:00Z
sent_at: 2026-08-25T20:34:08Z
sent_via: manual-gmail (svector.anu@gmail.com)
---

<!-- EMAIL-BODY-START -->
Hi Amir,

I found two security issues in SpiderPanel while doing a routine OSS security review. No exploit was run against any live system.

1. Default administrator credentials / weak password hashing (High)

In main.py, the admin password and secret are initialized from environment variables with documented defaults:

    "secret": os.environ.get("SECRET_KEY", "spider-panel-secret-key-v2")

    def hash_password(pw: str) -> str:
        return hashlib.sha256(f"{pw}{CONFIG['secret']}".encode()).hexdigest()

    AUTH = {"password_hash": hash_password(os.environ.get("ADMIN_PASSWORD", "admin"))}

docker-compose.yml carries the same defaults (ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}, SECRET_KEY=${SECRET_KEY:-spider-panel-secret-key-v2}). The README tells users to change them after first login, but there is no code-level enforcement.

Impact: any internet-exposed deployment where the operator did not manually override these values can be fully compromised through /api/login. Admin access grants control of all VPN users/inbounds, Cloudflare Worker config, backup/restore, and Docker-backed Telegram proxy management (the compose file mounts /var/run/docker.sock).

The password hash is also a single round of SHA256 with a per-installation salt, which is fast to crack if an attacker ever obtains the state backup (the backup endpoint returns the password hash and saved secret).

Suggested fixes:
A) Refuse to start, or force a password reset, when the default ADMIN_PASSWORD is detected.
B) Generate and persist a random SECRET_KEY on first startup if one is not provided.
C) Replace single-round SHA256 with bcrypt, argon2, or scrypt.

2. Session cookie and CORS hardening (Medium)

The session cookie is set without secure=True:

    resp.set_cookie(SESSION_COOKIE, token, max_age=SESSION_TTL, httponly=True, samesite="lax", path="/")

And the CORS middleware is configured with wildcard origins plus credentials:

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

Starlette will echo the requester's Origin and send Access-Control-Allow-Credentials: true in this configuration. Combined with a missing Secure flag and SameSite="lax" rather than "Strict", this weakens defense-in-depth for an HTTPS-administered panel.

Suggested fixes:
A) Set secure=True, samesite="Strict" on the session cookie.
B) Restrict allow_origins to the panel's actual public domain(s), or remove allow_credentials=True if wildcard origins are required.

Dependency notes:

requirements.txt pins fastapi==0.104.1 and pillow==10.4.0, both of which have public CVEs (PYSEC-2024-38 and several Pillow image-parsing advisories). These are already public dependency issues, so I am not filing a separate private report for them, but bumping them would be worthwhile routine maintenance.

I am happy to provide more detail or help review a patch. I can also hold the details private until you confirm a fix is available.

— Anu (Svector Lab)
<!-- EMAIL-BODY-END -->
