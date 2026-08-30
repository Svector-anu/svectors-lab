*web3 developer tooling — 2026-08-30*

_TL;DR: Radix builders need to rebuild Stokenet state after yesterday's wipe, while Stellar operators have a September 9 validator deadline ahead of Protocol 28._

_Quiet news day: only two items cleared the recency, primary-source, and dedup filters._

1. *Rebuild Radix Stokenet deployments after the August 29 wipe*
   Radix Stokenet packages, components, balances, dApp metadata, and wallet personas were erased in the scheduled reset. Network IDs, gateway URLs, well-known addresses, and key-derived account addresses remain unchanged, but test deployments must be recreated and refunded.
   Why it matters: CI fixtures and staging environments can fail until their on-ledger state is rebuilt
   https://radix.wiki/developers/radix-developer-resources

2. *Prepare Stellar infrastructure for the Protocol 28 mainnet vote*
   Stellar's Protocol 28 builds are available across Core, Horizon, RPC, Galexie, and SDKs. Validators must upgrade and arm by September 9; raw-ledger consumers also need to handle CAP-83's empty-transaction-set value before the September 16 vote.
   Why it matters: validators have a ten-day operational deadline, and custom indexers may need a schema-path change
   https://stellar.org/blog/developers/adapter-protocol-28-upgrade-guide
