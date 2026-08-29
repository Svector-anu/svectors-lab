*web3 developer tooling — 2026-08-29*

_TL;DR: Base apps need a production RPC and explicit wallet-account boundaries; Arc, Compass, and Astar shipped or scheduled concrete builder surfaces._

1. *Do not ship a Base consumer app on the public RPC*  
   Base labels its public endpoints rate-limited and unsuitable for production. Keep Privy at the auth/signing boundary, use a dedicated RPC behind a provider abstraction, and test failover before adding sponsored gas.  
   Why it matters: prevents an onboarding win from becoming an availability dependency  
   https://docs.base.org/base-chain/quickstart/connecting-to-base

2. *Prepare Arc testnet nodes for the September 3 hardfork*  
   Arc testnet v0.8.0 activates September 3 at 15:00 UTC. Update test infrastructure and rerun integration checks before activation.  
   Why it matters: stale testnet infrastructure can stop tracking the network  
   https://community.arc.io/public/blogs/arc-testnet-v080-hardfork-2026-08-28

3. *Compass makes WisdomTree’s WTGXX callable on Sepolia*  
   Compass shipped a testnet flow that prepares WTGXX transactions for user-wallet approval without taking custody. Mainnet access remains subject to availability, eligibility, and KYB.  
   Why it matters: wallets and fintechs can prototype regulated RWA flows without rebuilding the transaction layer  
   https://www.compasslabs.ai/blog/compass-labs-x-wisdomtree-bringing-real-world-assets-into-the-products-people-already-use

4. *Aradia opens its Astar developer portal and interactive API docs*  
   Builders can inspect the API, send requests, connect wallets, and monitor usage. Its indexer and data coverage are still being improved.  
   Why it matters: Astar integrations can now be evaluated before committing engineering time  
   https://forum.astar.network/t/aradia-staking-report/9591/2

*Also worth a glance:* Base’s SDK exposes sub-account ownership, funding modes, and per-chain paymaster URLs. Use those controls only after custody, recovery, and sponsorship limits are defined: https://docs.base.org/base-account/reference/core/createBaseAccount

## Summary

- Created [the digest](/home/runner/work/svectors-lab/svectors-lab/output/digest-2026-08-29-web3-developer-tooling.md).
- Updated `memory/MEMORY.md` and today’s digest log.
- Reused the RightStack chain context without rerunning it.
- Notification delivery was attempted, but Aeon’s external queues were read-only in this harness.
