---
title: Vuln Scanner — stripe/stripe-php
date: 2026-09-05
mode: scan
repo: stripe/stripe-php
---

# Vuln Scanner — stripe/stripe-php

**Verdict: clean audit. 2 candidates reviewed, 0 confirmed.**

## Repo metadata

- **Repo:** stripe/stripe-php (Stripe's official PHP SDK)
- **Stars:** 4,018 · **Language:** PHP · **Default branch:** master
- **Audited commit:** `12986995cd5e229cc094d4b57de056f8e2e6e5a9`
- **Forced target** via `var=stripe/stripe-php` (bare `owner/repo` → Arm A scan)
- **PVR:** disabled (`private-vulnerability-reporting.enabled = false`)
- **SECURITY.md:** none on the repo itself, but the `stripe/.github` org-level `SECURITY.md` routes all reports to Stripe's own [Vulnerability Disclosure and Reward Program](https://stripe.com/docs/security/stripe#disclosure-and-reward-program) — a human-submission bug-bounty channel, out of scope for this skill's PVR/email auto-disclosure (same pattern observed on stripe-cli 2026-09-04 and stripe-node 2026-09-05).

## Scanner sources

| Tool | Status | Notes |
|---|---|---|
| semgrep (`p/security-audit`, `p/owasp-top-ten`, `p/secrets`) | ok | 2 hits, both GitHub Actions mutable-action-tag hardening |
| trufflehog (filesystem, `--only-verified`) | ok | 0 verified secrets (2,243 chunks / 23.0MB scanned) |
| trufflehog (full git history, bounded 300s) | ok | 0 verified secrets (47,215 chunks / 45.0MB scanned, no timeout) |
| osv-scanner (`scan source --recursive --no-ignore`) | none (n/a, not fail) | exit 128 "No package sources found" — `composer.json` has zero runtime dependencies (`ext-curl`/`ext-json`/`ext-mbstring` PHP extensions only) and no committed `composer.lock`; nothing for osv to resolve. Same non-issue pattern as stripe-node/honojs/hono/paypal-js. |
| slither | skipped | no `.sol` files |
| cargo-fuzz | skipped | no `fuzz/fuzz_targets` harness |
| agentic (Claude-native source-to-sink review) | ok | 0 candidates survived triage (see below) |

## Candidate count / confirmed findings

**2 candidates reviewed, 0 confirmed.**

1. `yaml.github-actions.security.github-actions-mutable-action-tag` — `.github/workflows/ci.yml:141` and `:162`. Third-party GitHub Actions pinned by mutable tag rather than SHA. Hardening-class only (supply-chain best practice, not an exploitable flaw in this repo's own code) — consistent with prior stripe scans, not filed as a public PR.

## Agentic logic audit (A3.6)

**Threat model:** stripe-php is a client SDK wrapping HTTP calls to Stripe's API. The two things an attacker most wants from an SDK like this: (1) forge a webhook event to fool a merchant's server into believing a fake payment/event happened, and (2) get a merchant's API key or account/context header exfiltrated or corrupted via injection. Trust boundary: the webhook payload (arbitrary POST body an attacker can send to a merchant's webhook endpoint) is the only genuinely untrusted-input entrypoint this library handles; everything else is either the developer's own trusted config or Stripe's own TLS-verified API responses.

478 code files (excluding tests/vendor) → budget N=10. Entrypoints deep-reviewed:

- **`WebhookSignature::verifyHeader`** (`lib/WebhookSignature.php`) — HMAC-SHA256 over `{timestamp}.{payload}`, compared via `Util::secureCompare`, with a configurable replay-tolerance window (`Webhook::DEFAULT_TOLERANCE = 300`). Solid.
- **`Util::secureCompare`** (`lib/Util/Util.php:131`) — uses `hash_equals` when available, falls back to a manual constant-time loop (length-checked first, then XOR-accumulated, no early exit on content). No timing side-channel.
- **`Util::convertToStripeObject`** (`lib/Util/Util.php:47`) — maps the attacker-influenced `object`/`type` string from API/webhook JSON to a PHP class, but only ever through a fixed, hardcoded allowlist (`ObjectTypes::mapping` / `EventTypes::v2EventMapping`) — never `class_exists()`/dynamic instantiation on the raw string. No object-injection gadget.
- **`ApiRequestor::assertNoHeaderInjection`** (`lib/ApiRequestor.php:527`) — rejects CR/LF/NUL in every header name and value, applied uniformly across `$combinedHeaders` (`_prepareRequest`, line 629) — this covers the `Authorization` header (built from the API key), `Stripe-Account`, and any caller-supplied headers including `Stripe-Context`/`Stripe-Request-Trigger`, the latter of which `fetchRelatedObject()` (across ~40 `Events/*.php` classes) builds from the webhook's own event ID. Traced this specifically because of an in-code comment flagging that these values "originate in remote data" — confirmed the CRLF/NUL guard is applied before any of them reach the raw header line, so an attacker-controlled event ID containing `\r\n` throws `InvalidArgumentException` rather than injecting a header. Not exploitable.
- **CurlClient TLS handling** (`lib/HttpClient/CurlClient.php:310-318`) — `CURLOPT_CAINFO` set unconditionally; `CURLOPT_SSL_VERIFYPEER` is disabled only if the developer explicitly calls `Stripe::setVerifySslCerts(false)` — default (`Stripe::$verifySslCerts = true`, `lib/Stripe.php:38`) verifies certs. Standard opt-out, not a vulnerability.
- **File upload path** (`lib/ApiRequestor.php:610`, `lib/File.php`) — uses native `CURLFile` + curl's own multipart encoder rather than hand-building the multipart body/boundary, so there's no manual header-construction step to get wrong (contrast with the boundary-escaping code stripe-node has to carry).
- **Dangerous PHP sinks** — swept `lib/` for `unserialize`, `eval`, `assert`, `create_function`, `shell_exec`/`passthru`/`system`/`proc_open`, `extract`: zero hits.

Reviewed-but-not-deep (past the N=10 budget, no red flags on a shallow pass): `lib/OAuth.php` / `Service/OAuthService.php` (outbound-only, calls Stripe's own token endpoint), `lib/HttpClient/StreamingClientInterface.php`, the per-resource `Service/*.php` classes (generated CRUD wrappers that just forward params to `ApiRequestor`, not independently security-sensitive), retry/backoff logic in `ApiRequestor`.

0 candidates written to `agentic.json` / survived triage.

## PoC gate status

**Not required** — no HIGH/CRITICAL candidate survived A4 triage, so the A4.5 PoC-verification gate was never invoked.

## Dedup note

No prior scan of stripe/stripe-php in `memory/vuln-scanned.json` (30-day window). This run's result recorded there now.

## Disclosure

No confirmed findings → nothing routed. The 2 semgrep hits are hardening-class CI supply-chain items, consistent with the operator's existing pattern of not filing hardening-only PRs against this org.

---

## Summary

- Scanned `stripe/stripe-php` (forced target `var=stripe/stripe-php`) at commit `1298699`.
- Ran semgrep (ok, 2 hardening-only hits), trufflehog filesystem + bounded git-history (ok, 0 verified secrets both passes), osv-scanner (n/a — zero runtime deps, no lockfile), and a Claude-native agentic source-to-sink review of webhook signature verification, header-injection defenses, object-type mapping, TLS defaults, and file-upload handling (0 candidates).
- **Clean audit — no disclosure filed.**
- Files written: `output/articles/vuln-scan-2026-09-05-stripe-php.md` (this report); scratch artifacts under `vuln-scan-stripe-php/` (semgrep.json, trufflehog.json, agentic.json, sources.txt); appended to `memory/vuln-scanned.json`; will append to `memory/logs/2026-09-05.md` and `memory/MEMORY.md`.
- Follow-up: none required — repo has no unresolved findings. Fork at `Svector-anu/stripe-php` can be deleted or left for future re-scans (skip window: 30 days from 2026-09-05).
