import json
p = "memory/vuln-scanned.json"
data = json.load(open(p))
notes = (
    "Forced target via var=stripe/stripe-php (bare owner/repo -> Arm A scan). 4,018 stars, PHP, "
    "Stripe's official PHP SDK. PVR disabled; org .github/SECURITY.md points to Stripe bug-bounty "
    "program (human-submission channel, out of scope for auto-disclosure, same pattern as "
    "stripe-cli 2026-09-04 and stripe-node 2026-09-05). Audited commit 12986995cd5e229cc094d4b57de056f8e2e6e5a9. "
    "semgrep: 2 hits, both CI mutable-action-tag hardening (not filed). trufflehog: 0 verified "
    "secrets (filesystem + bounded full git history, no timeout). osv-scanner: n/a (exit 128, "
    "no package sources -- composer.json has zero runtime deps, no committed composer.lock), same "
    "non-issue pattern as stripe-node/hono/paypal-js. Agentic pass (N=10 budget, 478 code files): "
    "deep-reviewed WebhookSignature::verifyHeader (HMAC-SHA256 + secureCompare + 300s tolerance), "
    "Util::secureCompare (hash_equals with constant-time fallback), Util::convertToStripeObject "
    "(webhook/API object-type string mapped only through a fixed class allowlist, no dynamic "
    "instantiation), ApiRequestor::assertNoHeaderInjection (CRLF/NUL rejected on every header "
    "including Authorization and the webhook-event-id-derived Stripe-Request-Trigger), CurlClient "
    "TLS defaults (verify=true unless developer opts out), and file upload (native CURLFile, no "
    "manual multipart boundary construction). No unserialize/eval/exec/extract sinks anywhere in "
    "lib/. 0 candidates survived triage. No .sol files (slither n/a), no fuzz/fuzz_targets (fuzz skip)."
)
data.append({
    "repo": "stripe/stripe-php",
    "scanned_at": "2026-09-05T18:20:00Z",
    "findings": 0,
    "channel": "clean",
    "notes": notes,
})
json.dump(data, open(p, "w"), indent=1)
print("appended; total entries:", len(data))
