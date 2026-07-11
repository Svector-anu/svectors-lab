import json
with open('/home/runner/work/skopos-aeon/skopos-aeon/.tmp/pools.json') as f:
    data = json.load(f)

pools = data.get('data', [])

real_yield = []
incentive_yield = []

for p in pools:
    tvl = p.get('tvlUsd') or 0
    apy = p.get('apy') or 0
    apy_base = p.get('apyBase') or 0
    apy_reward = p.get('apyReward') or 0
    outlier = p.get('outlier', False)
    apy_mean30 = p.get('apyMean30d') or 0
    confidence = (p.get('predictions') or {}).get('binnedConfidence') or 0

    if (apy_base > 0 and not outlier and tvl >= 10e6 and confidence >= 2 and apy_mean30 >= apy * 0.5):
        reward_share = apy_reward / apy if apy > 0 else 0
        if reward_share < 0.5:
            real_yield.append({
                'name': p.get('symbol', '?'),
                'project': p.get('project', '?'),
                'chain': p.get('chain', '?'),
                'apy_base': apy_base,
                'apy': apy,
                'tvl': tvl,
            })

    if (apy_reward > 0 and not outlier and tvl >= 25e6):
        rts = p.get('rewardTokens') or ['?']
        reward_token = rts[0] if rts else '?'
        incentive_yield.append({
            'name': p.get('symbol', '?'),
            'project': p.get('project', '?'),
            'chain': p.get('chain', '?'),
            'apy': apy,
            'apy_reward': apy_reward,
            'tvl': tvl,
            'reward_token': reward_token,
        })

real_yield.sort(key=lambda x: x['apy_base'], reverse=True)
incentive_yield.sort(key=lambda x: x['apy'], reverse=True)

print("Real yield top 5:")
for p in real_yield[:5]:
    print(f"  {p['name']} ({p['project']}, {p['chain']}): apyBase={p['apy_base']:.2f}% TVL=${p['tvl']/1e6:.0f}M")

print("\nIncentive yield top 3:")
for p in incentive_yield[:3]:
    print(f"  {p['name']} ({p['project']}, {p['chain']}): apy={p['apy']:.2f}% TVL=${p['tvl']/1e6:.0f}M reward={p['reward_token']}")
