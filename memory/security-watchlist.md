---
type: Reference
title: Security Watchlist
description: Repos with a real, verified finding staged for private disclosure but no PVR channel yet — probed by the vuln-scanner resubmit arm (Arm B) to check whether PVR flips on so the staged advisory can go out the proper channel instead of email.
tags: [security, vuln-scanner, watchlist]
timestamp: 2026-08-25T12:00:00Z
---

# Security Watchlist

| owner/repo | severity | short-title | first-checked | last-checked | status |
|---|---|---|---|---|---|
| DigitalShieldOfficial/USDTPAY-woocommerce | medium | webhook completes orders without validating paid amount | 2026-08-18 | 2026-08-19 | sent 2026-08-19, awaiting vendor response |
| z-fi/zFi | informational (was critical, recalibrated) | zRouter.multicall msg.value reuse — audit record says patched, isn't, but sweep() already permissionlessly exposes the same funds more easily | 2026-08-19 | 2026-08-19 | sent + discussed with author (z0r0z), severity conceded down after his pushback; Matcha-family (Finding 2, medium) confirmed to still stand, no equivalent redundant path exists there |
| ZSvirt/zsvirt | CRITICAL | committed private RSA key deployed as root SSH cred to every managed node; separately, TLS validation disabled by default + unverified JWT signature = SSO auth-bypass chain | 2026-08-23 | 2026-08-23 | sent + ACKNOWLEDGED by vendor 2026-08-23 — confirmed severity, committed to key rotation + per-install unique keys + REST-client TLS/JWT audit, matching the suggested fixes |
| ZSvirt/zsvirt | medium | Spring Security 5.7.13 auth-bypass CVE (trivial fix to 5.7.14); Spring Framework 5.2.25 needs a major-version migration | 2026-08-23 | 2026-08-23 | pending-operator-send, lower priority now that the critical one is acknowledged (see memory/pending-disclosures/ZSvirt-zsvirt-2026-08-23.md) |
| amirh00sain/SpiderPanel | high | default admin credentials + hardcoded secret salt; session cookie and CORS hardening | 2026-08-25 | 2026-08-25 | armed-for-auto-send (see memory/pending-disclosures/amirh00sain-SpiderPanel-2026-08-25.md) |
