---
type: Reference
repo: guillaumemeyer/watermarks-remover
severity: medium
cwe: CWE-776
status: accepted-already-fixed
ghsa_id: GHSA-pjg6-92pm-mmcf
advisory_url: https://github.com/guillaumemeyer/watermarks-remover/security/advisories/GHSA-pjg6-92pm-mmcf
submitted_at: 2026-08-15T08:03:14Z
submitted_via: interactive gh session (broader OAuth scope than the Aeon automation's fine-grained PAT)
auto_send: false
human_only: true
channel: github-pvr-form
audited_commit: 92f38b10b247788c1d2e2807251e755c315918a8
detected_at: 2026-08-15T00:00:00Z
accepted_at: 2026-08-18T16:21:51Z
closed_at: 2026-08-18T16:21:51Z
resolution_pr: https://github.com/guillaumemeyer/watermarks-remover/pull/146
---

**Resolved 2026-08-18.** Went quiet in triage for 3 days — the maintainer's own
notification pipeline had a misconfiguration and never surfaced it (his words,
not a guess). The operator followed up publicly on X (@guillaumemeyer),
prompting a same-day response: `submission.accepted: true`, credited as
reporter (`credits_detailed[0].state: "accepted"`), advisory `state: closed`.

Turns out the root cause was already patched by an unrelated commit
(`7236277`, a Ruff-linting sweep that enabled rule `S314` and, as a listed
side effect, "harden sitemap XML parsing: reject DTD/entity declarations") —
landed *before* this report was filed, just without a regression test. The
maintainer's follow-up, [PR #146](https://github.com/guillaumemeyer/watermarks-remover/pull/146)
("test: refuse DTD/entity bombs in sitemap parser (GHSA-pjg6-92pm-mmcf)"),
adds that test against `tests/test_audit.py` and merged 2026-08-18T16:24:54Z,
3 minutes after the advisory closed. Independently verified both the commit
and the PR via `gh api`/`gh pr view` — not just taking the maintainer's word.

`published_at` is still `null` (no public CVE) as of this writing — advisory
is accepted + closed but not yet published. Nothing further needed from our
side; this thread is closed.

---

**Submitted 2026-08-15T08:03:14Z as GHSA-pjg6-92pm-mmcf, state: triage.** Awaiting maintainer response. The automation's `GH_GLOBAL` PAT still lacks Private Vulnerability Reporting write scope — this one went out via the operator's interactive `gh` session instead, not a fixed automation path.

# Staged private disclosure — guillaumemeyer/watermarks-remover

**Operator action required.** This is a real, verified finding that could NOT be
auto-submitted: PVR is enabled on the repo
(`private-vulnerability-reporting.enabled = true`), so the responsible channel is
GitHub's private advisory form — but the Aeon GitHub token is a restricted
fine-grained PAT that returns `403 "Resource not accessible by personal access
token"` on `POST /repos/.../security-advisories/reports` (and on repo fork).
Nothing is wrong with the target repo; it's our token. Same limitation hit on the
2026-08-13 genoffice run.

**This is NOT an email disclosure** — do not arm it for the disclose arm (Arm C);
`auto_send` is `false` by design. The repo's SECURITY.md directs reporters to the
GitHub advisory form, not email. The correct action is for a human with GitHub
access to paste the advisory below into the private-reporting form:

  https://github.com/guillaumemeyer/watermarks-remover/security/advisories/new

Severity: medium. CWE-776 (recursive entity expansion) → CWE-400 (resource
exhaustion). Remote, unauthenticated DoS on the audit host; no RCE / data
exposure. Not a duplicate: PR #49 hardened this same file against SSRF and gzip
bombs but not against XML entity expansion; no open/closed issue or PR mentions
the sitemap XML parser, entities, billion-laughs, or defusedxml.

---

## Advisory (paste into the PVR form)

**Summary:** XML entity-expansion (billion laughs) DoS in audit_website.py sitemap parser
**Severity:** medium
**CWE IDs:** CWE-776, CWE-400
**Affected:** watermarks-remover, main @ 92f38b10b247788c1d2e2807251e755c315918a8

## Summary

`audit_website.py` parses remote, attacker-controlled sitemap XML with the
stdlib `xml.etree.ElementTree.fromstring`, which expands internal DTD entities.
A hostile sitemap of a few hundred bytes can therefore inflate to gigabytes in
memory during parsing (a classic "billion laughs" / XML entity-expansion bomb),
exhausting RAM and taking down the host running the audit. The existing 4 MB
*input* byte cap does not help — the amplification happens after the bytes are
read, during entity expansion.

This is on the tool's primary untrusted-input path: `audit_website.py` exists to
audit **arbitrary, third-party websites** for AI-provenance marks, so pointing it
at an attacker-influenced site is the intended use, and the sitemap it fetches is
fully controlled by that site.

- **Class:** CWE-776 (Improper Restriction of Recursive Entity References /
  "billion laughs"), leading to CWE-400 (Uncontrolled Resource Consumption).
- **Severity:** Medium — remote, unauthenticated, trivially exploitable
  denial-of-service against the audit host; no code execution or data exposure.

This complements PR #49 ("harden website audit against SSRF and gzip bombs"),
which guarded the same file against SSRF and *gzip* decompression bombs but not
against *XML entity* expansion on the very parser those bytes flow into.

## Location

- `service/scripts/audit_website.py:72` — `root = ET.fromstring(data)` inside
  `parse_sitemap(data)`.
- Reached from `collect_urls()` → `_recurse()` →
  `data, _ = fetch(url, timeout, DEFAULT_MAX_BYTES)` → `parse_sitemap(data)`
  (`audit_website.py:457`), and from `discover_sitemap()` (`:396`).
- Audited commit: `92f38b10b247788c1d2e2807251e755c315918a8` (main, 2026-08-14).

## Impact

An attacker who controls (or can convince a victim to audit) a website serves a
malicious `sitemap.xml`. When the victim runs, e.g.:

    python service/scripts/audit_website.py --sitemap https://attacker.example/sitemap.xml
    # or the auto-discovery path:
    python service/scripts/audit_website.py --base https://attacker.example

`parse_sitemap` expands the entity bomb and the process consumes all available
memory, triggering the OOM killer / swap thrash — a host-level denial of service
that "affects the host beyond normal process failure" (explicitly in-scope per
SECURITY.md). Because `_recurse` follows nested `<sitemapindex>` entries up to
depth 3, every fetched sub-sitemap is parsed the same way, so a single malicious
index can point at multiple bombs.

Note: Python's `xml.etree` is *not* vulnerable to external-entity XXE (pyexpat
does not resolve external entities/DTDs by default since 3.7.1), so this is a
resource-exhaustion issue, not file-read/SSRF via XML. The SSRF surface is
separately handled well by the IP-pinning code.

