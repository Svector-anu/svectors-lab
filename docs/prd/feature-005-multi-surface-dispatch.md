# PRD: F-005 Multi-surface skill dispatch

Full stories, acceptance criteria, and verification commands live in `docs/product/feature-map.md`; this file adds what that one doesn't carry.

## Dependencies

- Depends on: nothing; this is foundational, every other feature depends on it.
- Blocks: correctness of every capability/secret-scoping claim any other feature makes, on every dispatch surface.

## Engineering notes

Not a single component; it's a discipline about where a security-relevant check is allowed to live. The concrete failure mode this session demonstrated (`F-002`'s `AC-002.2.2`): a check written once but only wired into one of several dispatch surfaces looks, from the surface that has it, like the system is correctly enforcing the rule everywhere. Nothing about that surface's own tests or behavior reveals the gap; only checking the other surfaces does.

`apps/webhook` is the one dispatch surface this session did not audit for the same class of gap (see `roadmap.md`, "Now"). Given the MCP-server and `aeon.yml` paths both needed this fix independently discovered, treating the webhook path as "probably fine" without checking would repeat the exact mistake this feature exists to name.
