#!/usr/bin/env bash
# Phase 1: Health Snapshot — collects platform metrics every 10 min
# Platform: macOS/Linux compatible
# Zero LLM cost. Triggered by OpenClaw cron.

set -e

SNAP_DIR="$HOME/.openclaw/monitoring/snapshots"
mkdir -p "$SNAP_DIR"

TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
DATE_FILE=$(date -u +%Y-%m-%d-%H%M)
OUT="$SNAP_DIR/$DATE_FILE.json"

# Prepare temp JSON files
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Default empty structures
echo '{}' > "$TMP_DIR/status.json"
echo '[]' > "$TMP_DIR/channels.json"
echo '{"checks":[]}' > "$TMP_DIR/doctor.json"
echo '{}' > "$TMP_DIR/mem.json"
echo '{}' > "$TMP_DIR/swap.json"
echo '{}' > "$TMP_DIR/disk.json"
echo '{}' > "$TMP_DIR/load.json"

# Collect OpenClaw metrics (non-blocking)
(openclaw status --json > "$TMP_DIR/status.json" 2>/dev/null &)
(openclaw channels status --probe --json > "$TMP_DIR/channels.json" 2>/dev/null &)
(openclaw doctor --json > "$TMP_DIR/doctor.json" 2>/dev/null &)
sleep 15

# System resources
OS_TYPE=$(uname -s)

if [ "$OS_TYPE" = "Darwin" ]; then
  vm_stat_out=$(vm_stat 2>/dev/null || true)
  pages_free=$(echo "$vm_stat_out" | grep "Pages free:" | awk '{print $3}' | tr -d '.' || echo "0")
  pages_active=$(echo "$vm_stat_out" | grep "Pages active:" | awk '{print $3}' | tr -d '.' || echo "0")
  pages_wired=$(echo "$vm_stat_out" | grep "Pages wired:" | awk '{print $3}' | tr -d '.' || echo "0")
  pagesize=$(/usr/sbin/sysctl -n hw.pagesize 2>/dev/null || echo "4096")
  
  total_mem=$(/usr/sbin/sysctl -n hw.memsize 2>/dev/null || echo "0")
  used_mem=$(( (pages_active + pages_wired) * pagesize ))
  avail_mem=$(( pages_free * pagesize ))
  
  printf "{\"total\":%d,\"used\":%d,\"avail\":%d}" "$total_mem" "$used_mem" "$avail_mem" > "$TMP_DIR/mem.json"
  printf "{\"total\":0,\"used\":0}" > "$TMP_DIR/swap.json"
  df / | awk 'NR==2 {printf "{\"total\":%s,\"used\":%s,\"avail\":%s}", $2*1024, $3*1024, $4*1024}' > "$TMP_DIR/disk.json"
  
  # Parse load average from sysctl output: { 2.85 2.32 2.16 }
  load_output=$(/usr/sbin/sysctl -n vm.loadavg 2>/dev/null | sed 's/{//;s/}//')
  load_avg=$(echo "$load_output" | awk '{printf "{\"1m\":%s,\"5m\":%s,\"15m\":%s}", $1, $2, $3}' || echo '{}')
  printf "$load_avg" > "$TMP_DIR/load.json"
  
  # Parse uptime: sec = 1710434600,usec = 123456 } -> extract seconds and calc uptime
  boottime_epoch=$(/usr/sbin/sysctl -n kern.boottime 2>/dev/null | awk -F'sec = ' '{print $2}' | awk -F',' '{print $1}' || echo "0")
  UPTIME_SEC=$(( $(date +%s) - boottime_epoch ))
  
elif [ "$OS_TYPE" = "Linux" ]; then
  free -b | awk '/Mem:/ {printf "{\"total\":%s,\"used\":%s,\"avail\":%s}", $2, $3, $7}' > "$TMP_DIR/mem.json"
  free -b | awk '/Swap:/ {printf "{\"total\":%s,\"used\":%s}", $2, $3}' > "$TMP_DIR/swap.json"
  df -B1 / | awk 'NR==2 {printf "{\"total\":%s,\"used\":%s,\"avail\":%s}", $2, $3, $4}' > "$TMP_DIR/disk.json"
  cat /proc/loadavg | awk '{printf "{\"1m\":%s,\"5m\":%s,\"15m\":%s}", $1, $2, $3}' > "$TMP_DIR/load.json"
  UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime)
