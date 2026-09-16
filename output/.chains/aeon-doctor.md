⚠️ aeon-doctor: 22 config issue(s)

## Warnings (22)

These defects are silent: none creates a failed run in the Actions tab.

### On disk but absent from `aeon.yml` (7)

- `competitor-monitor` — `skills/competitor-monitor/SKILL.md:2` exists but has no config entry, so it is indistinguishable from deliberately disabled. Register it disabled with: `sed -i '/^  # --- Fallback/i\  competitor-monitor: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `higgsfield` — `skills/higgsfield/SKILL.md:2` exists but has no config entry. Fix: `sed -i '/^  # --- Fallback/i\  higgsfield: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `remotion` — `skills/remotion/SKILL.md:2` exists but has no config entry. Fix: `sed -i '/^  # --- Fallback/i\  remotion: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `skill-article` — `skills/skill-article/SKILL.md:2` exists but has no config entry. Fix: `sed -i '/^  # --- Fallback/i\  skill-article: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `spend-watch` — `skills/spend-watch/SKILL.md:2` exists but has no config entry. Fix: `sed -i '/^  # --- Fallback/i\  spend-watch: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `video-script` — `skills/video-script/SKILL.md:2` exists but has no config entry. Fix: `sed -i '/^  # --- Fallback/i\  video-script: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `weekly-aeoncard` — `skills/weekly-aeoncard/SKILL.md:2` exists but has no config entry. Fix: `sed -i '/^  # --- Fallback/i\  weekly-aeoncard: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`

If any is intentionally uninstalled, removing its directory instead is the alternative; use `skill-repair` to make the chosen mechanical change.

### Inert schedules in skill frontmatter (14)

The scheduler reads only `aeon.yml`; each declaration below looks load-bearing but is ignored. Remove the inert line (the real schedules already live in `aeon.yml`):

- `aeon-update` — `skills/aeon-update/SKILL.md:11`. Fix: `sed -i '11d' skills/aeon-update/SKILL.md`
- `fear-divergence` — `skills/fear-divergence/SKILL.md:6`. Fix: `sed -i '6d' skills/fear-divergence/SKILL.md`
- `fleet-control` — `skills/fleet-control/SKILL.md:16`. Fix: `sed -i '16d' skills/fleet-control/SKILL.md`
- `fork-fleet` — `skills/fork-fleet/SKILL.md:10`. Fix: `sed -i '10d' skills/fork-fleet/SKILL.md`
- `hunter-22` — `skills/hunter-22/SKILL.md:11`. Fix: `sed -i '11d' skills/hunter-22/SKILL.md`
- `inbox-triage` — `skills/inbox-triage/SKILL.md:12`. Fix: `sed -i '12d' skills/inbox-triage/SKILL.md`
- `mention-radar` — `skills/mention-radar/SKILL.md:7`. Fix: `sed -i '7d' skills/mention-radar/SKILL.md`
- `narrative-tracker` — `skills/narrative-tracker/SKILL.md:5`. Fix: `sed -i '5d' skills/narrative-tracker/SKILL.md`
- `picks-tracker` — `skills/picks-tracker/SKILL.md:7`. Fix: `sed -i '7d' skills/picks-tracker/SKILL.md`
- `schedule-ads` — `skills/schedule-ads/SKILL.md:17`. Fix: `sed -i '17d' skills/schedule-ads/SKILL.md`
- `slop-watch` — `skills/slop-watch/SKILL.md:11`. Fix: `sed -i '11d' skills/slop-watch/SKILL.md`
- `soul-builder` — `skills/soul-builder/SKILL.md:6`. Fix: `sed -i '6d' skills/soul-builder/SKILL.md`
- `strategy-builder` — `skills/strategy-builder/SKILL.md:6`. Fix: `sed -i '6d' skills/strategy-builder/SKILL.md`
- `unlock-monitor` — `skills/unlock-monitor/SKILL.md:7`. Fix: `sed -i '7d' skills/unlock-monitor/SKILL.md`

### Health-log attribution (1)

- `fear-divergence` — `skills/fear-divergence/SKILL.md:136` and `:147` prescribe `## Fear Divergence Scout`, so the health loop cannot key the narrative log by slug. Fix both examples with: `sed -i 's/^## Fear Divergence Scout$/### fear-divergence/' skills/fear-divergence/SKILL.md`

No critical findings. Duplicate keys, enabled missing skills, invalid `requires:`, mode typos, unresolved MCP variables, split config entries, unquoted schedules/overrides, and invalid categories are clean.