*web3 developer tooling — 2026-08-29*

_TL;DR: Base apps need a production RPC and explicit wallet-account boundaries; Arc, Compass, and Astar shipped or scheduled concrete builder surfaces._

1. *Do not ship a Base consumer app on the public RPC*
   Base labels its public mainnet and Flashblocks endpoints rate-limited and not for production. For the embedded-wallet stack from the architecture brief, keep Privy at the auth/signing boundary, put a dedicated RPC behind a provider abstraction, and test failover before adding sponsored gas.
   Why it matters: prevents an onboarding win from becoming an availability dependency
   https://docs.base.org/base-chain/quickstart/connecting-to-base

2. *Prepare Arc testnet nodes for the September 3 hardfork*
   Arc testnet v0.8.0 activates September 3 at 15:00 UTC; RPC operators are scheduling arc-node v0.8.0 upgrades ahead of it. Update test infrastructure and re-run integration checks before the activation window.
   Why it matters: stale testnet infrastructure can stop tracking the network
   https://community.arc.io/public/blogs/arc-testnet-v080-hardfork-2026-08-28

3. *Compass makes WisdomTree's WTGXX callable on Sepolia*
   Compass shipped a working testnet flow that prepares a WTGXX transaction for user-wallet approval without taking custody. Mainnet access is not live yet and remains subject to eligibility and KYB.
   Why it matters: wallets and fintechs can prototype regulated RWA flows without rebuilding the transaction layer
   https://www.compasslabs.ai/blog/compass-labs-x-wisdomtree-bringing-real-world-assets-into-the-products-people-already-use

4. *Aradia opens its Astar developer portal and interactive API docs*
   The new portal lets builders inspect API docs, send live requests, connect a wallet, and monitor usage. The team says the indexer and data coverage are still being improved, so treat it as an integration-evaluation surface.
   Why it matters: Astar data integrations can now be tested before committing engineering time
   https://forum.astar.network/t/aradia-staking-report/9591/2

*Also worth a glance:* Base's SDK supports explicit sub-account creation, owner accounts, funding modes, and per-chain paymaster URLs—use those controls only after custody, recovery, and sponsorship limits are defined: https://docs.base.org/base-account/reference/core/createBaseAccount
