# PRD: F-005 Multi-surface skill dispatch

Full stories, acceptance criteria, and verification commands live in `docs/product/feature-map.md`; this file adds what that one doesn't carry.

## Dependencies

- Depends on: nothing; this is foundational, every other feature depends on it.
- Blocks: correctness of every capability/secret-scoping claim any other feature makes, on every dispatch surface.

## Engineering notes

Not a single component; it's a discipline about where a security-relevant check is allowed to live. The concrete failure mode this session demonstrated (`F-002`'s `AC-002.2.2`): a check written once but only wired into one of several dispatch surfaces looks, from the surface that has it, like the system is correctly enforcing the rule everywhere. Nothing about that surface's own tests or behavior reveals the gap; only checking the other surfaces does.

The `apps/webhook` audit completed on 2026-09-17. It has no local skill
executor: it relays authenticated Telegram updates to `messages.yml`, which
routes skill requests through `scripts/telegram-route.sh` into `aeon.yml` with
the runtime selector preserved. Capability resolution and secret scoping
therefore happen on the canonical workflow path. The structural
`scripts/tests/test_webhook_capability_path.sh` gate protects that boundary: it
checks the relay chain and fails if the Worker acquires a direct harness path.
