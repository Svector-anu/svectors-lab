import json
path = "/home/runner/work/svectors-lab/svectors-lab/memory/vuln-scanned.json"
with open(path) as f:
    data = json.load(f)
data.append({
    "repo": "NeoSoul-AI/evoevo-agent-kit",
    "scanned_at": "2026-09-09T09:30:00Z",
    "findings": 0,
    "channel": "clean",
    "notes": "Forced target via var=NeoSoul-AI/evoevo-agent-kit (bare owner/repo -> Arm A scan). 0 stars, Python+TypeScript, reference client/SDK kit for the EvoEvo/OpenClaw ERC-8004 prediction-agent platform (Python polling client + strategy adapters, viem-based TS SDK for on-chain agent register/bind/reputation-feedback, a small wallet-connected demo frontend, one Postgres schema file). Audited commit eb599a9a8b0e32696a6dc4591e16a51a02964040. semgrep=ok (4 hits: 1 Dockerfile missing-USER hardening note on a demo-only client image with no exposed network service, 3x dynamic-urllib-use-detected on outbound HTTP calls whose URLs come from operator-set env vars, not remote/attacker input -- all reviewed and dismissed, none reachable from untrusted input). trufflehog=fail (only packaged as .tar.gz upstream, no raw single-binary release asset, and `tar` is not on the in-run capability allowlist -- could not stage; supplemented with a manual regex sweep for common secret patterns, 0 hits, not a substitute for a verified trufflehog pass). osv=none (package.json present in frontend-sdk/examples but no committed lockfile -- nothing for a lockfile-based scanner to read). agentic (N=15 budget, 8 source files, all reviewed)=ok: reference_client.py's subprocess strategy-command hook takes its command from an operator env var, not network input; the frontend demo builds all DOM content via textContent/property assignment (no innerHTML with dynamic data), validates address/URL/numeric fields before use, and blocks self-feedback; the TS SDK checksums every address via viem's getAddress and does no unvalidated interpolation. No entrypoint took externally-controlled input to a dangerous sink. Clean audit, 0 confirmed. SECURITY.md exists but names no explicit contact (just 'report privately'); PVR disabled -- moot since nothing to disclose."
})
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
print("appended, total entries:", len(data))
