## Crypto — 2026-09-24 — rotation (conviction medium) | DeFi Mixed: TVL flat, DEX volume still depressed, alts leading

**Take:** Breadth surged to 14/20 green (from just 1/20 at 12:11Z) while BTC held roughly flat (-0.04% 24h, $84,164) and dominance slipped to 58.57% — alts (XRP, SOL, LINK, ADA, DOGE) did the work, not BTC. Conviction medium: BTC ETF flows confirm (Sep 21's $998.95M inflow, first YTD-net-positive day since April) but DEX volume is still -10.1% 1d, lagging the price recovery.

*Positions:* no DeFi positions configured (`memory/on-chain-watches.yml` missing) — facet skipped cleanly, no flags to report.

*TVL:* $95.29B canonical chain-level (+0.7% 24h, +7.8% 7d)

**Top chains** — Ethereum $53.62B (-1.4% 1d, +9.0% 7d) · Solana $6.45B (-1.3%, +11.5%) · Base $6.20B (-1.0%, +11.8%)

**Movers**
- ↑ Circle Bitcoin (protocol) +115.8% ($264M→$271M) — cirBTC/Arc BTC-collateralized lending demand, a 5th consecutive same-day acceleration read (32.9%→93.6%→114.4%→115.8%)
- ↓ Steakhouse Financial (protocol) -17.4% ($3.1B→$2.6B) — Risk Curators/Morpho vault, no confirmed catalyst, first appearance as a down mover today
- ↓ Bittensor (chain) -6.43% ($620M→$580M) — bridge/pool TVL bleed continuing; TAO's actual token price is flat-at-highs (~$305-310, Peak per narrative-tracker) — the two metrics diverge
- No chain cleared the up-mover filter; Avalanche -4.9% ($611M), a near-miss

**Fees leaders (24h):** Tether $17.22M (-0.3%) · Circle USDC $7.17M (-0.1%) · PumpSwap $3.50M (+2.9%) — all unchanged from this morning

**Fees beating TVL:** HyperLend Pooled — fees +236.4% / TVL -6.6% (7d, $442.9M, multi-session) · Grove Finance — fees +130.3% / TVL -0.8% (7d, $1.26B, bleed easing from -7.9%)

*DEX vol (24h):* $10.08B (-10.1% 1d) — top: Uniswap V3 $1.55B (+4.8%), Uniswap V4 $1.39B (-9.1%), PancakeSwap V3 $0.75B (+3.3%)

*Stables:* $312.68B (roughly flat vs 12:11Z) — USDD +6.5% and PYUSD -5.8% continue standing single-issuer drifts · USDai -37.3%, unchanged from noon (stale, not fresh)

**Real yield (sustainable, ≥$10M)**
- raydium-amm WSOL-USDC (Solana) — 63.58% apyBase ($43.5M) — down sharply from 86.13% at noon, 3rd straight decline, material IL risk
- uniswap-v4 ETH-LINK (Ethereum) — 57.33% apyBase ($22.8M) — new entry
- uniswap-v3 WETH-USDT (Ethereum) — 48.43% apyBase ($108.5M)

**Incentive yield (≥$25M):** Aerodrome USDC-AERO — 24.11% apy via AERO ($36.8M) · Stake DAO SDCRV — 12.65% via CRV/cvxCRV ($41.8M)

**Active narratives:** Circle/Arc cirBTC lending (rising, 5th consecutive acceleration read) · Breadth/dominance rotation (emerging, 1/20→14/20 intraday) · BTC ETF inflow reversal (rising, first YTD-net-positive flow day) · NEAR ecosystem inflow (rising — reversing prior "fading" call; Bridge TVL +7.1% 1d and token price +8.3% 24h now confirm each other, currently CoinGecko-trending) · Bittensor bridge/pool bleed (fading)

**Macro:** BTC $84,164 (-0.04%) / ETH $2,671.60 (+0.3%) · F&G 71 (Greed, unchanged, 5th+ straight read) · breadth 14/20 · hot market: "Will the Fed increase interest rates by 25 bps after the October 2026 meeting?" YES 65.5% (down from 67.5%) · also: "Will Bitcoin reach $87,500 in September?" YES 32.5% (up from 27.5%) · live driver: 10Y Treasury yield hit its highest since 2007, then BTC bounced off the intraday low

_sources: llama_tvl=ok llama_dex=ok llama_fees=ok llama_stables=ok llama_yields=ok coingecko=ok fng=ok polymarket=ok websearch=ok | var: none_

## Summary
- Ran combined defi-overview (Positions + Macro facets), var=none.
- Positions facet: `memory/on-chain-watches.yml` missing → `DEFI_MONITOR_NO_CONFIG`, skipped cleanly.
- Macro facet: fetched DeFiLlama (chains, protocols, dexs, fees, stablecoins, yields, plus historicalChainTvl for chain-level 1d/7d deltas since `/v2/chains` no longer returns `change_1d`/`change_7d`), CoinGecko (price/markets/global/trending via direct keyless curl — `./secretcurl` binary absent in this environment, `COINGECKO_API_KEY` unset), alternative.me Fear & Greed, and Polymarket Gamma. 2 WebSearch queries for macro catalysts and BTC ETF flows.
- Headline finding: sharp same-day breadth reversal (1/20 green at 12:11Z → 14/20 green now) driven by alt strength (XRP/SOL/LINK/ADA/DOGE) against a flat BTC, corroborated by confirmed BTC ETF inflow reversal (Sep 21's $998.95M day, first YTD-net-positive flow since April) and a NEAR TVL/price reconfirmation (ending its 4-session outflow narrative).
- Files written: `memory/skills/defi-overview/market-context.md` (full overwrite, prior Token Picks Made table preserved + STONK 2026-09-24 row appended), `memory/logs/2026-09-24.md` (positions + macro log blocks appended), `output/defi-overview/run_20260924T181459Z_defi-overview_55d69d.md` (this file) + `latest.md`.
- No position alerts (no config). No source failures — all DeFiLlama/CoinGecko/F&G/Polymarket endpoints returned ok.
- Follow-up: narrative-tracker should reclassify NEAR ecosystem fading→rising and consider promoting BTC-ETF-inflow from Watch→Rising given today's confirmed reversal.
