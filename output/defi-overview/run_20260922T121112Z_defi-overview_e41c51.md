*Crypto — 2026-09-22* — risk-on, institutional-led (conviction high) | DeFi Mixed: TVL +1.2% and DEX volume holding +48% surge while stables sit flat

*TVL:* $613.3B protocol-tracked (+1.2% 24h, +9.7% 7d)

*Top chains* (canonical DeFiLlama chain TVL)
1. Ethereum — $54.3B (+1.6%)
2. Solana — $6.4B (+4.0%)
3. Base — $6.2B (+4.9%)

*Movers*
↑ Bittensor chain +16.2% ($532M→$618M) — TAO breakout day 3, decelerating (+13.5% trending vs +19.5% yesterday)
↑ Bittensor dTAO (protocol) +13.3% ($555M) — same TAO narrative, DEX-level confirmation
↓ none cleared the mover filter today

*Fees leaders (24h)*
1. Tether — $17.13M (+0.4% vs 7d avg)
2. Circle USDC — $7.00M (+0.9% vs 7d avg)
3. Hyperliquid Perps — $4.44M (+55.2% vs 7d avg)

*Fees beating TVL*
• Pendle V2 — fees +956.6% / TVL +4.8% (7d) — $1.31B TVL, 2nd straight session, divergence stable not fading
• Ethena USDe — fees +183.0% / TVL +4.6% (7d) — $4.90B TVL, new entrant to this screen

*DEX vol (24h):* $13.74B (+47.9%, holding this morning's surge flat) top: Uniswap V3 $1.68B, Uniswap V4 $1.63B, PancakeSwap AMM V3 $0.96B

*Stables:* $312.0B (+0.3%) — USDD +6.5% 1d ($1.51B) the sharpest single-issuer move for a 2nd session; RLUSD +2.7% ($2.44B)

*Real yield (sustainable, ≥$10M, filtered — volatile-pair LPs, material IL risk)*
• WSOL-USDC (Raydium, Solana) — 167.3% apyBase ($42.1M TVL)
• WETH-USDT (Uniswap V3, Ethereum) — 84.4% apyBase ($100.4M TVL)
• ETH-LINK (Uniswap V4, Ethereum) — 56.9% apyBase ($23.2M TVL)

*Incentive yield (points / emissions, ≥$25M)*
• USDC-AERO (Aerodrome, Base) — 29.0% apy via $AERO ($36.6M TVL)
• SDCRV (Stake DAO, Ethereum) — 12.2% apy via $CRV/$FXN ($42.7M TVL)

*Macro:* BTC $85,950 (+1.2%) / ETH $2,742.47 (+0.7%) · F&G 78 (Extreme Greed) · breadth 12/20 (down from 16/20 this morning) · hot market: "Will the Fed increase interest rates by 25 bps after the October 2026 meeting?" YES 49.5%

*Institutional catalyst:* spot BTC ETFs took in ~$1B on Sep 21 — largest single-day inflow in 11 months — alongside Strategy (+950 BTC, ~$76M) and Strive (+1,355 BTC, ~$108M) treasury buys, and >$648M in BTC shorts liquidated.

_sources: llama_tvl=ok llama_dex=ok llama_fees=ok llama_stables=ok llama_yields=ok coingecko=ok fng=ok polymarket=ok websearch=ok | var: none_

---

**Positions facet:** no protocols configured in `memory/on-chain-watches.yml` — DEFI_MONITOR_NO_CONFIG, skipped cleanly (not an error).

**What changed since this morning's refresh (06:46Z):** the standout is a new institutional-demand catalyst — spot BTC ETFs logged their largest single-day inflow in 11 months (~$1B) on Sep 21, plus concrete treasury buys (Strategy, Strive) and >$648M in short liquidations — while 24h breadth narrowed sharply (16/20 → 12/20 green) and total crypto mcap flipped to -1.69% 24h. Read: the rally is concentrating in BTC/majors on institutional flow rather than broadening across alts, even as DEX volume ($13.74B) and TVL 7d growth (+9.7%) both stay firm. Pendle V2's fee-outperformance divergence persists into a 2nd session; Ethena USDe is a new entrant to that same screen. HyperLend Pooled's TVL bleed has stalled (4th session not clearing the mover filter) rather than reversing.

**Note on chain-level TVL:** this run switched to DeFiLlama's canonical `/v2/chains` + `historicalChainTvl` figures for Top Chains/Chain Flow (Ethereum $54.3B, not the $61.7B figure this morning's snapshot carried) — the prior number appears to have come from a chain-aggregation method that double-counts overlapping protocol categories. This is a data-source correction, not a claimed 24h market move; the 1d/7d deltas shown are computed from the same time series and are internally consistent.

## Summary
- Ran defi-overview (empty var → both facets). **Positions facet:** `memory/on-chain-watches.yml` does not exist — logged `DEFI_MONITOR_NO_CONFIG`, skipped cleanly, no notification block.
- **Macro facet:** fetched DeFiLlama (v2/chains, protocols, dexs, fees, stablecoins, yields, plus per-chain `historicalChainTvl` for the top 15 chains ≥$500M to get accurate 1d/7d deltas since `v2/chains` no longer carries `change_1d`/`change_7d` fields), CoinGecko (price, markets, global, trending — via `scripts/secretcurl.sh` fallback since `./secretcurl` wasn't on `PATH`, no key needed on the free tier), Fear & Greed, Polymarket (volume + liquidity), and 2 WebSearches for macro catalysts (surfaced the ETF-inflow story). All 9 sources returned ok.
- Filtered a garbage `ETCswap V2` `change_1d` outlier (~1.6e19%) and other sub-$1M-TVL noise out of the weighted TVL calc before computing the regime verdict, matching this morning's established filter.
- Corrected the Top Chains/Chain Flow data source to canonical `/v2/chains` + `historicalChainTvl` after finding this morning's chain-flow figures didn't reproduce from any available current endpoint (likely a chain-aggregation double-count in a prior run) — documented as a data-source note, not a fabricated market move.
- Computed DeFi Verdict (Mixed — TVL/stables steady, DEX volume holding a large surge) and Market Take (risk-on, institutional-led, high conviction) anchored on the new BTC spot-ETF inflow catalyst found via WebSearch.
- Files written/modified:
  - `memory/skills/defi-overview/market-context.md` — full overwrite, Token Picks Made table preserved verbatim (no new token-pick entries found in today's logs).
  - `memory/logs/2026-09-22.md` — appended `### defi-overview (positions)` and `### defi-overview` entries.
  - `output/defi-overview/run_20260922T121112Z_defi-overview_e41c51.md` (this report) and `output/defi-overview/latest.md`.
- Follow-up: none required — real-yield and incentive-yield sections both cleared their filters; no sources degraded; no positions to flag. Worth a downstream narrative-tracker check tomorrow on whether the breadth/mcap divergence (12/20 green, -1.69% total mcap) resolves toward broad confirmation or toward a BTC-only rally fading back.