## Proof

A safe, bounded demonstration that `ET.fromstring` expands internal entities
(kept small on purpose — a real attack simply adds more levels to go exponential
until OOM):

    import xml.etree.ElementTree as ET
    xml = b'''<?xml version="1.0"?>
    <!DOCTYPE sitemapindex [
     <!ENTITY a "lol">
     <!ENTITY b "&a;&a;&a;&a;&a;&a;&a;&a;&a;&a;">
     <!ENTITY c "&b;&b;&b;&b;&b;&b;&b;&b;&b;&b;">
     <!ENTITY d "&c;&c;&c;&c;&c;&c;&c;&c;&c;&c;">
     <!ENTITY e "&d;&d;&d;&d;&d;&d;&d;&d;&d;&d;">
     <!ENTITY f "&e;&e;&e;&e;&e;&e;&e;&e;&e;&e;">
     <!ENTITY g "&f;&f;&f;&f;&f;&f;&f;&f;&f;&f;">
    ]>
    <sitemapindex><loc>&g;</loc></sitemapindex>'''
    root = ET.fromstring(xml)
    print(len(xml), "bytes ->", len(root.find("loc").text), "chars")

Observed: 388 bytes -> 3,000,000 chars (~7,700x) at only 7 levels. Adding a few
more levels (and referencing the top entity several times) drives this into the
multi-gigabyte range from a payload still well under the 4 MB fetch cap. The same
`<!DOCTYPE ... <!ENTITY ...>>` prologue placed on a served `sitemap.xml` reaches
the sink verbatim through `fetch` → `parse_sitemap`.

### Verification
- Reproduced locally: yes (entity-expansion behavior of `ET.fromstring`, shown above)
- Command: `python3 -c "<snippet above>"`
- Before: a <1 KB DOCTYPE/ENTITY sitemap expands unbounded in memory during `parse_sitemap`
- After (with the suggested fix): the same input is rejected before expansion
- Environment: CPython 3.12, stdlib `xml.etree.ElementTree` (pyexpat)

## Suggested fix

Valid sitemaps (per sitemaps.org) never contain a DTD, so the cleanest
stdlib-only fix is to refuse any document that declares one, before parsing —
which neutralizes both entity-expansion and any future DTD-based vector while
keeping the "stdlib-only" constraint:

    def parse_sitemap(data: bytes) -> tuple[str, list[str]]:
        ...  # existing gzip / size-cap handling
        # Reject DTDs: sitemaps have none, and a DOCTYPE is the entry point for
        # entity-expansion ("billion laughs") DoS.
        parser = ET.XMLParser()
        def _no_dtd(*_a, **_k):
            raise ValueError("DTD/entity declarations are not allowed in sitemaps")
        parser.parser.StartDoctypeDeclHandler = _no_dtd
        parser.parser.EntityDeclHandler = _no_dtd
        root = ET.fromstring(data, parser=parser)
        ...

Alternatively, depend on `defusedxml` and call
`defusedxml.ElementTree.fromstring(data, forbid_dtd=True)`, which is purpose-built
for exactly this. A cheap pre-check (`if b"<!DOCTYPE" in data[:4096]: raise ...`)
can be added as belt-and-suspenders.

Happy to open a small PR with the fix + a regression test if useful.

## Detected by

Semgrep (`p/security-audit` → `use-defused-xml`) flagged the raw `xml.etree`
usage; manual review of the `fetch` → `parse_sitemap` call path and a local
expansion test confirmed reachability from remote input and the amplification
factor. Reported as part of an automated-but-human-triaged trending-repo audit.
