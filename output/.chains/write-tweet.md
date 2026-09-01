## Tweet Drafts: Device biometrics for risky agent actions

### Tier 1 — One-liner

**1a. Reframe**

> agents can plan the action. your device should still authorize the risk

**1b. Observation**

> real agent autonomy needs a brake you can reach from your pocket

### Tier 2 — Two-punch

**2a. Structural**

> the agent can prepare a risky action. execution should still belong to the person holding the phone

**2b. Technical**

> a confirmation button proves intent. device biometrics prove the person approving it is actually there

### Tier 3 — Paragraph

**3a. Shipping**

> shipped a biometric gate for risky agent actions. the server issues the confirmation token, but the mobile client will not submit it until device auth succeeds. cancel the prompt and nothing executes. the token stays ready for an explicit retry

**3b. Principle**

> autonomy should remove repetitive work, not erase the last meaningful human decision. let the agent plan everything. when money or permissions move, the phone becomes the final execution boundary

### Tier 4 — Long tweet

**4a. Narrative**

> shipped the missing boundary in dieena's risky-action flow: device biometrics before the mobile client submits a server-issued confirmation token. if face or fingerprint auth fails or gets cancelled, the action never executes and the token stays available for an explicit retry. agents can handle the machinery. the final irreversible step still belongs to the user

**4b. Critique**

> most agent safety demos stop at a confirmation screen. that proves someone tapped a button, not that the authorized person approved the action. for risky operations, i want the agent to prepare the transaction, the server to issue a narrow confirmation token, and the phone to release it only after device auth. useful autonomy needs a clean final boundary

### Tier 5 — Thread opener

**5a. Thesis-first**

> i don't want humans approving every agent step. i want one strong boundary before the step that changes money, permissions, or state. we just shipped that boundary with device biometrics

---

- Why approval at every step destroys useful autonomy
- Where the irreversible-action boundary belongs
- How server tokens and device authentication work together
- Why cancellation must fail closed without destroying retry state

**5b. Question**

> an agent confirmation flow can look safe and still fail at the last inch. the server may issue a narrow token, but who proves the right person approved it? the user's own device should

---

- The gap between tapping confirm and authenticating the approver
- How the mobile client guards token submission
- Failure and cancellation behavior
- The broader pattern for agent-controlled financial actions

Best overall: **#4a**. Best per tier: **1a, 2b, 3a, 4a, 5a**.

## Summary

- Generated 10 drafts and verified all character limits.
- Saved the revisable batch to [write-tweet-latest.md](/home/runner/work/svectors-lab/svectors-lab/memory/drafts/write-tweet-latest.md).
- Logged the run in [2026-09-01.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-01.md).
- External notification and revision prompt could not be delivered because the harness queue is read-only.
