import json

path = "memory/vuln-scanned.json"
d = json.load(open(path))

notes = (
    "Forced target via var=hashicorp/vault. 36,222 stars, Go, HashiCorp's secrets-management/identity-broker product -- "
    "mature, security-critical, actively bug-bountied on HackerOne with a dedicated internal security team and published "
    "third-party audits (Trail of Bits, NCC Group, Cure53). No repo-level SECURITY.md and PVR disabled at the repo level, "
    "but confirmed a usable out-of-band channel before forking: org-level hashicorp/.github/SECURITY.md and the repo README "
    "both designate security@hashicorp.com for vulnerability reports -- not used this run since 0 confirmed HIGH/CRITICAL "
    "code findings. semgrep: 8,011 raw hits, 0 survive triage -- 7,746 generic.html-templates unquoted-attribute-var hits "
    "are systemic false positives from a rule that doesn't understand Ember Handlebars component-argument syntax "
    "(component-arg passing like onClose is safe, not raw HTML attribute interpolation) across ui/app/**.hbs; "
    "7 string-formatted-query hits (physical/cockroachdb, mssql, mysql) build CREATE TABLE statements from operator-supplied "
    "storage-backend config (database/table/lock_table set in the Vault server config file), not remote/attacker input -- "
    "same trust boundary as every other physical-backend driver; 3 unsafe-deserialization-interface hits are standard Go "
    "json.Unmarshal into interface{} (api/sys_raft.go, builtin/logical/aws/iam_policies.go, physical/raft/raft_autopilot.go), "
    "not vulnerable the way e.g. Java ObjectInputStream or Python pickle are; 20 detected-private-key hits are all in "
    "test-fixtures/ or vault/testing.go (test-only TLS material); 48 GitHub Actions run-shell-injection hits spot-checked -- "
    "the two genuinely PR-derived values (bob-review-approval-gate.yml, build.yml) both already pass HEAD_REF/BASE_REF through "
    "env: indirection per GitHub's documented mitigation (explicit inline comment citing the docs), and "
    "copy-external-contributor-pull-request-ce.yml only interpolates a numeric PR number behind a manual deployment-approval "
    "gate; remaining unsafe-block/math-random/missing-ssl-minversion/weak-crypto hits are internal crypto/FFI code, not "
    "attacker-reachable auth or transport paths. trufflehog: 0 verified secrets (filesystem scan: 52,084 chunks/547MB; "
    "full git-history scan: 865,818 chunks/918MB, completed in 84s, no timeout). osv-scanner: 178 dependency vulnerability "
    "entries (85 unique GHSA/CVE ids, 42 critical/high) across go.mod (root + 8 api/auth/* submodules + sdk + hcp_link/proto) "
    "and ui/pnpm-lock.yaml -- almost entirely UI frontend build-tooling deps (xmldom, browserslist, postcss, js-yaml, nanoid, "
    "socket.io-parser, fast-uri, brace-expansion, shell-quote, immutable, jsondiffpatch, linkify-it, websocket-driver) plus "
    "Go grpc/docker/moby; spot-checked prior art and confirmed an extremely active first-party Dependabot already covers this "
    "exact class (e.g. grpc already bumped past our found 1.79.3 to 1.82.1+ in merged PR #32048, xmldom bumped in #31869, "
    "docker/docker bumped repeatedly through #31821/#31496) -- all duplicate-skipped rather than filed, consistent with prior "
    "audits of similarly Dependabot-active repos (parse-server, hono, Shopify/cli). Agentic review (N=6 budget, 2,372 "
    "non-vendor .go files): threat-modeled around ACL/policy bypass, auth-method login bypass, and SSRF/injection into the "
    "unseal/audit/replication path as the highest-value goals; deep-reviewed vault/acl.go AllowOperation + "
    "resolveACLPermsForListOp (LIST deny-precedence logic matches historical VAULT-3825 fix intent), token_store.go "
    "handleCreateCommon (child-token policy-subset check holds via StrListSubset), the OAuth-JWT unauthenticated fast path in "
    "request_handling.go (dead code in CE -- IsOAuthJwt hardcoded false), DR-secondary unauthenticated raft paths in "
    "logical_system.go (gated behind a replication state bit CE never sets), identity_store_oidc_provider.go's OIDC token "
    "issuance (provider name constrained by GenericNameRegex before reaching the policy template, no injection surface), and "
    "approle path_login.go's CIDR/use-count lock-switch handling (re-validates after re-acquiring the write lock, no obvious "
    "TOCTOU). Not deep-reviewed: userpass/cert/aws credential path_login.go, logical_system.go handleWrappingUnwrap, "
    "http/handler.go CORS/header handling. Net: clean audit, 0 confirmed."
)

d.append({
    "repo": "hashicorp/vault",
    "scanned_at": "2026-09-10T23:45:00Z",
    "findings": 0,
    "channel": "clean",
    "notes": notes
})

with open(path, "w") as f:
    json.dump(d, f, indent=2)
    f.write("\n")

print("appended, new total:", len(d))
