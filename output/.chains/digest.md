*daily digest — 2026-09-02*

_TL;DR: fork a production commerce-agent baseline today, then protect KuCoin automation from two scheduled disruptions._

1. *Fork Anthropic's commerce-agent blueprint instead of rebuilding the loop*  
   Anthropic released an Apache-2.0 reference repo with runnable shopping and merchant agents across retail, travel, telecom, and ticketing. It includes three runtimes, staged human approval for writes, safety gates, eval tooling, and a Claude Code scaffolding plugin.  
   Why it matters: builders can reuse the execution and safety layer, then connect their own catalog, cart, inventory, and pricing backends.  
   https://github.com/anthropics/commerce-agents

2. *Close KuCoin GALA margin positions before 02:00 UTC September 3*  
   KuCoin will delist GALA margin trading, lending, borrowing, and its Margin Grid bot. Open orders will be cancelled and outstanding positions may be liquidated automatically.  
   Why it matters: anyone carrying a GALA margin loan or bot has only hours to exit cleanly.  
   https://www.kucoin.com/announcement/kucoin-margin-notice-260902

3. *Add reconnect and loss handling before KuCoin's September 4 API upgrade*  
   KuCoin’s UTA API maintenance starts at 12:00 UTC September 4 and runs for about two hours. WebSocket clients may disconnect, lose data, or see delays; the API also adds error `110188` for busy-system retries.  
   Why it matters: trading agents need reconnect, replay, and backoff paths tested before the window.  
   https://www.kucoin.com/announcement/en-announcement-of-kucoin-api-upgrade-2026-09-04

*Also worth a glance:* AWS published a six-pillar production-agent walkthrough covering build, test, run, secure, observe, and govern: https://aws.amazon.com/blogs/industries/building-a-production-ai-agent-on-aws-a-six-pillar-walkthrough/

## Summary

- Created [digest-2026-09-02-third-run.md](/home/runner/work/svectors-lab/svectors-lab/output/digest-2026-09-02-third-run.md).
- Updated [MEMORY.md](/home/runner/work/svectors-lab/svectors-lab/memory/MEMORY.md) and [2026-09-02.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-02.md).
- Verified all four links returned HTTP 200.
- xAI search returned HTTP 403 after three attempts.
- Notification delivery was attempted, but the external notification queues were read-only; the digest remains saved in the workspace.
