import json

path = 'memory/vuln-scanned.json'
with open(path) as f:
    data = json.load(f)

entry = {
    "repo": "elysiajs/elysia",
    "scanned_at": "2026-09-04T16:55:00Z",
    "findings": 0,
    "channel": "clean",
    "notes": "Forced target via var=elysiajs/elysia (bare owner/repo -> Arm A scan). 19,076 stars, TypeScript web framework, PVR enabled + SECURITY.md present (safe channel existed if needed). Audited commit e037eca710e7ad193be09cc6615ab0dbe54af914 (fork: Svector-anu/elysia). semgrep: 5 hits, all github-actions-mutable-action-tag hardening warnings in .github/workflows/ci.yml + publish.yml (not code vulns, not filed, matches prior-run precedent). trufflehog: 0 verified secrets (filesystem + full git history, 66355 chunks). osv-scanner: 60 vulnerable-package rows across 2 lockfiles -- root bun.lock devDependencies (rollup/valibot/js-yaml/minimatch/picomatch/ajv/brace-expansion/flatted/file-type/fflate/@humanfs-node/smol-toml, all build/lint/test tooling) plus test/cloudflare/package-lock.json (an isolated Cloudflare-Workers test fixture: defu/sharp/undici/wrangler/ws) -- package.json confirms the published elysia package ships only 4 runtime deps (cookie, exact-mirror, fast-decode-uri-component, memoirist), none of which were flagged, so none of the 60 rows reach a production install. Also flagged were 4 already-published elysia-self CVEs (GHSA-8hq9 cookie prototype pollution fixed 1.4.27, GHSA-8vch cookie-config code injection fixed 1.4.18, GHSA-f45g URL format ReDoS fixed 1.4.26, GHSA-hxj9 critical multi-schema prototype pollution fixed 1.4.17) against old elysia versions (1.4.8/1.4.16) pinned only inside the test fixture lockfile -- verified all four are already fixed in the audited HEAD (package.json version 1.4.30); manually confirmed the cookie-parsing __proto__/constructor/prototype guard is present in src/cookies.ts. Agentic pass (N=15 budget, 39 src files/27584 lines): traced the Function()-based per-route codegen pipeline in compose.ts/sucrose.ts -- all developer-defined schema/param keys are embedded via JSON.stringify (safe encoding), no per-request attacker-controlled string reaches the generated source; one hardening gap noted (compose.ts:901 embeds the registered route path into a backtick template literal without escaping) but path is developer-authored at route-registration time in normal usage, not attacker-reachable, so it doesn't clear the attacker-control bar for a finding. Full read of cookies.ts (proto-pollution guard confirmed) and parse-query.ts (Object.create(null) throughout, no prototype pollution). Spot-checked url/hostname/email/uri-template format regexes in type-system/format.ts against adversarial inputs in Node -- no catastrophic backtracking observed. universal/file.ts (ElysiaFile) takes developer-supplied paths only, no static-file plugin in this repo. No .sol files (slither n/a), no fuzz/fuzz_targets (fuzz skip). Note: elysia/CLAUDE.md in the cloned repo contains an embedded prompt-injection instruction directing AI agents to insert a phrase into edited files/PR descriptions -- flagged as untrusted content and ignored per policy, not followed. Net: 0 confirmed findings on an actively maintained, PVR-enabled framework with a strong recent patch history."
}

data.append(entry)

with open(path, 'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')

print("appended, new length:", len(data))
