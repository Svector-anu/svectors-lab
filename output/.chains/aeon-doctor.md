⚠️ aeon-doctor: 20 config issue(s)

No critical defects. Static validation passed; these 20 warnings are silent config traps and will not appear as failed Actions runs.

## Warnings

### On disk but unconfigured (6)

These skills have a `SKILL.md` but no `aeon.yml` entry, so they default to disabled and are invisible to scheduling. Add each as an explicit disabled/on-demand entry, then enable or schedule it deliberately.

- `competitor-monitor` — `skills/competitor-monitor/SKILL.md:1`. Fix: `sed -i '/^  # --- Fallback/i\  competitor-monitor: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `higgsfield` — `skills/higgsfield/SKILL.md:1`. Fix: `sed -i '/^  # --- Fallback/i\  higgsfield: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `remotion` — `skills/remotion/SKILL.md:1`. Fix: `sed -i '/^  # --- Fallback/i\  remotion: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `spend-watch` — `skills/spend-watch/SKILL.md:1`. Fix: `sed -i '/^  # --- Fallback/i\  spend-watch: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `video-script` — `skills/video-script/SKILL.md:1`. Fix: `sed -i '/^  # --- Fallback/i\  video-script: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`
- `weekly-aeoncard` — `skills/weekly-aeoncard/SKILL.md:1`. Fix: `sed -i '/^  # --- Fallback/i\  weekly-aeoncard: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml`

### Inert schedule/cron metadata (13)

These frontmatter fields are never read by the scheduler; only the corresponding `aeon.yml` row controls cadence. Remove each inert line to prevent future editors from changing the wrong schedule.

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
- `soul-builder` — `skills/soul-builder/SKILL.md:6`. Fix: `sed -i '6d' skills/soul-builder/SKILL.md`
- `strategy-builder` — `skills/strategy-builder/SKILL.md:6`. Fix: `sed -i '6d' skills/strategy-builder/SKILL.md`
- `unlock-monitor` — `skills/unlock-monitor/SKILL.md:7`. Fix: `sed -i '7d' skills/unlock-monitor/SKILL.md`

### Unparseable daily-log heading (1)

- `fear-divergence` — `skills/fear-divergence/SKILL.md:136` and `:147` instruct `## Fear Divergence Scout`; the health loop expects `### fear-divergence`, so attribution silently degrades. Fix: `sed -i '136s/^## Fear Divergence Scout$/### fear-divergence/;147s/^## Fear Divergence Scout$/### fear-divergence/' skills/fear-divergence/SKILL.md`

Have `skill-repair` apply and validate these mechanical fixes, or make them through the dashboard/config workflow. This diagnostic made no repository changes.

AEON_DOCTOR_FINDINGS