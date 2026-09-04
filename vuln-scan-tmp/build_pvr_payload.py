import json

with open('/home/runner/work/svectors-lab/svectors-lab/vuln-scan-tmp/pvr-body.md') as f:
    body = f.read()

payload = {
    "summary": "DOM XSS via remote bot names (avatar.tsx) + live Algolia key with broader-than-documented ACL",
    "description": body,
    "severity": "high",
    "cwe_ids": ["CWE-79", "CWE-798"],
    "vulnerabilities": [
        {"package": {"ecosystem": "npm", "name": "hermes-agent"}}
    ]
}

with open('/home/runner/work/svectors-lab/svectors-lab/vuln-scan-tmp/pvr.json', 'w') as f:
    json.dump(payload, f)

print("wrote payload, keys:", list(payload.keys()))
