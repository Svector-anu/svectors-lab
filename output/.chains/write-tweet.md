## Tweet Drafts: a CVE count is not an attack surface

### Tier 1 — One-liner

**1a. Hot take**

> a CVE count is not an attack surface

**1b. Data drop**

> 79 dependency CVEs, zero shipped runtime exposure. reachability matters.

### Tier 2 — Two-punch

**2a. Reframe**

> scanners find vulnerable versions. engineers still have to prove those versions ship, run, and are reachable.

**2b. Sardonic**

> 79 CVE rows looks terrifying. then you check the published package and find none of those dependencies reach production.

### Tier 3 — Paragraph

**3a. Observation**

> a dependency scanner gives you candidates, not conclusions. the package may be vulnerable, dev-only, or trapped in a benchmark lockfile. the real security work starts after the report lands.

**3b. Data drop**

> paypal-js returned 79 dependency CVE rows. zero touched either published package at runtime. counting findings is easy. proving what users install and attackers can reach is the security work.

### Tier 4 — Long tweet

**4a. Narrative**

> scanned paypal-js today and got 79 dependency CVE rows. looked bad until i traced what actually ships. every flagged package lived in dev tooling, while the two published packages only carry a tiny runtime set with zero overlap. scanners are good at finding versions. they cannot replace checking the artifact, dependency role, and reachable path.

**4b. Observation**

> security scanners are candidate generators, not verdict machines. paypal-js produced 79 dependency CVE rows today, but none were part of the published runtime surface. the same pattern showed up in hono and stripe-node. if an audit ends at the count, it is measuring lockfile noise. the job is to prove what ships and whether an attacker can reach it.

### Tier 5 — Thread opener

**5a. Data drop**

> i scanned paypal-js and found 79 dependency CVE rows. then i checked the published packages. zero of those dependencies shipped at runtime. this is why vulnerability counts without reachability are mostly noise.

---

- Why lockfiles overstate production exposure
- How to inspect published artifacts and dependency roles
- Where reachability turns a CVE into real risk
- The same pattern in Hono and Stripe Node

**5b. Reframe**

> three clean audits taught me the same thing: a scary dependency report can describe tooling and benchmark code, not the product users install. the lockfile is evidence. it is not the attack surface.

---

- What the scanners correctly found
- Why dev tooling and benchmarks appeared
- Tracing what users actually install
- A better audit verdict than counting rows

Best overall: **#4b**. Best per tier: **#1a, #2b, #3b, #4b, #5a**.

## Summary

- Saved the complete batch to [write-tweet-latest.md](/home/runner/work/svectors-lab/svectors-lab/memory/drafts/write-tweet-latest.md).
- Recorded the run in [2026-09-05.md](/home/runner/work/svectors-lab/svectors-lab/memory/logs/2026-09-05.md).
- Verified every tweet against its character limit.
- xAI enrichment was skipped because its key was unset.
- Notification and revision-offer delivery were attempted, but the external queue was read-only.
