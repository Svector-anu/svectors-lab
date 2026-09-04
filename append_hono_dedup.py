import json

path = 'memory/vuln-scanned.json'
with open(path) as f:
    data = json.load(f)

entry = {
    "repo": "honojs/hono",
    "scanned_at": "2026-09-04T11:50:00Z",
    "findings": 0,
    "channel": "clean",
    "notes": (
        "Forced target via var=honojs/hono (bare owner/repo -> Arm A scan). 32.1k stars, "
        "TypeScript, PVR enabled (no SECURITY.md, but PVR confirmed via API), active (pushed "
        "2026-08-28). Audited commit e2740d5a1bd0b4254e517e3af8b60789284bc7bd. semgrep: 4 raw "
        "hits -- 3 in benchmarks/http-server/benchmark.ts (bench/ dir, dropped per triage rule), "
        "1 in src/jsx/components.ts:234 flagged as 'unknown value used with script tag' but "
        "traced dataflow: only a monotonic internal counter (errorBoundaryCounter) is "
        "interpolated into the <script> block, not the flagged 'callbacks' array or rendered "
        "content -- false positive, dropped. trufflehog: 0 verified secrets (filesystem + full "
        "git history). osv-scanner: 43 vulnerable-package rows across 4 lockfiles (root bun.lock "
        "devDependencies -- vite/rollup/eslint-toolchain -- plus 3 benchmarks/* lockfiles "
        "comparing hono against other frameworks, including stale hono 3.10.4/4.12.18 pulled in "
        "only as benchmark comparison targets) -- confirmed via package.json that the published "
        "hono package ships zero runtime dependencies and zero peerDependencies, so none of "
        "these 43 rows reach a consumer's production install; all non-issues, nothing filed. "
        "Agentic pass (N=10 budget for 361-file repo, ~5 entrypoints deep-reviewed): serve-static "
        "(path.ts + index.ts) has an explicit pre-join regex guard rejecting any '..'/'.'/"
        "double-slash/backslash path segment before filesystem join -- traversal-safe; JWT "
        "verify() (utils/jwt/jwt.ts, jwa.ts) enforces exact alg match against caller-supplied "
        "expected alg, AlgorithmTypes enum has no 'none' entry (no alg-none bypass), "
        "verifyWithJwks explicitly rejects symmetric algorithms and cross-checks JWK alg vs "
        "header alg (documented algorithm-confusion mitigation); proxy helper is an intentional "
        "fetch passthrough (SSRF is inherent to the feature and target-URL choice is "
        "developer-controlled, not a framework flaw). router/cors/basic-auth/csrf/secure-headers "
        "noted reviewed-but-not-deep within budget. Net: 0 confirmed findings on a mature, "
        "zero-dependency, heavily-scrutinized framework."
    ),
}

data.append(entry)

with open(path, 'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')

print("appended, new length:", len(data))
