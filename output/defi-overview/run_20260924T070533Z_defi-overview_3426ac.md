## Crypto — 2026-09-24 — risk-off drift continues (conviction medium) | DeFi Mixed: TVL drifting down on sharply lower DEX volume, stables flat

**Take:** BTC $83,976 (-2.78% 24h) sliding further as a hot September PMI print (58.4, fastest expansion since 2021) pushed CME-implied odds of an October 25bp Fed hike to 69.7% — the live driver of today's weakness. Breadth crushed at 4/20 green (up from 1/20 at 00:00Z). Conviction medium: DEX volume -9.0% and TVL -1.7% 1d confirm outflow, but Bitcoin ETFs booked $241M net inflow today (reversing a 2-day ~$683M outflow) and F&G is stuck at 71 (Greed) for a 3rd straight read — a real price/sentiment lag muddying a clean risk-off call.

*Positions:* no DeFi positions configured (`memory/on-chain-watches.yml` missing) — facet skipped cleanly, no flags to report.

*TVL:* $94.78B canonical (-1.71% 24h, +8.84% 7d)

**Top chains** — Ethereum $53.51B (-1.6% 1d, +8.8% 7d) · Solana $6.39B (-2.2%, +10.5%) · Base $6.14B (-2.0%, +10.7%)

**Movers**
- ↑ Circle Bitcoin (protocol) +93.6% ($158M→$240M) — cirBTC/Arc BTC-collateralized lending demand still compounding same-day (2nd acceleration read today)
- ↓ NEAR Bridge (protocol) -16.0% ($136M→$114M) — 3rd straight outflow session, deepening last week's reversal
- ↓ Bittensor (chain) -7.88% ($620M→$571M) — bridge/pool TVL only; narrative-tracker flagged this AM that TAO's actual token price is +41% 7d (Peak, not Fade) — the two metrics diverge
- No chain cleared the up-mover filter; Avalanche -6.2% ($604M) newly crossed the down threshold too

**Fees leaders (24h):** Tether $17.2M (-0.3%) · Circle USDC $7.17M (-0.1%) · PumpSwap $3.50M (+2.9%)

**Fees beating TVL:** HyperLend Pooled — fees +241.7% / TVL -6.9% (7d, $429M, multi-session) · Grove Finance — fees +130.3% / TVL -7.9% (7d, $1.26B, new)

*DEX vol (24h):* $10.20B (-9.0% 1d) — top: Uniswap V3 $1.54B, Uniswap V4 $1.32B, PancakeSwap V3 $0.75B

*Stables:* $312.35B (-0.09% 1d) — USDai -37.3% (RWA stablecoin, mirrors its protocol's TVL drop, no confirmed catalyst); USDD +6.5% (multi-session elevated); PYUSD -5.3% (2nd straight single-issuer move)

**Real yield (sustainable, ≥$10M)**
- raydium-amm WSOL-USDC (Solana) — 103.83% apyBase ($42.2M) — volatile pair, IL risk
- uniswap-v3 UNI-WETH (Ethereum) — 69.95% apyBase ($17.6M) — new entry
- uniswap-v3 WETH-USDT (Ethereum) — 44.85% apyBase ($108.4M)

**Incentive yield (≥$25M):** Aerodrome USDC-AERO — 23.74% apy via AERO ($36.2M) · Stake DAO SDCRV — 12.82% via CRV/cvxCRV ($40.2M)

**Active narratives:** Circle/Arc BTC-lending (rising) · Fed hawkish repricing (rising, new) · NEAR outflow (rising, bearish) · Bittensor/TAO (peak, corrected) · breadth/F&G divergence (persisting)

*Macro:* BTC $83,976 (-2.78%) / ETH $2,681.49 (-2.51%) · dominance 58.66% (-0.16pp) · F&G 71 (Greed) · breadth 4/20 · hot market: "BTC above $82,000 on Sep 24?" YES 93.5%; Fed +25bp Oct YES 64.5% (unchanged); Deribit quarterly options expiry lands Sep 25.

_sources: llama_tvl=ok llama_dex=ok llama_fees=ok llama_stables=ok llama_yields=ok coingecko=ok(secretcurl, no key) fng=ok polymarket=ok websearch=ok | var: none_

## Summary
- Ran combined defi-overview (Positions + Macro facets) for 2026-09-24 07:05Z, ~7h after the 00:00Z run.
- Positions facet: `memory/on-chain-watches.yml` missing → `DEFI_MONITOR_NO_CONFIG`, skipped cleanly.
- Macro facet: fetched DeFiLlama (chains, protocols, dexs, fees, stables, pools + historicalChainTvl for chain-level 1d/7d), CoinGecko (price/markets/global/trending via `scripts/secretcurl.sh`, no key needed), alternative.me F&G, Polymarket (volume + liquidity + widened crypto/macro filter), and 2 WebSearches for macro catalysts — all sources `ok`.
- Identified fresh macro catalyst (PMI 58.4 → 69.7% Oct hike odds) missing from the 00:00Z snapshot; carried forward and corrected the Bittensor/TAO chain-TVL-vs-token-price conflation per narrative-tracker's 04:42Z fix.
- Files written: `memory/skills/defi-overview/market-context.md` (overwritten, Token Picks Made table preserved verbatim), `memory/logs/2026-09-24.md` (appended positions + macro log blocks).
- Follow-up: none blocking; downstream token-pick/narrative-tracker consumers should pick up the Circle/Arc and Fed-repricing implications on next run.
