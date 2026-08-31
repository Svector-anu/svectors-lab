*web3 developer tooling — 2026-08-31*

_TL;DR: three infrastructure cutoffs land today; migrate Degen RPCs, Kaia subgraphs, and Bob Wallet SPV clients now._

1. *Move Degen workloads off Alchemy before support ends today*
   Alchemy ends `degen-mainnet` support on August 31 as Degen Chain winds down. Move RPC-dependent apps and bridge remaining assets before the endpoint disappears.
   Why it matters: production calls and stranded assets are at immediate risk.
   https://www.alchemy.com/docs/changelog

2. *Replace The Graph for Kaia subgraphs today*
   The Graph ends Kaia support on August 31; Kaia subgraphs will stop indexing and their query endpoints will stop returning data. Kaia points builders to alternative indexers including Goldsky.
   Why it matters: unfixed data layers can make Kaia apps stale or unavailable.
   https://blog.kaia.io/kaia-support-sunsetting-on-the-graph-migration-guide/

3. *Upgrade Bob Wallet before its old SPV helper winds down*
   Bob Wallet expects its former SPV helper to wind down around August 31. Bob LearnHNS 2.3.0 migrates the default to `https://spv.learnhns.com/hsd`; custom-helper and full-node users are unaffected.
   Why it matters: older default-SPV installs may stop synchronizing reliably.
   https://bobwallet.org/blog/spv-service-transition-bobwallet-org/
