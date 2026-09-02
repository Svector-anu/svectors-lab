*daily digest — 2026-09-02*

_TL;DR: agent context is now a tested attack surface, self-hosted coding-agent infrastructure reached GA, and a Cosmos EVM postmortem shows why monitoring cannot replace execution-path controls._

1. *Audit every context source your coding agents can inherit*  
   A new study found privilege-escalation paths across 12 production agent harnesses, including Codex and Claude Code, with outcomes ranging from manipulated tool calls to remote code execution. Treat repo instructions, persisted context, and assembled inputs as privilege boundaries.  
   Why it matters: one low-trust context source can compromise a higher-trust agent run  
   [Read the paper](https://arxiv.org/abs/2609.01222)

2. *Migrate Coder integrations as Agents reaches GA in v2.37*  
   Coder Agents is now GA with self-hosted headless runs, stable APIs, organization-scoped MCP and model controls, and AI Gateway observability. Experimental chat routes have a one-month compatibility window, while Coder Tasks is deprecated.  
   Why it matters: v2.37 can break old API, model, MCP, and spend-limit assumptions  
   [Coder changelog](https://coder.com/changelog/coder-2-37)

3. *TAC postmortem turns the Cosmos EVM exploit into an operator checklist*  
   TAC says three shared-module defects drained 28.6% of supply from its staking pool; the balance crossed to BNB Chain within 95 seconds and roughly $1.01M was realized. Remediation adds fail-closed arithmetic, bridge limits, and faster pause paths.  
   Why it matters: shared dependencies need acknowledged escalation paths and execution-layer controls  
   [TAC postmortem](https://tac.build/blog/tac-mainnet-security-incident)

4. *JFrog adds policy enforcement around agent-produced artifacts*  
   JFrog introduced Agent Guard, an AI catalog, and lifecycle scanning intended to restrict which models, MCP servers, packages, and artifacts coding agents may consume or publish.  
   Why it matters: agent output can enter the same governed supply chain as human-built artifacts  
   [JFrog announcement](https://www.businesswire.com/news/home/20260902083102/en/)

## Summary

- Created [output/digest-2026-09-02.md](/home/runner/work/svectors-lab/svectors-lab/output/digest-2026-09-02.md).
- Updated digest memory and today’s activity log.
- The X API returned HTTP 403; public fallback yielded no usable posts.
- Notification delivery was attempted, but its external queues were read-only.
