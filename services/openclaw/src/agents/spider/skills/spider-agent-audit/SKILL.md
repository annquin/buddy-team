---
name: spider-agent-audit
description: Weekly agent health audit — SOUL.md drift, AGENTS.md staleness, protocol compliance, workspace hygiene. Use for scheduled Monday audits or ad-hoc agent quality checks.
---

# Spider Agent Audit — Weekly Health Check

## When to Use
- Monday 08:00 UTC cron trigger (weekly audit)
- After major protocol changes or rollouts
- When agent behavior seems off
- Duc or King requests an agent quality check

## Audit Procedure

### Step 0: Setup
```bash
# Get list of all active agents
openclaw status  # Check "Agents:" line
# Current roster: main, alex, joe, spider, dashboard-sync, dev, king, paa, fd
```

### Step 1: SOUL.md Drift Check (per agent)
For each agent, read their SOUL.md:
```bash
cat /home/midang/.openclaw/workspace-<id>/SOUL.md
wc -c /home/midang/.openclaw/workspace-<id>/SOUL.md  # Must be ≤1,500 chars
```

**Check:**
- [ ] Identity statement present and accurate (first paragraph)
- [ ] Vibe section matches observed behavior in Discord
- [ ] Rules are actionable (not vague platitudes)
- [ ] Boundaries include redirect patterns with specific agent names
- [ ] Under 1,500 chars (procedures should be in AGENTS.md, not SOUL.md)

**Scoring:** ✅ All pass | ⚠️ Minor drift (wording, missing redirect) | ❌ Major drift (wrong role, missing boundaries)

### Step 2: AGENTS.md Staleness Check (per agent)
```bash
cat /home/midang/.openclaw/workspace-<id>/AGENTS.md
```

**Check:**
- [ ] PROTOCOLS.md reference is FIRST content line (after title)
- [ ] No dead links or references to removed features/agents
- [ ] Ownership section current (matches actual responsibilities)
- [ ] No references to Cindy (she's been absorbed into Spider)
- [ ] Task lifecycle + execution protocol sections present
- [ ] Session keys / channel IDs still valid
- [ ] No stale agent names in collaboration sections

**Scoring:** ✅ Current | ⚠️ Minor staleness (outdated reference) | ❌ Outdated (wrong ownership, dead links)

### Step 3: Protocol Compliance Check (per agent)
```bash
grep -c "PROTOCOLS.md" /home/midang/.openclaw/workspace-<id>/AGENTS.md  # Should be ≥1
```

**Check:**
- [ ] References PROTOCOLS.md (not inline copies of shared sections)
- [ ] Discord reporting happening (check recent Discord activity)
- [ ] Thread routing followed (responses in correct threads)
- [ ] Push-back format used when needed
- [ ] REDIRECT_TO_JOE rule present (for worker agents)

**Scoring:** ✅ Compliant | ⚠️ Partial compliance | ❌ Non-compliant

### Step 4: Workspace Hygiene (per agent)
```bash
ls -la /home/midang/.openclaw/workspace-<id>/memory/
cat /home/midang/.openclaw/workspace-<id>/memory/active-tasks.md
find /home/midang/.openclaw/workspace-<id>/ -name "*.tmp" -o -name "*.bak" | head -10
```

**Check:**
- [ ] `memory/active-tasks.md` exists
- [ ] No tasks older than 7 days stuck in "in-progress"
- [ ] No orphaned temp files
- [ ] BOOTSTRAP.md has context recovery instruction
- [ ] MEMORY.md points to memory/ subdirectory

**Scoring:** ✅ Clean | ⚠️ Minor clutter | ❌ Stale tasks or missing recovery files

## Report Template

Write to `/home/midang/.openclaw/workspace-spider/health-reports/YYYY-MM-DD-health-audit.md`:

```markdown
# Agent Health Audit — YYYY-MM-DD

## Summary
- Agents audited: N
- Issues found: N (X critical / Y warning / Z info)

## Per-Agent Findings

### [Agent ID]
| Check | Status | Notes |
|-------|--------|-------|
| SOUL.md | ✅/⚠️/❌ | |
| AGENTS.md | ✅/⚠️/❌ | |
| Protocol compliance | ✅/⚠️/❌ | |
| Workspace hygiene | ✅/⚠️/❌ | |

(Repeat for each agent)

## Actions Needed
- [ ] [Agent]: [issue] — [fix] — [priority: now/next-maintenance]

## Notes
- [Any patterns, trends, or recommendations]
```

## Remediation Rules

| Severity | Action | Timeline |
|----------|--------|----------|
| ❌ Critical | Fix immediately, post to Discord | Same day |
| ⚠️ Warning | Fix in next maintenance window | Within 7 days |
| ℹ️ Info | Note for next audit | Track only |

For agent file fixes: back up the file first (no git in most workspaces), edit, verify, dispatch agent to reload.
