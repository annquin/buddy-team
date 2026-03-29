#!/usr/bin/env bash
# Phase 2: Daily Digest — analyzes today's snapshots, generates report
# Run by Spider cron at 22:00 UTC daily
set -euo pipefail

SNAP_DIR="$HOME/.openclaw/monitoring/snapshots"
REPO_DIR="$HOME/.openclaw/repo"
DAILY_DIR="$REPO_DIR/infra/monitoring/daily"
DATE=$(date -u +%Y-%m-%d)
OUT="$DAILY_DIR/$DATE.md"

mkdir -p "$DAILY_DIR"

# Collect today's snapshots
SNAPS=$(ls "$SNAP_DIR/$DATE"-*.json 2>/dev/null | sort)
SNAP_COUNT=$(echo "$SNAPS" | grep -c . 2>/dev/null || echo 0)

if [ "$SNAP_COUNT" -eq 0 ]; then
  echo "No snapshots for $DATE — skipping digest"
  exit 0
fi

SNAP_DIR="$SNAP_DIR" DATE="$DATE" OUT="$OUT" python3 << 'PYEOF'
import json, os, glob, sys
from datetime import datetime

date = os.environ["DATE"]
snap_dir = os.environ["SNAP_DIR"]
out = os.environ["OUT"]

snaps = sorted(glob.glob(os.path.join(snap_dir, f"{date}-*.json")))
data = []
for s in snaps:
    try:
        with open(s) as f:
            data.append(json.load(f))
    except:
        pass

if not data:
    sys.exit(0)

lines = []
lines.append(f"# Daily Health Digest — {date}")
lines.append(f"\n**Snapshots:** {len(data)} | **Period:** {data[0]['timestamp']} → {data[-1]['timestamp']}")
lines.append("")

# System Resources
lines.append("## System Resources")
mem_used = [d["system"]["memory"]["used"] for d in data if "memory" in d.get("system", {})]
mem_total = data[0]["system"]["memory"]["total"] if mem_used else 0
gw_rss = [d["system"].get("gatewayRssBytes", 0) for d in data]
disk_used = [d["system"]["disk"]["used"] for d in data if "disk" in d.get("system", {})]
disk_total = data[0]["system"]["disk"]["total"] if disk_used else 0
load_1 = [d["system"]["loadAvg"]["1m"] for d in data if "loadAvg" in d.get("system", {})]

def gb(b): return f"{b / (1024**3):.1f}GB"
def pct(used, total): return f"{used/total*100:.1f}%" if total else "N/A"

if mem_used:
    lines.append(f"| Metric | Min | Avg | Max | Total |")
    lines.append(f"|--------|-----|-----|-----|-------|")
    lines.append(f"| RAM Used | {gb(min(mem_used))} | {gb(sum(mem_used)/len(mem_used))} | {gb(max(mem_used))} | {gb(mem_total)} |")
    lines.append(f"| Gateway RSS | {gb(min(gw_rss))} | {gb(sum(gw_rss)/len(gw_rss))} | {gb(max(gw_rss))} | — |")
    lines.append(f"| Disk Used | {gb(min(disk_used))} | {gb(sum(disk_used)/len(disk_used))} | {gb(max(disk_used))} | {gb(disk_total)} |")
    lines.append(f"| Load (1m) | {min(load_1):.2f} | {sum(load_1)/len(load_1):.2f} | {max(load_1):.2f} | — |")
lines.append("")

# Gateway
lines.append("## Gateway Health")
gw_reachable = [d.get("gateway", {}).get("reachable", False) for d in data]
gw_latency = [d.get("gateway", {}).get("connectLatencyMs", 0) for d in data if d.get("gateway", {}).get("connectLatencyMs")]
downtime = sum(1 for r in gw_reachable if not r)
lines.append(f"- **Uptime:** {sum(1 for r in gw_reachable if r)}/{len(gw_reachable)} checks passed ({pct(sum(1 for r in gw_reachable if r), len(gw_reachable))})")
if downtime > 0:
    lines.append(f"- ⚠️ **Downtime detected:** {downtime} checks failed")
if gw_latency:
    lines.append(f"- **Latency:** min {min(gw_latency)}ms, avg {sum(gw_latency)/len(gw_latency):.0f}ms, max {max(gw_latency)}ms")
lines.append("")

# Doctor
lines.append("## Doctor Checks")
doc_errors = [d.get("doctor", {}).get("errors", 0) for d in data]
doc_warnings = [d.get("doctor", {}).get("warnings", 0) for d in data]
lines.append(f"- **Errors:** max {max(doc_errors)}, latest {doc_errors[-1]}")
lines.append(f"- **Warnings:** max {max(doc_warnings)}, latest {doc_warnings[-1]}")
if max(doc_errors) > 0:
    lines.append(f"- ⚠️ Doctor errors detected during the day")
lines.append("")

# Security
lines.append("## Security")
sec = [d.get("securityFindingsCount", 0) for d in data]
lines.append(f"- **Findings:** {sec[-1]} (stable)" if min(sec) == max(sec) else f"- **Findings:** {min(sec)} → {max(sec)} (changed)")
lines.append("")

# Per-Agent
lines.append("## Agent Metrics")
latest = data[-1].get("agents", {})
if latest:
    lines.append("| Agent | Sessions | Memory DB | Memory Files | Files Size |")
    lines.append("|-------|----------|-----------|--------------|------------|")
    for aid, m in sorted(latest.items()):
        if not aid: continue
        lines.append(f"| {aid} | {m.get('sessions', 0)} | {gb(m.get('memoryDbBytes', 0))} | {m.get('memoryFiles', 0)} | {m.get('memoryFilesBytes', 0)/1024:.1f}KB |")
lines.append("")

# Session count trend
lines.append("## Sessions")
sess_counts = [d.get("sessionCountTotal", 0) for d in data]
lines.append(f"- **Total sessions:** {sess_counts[0]} → {sess_counts[-1]} (delta: {sess_counts[-1] - sess_counts[0]:+d})")
lines.append("")

# Alerts
lines.append("## Alerts")
alerts = []
if mem_used and max(mem_used) / mem_total > 0.80:
    alerts.append("🔴 RAM usage exceeded 80%")
if disk_used and max(disk_used) / disk_total > 0.80:
    alerts.append("🔴 Disk usage exceeded 80%")
if max(gw_rss) > 4 * 1024**3:
    alerts.append("🟡 Gateway RSS exceeded 4GB")
if downtime > 0:
    alerts.append(f"🔴 Gateway downtime: {downtime} checks failed")
if max(doc_errors) > 0:
    alerts.append("🟡 Doctor errors detected")
if not alerts:
    alerts.append("✅ No alerts — all clear")
for a in alerts:
    lines.append(f"- {a}")

with open(out, "w") as f:
    f.write("\n".join(lines) + "\n")

print(f"Daily digest saved: {out}")
print(f"Alerts: {len([a for a in alerts if not a.startswith('✅')])}")
PYEOF

# Git commit if changed
cd "$REPO_DIR"
git add infra/monitoring/daily/
if ! git diff --cached --quiet; then
  git commit -m "monitoring: daily digest $DATE"
  git push origin HEAD
  echo "Digest committed and pushed"
else
  echo "No changes to commit"
fi
