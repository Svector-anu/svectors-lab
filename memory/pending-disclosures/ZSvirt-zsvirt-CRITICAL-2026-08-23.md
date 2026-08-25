---
type: Reference
repo: ZSvirt/zsvirt
severity: critical
cwe: CWE-798
status: pending-operator-send
auto_send: false
human_only: true
contact_email: security@zsvirt.io
cc: []
email_subject: "CRITICAL: committed private RSA key deployed as root SSH credential to every managed node, plus a TLS-verification-disabled + unverified-JWT auth bypass chain in SSO login"
detected_at: 2026-08-23T00:50:00Z
---

**Operator review required before sending — highest severity finding of the
entire campaign, send this ahead of/separately from the Spring CVE
disclosure.** Not holding this back out of uncertainty — the mechanism is
fully confirmed by direct code read, not inferred. Holding only because:

1. This is a live, actionable credential compromise path on real
   infrastructure-management software (an IaaS/hypervisor orchestrator, not
   a web app) — the operator should control exact send timing given the
   sensitivity, same principle as the zFi live-exploit disclosure.
2. Same brand-new-org caution as the other ZSvirt disclosure (org created
   2026-08-03).

# Staged private disclosure — ZSvirt/zsvirt (CRITICAL)

<!-- EMAIL-BODY-START -->
Hi,

Flagging this one separately and first, ahead of a smaller Spring Security/
Framework version finding I'm also sending — this one needs immediate
attention.

**`conf/ansible/rsaKeys/id_rsa` is a fully-formed, working RSA private key
committed directly in the public repository**, added in the initial "import
ZSvirt master source" commit (4aeacf24), key comment `root@zstack`.

I traced exactly how it's used before writing in, so this isn't speculative:

- `core/src/main/java/org/zstack/core/ansible/AnsibleConstant.java` defines
  `RSA_PRIVATE_KEY = "ansible/rsaKeys/id_rsa"` and
  `RSA_PUBLIC_KEY = "ansible/rsaKeys/id_rsa.pub"`.
- `console/src/main/java/org/zstack/console/ManagementServerConsoleProxyBackend.java`
  loads this exact private key file directly off the classpath.
- `core/src/main/java/org/zstack/core/ansible/AnsibleRunner.java` (around
  line 245-255) appends the matching **public** key into every managed
  node's `~/.ssh/authorized_keys` as part of provisioning — for the `root`
  user, per the key's own comment.

**The practical impact:** any ZSvirt deployment that hasn't manually
regenerated this specific keypair before going into production is running
with a known, publicly-downloadable root SSH credential granting access to
every hypervisor/compute node the management server has provisioned. Anyone
who has ever cloned this repository — which is now anyone, since it's
public — has root access to those machines, network position permitting.
This isn't a theoretical weakness in an algorithm; it's the literal private
key file, plaintext, in git history forever (rotating it in a future commit
does not remove it from history, and it's likely already been scraped by
automated secret-scanners crawling public GitHub given the repo's star
count).

**Suggested immediate steps**, roughly in priority order:
1. Treat this key as fully compromised — assume it's already been harvested.
2. If any real deployments exist (including your own demo/reference
   environments) that used this default key without regenerating it,
   rotate the SSH keypair on every managed node immediately and remove this
   key from `authorized_keys` everywhere.
3. Remove the private key from the repository and generate a fresh keypair
   per-deployment at install time instead of shipping a static one (or, if a
   default must ship for a smoother out-of-box experience, force key
   rotation on first boot/setup rather than trusting the shipped pair long
   term).
4. Since git history retains the old key regardless of a future commit
   removing it, consider whether a history rewrite is warranted for a repo
   this young (created 2026-08-14), understanding that's disruptive for any
   existing forks/clones.

**Second, separate finding — SSO login auth-bypass chain:** `RESTFacade.createRestTemplate`
(`header/src/main/java/org/zstack/header/rest/RESTFacade.java`, lines ~116-133)
is the shared, default REST client factory used broadly across the codebase.
It unconditionally builds every HTTP client with a trust-all `SSLContext`
(`DefaultSSLVerifier.trustAllCerts`, which validates nothing) and
`NoopHostnameVerifier` (also validates nothing) — no certificate chain or
hostname checking at all, by default, for outbound HTTPS.

The OAuth2 SSO plugin (`premium/plugin-premium/sso-plugin/.../OAuth2ManagerImpl.java`,
line 94) uses exactly this client to fetch the ID token from the configured
third-party identity provider's token endpoint, and then decodes that JWT via
`JWT.decode(...)` (lines 304 and 523) — which, per the auth0 java-jwt
library's own design, reads claims but does **not** verify the token's
cryptographic signature.

Put together: anyone in a position to intercept traffic between the ZSvirt
server and the configured identity provider (network position — not
necessarily on the ZSvirt host itself) can transparently MITM that
connection, since neither the certificate nor the hostname is checked, then
forge or tamper the OAuth2 token response including the JWT's claims. The
application will trust whatever claims arrive, since the signature is never
independently verified. For any deployment using SSO, this is a full
authentication-bypass / account-takeover path, not limited to the specific
IdP call — the same trust-all client appears to be the framework default
used broadly elsewhere in the codebase too, so it's worth an audit beyond
just this one call site.

Happy to answer anything or provide more detail. Given the severity of both
of these I'd recommend prioritizing this email over the separate Spring
version findings I'm also sending.

Thanks for building in the open,
Anu
<!-- EMAIL-BODY-END -->

---

## Full technical writeup (for reference / if a GitHub PVR channel opens later)

