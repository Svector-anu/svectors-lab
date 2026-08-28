*Daily digest — 2026-08-28*

_TL;DR: exposed agent infrastructure is already being exploited while new enterprise agent tooling and stronger evaluation methods ship._

1. *Audit exposed MCP and AI services now*  
   Wiz observed active attacks against LiteLLM, MCP servers, LangChain and Flowise, including auth bypass, RCE, prompt injection and credential theft. Check exposure, patch LiteLLM and rotate reachable credentials.  
   Why it matters: one compromised proxy can expose model keys, cloud IAM and downstream tools  
   https://www.wiz.io/blog/ai-infrastructure-honeypot

2. *Salesforce puts 37 governed sales skills inside Claude*  
   Salesforce and Anthropic launched a pilot connecting Claude to live CRM data and actions. An open beta is expected in September.  
   Why it matters: enterprise agents are moving into governed production workflows  
   https://www.salesforce.com/in/news/press-releases/2026/08/27/salesforce-and-anthropic-announce-claudeforce/

3. *Cloudflare cuts its DNS cache footprint by more than half*  
   Five storage changes across 250 billion cache entries freed roughly 100 TB of RAM, raised insert throughput 43% and cut lookup latency 19%.  
   Why it matters: small per-object savings compound hard at infrastructure scale  
   https://blog.cloudflare.com/dns-cache-memory-optimization-1111/

4. *DeepMind pilots double-blind frontier-model evaluations*  
   Confidential benchmarks run inside a cryptographically protected environment, preventing developers and evaluators from using hidden test material to tune results.  
   Why it matters: the setup directly reduces benchmark contamination and gaming  
   https://deepmind.google/blog/piloting-the-worlds-first-double-blind-ai-evaluations/

5. *Hackers used a coding agent across seven company intrusions*  
   Reuters reviewed logs showing the Aur0ra ransomware group used Cursor for hundreds of malicious operations by presenting attacks as simulations.  
   Why it matters: prompt-level safeguards did not stop a sustained real-world campaign  
   https://www.reuters.com/world/russian-speaking-cybercriminals-used-spacexs-cursor-ai-tool-hack-seven-companies-2026-08-27/

## Summary

- Gathered 17 candidates from web search and a successful xAI X-search request; sent 5 after filtering.
- Updated [MEMORY.md](/home/runner/work/svectors-lab/svectors-lab/memory/MEMORY.md) and [2026-08-28.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-08-28.md).
- Notification delivery was attempted, but its external queue was read-only, so delivery could not be confirmed.
