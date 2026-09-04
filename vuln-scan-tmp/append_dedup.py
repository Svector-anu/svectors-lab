import json

path = '/home/runner/work/svectors-lab/svectors-lab/memory/vuln-scanned.json'
with open(path) as f:
    data = json.load(f)

entry = {
    "repo": "NousResearch/hermes-agent",
    "scanned_at": "2026-09-04T07:06:25Z",
    "findings": 2,
    "channel": "pvr",
    "notes": "Python/TS Electron desktop agent (~241k stars). Audited commit 6327930. Scanners: semgrep=ok (415 findings triaged, most false-positive: unverified-jwt-decode diagnostic-only, subprocess-injection false-match on argv-list uv calls, GH Actions run-shell-injection on non-attacker-controlled base_ref, dangerouslySetInnerHTML#1 DOMPurify-sanitized OK), trufflehog=ok (1 verified: live Algolia key with settings ACL beyond the code's own 'search-only' comment), osv=ok (dep CVEs across browserslist/nanoid/qs/sanitize-html/fast-uri/extract-zip/tornado/h2/idna/electron; all JS ones already covered by open upstream PRs #91906/#94262/#101446 -> duplicate-skipped, not filed), agentic=ok (N=6, found real HIGH: BotFace/blobMarkup JSON.stringify+string-concat HTML injection via remote group-chat bot name, breaks data-bot-face attribute scope into a live <img onerror> DOM element). PoC gate: verified via local-command (jsdom harness against the literal extracted expression). Filed PVR GHSA-qjq9-cgwp-r73h bundling both confirmed findings. Report: output/articles/vuln-scan-2026-09-04-hermes-agent.md"
}

data.append(entry)

with open(path, 'w') as f:
    json.dump(data, f, indent=2)
    f.write('\n')

print('appended, total entries:', len(data))
