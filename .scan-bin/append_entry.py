import json
p = "memory/vuln-scanned.json"
data = json.load(open(p))
notes = (
    "User-directed target (var=vercel-labs/fx). Vercel's 'fx' Unix-like coding agent written in Zig "
    "(2080 stars, Apache-2.0, ~400 .zig files). PVR disabled AND no SECURITY.md -> no safe channel for "
    "code flaws anyway (moot: nothing found). Dependency surface clean: build.zig.zon has zero third-party "
    "Zig deps (empty dependencies table); only npm manifest is sdk/node with one devDep @xterm/headless@6.0.0 "
    "-> OSV API query returned empty (no vulns). osv=via OSV batch API (scanner binary exec denied this "
    "session, same as 2026-08-22 turbovec run); semgrep/slither n/a (Zig unsupported); trufflehog=manual "
    "grep, 0 hardcoded secrets in src/sdk/scripts. Manual review focused on crown-jewel untrusted-input "
    "surfaces for a coding agent: (1) command admission/auto-run planner command_effect.zig -- whitelist "
    "design, re-tokenizes and rebuilds canonical argv from a strict per-command flag allowlist "
    "(printf/pwd/ls/wc/cat/head/tail/grep/git only), forces absolute exes, sanitized env, hardened git "
    "prelude core.hooksPath=/dev/null + git_read_only profile, printf format-string validated to %s/%%/newline "
    "with exact arg count, rejects all dynamic shell/redirect/operator/env-assign, unknown->approval; "
    "(2) command_lex.zig/command_classification.zig -- careful fail-closed shell lexer with quote/escape "
    "state, wrapper-strip for env/nice/timeout, extensive tests; (3) auto_classifier.zig -- LLM last-chance "
    "permission reviewer with strict trust boundary (only canonical root requests authorize; "
    "assistant/tool/repo text untrusted), XML-escaping of review data, secret masking before send, strict "
    "output schema; (4) url_policy.zig SSRF -- blocks all private/reserved IPv4 CIDRs + IPv4-mapped IPv6 + "
    "metadata.google.internal/.internal/.local/localhost, rejects credentialed URLs/single-label "
    "hosts/ambiguous octal-hex IPv4/scope-ids/percent-encoded+unicode hosts; (5) http_fetch.zig -- CLOSES "
    "DNS-rebinding: re-validates every resolved DNS address via isPublicAddress and pins admitted addresses "
    "(no resolve/connect TOCTOU), careful HTTP head parsing with framing-smuggling defenses (rejects TE+CL, "
    "dup CL mismatch), 10MB body cap, redirect protocol/port pinning. ~5 candidate surface classes reviewed, "
    "0 confirmed exploitable. Repo ships exhaustive adversarial test suites inline. Scope-honest: manual "
    "review of highest-value surfaces, not exhaustive over all ~400 files."
)
data.append({
    "repo": "vercel-labs/fx",
    "scanned_at": "2026-08-22T23:20:00Z",
    "findings": 0,
    "channel": "clean",
    "notes": notes,
})
json.dump(data, open(p, "w"), indent=1)
print("appended; total entries:", len(data))
