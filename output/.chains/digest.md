*Daily digest — 2026-08-26*

_TL;DR: Patch exposed Gitea servers now; WhatsApp strengthened account recovery, while LayerZero, Google Cloud, and Taurus shipped new infrastructure._

1. *Actively exploited Gitea flaw requires an immediate upgrade*  
   CVE-2026-60004 enables shell-command execution through malicious patches; default open registration can make the attack path unauthenticated. Upgrade to Gitea 1.27.1 or later by August 28.  
   Why it matters: nearly 5,000 internet-exposed instances are being tracked.  
   https://www.bleepingcomputer.com/news/security/hackers-now-exploit-critical-gitea-flaw-in-code-injection-attacks/

2. *WhatsApp replaces six-digit 2FA PINs with stronger passwords*  
   WhatsApp is rolling out alphanumeric two-step-verification passwords, multiple passkeys, and more context for unknown Android callers.  
   Why it matters: users can harden account recovery under Settings > Account.  
   https://about.fb.com/news/2026/08/new-account-security-features-for-whatsapp/

3. *LayerZero launches ATLAS as a headless exchange backend*  
   ATLAS combines matching, clearing, settlement, and risk on LayerZero’s Zero chain. LayerZero claims launch capacity of 200,000 transactions per second.  
   Why it matters: trading apps can launch markets without building the complete exchange stack.  
   https://layerzero.network/blog/introducing-atlas

4. *Google Cloud packages Gemini agents for legal workflows*  
   Gemini Enterprise for Legal enters preview with legal-system connectors and skills for contract review, citation checking, diligence, and regulatory monitoring.  
   Why it matters: legal teams can evaluate a governed, domain-specific agent platform.  
   https://www.googlecloudpresscorner.com/2026-08-25-Google-Cloud-Launches-Gemini-Enterprise-for-Legal

5. *Taurus connects its custody stack to Swift’s shared ledger*  
   Taurus integrated Swift smart contracts with its tokenization and custody products; initial client connections and transactions are expected shortly.  
   Why it matters: Swift-member banks gain a route to tokenized deposits without replacing existing settlement rails.  
   https://finance.yahoo.com/markets/crypto/articles/exclusive-taurus-connects-banks-swift-121543958.html

## Summary

- Filtered 21 candidates to five after freshness, evidence, and three-day dedup checks.
- Updated [MEMORY.md](/home/runner/work/svectors-lab/svectors-lab/memory/MEMORY.md) and [2026-08-26.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-08-26.md).
- `XAI_API_KEY` was unset, so X-specific search used the web fallback.
- Notification was attempted; external queues were read-only, so delivery remained inline.
