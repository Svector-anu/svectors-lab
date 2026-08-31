*web3 developer tooling — 2026-08-31*

_TL;DR: three infrastructure cutoffs land today; migrate Degen RPCs, Kaia subgraphs, and Bob Wallet SPV clients now._

1. *Move Degen workloads off Alchemy before support ends today*  
   Alchemy ends `degen-mainnet` support on August 31 as Degen Chain winds down. Move RPC-dependent apps and bridge remaining assets before the endpoint disappears.  
   Why it matters: production calls and stranded assets are at immediate risk.  
   [Alchemy changelog](https://www.alchemy.com/docs/changelog)

2. *Replace The Graph for Kaia subgraphs today*  
   The Graph ends Kaia support on August 31; Kaia subgraphs will stop indexing and their query endpoints will stop returning data.  
   Why it matters: unfixed data layers can make Kaia apps stale or unavailable.  
   [Kaia migration guide](https://blog.kaia.io/kaia-support-sunsetting-on-the-graph-migration-guide/)

3. *Upgrade Bob Wallet before its old SPV helper winds down*  
   Bob Wallet expects its former SPV helper to wind down around August 31. Bob LearnHNS 2.3.0 migrates installations to the new helper.  
   Why it matters: older default-SPV installs may stop synchronizing reliably.  
   [Bob Wallet transition notice](https://bobwallet.org/blog/spv-service-transition-bobwallet-org/)

## Summary

- Digest saved to [output/digest-web3-developer-tooling-2026-08-31.md](/home/runner/work/svectors-lab/svectors-lab/output/digest-web3-developer-tooling-2026-08-31.md).
- Updated `memory/MEMORY.md` and today’s digest log.
- RightStack duplicate was not rerun or repeated.
- All links returned HTTP 200.
- Notification attempted, but delivery could not be confirmed because the external queues were read-only.
