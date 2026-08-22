Committed. Positions facet skipped (no config); macro facet ran and refreshed the context file. Notification suppressed — this is the 4th run today and the read is a continuation of the 13:05 cooling ping with no position-call flip, so per "don't re-report the same signal" nothing was sent. Here is the run output.

---

# Crypto — 2026-08-22 (evening) — Consolidation / risk-on cooling (conviction medium) | DeFi Mixed: DEX churn hot, no fresh capital

**Take:** consolidation — BTC flat $77.3k (−0.1% 24h, +22.6% 7d) while the multi-day alt blow-off keeps bleeding out: XRP +5.8% 24h (was +19.7% AM / +11.4% midday), ADA +4.2%, DOGE +9.9%; breadth eased to **14/20** (from 17 at the AM peak), mcap −2.1% 24h. ZEC is the lone big gainer (+21.6%).
**Conviction:** medium — F&G steady 71 Greed and DEX vol hot ($14B) still support the bid, but narrowing breadth, red mcap, and decelerating alts say the leg is digesting, not extending.
**Evidence:** top-20 24h breadth 14/20 with ZEC the only large gainer — participation collapsing toward a single name (a late-stage tell).

**DeFi Verdict: Mixed** — DEX volume $14.04B (+34% 1d) runs hot on flat TVL (+0.50% 1d wtd) and flat stables (+0.35% 1d) → rotation/churn, not fresh capital.

### What moved since the 13:05 refresh
- **Alt cooling extended, breadth narrowing** — XRP +11.4%→+5.8%, DOGE +10.7%→+9.9%, ADA +7.0%→+4.2%; breadth 16→14/20; mcap red deepened −0.82%→−2.11% 24h.
- **ETF streak intact but decelerating** — Aug-21 spot-BTC-ETF flows now published: **$307.5M net (IBIT +$239M), 5th straight day**, down from Aug-20's $606M. Watch for a streak break as the cleanest exhaustion tell. ([KuCoin](https://www.kucoin.com/news/flash/bitcoin-spot-etfs-see-307m-net-inflow-on-august-21-marking-fifth-consecutive-day-of-inflows), [Blockchain.News](https://blockchain.news/flashnews/bitcoin-etf-flows-total-307-5-million))
- **Rally decoupled from equities** — US stocks fell sharply, European stocks logged their worst week in ~2 months, while crypto held. Liquidity/regulatory-driven (Treasury buyback doubling, CLARITY Act push), not risk-asset beta — a decoupled rally is more fragile if the liquidity impulse rolls over. ([CNBC](https://www.cnbc.com/2026/08/21/bitcoin-gain-cryptocurrency-investors-optimistic.html), [The Block](https://www.theblock.co/news/markets/2026-08-21-bitcoin-surge-80k-liquidity-driven-momentum-shift-etf-flows-rebound-bernstein-412443))
- **DeFi fundamentals flat intraday** — DEX $14.04B, Tether fees $15.9M, Hyperliquid Perps $6.0M (+411% 7d), same movers (Dolomite, M0). Only sentiment/breadth shifted.

### Signal snapshot
- BTC $77,251 (−0.1% 24h, +22.6% 7d) · dominance 58.80% (flat) · ETH $2,427 (+0.2%, +28.8% 7d) · SOL $94.25 (+2.8%)
- Total mcap $2.626T (−2.11% 24h) · DEX vol $14.04B (+34% 1d) · F&G 71 (Greed, yest 72)

### DeFi read
- **Top chains:** Ethereum $48.59B · BSC $5.52B · Solana $5.51B (`/v2/chains` returned no deltas again — chain movers omitted)
- **Protocol movers:** ↑ Dolomite +57% ($0.32B Lending, continued) · ↑ Concrete +11% ($1.15B allocator) — ↓ M0 −15% ($0.19B stablecoin issuer) · ↓ Biconomy −12% ($0.15B). *NEOPIN +860% excluded as a data artifact.*
- **Fees leaders (24h):** Tether $15.9M (flat) · Circle $6.4M · Hyperliquid Perps $6.0M (+411% 7d) — the standout real-demand story
- **Fees beating TVL:** Polymarket Intl (+33% fees / +2.8% TVL 7d) · Aerodrome Slipstream (+340% fees / +4% TVL 7d)
- **Real yield (sustainable):** USDC-WETH 27.8% apyBase (Uniswap V3, $104M — LP, carries IL) · HGRAM 17.2% (TON, $12M) · SUSDAT 15.9% (ETH, $80M)
- **Incentive yield:** USDC-AERO 23.2% via AERO (Base, $28M) · CVXCRV 15.7% (ETH, $53M) · SDCRV 14.1% via SDT (ETH, $40M)
- **Stables:** $309.5B (+0.72% 7d) — USDT $183.2B flat, USDC $73.7B (+1.0% 1d). Flat supply + hot DEX vol = churn, not inflows.
- **Prediction markets:** crypto/macro book thin — Fed Sept-path market dropped out of the active top-vol/liquidity book (top-vol is sports/esports). No tradeable prediction-market signal today.

### Position call
Favor **BTC/ETH beta and pullback entries** over chasing extended large-cap alts (XRP/ADA/DOGE all giving back); **fade / take profit** on the parabolic isolated names (ZEC +68% 7d, lone gainer). **Ride** perp-DEX cashflow (HYPE, fees +411% 7d) as the cleanest fundamentals hold. **Watch** the ETF daily print — a streak break confirms the cooling.

## Summary
- **Ran:** defi-overview, empty var → combined. Positions facet skipped cleanly (`DEFI_MONITOR_NO_CONFIG` — no `memory/on-chain-watches.yml`). Macro facet ran fully.
- **Sources:** all `ok` — DeFiLlama (chains/protocols/dexs/fees/stables/yields), CoinGecko (keyless), alternative.me F&G, Polymarket (crypto book thin), WebSearch (2 queries).
- **Files:** rewrote `memory/topics/market-context.md` (KAITO pick preserved verbatim); appended `memory/logs/2026-08-22.md`. Committed as `6fcbcab`.
- **Notify:** **suppressed** — 4th run today; continuation of the 13:05 cooling read with no regime/position-call flip and unchanged DeFi fundamentals, so per "notify only on signal / don't re-report" nothing was sent.
- **Follow-up:** none required. Next run's key tells — a spot-ETF inflow streak break, a breadth reading <7/20 (risk-off), or a break-and-hold above $80k (leg resumes).
