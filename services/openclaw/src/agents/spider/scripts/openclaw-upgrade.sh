#!/bin/bash
# OpenClaw Upgrade Script: v2026.3.2 → v2026.3.8
# Scheduled for ~18:41 UTC on 2026-03-11
# Run by Spider after warning team

set -e

LOG="/tmp/openclaw-upgrade-$(date +%Y%m%d-%H%M).log"
exec > >(tee -a "$LOG") 2>&1

echo "=== OpenClaw Upgrade Started: $(date -u) ==="

# Step 1: Backup
echo "--- Step 1: Backup config ---"
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.bak.$(date +%Y%m%d-%H%M%S)
echo "Config backed up"

# Step 2: Pre-upgrade doctor
echo "--- Step 2: Pre-upgrade doctor ---"
openclaw doctor 2>&1 || true

# Step 3: Stop gateway
echo "--- Step 3: Stopping gateway ---"
openclaw gateway stop 2>&1 || true
sleep 5

# Step 4: Upgrade
echo "--- Step 4: Upgrading openclaw ---"
npm update -g openclaw 2>&1

# Step 5: Verify version
echo "--- Step 5: Version check ---"
openclaw --version 2>&1

# Step 6: Start gateway
echo "--- Step 6: Starting gateway ---"
openclaw gateway start 2>&1
sleep 10

# Step 7: Post-upgrade doctor
echo "--- Step 7: Post-upgrade doctor ---"
openclaw doctor 2>&1 || true

# Step 8: Verify channels
echo "--- Step 8: Channel probe ---"
openclaw channels status --probe 2>&1 || true

# Step 9: Test heartbeats
echo "--- Step 9: Quick agent test ---"
openclaw agent --agent spider --message "Post-upgrade test. Reply with your version: openclaw --version" --timeout 30 2>&1 || true

echo "=== OpenClaw Upgrade Complete: $(date -u) ==="
echo "Log saved to: $LOG"
