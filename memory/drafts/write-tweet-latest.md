tweet drafts: device biometrics as the final gate for risky agent actions

— one-liner —
1a. agents can plan the action. your device should still authorize the risk
1b. real agent autonomy needs a brake you can reach from your pocket

— two-punch —
2a. the agent can prepare a risky action. execution should still belong to the person holding the phone
2b. a confirmation button proves intent. device biometrics prove the person approving it is actually there

— paragraph —
3a. shipped a biometric gate for risky agent actions. the server issues the confirmation token, but the mobile client will not submit it until device auth succeeds. cancel the prompt and nothing executes. the token stays ready for an explicit retry
3b. autonomy should remove repetitive work, not erase the last meaningful human decision. let the agent plan everything. when money or permissions move, the phone becomes the final execution boundary

— long tweet —
4a. shipped the missing boundary in dieena's risky-action flow: device biometrics before the mobile client submits a server-issued confirmation token. if face or fingerprint auth fails or gets cancelled, the action never executes and the token stays available for an explicit retry. agents can handle the machinery. the final irreversible step still belongs to the user
4b. most agent safety demos stop at a confirmation screen. that proves someone tapped a button, not that the authorized person approved the action. for risky operations, i want the agent to prepare the transaction, the server to issue a narrow confirmation token, and the phone to release it only after device auth. useful autonomy needs a clean final boundary

— thread opener —
5a. i don't want humans approving every agent step. i want one strong boundary before the step that changes money, permissions, or state. we just shipped that boundary with device biometrics
5b. an agent confirmation flow can look safe and still fail at the last inch. the server may issue a narrow token, but who proves the right person approved it? the user's own device should

best: #4a — it explains the shipped mechanism, failure behavior, and product principle without turning into a security lecture
