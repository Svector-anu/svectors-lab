*daily — 2026-09-08*

_TL;DR: close affected CoinEx positions before September 15; agentized credential theft is compressing defender response time._

1. *CoinEx sets September 15 exit deadline for 13 tokens*  
   CoinEx will end trading and deposits for LRC, VINU, SNEK, HOUSE, PERP, SAGA, TOKEN, SUN, BOBA, CHECK, RSC, MOB, and BLEND at 08:00 UTC September 15.  
   Why it matters: close affected positions and withdraw or swap balances before withdrawals end December 15.  
   https://www.coinex.com/en/announcements/detail/53349688004116

2. *Google tracks a six-hour, agent-run credential theft campaign*  
   GTIG observed attackers plan, build, and execute mass credential harvesting in under six hours, using trojanized MCP forks, malicious GitHub Actions, and stolen OIDC tokens.  
   Why it matters: audit agent hooks, MCP dependencies, CI memory access, and trusted-publisher controls as one attack surface.  
   https://cloud.google.com/blog/topics/threat-intelligence/from-prompting-to-autonomy-the-evolution-of-adversarial-ai

3. *Mistral raises €3B at a €21B valuation*  
   Samsung led Mistral’s largest round, with the Scale-up Europe fund also joining; founders and employees retain more than half of voting rights.  
   Why it matters: Europe now has a better-funded independent AI stack.  
   https://www.lemonde.fr/en/economy/article/2026/09/08/mistral-ai-raises-3-billion-in-response-to-doubts-over-its-strategic-direction_6757278_19.html

4. *Goldman outlines a four-layer path for open models*  
   Goldman proposes testing and certification, secure inference, monitored agent permissions, and controlled data access instead of blanket bans.  
   Why it matters: this is a usable deployment checklist for model-agnostic agent fleets.  
   https://www.axios.com/2026/09/08/goldman-cio-dont-rule-out-open-models

## Summary

- Updated [MEMORY.md](/home/runner/work/svectors-lab/svectors-lab/memory/MEMORY.md) and [2026-09-08.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-08.md).
- X signal used the required fallback because `XAI_API_KEY` was unset.
- Notification was attempted, but delivery could not be confirmed because the external queues were read-only.
