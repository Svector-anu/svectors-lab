---
title: RightStack Aeon integration
description: Release and verification record for RightStack's read-only Aeon advisor.
tags: [rightstack, aeon, web3, skills]
resource: https://github.com/Svector-anu/rightstack
timestamp: 2026-08-25T16:45:00Z
---

# RightStack Aeon integration

## Current state

- RightStack PR #2 added deterministic `schema_version: "1.0"` JSON to `recommend`, `workflow`, and `compare`; merged as `c782703`.
- RightStack PR #3 corrected npm's executable mappings before release; merged as `da6bbc9`.
- `rightstack@0.3.2` is published on npm with both `rightstack` and `rightstack-mcp` binaries and the complete corpus.
- A clean npm install successfully ran `rightstack recommend "consumer app on base with embedded wallet" --json`, returned schema v1, and matched a workflow.
- Aeon's adapter pins `rightstack@0.3.2`, passes no Aeon secrets to the child, disables npm install scripts, and requests JSON for every supported operation.

## Scope

The Aeon skill is intentionally read-only, disabled by default, and manual-dispatch only. It advises on architecture; it does not install dependencies, edit a dapp, create wallets, deploy contracts, or submit transactions. Corpus claims still require review against primary documentation before implementation.

## Closure gate

Before treating the fork integration as complete, run one real `rightstack` workflow dispatch on Codex and inspect the captured recommendation and notification. Then run `skill-health` against that completed run. An upstream Aeon contribution remains separate and must be based on current `upstream/main`, contain no fork runtime artifacts, and explain RightStack to maintainers who have no prior context.
