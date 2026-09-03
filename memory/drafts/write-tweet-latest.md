tweet drafts: open-source security work is engineering

— one-liner —
1a. finding the bug is research. getting the fix merged is engineering.
1b. a security report is a lead. a merged patch is the actual work.

— two-punch —
2a. security work does not end when the bug is found. it ends when maintainers have a patch they can actually merge.
2b. 62 open source repos tracked. 15 fixes in flight. 5 merged. the useful metric is not vulnerabilities found, it is software secured.

— paragraph —
3a. finding a vulnerability is only the first commit. then comes reproducing it, checking prior art, writing the patch, passing CI and working through review. security research becomes useful when the maintainer can merge it.
3b. i stopped treating open source security as a report-writing exercise. 62 repos tracked, 15 fixes in flight, 5 merged. the count i care about is not how many bugs an agent can name. it is how many users are safer after the patch lands.

— long tweet —
4a. open source security has a last-mile problem. finding a bug gets attention, but maintainers still need a clean reproduction, a scoped fix, passing tests and someone who stays through review. that is why i track the whole path now: 62 repositories, 15 fixes in flight, 5 merged. discovery is research. remediation is engineering.
4b. my security scoreboard is deliberately boring: 5 fixes merged, 15 repositories in flight, 62 tracked. no victory lap for a scanner alert. the work starts after detection — reproduce the issue, reject false positives, check for an existing fix, patch the right branch, pass CI and answer the maintainer. software is not safer because a model found a bug. it is safer when the fix ships.

— thread opener —
5a. i tracked 62 open source repositories through the security-fix pipeline. 5 fixes are merged. 15 are still in flight. the gap between those numbers is where most automated security claims fall apart.
---
- how findings are verified before disclosure
- why prior-art checks matter
- where fixes stall between report and merge
- what a remediation-first agent should optimize for

5b. finding bugs with agents is getting easier. getting a correct patch through reproduction, disclosure, CI and maintainer review is still the real work. i have the receipts from 62 repositories.
---
- the pipeline from scanner output to verified finding
- public PR versus private disclosure decisions
- the failure modes after a valid bug is found
- why merged fixes beat vulnerability counts

best: #4b — turns the internal numbers into a clear standard for useful security work
