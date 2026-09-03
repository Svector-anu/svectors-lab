*daily — 2026-09-03*

_TL;DR: upgrade Firo nodes before tomorrow's fork, treat copied `.git` directories as executable input, and expect Hugging Face to close under NVIDIA in 2027._

1. *Upgrade Firo before Spark reactivates tomorrow*  
   Firo v0.14.18.0 is mandatory for wallets, nodes, masternodes, miners and exchanges before block 1,371,000, expected September 4 at 10:00 UTC. It permanently fixes multi-input Spark spends.  
   Why it matters: outdated infrastructure will miss the hard fork.  
   https://firo.org/2026/08/27/firo-v014180-release.html

2. *Sanitize `.git` before an agent opens untrusted code*  
   Eight GitSpawn flaws let repository-local Git configuration trigger commands when coding agents inspect a project. Disable `core.fsmonitor` for untrusted repositories and remove copied `.git` metadata before opening them with an agent.  
   Why it matters: code can run before the agent shows a trust prompt.  
   https://thehackernews.com/2026/09/malicious-git-configs-can-make-claude.html

3. *NVIDIA agrees to acquire Hugging Face for $12.93B*  
   NVIDIA says Hugging Face will remain open and hardware-agnostic after the deal, expected to close in the first half of 2027. The platform serves 18 million developers and hosts more than 3 million models.  
   Why it matters: the largest open-model distribution hub is moving under the dominant AI chip vendor.  
   https://blogs.nvidia.com/blog/nvidia-to-acquire-hugging-face/

4. *Coder brings Cursor cloud agents onto customer infrastructure*  
   Coder Agent Relay lets regulated teams run Cursor Cloud Agents inside self-hosted Coder workspaces while Cursor retains inference and planning.  
   Why it matters: cloud coding agents can now meet stricter data-residency and network-boundary requirements.  
   https://coder.com/blog/agent-relay-spacexai-launch-partner-cursor-cloud-agents

## Summary

- Saved the digest to [digest-2026-09-03-2.md](/home/runner/work/svectors-lab/svectors-lab/output/digest-2026-09-03-2.md).
- Updated memory and the daily run log.
- xAI failed with HTTP 403 because its spending allowance is exhausted; web-search fallback was used.
- Notification delivery was attempted but could not be confirmed because the external queues are read-only.
