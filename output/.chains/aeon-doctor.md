⚠️ aeon-doctor: 21 config issue(s)

# Aeon Doctor findings

No critical issues. The enabled fleet will still fire with the intended privilege.

## Warnings (21)

### 7 on-disk skills are absent from `aeon.yml`

These silently default to disabled, so the Actions tab cannot distinguish intentional removal from forgotten configuration:

- `skills/competitor-monitor/SKILL.md:2`
- `skills/higgsfield/SKILL.md:2`
- `skills/remotion/SKILL.md:2`
- `skills/skill-article/SKILL.md:2`
- `skills/spend-watch/SKILL.md:2`
- `skills/video-script/SKILL.md:2`
- `skills/weekly-aeoncard/SKILL.md:2`

Exact safe fix to record them as deliberately installed-but-off (then enable/configure individually in `./aeon` if wanted):

```bash
sed -i '9a\  competitor-monitor: { enabled: false, schedule: "workflow_dispatch", var: "" }\n  higgsfield: { enabled: false, schedule: "workflow_dispatch", var: "" }\n  remotion: { enabled: false, schedule: "workflow_dispatch", var: "" }\n  skill-article: { enabled: false, schedule: "workflow_dispatch", var: "" }\n  spend-watch: { enabled: false, schedule: "workflow_dispatch", var: "" }\n  video-script: { enabled: false, schedule: "workflow_dispatch", var: "" }\n  weekly-aeoncard: { enabled: false, schedule: "workflow_dispatch", var: "" }' aeon.yml
```

### 13 inert schedules in skill frontmatter

`scheduler.yml` ignores these declarations silently; only the corresponding `aeon.yml` schedules are live:

- `skills/aeon-update/SKILL.md:11`
- `skills/fear-divergence/SKILL.md:6`
- `skills/fleet-control/SKILL.md:16`
- `skills/fork-fleet/SKILL.md:10`
- `skills/hunter-22/SKILL.md:11`
- `skills/inbox-triage/SKILL.md:12`
- `skills/mention-radar/SKILL.md:7`
- `skills/narrative-tracker/SKILL.md:5`
- `skills/picks-tracker/SKILL.md:7`
- `skills/schedule-ads/SKILL.md:17`
- `skills/soul-builder/SKILL.md:6`
- `skills/strategy-builder/SKILL.md:6`
- `skills/unlock-monitor/SKILL.md:7`

Exact fix:

```bash
sed -i -e '11{/^[[:space:]]*cron:/d;}' skills/aeon-update/SKILL.md; sed -i -e '6{/^[[:space:]]*schedule:/d;}' skills/fear-divergence/SKILL.md; sed -i -e '16{/^[[:space:]]*cron:/d;}' skills/fleet-control/SKILL.md; sed -i -e '10{/^[[:space:]]*cron:/d;}' skills/fork-fleet/SKILL.md; sed -i -e '11{/^[[:space:]]*schedule:/d;}' skills/hunter-22/SKILL.md; sed -i -e '12{/^[[:space:]]*schedule:/d;}' skills/inbox-triage/SKILL.md; sed -i -e '7{/^[[:space:]]*schedule:/d;}' skills/mention-radar/SKILL.md; sed -i -e '5{/^[[:space:]]*schedule:/d;}' skills/narrative-tracker/SKILL.md; sed -i -e '7{/^[[:space:]]*schedule:/d;}' skills/picks-tracker/SKILL.md; sed -i -e '17{/^[[:space:]]*schedule:/d;}' skills/schedule-ads/SKILL.md; sed -i -e '6{/^[[:space:]]*schedule:/d;}' skills/soul-builder/SKILL.md; sed -i -e '6{/^[[:space:]]*schedule:/d;}' skills/strategy-builder/SKILL.md; sed -i -e '7{/^[[:space:]]*schedule:/d;}' skills/unlock-monitor/SKILL.md
```

### `fear-divergence` daily-log heading is not keyed by slug

`skills/fear-divergence/SKILL.md:136` and `:147` use `## Fear Divergence Scout`; health attribution expects `### fear-divergence`, so this silently degrades log attribution.

Exact fix:

```bash
sed -i 's/^## Fear Divergence Scout$/### fear-divergence/' skills/fear-divergence/SKILL.md
```

Route these mechanical edits through `skill-repair` or apply them in a write-enabled run.