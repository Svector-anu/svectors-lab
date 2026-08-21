import json, datetime
now = "2026-08-21T10:00:00Z"
cutoff = datetime.datetime(2026, 7, 22)
resp = json.load(open('.hunter22-resp.json'))
seen = json.load(open('memory/topics/hunter-22-seen.json'))
run = {}
for m in resp['matches']:
    run[m['id']] = {"id": m['id'], "title": m['title'],
                    "reward": round(m['rewardUsd'], 2), "seen_at": now}
by_id = {}
for e in seen:
    by_id[e['id']] = e
for i, e in run.items():
    by_id[i] = e
def keep(e):
    try:
        d = datetime.datetime.strptime(e['seen_at'][:10], "%Y-%m-%d")
        return d >= cutoff
    except Exception:
        return True
merged = [e for e in by_id.values() if keep(e)]
json.dump(merged, open('memory/topics/hunter-22-seen.json', 'w'), indent=2)
print("total entries:", len(merged), "| this-run ids:", len(run))
