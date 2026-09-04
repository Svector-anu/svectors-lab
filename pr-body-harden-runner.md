Automated dependency bump addressing five disclosed CVE groups in transitive npm dependencies. All fixes stay within the currently-resolved major version line, so no source changes are required — only `package.json` (new `overrides` block) and the regenerated `package-lock.json`.

| Package | From | To | Advisory | Severity |
|---|---|---|---|---|
| `brace-expansion` (prod, transitive) | 1.1.14 | 1.1.18 | [GHSA-3jxr-9vmj-r5cp](https://github.com/juliangruber/brace-expansion/security/advisories/GHSA-3jxr-9vmj-r5cp), [GHSA-mh99-v99m-4gvg](https://github.com/juliangruber/brace-expansion/security/advisories/GHSA-mh99-v99m-4gvg), [GHSA-rgw5-rvv9-x895](https://github.com/juliangruber/brace-expansion/security/advisories/GHSA-rgw5-rvv9-x895) | HIGH |
| `fast-xml-parser` (prod, transitive) | 5.9.3 | 5.10.1 | [GHSA-8r6m-32jq-jx6q](https://github.com/advisories/GHSA-8r6m-32jq-jx6q) | HIGH |
| `js-yaml` (dev, transitive) | 3.14.2 | 3.15.1 | [GHSA-52cp-r559-cp3m](https://github.com/advisories/GHSA-52cp-r559-cp3m), [GHSA-5p4m-2wfm-xmqj](https://github.com/advisories/GHSA-5p4m-2wfm-xmqj), [GHSA-h67p-54hq-rp68](https://github.com/advisories/GHSA-h67p-54hq-rp68) | HIGH / HIGH / MODERATE |
| `browserslist` (dev, transitive) | 4.28.4 | 4.28.7 | [GHSA-73wf-gq98-2v4g](https://github.com/browserslist/browserslist/security/advisories/GHSA-73wf-gq98-2v4g), [GHSA-c83g-rgw3-j3cx](https://github.com/browserslist/browserslist/security/advisories/GHSA-c83g-rgw3-j3cx) | HIGH |
| `fast-uri` (dev, transitive) | 3.1.2 | 3.1.6 | [GHSA-4c8g-83qw-93j6](https://github.com/fastify/fast-uri/security/advisories/GHSA-4c8g-83qw-93j6), [GHSA-7p8r-x3mc-p8w7](https://github.com/advisories/GHSA-7p8r-x3mc-p8w7), [GHSA-f65p-4m7j-42xc](https://github.com/advisories/GHSA-f65p-4m7j-42xc), [GHSA-fph4-wmhf-6fwf](https://github.com/advisories/GHSA-fph4-wmhf-6fwf), [GHSA-jqff-g426-hqxp](https://github.com/advisories/GHSA-jqff-g426-hqxp), [GHSA-v2hh-gcrm-f6hx](https://github.com/advisories/GHSA-v2hh-gcrm-f6hx) | HIGH |

None of these packages are declared directly in `package.json`'s own `dependencies`/`devDependencies` (they're pulled in transitively), so the fix uses an `overrides` block to pin each to its lowest same-major patched version, then regenerates the lockfile with `npm install --package-lock-only`.

### Verification
- Reproduced locally: yes
- Command: `osv-scanner scan source --recursive --no-ignore --format=json .` (before and after)
- Before: all 5 packages/version pairs above reported by osv-scanner with the listed GHSA IDs
- After: `osv-scanner` reports zero findings for these 5 packages; only `undici@5.29.0` (11 findings, needs a major-version bump — same "requires a malicious server" risk-acceptance rationale your team already applied to `GHSA-g9mf-h72j-4rw9` in `osv-scanner.toml`) and `uuid@3.4.0`/`8.3.2` (1 moderate finding each, fix requires a major-version bump past the pinned `^8.3.2` range) remain, left out of scope here as breaking-change bumps
- Environment: npm 10.9.8, Node 22.23.2 (repo's own `action.yml` targets `node24`)

Detected by [osv-scanner](https://google.github.io/osv-scanner/). No code changes outside `package.json`/`package-lock.json`.

Note: this repo already has three open Dependabot PRs (#557, #610, #633) targeting older, now-superseded versions of `brace-expansion`, `js-yaml`, and `fast-xml-parser` that predate these CVE disclosures and would not fix them even if merged as-is; this PR supersedes those three for the packages it touches.
