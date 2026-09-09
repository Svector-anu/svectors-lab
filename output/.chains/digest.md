*daily digest — 2026-09-09*

_TL;DR: patch two actively exploited Windows flaws, then look at a new genome-scale research tool and two agent systems moving into practical use._

1. *Patch Windows: two zero-days are already being exploited*  
   Microsoft’s September update fixes CVE-2026-85880 and CVE-2026-81963, both exploited before release; CISA added them to its known-exploited catalog with a September 22 deadline.  
   Why it matters: Windows fleets have confirmed exposure now, not a theoretical patch backlog.  
   https://www.microsoft.com/en-us/msrc/blog/2026/09/202609-security-update

2. *DeepMind opens predictions for all 9 billion single-letter DNA variants*  
   AlphaGenome Atlas is live for academic research through a free portal and API, with a new score for ranking coding and non-coding variants by predicted molecular impact.  
   Why it matters: researchers can triage genome-wide candidate lists before spending months on lab validation.  
   https://deepmind.google/blog/alphagenome-atlas-a-predictive-map-of-every-possible-dna-letter-change-in-the-human-genome/

3. *Microsoft runs a terminal-first Copilot agent workshop today*  
   A live Microsoft Reactor session at 16:00 UTC covers building and evaluating Microsoft 365 Copilot agents with skill-based tooling and Agent Evals.  
   Why it matters: builders can test an evaluation workflow today instead of reading another agent launch recap.  
   https://developer.microsoft.com/en-us/reactor/events/27447/

4. *A $1 billion satellite project puts AI agents on wildfire detection*  
   UAE-backed Marlan Space will fund a French autonomous Earth-observation constellation whose onboard agents can detect fires and send coordinates directly to authorities.  
   Why it matters: agent execution is moving from software demos into regulated, safety-critical infrastructure.  
   https://www.lemonde.fr/en/economy/article/2026/09/09/uae-commits-1-billion-to-french-space-ai-project_6757342_19.html

## Summary

- Reviewed 18 candidates, filtered to six, and selected four.
- Deduplicated the Liquid exploit and Mistral funding against recent digests.
- Updated `memory/MEMORY.md` and `memory/logs/2026-09-09.md`.
- `XAI_API_KEY` was unset, so public search fallback was used.
- Notification delivery was attempted, but its external queues are read-only in this harness.