### Finding 1 — Committed private key deployed as root SSH credential

**Summary:** A working RSA private key is committed in plaintext at
`conf/ansible/rsaKeys/id_rsa`. The application's own Ansible-based node
provisioning flow deploys the matching public key into every managed
hypervisor/compute node's `root` `~/.ssh/authorized_keys`. Any deployment
that does not manually regenerate this keypair before production use grants
root SSH access to every provisioned node to anyone who has ever cloned the
public repository.

**Severity:** Critical. CWE-798 (Use of Hard-coded Credentials). This is full
remote root compromise of managed infrastructure nodes, not a
web-application-layer bug — the blast radius is the actual compute/hypervisor
fleet a deployment manages, not just the ZSvirt control-plane application
itself.

**CWE:** CWE-798 (Use of Hard-coded Credentials), CWE-321 (Use of Hard-coded
Cryptographic Key) as a secondary classification.

**Location:**
- `conf/ansible/rsaKeys/id_rsa` (private key, plaintext, committed)
- `conf/ansible/rsaKeys/id_rsa.pub` (matching public key)
- `core/src/main/java/org/zstack/core/ansible/AnsibleConstant.java:16-17`
  (path constants)
- `console/src/main/java/org/zstack/console/ManagementServerConsoleProxyBackend.java:204`
  (loads the private key)
- `core/src/main/java/org/zstack/core/ansible/AnsibleRunner.java:~245-255`
  (deploys the public key into `authorized_keys` on managed nodes)

**Verification:**
- Reproduced: partially — confirmed the key is a real, valid, well-formed
  RSA keypair (`ssh-keygen -lf` produced a real fingerprint,
  `SHA256:WXe8eqQVtNvf4/MaXQrBjm3J5oEhULBUN6iY+w9QeCQ`, 2048-bit) and traced
  the exact code path that deploys it to managed nodes. Did NOT attempt to
  actually SSH into any real deployment using this key — no real deployment
  was accessible to test against, and doing so without authorization would
  itself be unauthorized access. Confirmed it is NOT the well-known Vagrant
  public insecure test keypair (different fingerprint), ruling out the
  "this is a deliberately-public test fixture" explanation.
- Command: `ssh-keygen -lf conf/ansible/rsaKeys/id_rsa.pub`; `git log
  --oneline -- conf/ansible/rsaKeys/id_rsa` (single commit, no history
  explaining intent); grep for `RSA_PRIVATE_KEY`/`RSA_PUBLIC_KEY` usage
  across the Java source tree
- Environment: full local clone, audited 2026-08-23
- Detected by: semgrep (`generic.secrets.security.detected-private-key`),
  followed by manual verification of the key's validity and full trace of
  its actual deployment mechanism in the codebase — not a raw tool-hit
  citation.

### Finding 2 — TLS verification disabled by default + unverified JWT signature in SSO login

**Summary:** The default shared REST client factory
(`RESTFacade.createRestTemplate`) disables both TLS certificate-chain
validation and hostname verification unconditionally. The SSO OAuth2 plugin
uses this client to fetch ID tokens from the configured identity provider and
decodes the returned JWT without verifying its signature, combining into a
full network-MITM-based authentication bypass for SSO logins.

**Severity:** Critical for any deployment with SSO configured. CWE-295
(Improper Certificate Validation) combined with CWE-347 (Improper
Verification of Cryptographic Signature).

**CWE:** CWE-295, CWE-347.

**Location:**
- `header/src/main/java/org/zstack/header/rest/RESTFacade.java:116-133`
  (`createRestTemplate` — trust-all `SSLContext` + `NoopHostnameVerifier`,
  unconditional)
- `header/src/main/java/org/zstack/header/rest/DefaultSSLVerifier.java`
  (defines `trustAllCerts`, a `X509TrustManager` that performs no validation
  in either `checkClientTrusted` or `checkServerTrusted`)
- `premium/plugin-premium/sso-plugin/src/main/java/org/zstack/sso/oauth2/service/OAuth2ManagerImpl.java:94`
  (`http` client instantiated via the vulnerable `createRestTemplate`)
- `premium/plugin-premium/sso-plugin/src/main/java/org/zstack/sso/oauth2/service/OAuth2ManagerImpl.java:304,523`
  (`JWT.decode(...)` calls with no corresponding signature verification)

**Verification:**
- Reproduced: no — did not attempt an actual network MITM against a live
  deployment, since none was available/authorized to test against. Traced
  the full code path statically: confirmed `createRestTemplate` is the
  literal method the OAuth2 plugin's `http` field is initialized from
  (`OAuth2ManagerImpl.java:94`), confirmed `DefaultSSLVerifier.trustAllCerts`
  performs no checks in either `X509TrustManager` method, confirmed
  `JWT.decode()` (auth0 java-jwt library) is documented/known to skip
  signature verification by design (it is a claims-reading convenience
  method, not `JWT.require(algorithm).build().verify(token)`), and confirmed
  no separate verification call exists anywhere else in `loginByToken`.
- Command: manual source read across `RESTFacade.java`,
  `DefaultSSLVerifier.java`, `OAuth2ManagerImpl.java`
- Environment: full local clone, audited 2026-08-23
- Detected by: semgrep flagged the trust-manager and JWT-decode patterns
  independently (`java.lang.security.audit.crypto.ssl.insecure-trust-manager`,
  `java.java-jwt.security.audit.jwt-decode-without-verify`); manually traced
  the connection between the two to confirm they form a single exploitable
  chain rather than reporting them as two unrelated low-context hits.
