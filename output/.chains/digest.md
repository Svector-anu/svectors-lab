*daily — 2026-09-02*

_TL;DR: Browser inference got a usable kernel layer while agent security money moved toward runtime controls and continuous skill verification._

1. *Try Hugging Face’s 207-kernel WebGPU layer in browser-local AI*  
   `@huggingface/kernels` loads versioned WebGPU operations from the Hub, with correctness tests and benchmarks attached. Hugging Face reports a 2.57× geometric-mean speedup over ORT WebGPU across 809 matching M4 test cases, excluding setup and transfer time.  
   Why it matters: browser agents can test faster local inference without maintaining a private shader stack.  
   https://huggingface.co/blog/webgpu-kernels

2. *Measure the context tax before buying a larger coding-agent window*  
   Sonar traced an ordinary ~800-line pull request to 156 million context tokens and a 459k-token peak because repeated grep-and-read results stayed in the conversation. Its SemSitter engine replaces text-search loops with dependency-graph queries.  
   Why it matters: navigation telemetry may cut agent cost before a model or context-window upgrade does.  
   https://www.sonarsource.com/blog/stop-the-context-tax/

3. *AIR raises $50M to continuously verify agent skills and MCP servers*  
   AIR exited stealth with $50 million across two seed rounds and says its enforcement layer discovers agents, rechecks their skills and add-ons as dependencies change, and blocks components that fail policy. The company told TechCrunch it currently filters roughly 27% of the add-ons it finds.  
   Why it matters: skill provenance and change monitoring are becoming a dedicated control plane for agent fleets.  
   https://techcrunch.com/2026/09/01/air-raises-50m-to-help-companies-vet-the-skills-and-add-ons-ai-agents-use/

4. *HiddenLayer puts $100M behind agent runtime and harness security*  
   HiddenLayer raised a $100 million Series B led by Delta-v Capital, with M12 and others participating. It says the capital will deepen runtime controls for tool misuse, unauthorized actions, prompt injection, secret exposure, and coding-agent harnesses.  
   Why it matters: enterprise spend is shifting from static AI governance toward enforcement inside agent execution loops.  
   https://www.hiddenlayer.com/newsroom

## Summary

- Generated and validated a 2,229-character digest with four HTTP-verified links.
- Deduplicated against the previous three days and today’s three earlier digests.
- Updated [MEMORY.md](/home/runner/work/svectors-lab/svectors-lab/memory/MEMORY.md) and [2026-09-02.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-02.md).
- Saved the digest to [digest-2026-09-02-fourth.md](/home/runner/work/svectors-lab/svectors-lab/output/digest-2026-09-02-fourth.md).
- External delivery was attempted, but the notification queue is read-only. The xAI request also returned HTTP 403 because the team credit/spend limit was reached.
