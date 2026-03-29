# spider-backup — Backup & Restore Skill

Spider owns the backup system for the entire OpenClaw platform. This skill covers what's backed up, how to run a manual backup, and how to restore on a new machine.

## What Gets Backed Up

Daily at 23:00 UTC via `agent-config-backup` cron (script: `workspace-spider/scripts/agent-backup.sh`):

- All 10 agent workspace files (SOUL, AGENTS, IDENTITY, MEMORY, USER, TOOLS, HEARTBEAT, BOOT, BOOTSTRAP)
- Per-agent memory/ dirs, skills/ dirs, scripts/, ops/
- Platform config: `openclaw.json` (secrets sanitized), cron-jobs.json, paired-devices.json
- Shared skills: `~/.openclaw/skills/`
- Shared scripts: `~/.openclaw/scripts/`
- Hooks: `~/.openclaw/hooks/`
- Systemd service files
- PROTOCOLS.md

Destination: `buddy-team` GitHub repo → `infra/backup/`

## What Is NOT Backed Up

- Secrets/tokens in raw form (sanitized to REDACTED in openclaw.json)
- SQLite memory databases (`~/.openclaw/memory/*.sqlite`) — vector DB, not text
- Session transcripts
- Monitoring snapshots (`~/.openclaw/monitoring/snapshots/`)
- Log files

## Running a Manual Backup

```bash
bash /home/midang/.openclaw/workspace-spider/scripts/agent-backup.sh
```

Check result:
```bash
cd /home/midang/.openclaw/repo && git log --oneline -3
```

## Restoring on a New Machine

Full instructions: `infra/backup/README.md` in the `buddy-team` repo.

### Quick steps:
1. Install OpenClaw: `npm install -g openclaw`
2. Copy `platform/openclaw.json.template` → `~/.openclaw/openclaw.json`, fill in secrets
3. Copy agent workspace files from `agents/<id>/` to each agent's workspace path
4. Copy shared skills to `~/.openclaw/skills/`
5. Copy hooks to `~/.openclaw/hooks/`, enable with `openclaw hooks enable <name>`
6. Copy systemd units to `~/.config/systemd/user/`, reload + enable gateway
7. Start gateway: `openclaw gateway start`
8. Re-register agents (reference `openclaw.json` for IDs/names/models)
9. Re-register cron jobs (reference `platform/cron-jobs.json`)
10. Run `openclaw doctor` to verify

## Partial Restore Scenarios

**Single agent down / corrupted:**
```bash
cp -r infra/backup/agents/<id>/. ~/.openclaw/workspace-<id>/
# No gateway restart needed — files are read at next session start
```

**Config corrupted:**
```bash
cp infra/backup/platform/openclaw.json ~/.openclaw/openclaw.json
# Fill in REDACTED secrets, then:
openclaw gateway restart
```

**Hook missing:**
```bash
cp -r infra/backup/hooks/<name> ~/.openclaw/hooks/
openclaw hooks enable <name>
openclaw gateway restart
```

## Backup Health Checks

Run in `spider` context:
```bash
# Verify last backup committed to repo
cd /home/midang/.openclaw/repo && git log --oneline -5 | grep backup

# Check backup script last run time
ls -la /home/midang/.openclaw/workspace-spider/scripts/agent-backup.sh

# Verify cron is active
openclaw cron list | grep agent-config-backup
```

## Secrets Recovery

`openclaw.json` in backup has all tokens as `REDACTED`. To restore:
- Discord bot tokens: get from Discord Developer Portal per bot
- GitHub Copilot token: `openclaw auth login --provider github-copilot`
- GitHub repo token: stored in `ghp_*` format — generate new PAT from GitHub

## Key Paths

- Backup script: `/home/midang/.openclaw/workspace-spider/scripts/agent-backup.sh`
- Backup repo: `https://github.com/cuihuibot/buddy-team` → `infra/backup/`
- Cron ID: `67931a34-8ee0-4607-a3df-4952a6c21611`
- Restore guide: `infra/backup/README.md`
