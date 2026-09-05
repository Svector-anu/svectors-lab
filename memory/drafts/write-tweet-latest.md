tweet drafts: a CVE count is not an attack surface

— one-liner —
1a. a CVE count is not an attack surface
1b. 79 dependency CVEs, zero shipped runtime exposure. reachability matters.

— two-punch —
2a. scanners find vulnerable versions. engineers still have to prove those versions ship, run, and are reachable.
2b. 79 CVE rows looks terrifying. then you check the published package and find none of those dependencies reach production.

— paragraph —
3a. a dependency scanner gives you candidates, not conclusions. the package may be vulnerable, dev-only, or trapped in a benchmark lockfile. the real security work starts after the report lands.
3b. paypal-js returned 79 dependency CVE rows. zero touched either published package at runtime. counting findings is easy. proving what users install and attackers can reach is the security work.

— long tweet —
4a. scanned paypal-js today and got 79 dependency CVE rows. looked bad until i traced what actually ships. every flagged package lived in dev tooling, while the two published packages only carry a tiny runtime set with zero overlap. scanners are good at finding versions. they cannot replace checking the artifact, dependency role, and reachable path.
4b. security scanners are candidate generators, not verdict machines. paypal-js produced 79 dependency CVE rows today, but none were part of the published runtime surface. the same pattern showed up in hono and stripe-node. if an audit ends at the count, it is measuring lockfile noise. the job is to prove what ships and whether an attacker can reach it.

— thread opener —
5a. i scanned paypal-js and found 79 dependency CVE rows. then i checked the published packages. zero of those dependencies shipped at runtime. this is why vulnerability counts without reachability are mostly noise.
---
- why lockfiles overstate the production surface
- how to inspect the published artifact and dependency roles
- where reachability changes a CVE from noise into risk
- the same pattern in hono and stripe-node

5b. three clean audits taught me the same thing: a scary dependency report can describe tooling and benchmark code, not the product users install. the lockfile is evidence. it is not the attack surface.
---
- what the scanners correctly found
- why dev tooling and benchmarks still appeared
- tracing what users actually install
- a better audit verdict than counting rows

best overall: #4b — observation / long tweet
best per tier: #1a, #2b, #3b, #4b, #5a
