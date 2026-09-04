import json

path = 'memory/vuln-scanned.json'
with open(path) as f:
    data = json.load(f)

entry = {
    "repo": "parse-community/parse-server",
    "scanned_at": "2026-09-04T07:45:00Z",
    "findings": 0,
    "channel": "duplicate-skipped",
    "notes": "JS repo, 21.4k stars, PVR enabled + SECURITY.md present. Audited commit f7ab647. Scanners: semgrep=ok (75 hits: 72 GH-Actions mutable-action-tag hardening warnings not code vulns, 3 code findings all triaged false-positive -- GridFSBucketAdapter.js:168 createCipheriv('aes-256-gcm') omits explicit authTagLength but Node defaults to the secure 16-byte tag, not attacker-reachable; middlewares.js:412 CORS handler only ever reflects an operator-configured allowlisted origin or falls back to the configured default, no Access-Control-Allow-Credentials set anywhere in the codebase; password.js:33 'bcrypt hash' is an intentional dummy hash used for timing-attack/enumeration normalization, not a leaked credential), trufflehog=ok (0 verified secrets, filesystem + full git history), osv=ok (55 vulnerable packages in package-lock.json, only 2 are direct prod deps (semver, ws) rest transitive/devDependencies; spot-checked 11 of the highest-signal packages (semver, ws, tar, protobufjs, qs, browserslist, @humanfs/node, undici, postcss, ip-address, body-parser) against the target's own PR history -- Dependabot (746 total PRs on this repo) already has open or recently-closed bump PRs for every one checked, so the whole dependency batch is duplicate-skipped rather than filed), fuzz=skipped (JS repo, no cargo-fuzz harness in scope), agentic=ok (N=10 budget, reviewed auth/master-key gating in RestQuery.js, CORS trust boundary, password hashing, GraphQL schema-disclosure hardening in ParseGraphQLServer.js -- 0 candidates, all already correctly gated). Clean audit, 0 confirmed. No PVR/PR filed this run."
}

data.append(entry)

with open(path, 'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')

print('appended, new length:', len(data))
