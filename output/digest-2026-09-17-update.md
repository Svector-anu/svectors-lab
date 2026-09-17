*daily — 2026-09-17*

_TL;DR: Arc is live for stablecoin and agent payments; wallet-stealing fake agents make extension checks urgent._

1. *Circle opens Arc mainnet to developers*
   Circle launched its USDC-gas L1 with sub-second finality, post-quantum signatures, 100+ applications and 100+ institutional or ecosystem builders. Developers can deploy now; validators are institution-led and opt-in privacy is still in development.
   Why it matters: agent-payment and settlement teams have a new production rail to test today
   https://www.circle.com/pressroom/circle-launches-arc-mainnet-an-economic-operating-system-for-the-internet

2. *Fake AI trading agents are replacing crypto wallet extensions*
   HP found campaigns that package fake trading agents with malware which swaps trusted browser wallet extensions for malicious versions. Audit extension IDs and install paths before testing new agent tools.
   Why it matters: the agent wrapper is now a direct wallet-compromise vector
   https://www.hp.com/us-en/newsroom/press-releases/2026/hp-research-cybercriminals-leaning-into-agentic-ai-momentum-to-steal-crypto-wallets.html

3. *GitHub rewrites the Copilot agent runtime in Rust*
   One engineer used Copilot to move the live runtime from roughly 430,000 lines of TypeScript to more than 800,000 lines of production Rust across 128 merged PRs. GitHub shipped incrementally and reports dozens of traced regressions, all fixed by September 14.
   Why it matters: agents made a previously uneconomic platform rewrite feasible, but review, tests and staged releases remained essential
   https://github.blog/ai-and-ml/generative-ai/migrating-the-github-copilot-runtime-to-rust-using-copilot/

4. *OpenEden brings tokenized Treasury and high-yield funds to BNB Chain*
   OpenEden deployed TBILL and HYBOND, representing BNY-managed Treasury-bill and short-duration high-yield bond funds, on BNB Chain. This gives BNB DeFi direct access to regulated fixed-income collateral.
   Why it matters: BNB protocols can integrate yield-bearing RWA collateral without bridging to another chain
   https://openeden.com/news/openeden-launches-tbill-hybond-bnb-chain/
