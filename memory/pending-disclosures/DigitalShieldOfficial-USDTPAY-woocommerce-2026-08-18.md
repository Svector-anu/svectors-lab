---
type: Reference
repo: DigitalShieldOfficial/USDTPAY-woocommerce
severity: medium
cwe: CWE-840
status: sent
sent_at: 2026-08-19T00:00:00Z
auto_send: false
human_only: true
contact_email: service@ds.pro
cc: []
email_subject: "Security: WooCommerce webhook completes orders without validating paid amount"
detected_at: 2026-08-18T15:45:00Z
---

**Operator review requested before sending — not auto-armed.** A valid out-of-band
contact resolved cleanly (`service@ds.pro`, from the repo's own README "Contact Us"
table; no `SECURITY.md` on either DigitalShieldOfficial repo, and
`POST /repos/DigitalShieldOfficial/USDTPAY-woocommerce/security-advisories/reports`
confirmed `403 "Repository does not have private vulnerability reporting enabled"`,
so this is a genuine no-PVR case, not a token-scope problem). Per the skill's own
rule this qualifies for `auto_send: true`, but I'm holding it back deliberately:

1. **DigitalShieldOfficial is a brand-new account** (created 2026-07-24, ~3.5 weeks
   old, 4 followers, exactly 2 repos) — first contact with this vendor, no track
   record either way.
2. **Independent exploitability is genuinely unverifiable from here.** The gap
   (webhook trusts a signed `paid` status without checking the amount) is real and
   plainly visible in the plugin's own code, but whether it's *actually* triggerable
   depends on whether `cashier.ds.pro`'s closed-source, hosted backend already
   enforces exact-amount-or-reject before it ever emits a `paid` callback — I can't
   test that from outside. Said so plainly in the draft below rather than inflating
   confidence.
3. Signature verification itself is implemented correctly (HMAC-SHA256 +
   constant-time compare, both in the Node.js and PHP SDK) — this is a narrower,
   more judgment-call finding than a clean auth bypass, and worth a human read
   before it goes out under this project's name.

# Staged private disclosure — DigitalShieldOfficial/USDTPAY-woocommerce

<!-- EMAIL-BODY-START -->
Hi there,

I came across your USDTPAY-woocommerce plugin while running a routine, good-faith
security review of public GitHub repos, and wanted to flag something before it's
public anywhere.

**What I found:** in `dspay_handle_webhook()` (dspay-woocommerce.php), a
successfully-signed DSPay callback reporting `status=paid` marks the WooCommerce
order fully paid (`$order->payment_complete()`), but the handler never compares
the amount reported in that callback (`payAmount` / `actualReceivedAmount`)
against the amount the order actually expects. That expected amount is already
being stored on the order at creation time (`_dspay_token_amount`, set in
`src/Gateway.php::process_payment()`) but it's never read back in the webhook
handler. `src/PaymentStatus.php` only maps status strings — there's no amount
logic anywhere in the plugin.

**Why it might matter:** if your cashier service (cashier.ds.pro) ever reports a
`paid` status for less than the order's full expected amount — a partial payment,
a retried/interrupted session, or any edge case not strictly enforced
server-side — the plugin would still mark the WooCommerce order as fully
completed. I can't test your hosted cashier's own enforcement from outside, so I
don't know for certain whether this is independently triggerable today or fully
covered by your backend already — but the plugin itself has no safety net either
way, and the data needed for one is sitting right there unused.

To be clear: the signature verification itself looks solid — HMAC-SHA256 with a
proper constant-time comparison, in both your Node.js and PHP SDKs. This isn't a
spoofing issue, it's a missing reconciliation step after a legitimately-signed
callback.

**Suggested fix:** before completing the order in the `paid` branch, compare
`$order->get_meta('_dspay_token_amount')` against the callback's reported amount
(with a small tolerance for decimal formatting), and route anything short to
manual review instead of auto-completing.

