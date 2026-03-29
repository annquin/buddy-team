---
name: spider-monitoring
description: Proactive infrastructure monitoring — gateway, agents, system resources, dependencies, alert thresholds, escalation. Use when checking platform health, diagnosing performance, or setting up monitoring.
---

# Spider Monitoring — Proactive Infrastructure Health

## When to Use
- Periodic health checks (cron or manual)
- Investigating slow responses or degraded performance
- After gateway restart, config change, or incident
- Duc asks "is everything healthy?"

## Health Check Sequence (run in order)

### 1. Gateway Health
```bash
openclaw status                    # Gateway up? PID? Uptime?
openclaw doctor                    # 19-check scan — config, state, model
openclaw channels status --probe   # Live channel connectivity (Telegram, Discord)
```

**Healthy signals:** Gateway running, reachable <100ms, all channels "ok", no doctor errors.
**Alert if:** Gateway unreachable, channel probe fails, doctor reports critical.

### 2. Agent Health
```bash
openclaw status                    # Agent count, session count, active sessions
```

**Check for each agent:**
- Session exists and is recent (not stale >24h with no activity)
- Context not truncated (`/context detail` in agent session)
- No error loops in logs

**Healthy signals:** All registered agents have sessions, default agent active recently.
**Alert if:** Agent missing from session list, session store errors in logs.

### 3. System Resources
```bash
free -h                            # RAM — alert if available <500MB
df -h /home                        # Disk — alert if usage >85%
ps aux --sort=-%mem | head -10     # Top memory consumers
cat /proc/$(pgrep -f "openclaw")/status | grep -i vm  # Gateway process memory
uptime                             # Load average — alert if >4 on 4-core
```

**Thresholds:**
| Resource | Warning | Critical |
|----------|---------|----------|
| RAM available | <1GB | <500MB |
| Disk usage | >80% | >90% |
| Gateway RSS | >1GB | >2GB |
| Load average | >3 | >6 |

### 4. Dependency Health
```bash
# Dashboard (Caddy)
curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:45680/  # Expect 200
systemctl --user status dashboard.service                         # Expect active

# Supabase
curl -s -o /dev/null -w "%{http_code}" \
  -H "apikey: $SUPABASE_ANON_KEY" \
  "https://jbgxptnrqqbnebavdduy.supabase.co/rest/v1/team_members?select=count"  # Expect 200

# Embedding model (memory search)
# Triggered on first memory_search — check if model downloaded
ls ~/.cache/openclaw/models/ 2>/dev/null
```

### 5. Log Scan
```bash
openclaw logs --tail               # Recent errors
```

**Pattern watch:**
| Pattern | Meaning | Action |
|---------|---------|--------|
| `health-monitor.*restart` | Channel thrashing | Check Discord bot count, reduce burst |
| `SIGTERM` | Process killed | Check OOM, manual kill, or health-monitor |
| `rate limit` | API throttling | Reduce maxConcurrent or stagger requests |
| `timeout` | Agent/tool timeout | Check lane congestion, increase timeout |
| `auth.*fail` | Credential issue | Check API keys, tokens |
| `ENOSPC` | Disk full | Clean logs, old sessions, tmp files |

## Alert Escalation

| Severity | Action | Notify |
|----------|--------|--------|
| Info | Log to health-log.txt | None |
| Warning | Log + post to Discord product-team | Team |
| Critical | Log + Discord + Telegram to Duc | Duc immediately |

## Post-Check Report Template
```markdown
## Platform Health Check — YYYY-MM-DD HH:MM UTC

### Summary: ✅ HEALTHY / ⚠️ DEGRADED / ❌ UNHEALTHY

### Gateway: ✅/⚠️/❌
- PID: X | Uptime: X | Reachable: Xms

### Channels: ✅/⚠️/❌
- Telegram: ok/fail (Xms) | Discord: ok/fail (Xms)

### Agents: ✅/⚠️/❌
- Registered: X | Sessions: X | Active recently: X

### System: ✅/⚠️/❌
- RAM: X available | Disk: X% used | Load: X

### Dependencies: ✅/⚠️/❌
- Dashboard: up/down | Supabase: reachable/unreachable

### Issues Found
- [list or "None"]

### Actions Taken
- [list or "None"]
```
