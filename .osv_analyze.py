import json
d = json.load(open('/tmp/vuln-scan/osv.json'))
results = d.get('results', [])
total = 0
crit = []
high = []
for r in results:
    for pkg in r.get('packages', []):
        for v in pkg.get('vulnerabilities', []):
            total += 1
            sev_label = v.get('database_specific', {}).get('severity')
            entry = (r.get('source', {}).get('path'), pkg.get('package', {}).get('name'), pkg.get('package', {}).get('version'), v.get('id'), sev_label)
            if sev_label == 'CRITICAL':
                crit.append(entry)
            elif sev_label == 'HIGH':
                high.append(entry)
print('total vuln rows:', total)
print('CRITICAL:', len(crit))
print('HIGH:', len(high))
for e in crit[:30]:
    print('CRIT', e)
for e in high[:30]:
    print('HIGH', e)
