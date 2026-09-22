## Crypto — 2026-09-22 — risk-on (conviction high) | DeFi Mixed: TVL up steadily, volume and stables flat

**Take:** risk-on — BTC $86,496 (+6.39% 24h) with 17/20 top-cap breadth and Fear & Greed at 78 (**Extreme Greed**, up from 70). Conviction: high — breadth, F&G, and 7d TVL (+8.78%) all confirm; only BTC dominance disagrees (flat at 58.91%, no clean alt-rotation signal). Evidence: DEX 24h volume is flat at $9.29B — unchanged from yesterday's snapshot despite the price extension, a mild divergence worth watching.

*TVL:* $618.3B protocol-tracked (+4.32% 24h, +8.78% 7d)

*Top chains*
1. Ethereum — $62.3B (+3.5% 1d)
2. Bitcoin — $23.6B (+6.2% 1d)
3. Solana — $15.1B (+6.4% 1d)

*Movers*
↑ Bittensor (chain TVL) +16.2% ($550M → $639M) — TAO is CoinGecko's top trending coin (+19.1%), dTAO/Chutes/wTAO/Tensorplex all +14-17% TVL
↑ Unit (Bridge) +28.1% ($817M → $1.05B) — BTC-bridging demand, third straight day of gains
↓ Polymarket International −11.0% ($378M → $337M) — looks like volume migrating to newly launched Polymarket US (fees there +35.9% 1d / +32.5% 7d)

*Fees leaders (24h)*
1. Tether — $17.04M (flat vs 7d avg)
2. Circle USDC — $6.95M (flat)
3. Polymarket US — $3.63M (+35.9% 1d)

*Fees beating TVL:* none cleared filter today — top fee-growth% names are near-zero-base outliers or TVL-untracked.

*DEX vol (24h):* $9.29B (+0.4%) — top: Uniswap V3 $2.01B, Uniswap V4 $1.55B, PancakeSwap V3 $0.73B

*Stables:* $312.15B (+0.4% 24h) — USDe the only single issuer to clear ±1% (+1.19%)

*Real yield (sustainable, ≥$10M, filtered — fee-driven volatile-pair LPs, material IL risk)*
• WSOL-USDC (Raydium, Solana) — 195.4% apyBase ($42M TVL)
• WETH-CBBTC (Uniswap V3, Base) — 71.4% apyBase ($12M TVL)
• ETH-USDT (Uniswap V4, Ethereum) — 59.7% apyBase ($31M TVL)

*Incentive yield (points/emissions, ≥$25M)*
• USDC-AERO (Aerodrome, Base) — 29.0% apy via $AERO ($36M TVL)
• SDCRV (Stake DAO, Ethereum) — 12.2% apy via $CRV/$FXN ($44M TVL)

*Macro:* BTC $86,496 (+6.4%) / ETH $2,772 (+4.4%) · F&G 78 (Extreme Greed) · breadth 17/20 · hot market: "Will Ethereum dip to $2,250 by Dec 31, 2026?" YES 24.5%

**What changed since yesterday:** F&G crossed into Extreme Greed for the first time this streak (70→78); BTC extended past $86K on a 7th straight positive session; HyperLend Pooled logged its third consecutive day past the -10% TVL filter (-10.96% today) with still no identified catalyst; Bittensor's rising narrative accelerated rather than stalled.

No tracked DeFi positions configured (`memory/on-chain-watches.yml` absent) — Positions facet logged `DEFI_MONITOR_NO_CONFIG`, no alert to report.

_sources: llama_tvl=ok llama_dex=ok llama_fees=ok llama_stables=ok llama_yields=ok coingecko=ok fng=ok polymarket=ok websearch=ok | var: none_

## Summary
- Ran combined defi-overview (empty var → Positions + Macro facets).
- Positions facet: no config (`memory/on-chain-watches.yml` missing) → `DEFI_MONITOR_NO_CONFIG`, skipped cleanly.
- Macro facet: fetched DeFiLlama (chains/protocols/dexs/fees/stables/pools), CoinGecko (price/markets/global/trending — keyless, no `COINGECKO_API_KEY` set), alternative.me F&G, Polymarket Gamma, and 2 WebSearches for macro catalysts. All sources returned ok.
- Regime call: risk-on, high conviction, driven by BTC +6.39%, 17/20 breadth, F&G 78 (Extreme Greed, first this streak), TVL +8.78% 7d.
- Files written: `memory/skills/defi-overview/market-context.md` (full rewrite, Token Picks table preserved + 1 new row appended: 2026-09-21 ZAMA $0.1010), `memory/logs/2026-09-22.md` (new file, defi-overview positions + macro log entries).
- Follow-up: no tracked positions configured — if the operator wants position-health monitoring, populate `memory/on-chain-watches.yml` with `type: pool`/`type: position` entries.
