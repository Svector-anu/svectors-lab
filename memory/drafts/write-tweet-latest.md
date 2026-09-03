## Tweet Drafts: accessibility is part of execution

### Tier 1 — One-liner
**1a. hot take**
> crypto apps are not usable if the interface locks people out.

**1b. reframe**
> accessibility bugs are execution bugs.

### Tier 2 — Two-punch
**2a. observation**
> a trading flow is not complete when only a mouse can finish it. keyboard and screen-reader support belong in the execution path.

**2b. sardonic**
> silent quote refresh looks smooth until the price changes without warning. good ux tells every user when execution moved.

### Tier 3 — Paragraph
**3a. data drop**
> fixed the keyboard, screen-reader, reduced-motion and silent quote-refresh gaps in skopos. 130 tests passed. accessibility work is product work because a trading interface has to be usable before it can be useful.

**3b. reframe**
> crypto keeps trying to hide wallet complexity while leaving basic interface complexity untouched. users should not need perfect vision, a mouse and motion tolerance just to place a trade. fixed that in skopos.

### Tier 4 — Long tweet
**4a. narrative**
> spent today fixing the parts of a trading interface that most demos never show: keyboard navigation, screen-reader labels, reduced-motion behavior and quote refresh announcements. 130 tests passed. if a user cannot understand that the price changed or complete the flow with their input method, the execution layer is not finished.

**4b. observation**
> accessibility bugs get treated like polish because they rarely break the happy-path demo. but a silent quote refresh can hide a changed execution price. a missing focus state can stop a trade. motion can make the app unusable. fixed those gaps in skopos and added tests because this is correctness work, not cleanup.

### Tier 5 — Thread opener
**5a. narrative**
> the hardest product bugs are often invisible in a demo. skopos looked fine with a mouse while keyboard, screen-reader, reduced-motion and quote-refresh flows still had gaps. fixed them.

---

- why mouse-only testing misses real blockers
- how silent quote refresh becomes an execution-risk problem
- the reduced-motion hydration bug and its test
- what 130 passing tests changed about confidence in the fix

**5b. structural critique**
> a non-custodial trading app can protect the user's keys and still fail them at the interface. accessibility is part of safe execution, not a separate polish pass.

---

- custody safety versus interaction safety
- keyboard and screen-reader failure modes in a trade flow
- why changing quotes must be announced
- making accessibility part of the definition of done

Best overall: **4b**. Best per tier: **1b, 2a, 3a, 4b, 5b**.
