Ran an automated dependency scan (osv-scanner) against this repo's `axios` pin and cross-checked against currently open work here.

This PR bumps `axios` 1.13.5 → 1.16.0, which does close several published advisories (including the HIGH `config.proxy` prototype-pollution MITM, GHSA-35jp-ww65-95wh / CVE-2026-44494). However, `axios@1.16.0` is still affected by a further set of published, fixed-upstream advisories that only land in 1.18.0:

- GHSA-42h9-826w-cgv3 / CVE-2026-67313 — excessive recursion in `formDataToJSON` (DoS), medium
- GHSA-pmv8-rq9r-6j72 / CVE-2026-67312 — deep `formToJSON` key recursion (DoS), medium
- GHSA-7q8q-rj6j-mhjq / CVE-2026-67319 — nested axios option objects can consume polluted prototype values, medium
- GHSA-jqh4-m9w3-8hp9 / CVE-2026-67317 — fetch adapter `ReadableStream` uploads bypass `maxBodyLength`, medium
- GHSA-mwf2-3pr3-8698 / CVE-2026-67318 — HTTP/2 streamed uploads bypass `maxBodyLength`, medium

### Verification
- Reproduced locally: no (advisory cross-reference only, not a fresh PoC — these are GitHub-reviewed advisories with GHSA/CVE IDs and a published fix range)
- Command: `osv-scanner scan source --recursive --no-ignore --format=json .` against this repo's `yarn.lock`, cross-checked with `gh api /advisories/<GHSA-id>`
- Before: `axios@1.13.5` (current) / `axios@1.16.0` (this PR) both affected by the 5 GHSAs above
- After: `axios@1.18.0`+ closes all of them
- Environment: osv-scanner 2.5.1, checked against axios GHSA fixed-version ranges as of 2026-09-10

Since this is the SDK's only runtime dependency (everything else in `yarn.lock` is dev-only), worth considering targeting the current latest (`1.20.0`) instead of `1.16.0` here, or a fast follow-up bump, so this doesn't need to be revisited piecemeal. No code changes needed beyond the version bump — happy to be wrong if any of these don't apply to how this SDK uses axios (no proxy config, no fetch adapter, no HTTP/2 usage, etc.).
