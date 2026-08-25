---
type: Reference
repo: ZSvirt/zsvirt
severity: medium
cwe: CWE-1104
status: pending-operator-send
auto_send: false
human_only: true
contact_email: security@zsvirt.io
cc: []
email_subject: "Security: core module pins Spring Security 5.7.13 with a known authorization-bypass CVE"
detected_at: 2026-08-23T00:20:00Z
---

**Operator review requested before sending — not auto-armed.** SECURITY.md
explicitly requires private email disclosure (not a public issue — confirmed
the hard way: public issue creation was blocked by an org-level restriction,
and SECURITY.md independently says the same). Two considerations for holding
this back from auto-send:

1. **Brand-new org** (created 2026-08-03, this repo created 2026-08-14) —
   first contact, no track record either way, same caution applied to
   DigitalShield.
2. **This is a real CVE with public exploitability details** already published
   on GitHub's own advisory database (GHSA-q3v6-hm2v-pw99 and siblings) — not
   a novel finding, but still worth a human read before it goes out, since it
   names a specific auth-bypass class in their actual auth layer.

# Staged private disclosure — ZSvirt/zsvirt

<!-- EMAIL-BODY-START -->
Hi,

I ran a routine, good-faith security review of ZSvirt's public repos and found
that `zsvirt`'s `core` module (and several other modules) pin Spring Security
and Spring Framework to versions with known, published CVEs:

```xml
<spring.framework.version>5.2.25.RELEASE</spring.framework.version>
<spring.security.version>5.7.13</spring.security.version>
```

**The one I'd prioritize:** GHSA-q3v6-hm2v-pw99 — a genuine authorization-bypass
vulnerability in Spring Security caused by case-sensitive comparison
mismatches. It's fixed in **5.7.14**, which is a same-line patch release
within `5.7.x` — should be a low-risk, drop-in version bump, no breaking API
changes expected. A few siblings in the same release are also worth picking up
in the same bump: GHSA-vxf7-qj7q-83fh (user attribute enumeration via
DaoAuthenticationProvider), GHSA-293q-567p-wmwq (X.509 client-cert user
impersonation), GHSA-mf92-479x-3373 (security headers not written under some
conditions), GHSA-x2r2-rvhq-2mqv (open redirect via unvalidated post-login
redirect URL).

**Separately, a bigger one to plan for, not fix today:** `spring.framework.version`
is pinned to `5.2.25.RELEASE`, which predates even the `5.3.x` line. Several
Spring MVC CVEs I checked (e.g. GHSA-cjpg-rgq5-fr37, multipart request
smuggling) list `5.3.39` as the last known-affected version before a fix —
meaning `5.2.x` is outside the tracked/patched range entirely rather than
already covered. A real fix means the jump to at least Spring Framework
`6.2.19`, which is a genuine major-version migration (Jakarta EE namespace
changes among other things) — too large for me to respectfully hand you as a
drop-in patch, but worth having on the roadmap given it's your actual web
framework layer, not an incidental dependency.

I confirmed both of these are *direct* dependencies (declared in `core/pom.xml`
and centrally pinned in the root `pom.xml`'s `dependencyManagement`), not
transitive noise, before writing in.

I tried to open a public issue first out of habit but it was blocked by an org
permission restriction — then noticed your own SECURITY.md correctly asks for
private email instead, so apologies if that attempt showed up anywhere on
your end.

Happy to open a PR for the Spring Security `5.7.13 -> 5.7.14` bump specifically
if that's useful — it should be a one-line, no-risk change. Let me know.

Thanks for building in the open,
Anu
<!-- EMAIL-BODY-END -->

---

## Full technical writeup (for reference / if a GitHub PVR channel opens later)

### Summary
`core/pom.xml` and other modules directly depend on Spring Security 5.7.13
and Spring Framework 5.2.25.RELEASE, both centrally version-pinned in the root
`pom.xml`. Spring Security 5.7.13 carries a real, published authorization-bypass
CVE with a trivial same-line fix available. Spring Framework 5.2.25 is old
enough to sit entirely outside several CVEs' tracked-affected-version ranges,
meaning a proper fix requires a major-version migration, not a patch bump.

### Severity
Medium overall (the trivial-fix item, GHSA-q3v6-hm2v-pw99, is independently
rated meaningful by its own GHSA listing as an authorization bypass; the
larger Spring Framework staleness is a broader hygiene/exposure concern, not
a single confirmed live exploit against this specific application, since no
attempt was made to actually trigger any of the listed CVEs against a running
instance).

### CWE
CWE-1104 (Use of Unmaintained Third-Party Components) as the umbrella; the
specific Spring Security CVE is itself an authorization-bypass class.

### Location
- `pom.xml` (repo root): `spring.framework.version` = `5.2.25.RELEASE`,
  `spring.security.version` = `5.7.13`, both in `<dependencyManagement>`
- `core/pom.xml`: direct `<dependency>` declarations for
  `spring-security-core`, `spring-security-web`, `spring-webmvc`, and other
  `spring-*` artifacts consuming those pinned versions

### Verification
- Reproduced: no — dependency-version analysis only, did not attempt to
  trigger any of the listed CVEs against a running deployment
- Command: osv-scanner against `core/pom.xml` (and 119 other manifests
  repo-wide), cross-checked flagged packages against the actual `pom.xml`
  `<dependency>`/`<dependencyManagement>` declarations to confirm direct
  (not transitive) usage before reporting
- Before: `spring-security-core`/`web` at 5.7.13, `spring-webmvc` (and
  siblings) at 5.2.25.RELEASE
- After (suggested minimal fix): bump `spring.security.version` to `5.7.14`
  (low-risk, same-line patch); `spring.framework.version` requires planning a
  major-version migration to >=6.2.19, out of scope for a quick PR
- Environment: Maven multi-module Java repo, audited via `gh`/local clone,
  2026-08-23

### Detected by
osv-scanner (full repo scan, 120 manifests, ~993 raw vuln rows) followed by
manual reachability triage against `core/pom.xml`'s actual direct
dependencies and the root `pom.xml`'s version-pinning properties — not a raw
tool-count citation.