else
  UPTIME_SEC=0
fi

# Gateway process — ps-based detection (pgrep unreliable for renamed binaries on macOS)
GW_PID=$(ps -A -o pid,comm 2>/dev/null | awk '/openclaw-gateway/{print $1}' | head -1 || pgrep -f "dist/index.js.*gateway" 2>/dev/null | head -1 || echo "")
GW_RSS=0
if [ -n "$GW_PID" ]; then
  if [ "$OS_TYPE" = "Darwin" ]; then
    GW_RSS=$(ps -o rss= -p "$GW_PID" 2>/dev/null | tr -d ' ' | awk '{print $1 * 1024}' || echo "0")
  else
    GW_RSS=$(ps -o rss= -p "$GW_PID" 2>/dev/null | tr -d ' ' || echo "0")
  fi
fi

# Make sure variables are defined
UPTIME_SEC="${UPTIME_SEC:-0}"
GW_PID="${GW_PID:-}"
GW_RSS="${GW_RSS:-0}"

# Export for Python access
export TMP_DIR OUT TIMESTAMP UPTIME_SEC GW_PID GW_RSS

# Assemble snapshot
python3 << 'PYEOF'
import json, os

tmp = os.environ["TMP_DIR"]
out = os.environ["OUT"]
timestamp = os.environ["TIMESTAMP"]
uptime = int(os.environ.get("UPTIME_SEC", "0"))
gw_pid = os.environ.get("GW_PID") or None
gw_rss = int(os.environ.get("GW_RSS", "0"))

def load_json(name):
    try:
        with open(os.path.join(tmp, name)) as f:
            return json.load(f)
    except:
        return {}

status = load_json("status.json")
channels = load_json("channels.json")
doctor = load_json("doctor.json")
mem = load_json("mem.json")
swap = load_json("swap.json")
disk = load_json("disk.json")
load_avg = load_json("load.json")

ch_list = channels if isinstance(channels, list) else channels.get("accounts", channels.get("channels", []))
channel_health = {}
if isinstance(ch_list, list):
    for c in ch_list:
        if isinstance(c, dict):
            name = c.get("accountId", c.get("name", "unknown"))
            channel_health[name] = {
                "connected": c.get("connected", c.get("status") == "connected"),
                "latencyMs": c.get("latencyMs", c.get("probeLatencyMs"))
            }

checks = doctor.get("checks", doctor.get("results", []))
doc_summary = {
    "total": len(checks) if isinstance(checks, list) else 0,
    "errors": sum(1 for c in checks if isinstance(c, dict) and c.get("status") in ("error", "fail", "critical")) if isinstance(checks, list) else 0,
    "warnings": sum(1 for c in checks if isinstance(c, dict) and c.get("status") in ("warn", "warning")) if isinstance(checks, list) else 0
}

snap = {
    "timestamp": timestamp,
    "system": {
        "memory": mem,
        "swap": swap,
        "disk": disk,
        "loadAvg": load_avg,
        "uptimeSec": uptime,
        "gatewayPid": gw_pid,
        "gatewayRssBytes": gw_rss
    },
    "gateway": status.get("gateway", {}),
    "channels": channel_health,
    "doctor": doc_summary,
    "securityFindingsCount": len(status.get("securityAudit", {}).get("findings", [])),
    "sessionCountTotal": status.get("sessions", {}).get("count", 0)
}

with open(out, "w") as f:
    json.dump(snap, f, indent=2)

print(f"Snapshot saved: {out}")
PYEOF

find "$SNAP_DIR" -name "*.json" -mtime +7 -delete 2>/dev/null || true
echo "✅ Health snapshot complete"
