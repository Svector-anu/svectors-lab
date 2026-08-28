*web3 developer tooling — 2026-08-28*

_TL;DR: builders can join a privacy hackathon today, Cardano shipped an agent-ready project generator, and wallet stacks added RGB Lightning and stricter transaction verification._

1. *Midnight's privacy hackathon starts today*
   The online build runs August 28–30 around private apps, zero-knowledge contracts, and agents with onchain policy guardrails; the event page links the Compact tooling and submission flow.
   Why it matters: a live weekend path to test policy-constrained wallet agents
   https://events.mlh.com/events/14510-midnight-hackathon-august

2. *cardano-init becomes a released, agent-ready project generator*
   Versions 0.2.0 and 0.2.1 turn the prototype into a CLI that generates wired monorepos, emits machine-readable JSON and AGENTS.md, and can add or remove stack components without regenerating the project.
   Why it matters: Cardano setup becomes a repeatable scaffold instead of manual glue work
   https://github.com/input-output-hk/cardano-init

3. *Tether WDK adds Lightning support for RGB assets*
   A new module built by Utexo brings RGB asset transfers over Bitcoin Lightning into Tether's Wallet Development Kit, expanding the routes one wallet stack can expose.
   Why it matters: wallet developers can test RGB Lightning without assembling the integration from scratch
   https://rgb.info/rgb-lightning-tether-wdk/

4. *Sparrow 2.5.4 hardens what wallets trust*
   The Bitcoin wallet now validates Electrum responses and block proofs more aggressively, redacts credentials from logs, closes Tor DNS leaks, and tightens hardware-wallet signing protections.
   Why it matters: embedded-wallet teams should make server verification and secret-safe diagnostics explicit acceptance criteria
   https://github.com/sparrowwallet/sparrow

*Also worth a glance:* for the Base consumer-app stack, keep Privy as the onboarding layer only after fixing the canonical account model; use wagmi + viem, a dedicated RPC with fallback, and one sponsorship path rather than stacking paymaster vendors.