I went ahead and wrote the fix rather than just describing it — it's a small,
self-contained change (falls back to today's behavior when there's no baseline
recorded, so it won't affect existing in-flight orders):

```diff
diff --git a/dspay-woocommerce.php b/dspay-woocommerce.php
index 9b32306..56bdab2 100644
--- a/dspay-woocommerce.php
+++ b/dspay-woocommerce.php
@@ -241,9 +241,35 @@ function dspay_handle_webhook(\WP_REST_Request $request)
     switch ($mapped) {
         case 'paid':
             if (!$order->is_paid()) {
-                $order->payment_complete();
-                if (PaymentStatus::all_items_downloadable_and_virtual($order)) {
-                    $order->update_status('completed');
+                // Reconcile against the amount recorded at order creation
+                // (Gateway::process_payment) before trusting a signed "paid"
+                // status — a validly-signed callback alone doesn't guarantee
+                // the full amount was received.
+                $expectedAmount = $order->get_meta('_dspay_token_amount');
+                $reportedAmount = $data['actualReceivedAmount'] ?? $data['payAmount'] ?? null;
+                $shortfall = ($expectedAmount !== '' && $reportedAmount !== null)
+                    ? (float) $expectedAmount - (float) $reportedAmount
+                    : 0;
+
+                if ($shortfall > 0.01) {
+                    $order->add_order_note(sprintf(
+                        __('DSPay callback reported paid, but received amount (%s) is short of the expected %s. Held for manual review, not auto-completed.', 'dspay-woocommerce'),
+                        $reportedAmount,
+                        $expectedAmount
+                    ));
+                    if (!$order->has_status('on-hold')) {
+                        $order->update_status('on-hold');
+                    }
+                    $logger->warning(sprintf(
+                        'Webhook: underpayment detected, expected=%s received=%s, order held for review',
+                        $expectedAmount,
+                        $reportedAmount
+                    ), $log_context);
+                } else {
+                    $order->payment_complete();
+                    if (PaymentStatus::all_items_downloadable_and_virtual($order)) {
+                        $order->update_status('completed');
+                    }
                 }
             }
             break;
```

Also on a branch on a fork if that's easier to pull from directly:
https://github.com/Svector-anu/USDTPAY-woocommerce/tree/fix/webhook-amount-validation
(deliberately not opened as a PR against your repo — didn't want the diff itself
public before you've had a chance to look, since it doubles as a roadmap to the
gap it fixes).

Happy to share more detail if useful — just didn't want to post this in a public
issue given the fraud angle. No SECURITY.md on the repo, so reaching out here
from your README's contact info.

Thanks for building in the open,
Anu
<!-- EMAIL-BODY-END -->

---

## Full technical writeup (for reference / if a GitHub PVR channel opens later)

### Summary
WooCommerce webhook handler completes orders based on a validly-signed `paid`
callback without validating the paid amount against the order total.

### Severity
Medium — business-logic/underpayment risk, not RCE/auth-bypass. Real-world
exploitability is contingent on the hosted cashier's own server-side enforcement,
which is outside this repo and unverifiable from here.

### CWE
CWE-840 (Business Logic Errors) — specifically, missing reconciliation between a
reported external event and the expected internal state before acting on it.

### Location
- `dspay-woocommerce.php`, `dspay_handle_webhook()`, `case 'paid':` branch (~line 242)
- `src/Gateway.php::process_payment()` stores `_dspay_token_amount` at order creation, never read back
- `src/PaymentStatus.php` — confirmed no amount logic exists anywhere in the plugin

### Verification
- Reproduced locally: no — static code review only; the amount-bypass path depends on cashier.ds.pro server behavior I don't have access to test
- Command: manual read-through of dspay_handle_webhook, Gateway.php, PaymentStatus.php
- Before: any signed `paid` callback completes the order regardless of amount
- After (suggested fix): amount is compared to `_dspay_token_amount` before completing; short payments route to manual review
- Environment: PHP (WooCommerce plugin), audited via GitHub API + local clone, 2026-08-18

### Detected by
Manual code review during a routine security scan (semgrep p/security-audit +
p/owasp-top-ten + p/secrets, trufflehog fs+git, osv-scanner all ran clean on this
repo separately) — this specific finding came from reading the webhook handler
directly, the highest-value file in a payment-processing plugin, not from an
automated tool hit.
