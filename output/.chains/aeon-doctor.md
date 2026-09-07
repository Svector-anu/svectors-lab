⚠️ aeon-doctor: 22 config issue(s)

## Warnings

### 7 on-disk skills are absent from `aeon.yml`

These skills silently default to disabled and never appear as deliberately configured choices. Decide whether each should remain uninstalled; to register it safely as disabled, run the command shown.

- `competitor-monitor` — `skills/competitor-monitor/SKILL.md:2`. Fix: `sed -i '/^  # --- Fallback/i\  competitor-monitor: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml && node scripts/validate-config.js`
- `higgsfield` — `skills/higgsfield/SKILL.md:2`. Fix: `sed -i '/^  # --- Fallback/i\  higgsfield: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml && node scripts/validate-config.js`
- `remotion` — `skills/remotion/SKILL.md:2`. Fix: `sed -i '/^  # --- Fallback/i\  remotion: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml && node scripts/validate-config.js`
- `skill-article` — `skills/skill-article/SKILL.md:2`. Fix: `sed -i '/^  # --- Fallback/i\  skill-article: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml && node scripts/validate-config.js`
- `spend-watch` — `skills/spend-watch/SKILL.md:2`. Fix: `sed -i '/^  # --- Fallback/i\  spend-watch: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml && node scripts/validate-config.js`
- `video-script` — `skills/video-script/SKILL.md:2`. Fix: `sed -i '/^  # --- Fallback/i\  video-script: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml && node scripts/validate-config.js`
- `weekly-aeoncard` — `skills/weekly-aeoncard/SKILL.md:2`. Fix: `sed -i '/^  # --- Fallback/i\  weekly-aeoncard: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml && node scripts/validate-config.js`

### 14 inert schedules in skill frontmatter

These schedule declarations are silently ignored; only `aeon.yml` controls dispatch. Remove each inert line so future editors do not mistake it for the live schedule.

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

### 1 daily-log heading is not keyed by slug

- `fear-divergence` — `skills/fear-divergence/SKILL.md` logs under `## Fear Divergence`, so health attribution and cross-skill dedup silently degrade. Fix: `sed -i 's/^## Fear Divergence$/### fear-divergence/' skills/fear-divergence/SKILL.md`

No critical issues were found. Unquoted schedules, duplicate keys, enabled entries without skill files, invalid `requires:` values, invalid modes, unresolved MCP variables, multiline entries, unquoted model/harness overrides, and invalid categories all passed.