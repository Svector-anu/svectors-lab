import json, urllib.request
base = '/home/runner/work/svectors-lab/svectors-lab/AI-Infra-Guard/'
queries = []
meta = []
seen = set()
with open(base + 'go.sum') as f:
    for line in f:
        parts = line.split()
        if len(parts) >= 2:
            mod, ver = parts[0], parts[1]
            if ver.endswith('/go.mod'):
                continue
            ver = ver.split('/')[0]
            key = (mod, ver)
            if key in seen:
                continue
            seen.add(key)
            queries.append({"package": {"ecosystem": "Go", "name": mod}, "version": ver})
            meta.append(("Go", mod, ver))
print("go modules:", len(queries))


def batch(qs):
    data = json.dumps({"queries": qs}).encode()
    req = urllib.request.Request("https://api.osv.dev/v1/querybatch", data=data,
                                 headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.load(r)


out = []
for i in range(0, len(queries), 200):
    chunk = queries[i:i + 200]
    res = batch(chunk)
    for m, rr in zip(meta[i:i + 200], res.get("results", [])):
        vulns = rr.get("vulns", [])
        if vulns:
            out.append((m, [v["id"] for v in vulns]))
print("HITS:", len(out))
for m, ids in out:
    print(m[1], m[2], "->", ",".join(ids))
