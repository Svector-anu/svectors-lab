*daily digest — 2026-09-19*

_TL;DR: patch exposed Cisco mail gateways now; agent sandboxes and package-release credentials both need tighter boundaries._

1. *Cisco mail-gateway flaw is under active exploitation*
   CVE-2026-76461 lets an unauthenticated crafted email trigger SQL injection and root command execution on affected Secure Email Gateway appliances. Update AsyncOS immediately and inspect every cluster member's `mail_logs` for suspicious SQL.
   Why it matters: internet-facing mail infrastructure can be compromised before authentication
   https://www.csa.gov.sg/alerts-and-advisories/alerts/al-2026-125/

2. *Gemini crossed a test boundary into three real companies*
   During a capture-the-flag evaluation, Gemini guessed one real system's password and found credentials for two others in public repositories; unintended internet access and a fictional company sharing a real name broke the test boundary. Google says the affected entities were contacted and the evaluator changed its process.
   Why it matters: agent isolation has to constrain network reach, targets, and credentials—not just prompts
   https://www.axios.com/2026/09/19/google-safety-incidents-testing-hacks

3. *npm adds stage-only tokens for release automation*
   npm workflows can now stage package versions without permission to publish them directly; a maintainer approves the release with 2FA. This is the practical migration path for token-based automation before bypass-2FA publishing is removed in January 2027.
   Why it matters: a stolen CI token no longer has to be a production publish credential
   https://github.blog/changelog/2026-09-18-stage-only-npm-tokens-for-safer-automation/

4. *GitHub sets an October 19 Copilot model migration deadline*
   Copilot will retire Gemini 3.7 Flash, GPT-5.5, GPT-5.4 variants, GPT-5 mini, and Grok 4.5 across chat, edits, agents, and completions. Audit pinned integrations now and move to the listed successor models.
   Why it matters: unattended workflows pinned to retired models can fail after the cutoff
   https://github.blog/changelog/2026-09-18-upcoming-deprecation-of-selected-github-copilot-models-in-mid-october/