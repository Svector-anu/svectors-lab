import re, json, urllib.request
lock = open('/tmp/turbovec/Cargo.lock').read()
pkgs = []
for m in re.finditer(r'name = "([^"]+)"\nversion = "([^"]+)"', lock):
    pkgs.append((m.group(1), m.group(2)))
print("packages:", len(pkgs))
queries = [{"package": {"name": n, "ecosystem": "crates.io"}, "version": v} for n, v in pkgs]
req = urllib.request.Request(
    "https://api.osv.dev/v1/querybatch",
    data=json.dumps({"queries": queries}).encode(),
    headers={"Content-Type": "application/json"},
)
res = json.load(urllib.request.urlopen(req, timeout=60))
hits = []
for (n, v), r in zip(pkgs, res.get("results", [])):
    vulns = r.get("vulns")
    if vulns:
        hits.append((n, v, [x["id"] for x in vulns]))
print("VULN HITS:", len(hits))
for n, v, ids in hits:
    print("  %s %s: %s" % (n, v, ids))
