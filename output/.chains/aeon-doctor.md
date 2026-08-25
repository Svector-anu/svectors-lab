⚠️ aeon-doctor: 20 config issue(s)

## Warnings

### Installed but unconfigured (6)
These skills are invisible to the scheduler: no `aeon.yml` entry exists, so no failure appears in Actions. Enable each if intended; otherwise accept it as deliberately off.

- `competitor-monitor` — `skills/competitor-monitor/SKILL.md:1`. Fix: `./aeon skills enable competitor-monitor`
- `higgsfield` — `skills/higgsfield/SKILL.md:1`. Fix: `./aeon skills enable higgsfield`
- `remotion` — `skills/remotion/SKILL.md:1`. Fix: `./aeon skills enable remotion`
- `spend-watch` — `skills/spend-watch/SKILL.md:1`. Fix: `./aeon skills enable spend-watch`
- `video-script` — `skills/video-script/SKILL.md:1`. Fix: `./aeon skills enable video-script`
- `weekly-aeoncard` — `skills/weekly-aeoncard/SKILL.md:1`. Fix: `./aeon skills enable weekly-aeoncard`

### Inert frontmatter schedules (13)
These `schedule:`/`cron:` lines are silently ignored; only `aeon.yml` controls dispatch. Remove each inert line so editors do not mistake it for live configuration.

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

### Health-log attribution (1)
- `fear-divergence` — `skills/fear-divergence/SKILL.md:136` and `:147` instruct logs under `## Fear Divergence Scout`, so the health loop cannot silently attribute them to the skill slug. Fix: `sed -i 's/^## Fear Divergence Scout$/### fear-divergence/' skills/fear-divergence/SKILL.md`

Ask `skill-repair` to apply and verify these mechanical changes. No critical issues were detected.