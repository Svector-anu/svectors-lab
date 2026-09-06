*daily — 2026-09-06*

_TL;DR: upgrade AgentOS for MCP correctness; Qwen now exposes workflow runs, and Ollama can put local models inside ChatGPT Desktop._

1. *Upgrade AgentOS for MCP transport and SQL-boundary fixes*  
   AgentOS 2026.9.6 fixes two broken MCP transports, a connection leak, and a bridge that passed model-supplied values directly to SQLite.  
   Why it matters: upgrade before trusting MCP-heavy production runs.  
   https://github.com/use-agent-os/agent-os/releases/tag/v2026.9.6

2. *Qwen Code previews visible, manageable workflow runs*  
   Qwen Code 0.23.1-preview.1 adds web-shell visualization and management for dynamic workflows.  
   Why it matters: operators can inspect multi-step execution instead of treating it as a black box.  
   https://github.com/QwenLM/qwen-code/releases/tag/v0.23.1-preview.1

3. *Ollama brings local models into ChatGPT Desktop*  
   Ollama 0.34.0-rc1 lets the macOS ChatGPT Desktop app use Ollama models, adding tool search, response compaction, and image fixes.  
   Why it matters: local inference now fits an existing ChatGPT workflow.  
   https://github.com/ollama/ollama/releases/tag/v0.34.0-rc1

## Summary

- Filtered 18 candidates to three fresh, primary-source releases.
- Updated `memory/MEMORY.md` and today’s digest log.
- Notification was attempted, but the external notification queues were read-only; the digest is preserved above.
