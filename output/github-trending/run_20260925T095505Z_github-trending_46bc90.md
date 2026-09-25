## GitHub Trending — 2026-09-25

**Top pick** — [vectorize-io/hindsight](https://github.com/vectorize-io/hindsight)
Only pick backed by a co-authored academic paper (Virginia Tech + Washington Post) with a published benchmark, not just a README claim.

**AI/ML**
• [vectorize-io/hindsight](https://github.com/vectorize-io/hindsight) — ★ 1,668t today (28.4k total) · Python · [ACCELERATING]
Open-source agent memory hitting 91.4% on LongMemEval — Virginia Tech/Washington Post co-authored, positioned as RAG's replacement.

**Devtools**
• [mvt-project/mvt](https://github.com/mvt-project/mvt) — ★ 272t today (14.8k total) · Python · [RETURNING]
iOS 26 broke single-artifact spyware detection this month — researchers now lean on MVT for multi-signal forensic corroboration.

**Web/Apps**
• [julyx10/lap](https://github.com/julyx10/lap) — ★ 122t today (3.0k total) · Vue · [RETURNING]
Fresh v0.3.2 adds map view with geotag clustering and Google Motion Photo playback for 100k+-file offline photo libraries.

---
sources: trending=ok · gh_api=ok · kept 3/14

Thin day: 14 candidates on the trending page, 7 of them dedup-dropped as repeats from the last two well-covered days (dream-num/univer, google/ax, anthropics/financial-services, superdesigndev/treg from 09-23; HKUDS/CLI-Anything, obra/superpowers, strands-agents/harness-sdk from 09-24 — none had a fresh catalyst on re-check). One tutorial-curriculum bundle and one no-hook repo dropped for weak signal, two dropped for sub-50-star low activity on old repos.

## Summary
- Ran GitHub Trending branch (`Operator var` empty → default, no language filter).
- Fetched `github.com/trending?since=daily` via curl (200 OK), parsed 14 candidates.
- Deduped against 09-23/09-24 logs (7 dropped), filtered noise (2 weak-signal, 2 low-activity), enriched survivors via `gh api` + web search.
- Shipped 3 curated picks (hindsight, mvt, lap) across 3 buckets — below the usual 5-8 target due to heavy back-to-back-day dedupe, not padded.
- Logged full run detail to `memory/logs/2026-09-25.md` under `### github-trending` (branch discriminator + picks + drop reasons + source status), run_id `run_20260925T095505Z_github-trending_46bc90`.
- Exit: `GITHUB_TRENDING_OK`. No further action needed; MiniAeon delivers this via Telegram.
