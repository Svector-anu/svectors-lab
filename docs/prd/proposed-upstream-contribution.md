# Proposed feature

Per `references/scope-control.md`: an idea noticed mid-task, reported rather than built.

---

**Potential improvement discovered:** a dedicated skill for auditing this fork against `aeonfun/aeon` upstream and porting genuine gaps back, on a schedule.

**Status:** Not currently in product map.

**Where this came from:** manually auditing ~43 recent fork PRs against upstream in one session (2026-09-16), finding 4 real, confirmed gaps (one a live security isolation gap affecting every Aeon operator, not just this fork) that had sat unported for up to two weeks. That process was entirely manual: list recent fork PRs, list recent upstream PRs, cross-reference by title and file path, verify each candidate by diffing actual file content rather than trusting titles, classify fork-specific-by-design versus genuinely-missing, port and verify the real gaps.

**Why it might be worth doing:** the fork/upstream drift compounds. A gap sitting unported for two weeks is a gap sitting unported indefinitely once nobody's doing the audit by hand. The security gap found this session (`F-002`'s `AC-002.2.2`) is the concrete argument: it existed identically upstream, unpatched, until this manual pass found it.

**Rough scope, if approved:** a skill that lists both repos' recent merged PRs, matches by touched-file overlap and content diff (not title heuristics alone, which produced at least one near-miss this session), classifies each as already-upstream / fork-specific / genuine-gap, and either opens the port PR directly for small, low-risk fixes or reports a proposal for anything larger (matching the mechanical-vs-propose split this system already uses in Maintain mode). Explicitly NOT scoped to auto-merge anything; a port PR still needs the same CI-green + independent-review bar as any other change.

**Action:** report as a proposed feature. Do not implement unless explicitly approved.

---
