import json, urllib.request

ids = {
    "x/net": ["GHSA-5cv4-jp36-h3mw", "GO-2026-4440", "GO-2026-4441", "GO-2026-4918",
              "GO-2026-5025", "GO-2026-5026", "GO-2026-5027", "GO-2026-5028",
              "GO-2026-5029", "GO-2026-5030", "GO-2026-5942"],
    "x/text": ["GO-2026-5970"],
}


def fetch(vid):
    with urllib.request.urlopen("https://api.osv.dev/v1/vulns/" + vid, timeout=30) as r:
        return json.load(r)


for grp, lst in ids.items():
    print("====", grp, "====")
    for vid in lst:
        try:
            d = fetch(vid)
        except Exception as e:
            print(vid, "ERR", e)
            continue
        summ = d.get("summary", "")
        sev = ""
        for s in d.get("severity", []):
            sev += s.get("type", "") + "=" + s.get("score", "") + " "
        pkgs = set()
        fixed = set()
        introduced = set()
        for a in d.get("affected", []):
            p = a.get("package", {}).get("name", "")
            pkgs.add(p)
            for rng in a.get("ranges", []):
                for ev in rng.get("events", []):
                    if "fixed" in ev:
                        fixed.add(ev["fixed"])
                    if "introduced" in ev:
                        introduced.add(ev["introduced"])
            # ecosystem_specific imports
            for imp in a.get("ecosystem_specific", {}).get("imports", []):
                pkgs.add("import:" + imp.get("path", ""))
        print(vid, "|", summ[:90])
        print("   sev:", sev.strip(), "| fixed:", sorted(fixed), "| pkgs:", sorted(pkgs)[:6])
