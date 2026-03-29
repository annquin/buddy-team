#!/usr/bin/env bash
# Agent Config Backup — daily sync to buddy-team repo
# Triggered by OpenClaw cron, no LLM cost
set -euo pipefail

REPO_DIR="$HOME/.openclaw/repo"
BACKUP_DIR="$REPO_DIR/infra/backup"
CONFIG="$HOME/.openclaw/openclaw.json"
DATE=$(date -u +%Y-%m-%d)

# Agent workspace map
declare -A WORKSPACES=(
  [main]="$HOME/.openclaw/workspace"
  [king]="$HOME/.openclaw/workspace-king"
  [joe]="$HOME/.openclaw/workspace-joe"
  [alex]="$HOME/.openclaw/workspace/agents/alex"
  [spider]="$HOME/.openclaw/workspace-spider"
  [dev]="$HOME/.openclaw/workspace-dev"
  [fd]="$HOME/.openclaw/workspace-fd"
  [paa]="$HOME/.openclaw/workspace-paa"
  [dashboard-sync]="$HOME/.openclaw/workspace-dashboard-sync"
)

# Config files to back up per agent
CONFIG_FILES=(SOUL.md AGENTS.md IDENTITY.md TOOLS.md USER.md MEMORY.md HEARTBEAT.md BOOTSTRAP.md BOOT.md)

mkdir -p "$BACKUP_DIR/platform"

# 0. Back up platform-level files
# Cron jobs
cp "$HOME/.openclaw/cron/jobs.json" "$BACKUP_DIR/platform/cron-jobs.json" 2>/dev/null || true

# Shared skills
if [ -d "$HOME/.openclaw/skills" ]; then
  rsync -a --include="*/" --include="*.md" --exclude="*" "$HOME/.openclaw/skills/" "$BACKUP_DIR/platform/shared-skills/"
fi

# Paired devices (no secrets)
cp "$HOME/.openclaw/devices/paired.json" "$BACKUP_DIR/platform/paired-devices.json" 2>/dev/null || true

# Telegram state
mkdir -p "$BACKUP_DIR/platform/telegram"
cp "$HOME/.openclaw/telegram/update-offset-"*.json "$BACKUP_DIR/platform/telegram/" 2>/dev/null || true

# 1. Back up each agent's config + memory
for agent in "${!WORKSPACES[@]}"; do
  ws="${WORKSPACES[$agent]}"
  dest="$BACKUP_DIR/$agent"
  
  if [ ! -d "$ws" ]; then
    echo "WARN: $agent workspace not found: $ws"
    continue
  fi

  mkdir -p "$dest/memory"

  # Copy config files
  for f in "${CONFIG_FILES[@]}"; do
    if [ -f "$ws/$f" ]; then
      cp "$ws/$f" "$dest/$f"
    fi
  done

  # Copy memory directory
  if [ -d "$ws/memory" ]; then
    find "$ws/memory" -name "*.md" -exec cp {} "$dest/memory/" \;
  fi

  # Copy skills directory
  if [ -d "$ws/skills" ]; then
    rsync -a --include="*/" --include="*.md" --include="*.sh" --include="*.py" --exclude="*" "$ws/skills/" "$dest/skills/"
  fi

  # Copy ops directory (Spider)
  if [ -d "$ws/ops" ]; then
    rsync -a --include="*/" --include="*.md" --exclude="*" "$ws/ops/" "$dest/ops/"
  fi

  # Copy scripts directory
  if [ -d "$ws/scripts" ]; then
    rsync -a --include="*/" --include="*.sh" --include="*.py" --exclude="*" "$ws/scripts/" "$dest/scripts/"
  fi
done

# 2. Back up PROTOCOLS.md (shared)
if [ -f "$HOME/.openclaw/workspace/PROTOCOLS.md" ]; then
  cp "$HOME/.openclaw/workspace/PROTOCOLS.md" "$BACKUP_DIR/PROTOCOLS.md"
fi

# 3. Sanitize and back up openclaw.json
if [ -f "$CONFIG" ]; then
  sed -E 's/("(token|Token|botToken|apiKey|apiSecret|secret|password|authToken|key)"[[:space:]]*:[[:space:]]*")[^"]*/\1<REDACTED>/g' \
    "$CONFIG" > "$BACKUP_DIR/openclaw.json"
fi

# 4. Git commit + push (skip if nothing changed)
cd "$REPO_DIR"
git add infra/backup/
if git diff --cached --quiet; then
  echo "No changes — skipping commit"
  exit 0
fi

git commit -m "backup: daily agent config $DATE"
git push origin HEAD
echo "Backup committed and pushed: $DATE"
