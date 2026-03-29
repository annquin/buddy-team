---
name: spider-protocol-rollout
description: Cross-agent protocol propagation — PROTOCOLS.md changes to all agent AGENTS.md files, clone fan-out for parallel edits, verification, notification. Use when rolling out protocol changes to multiple agents.
---

# Spider Protocol Rollout — Cross-Agent Propagation

## When to Use
- PROTOCOLS.md has been updated and changes need to propagate
- New convention/rule needs to be added to multiple agents
- Agent-specific AGENTS.md sections need bulk updates
- Post-retrospective fixes that affect multiple agents

## Pre-Rollout Checklist
- [ ] Change is finalized (no draft/WIP)
- [ ] Change is in PROTOCOLS.md (shared sections) or identified as per-agent (custom sections)
- [ ] Impact assessment: which agents are affected?
- [ ] Rollback plan: what to restore if something breaks

## Agent Workspace Roster
```
main (John):    /home/midang/.openclaw/workspace
joe:            /home/midang/.openclaw/workspace-joe
alex:           /home/midang/.openclaw/workspace/agents/alex
spider:             /home/midang/.openclaw/workspace-spider
dashboard-sync: /home/midang/.openclaw/workspace-dashboard-sync
dev:            /home/midang/.openclaw/workspace-dev
king:           /home/midang/.openclaw/workspace-king
paa:            /home/midang/.openclaw/workspace-paa
fd:             /home/midang/.openclaw/workspace-fd
```

## Rollout Procedure

### Step 1: Identify Scope
```bash
# Which agents reference PROTOCOLS.md?
grep -l "PROTOCOLS.md" /home/midang/.openclaw/workspace*/AGENTS.md /home/midang/.openclaw/workspace/agents/*/AGENTS.md 2>/dev/null

# Which agents have the section being changed?
grep -l "<pattern>" /home/midang/.openclaw/workspace*/AGENTS.md 2>/dev/null
```

### Step 2: Backup All Affected Files
```bash
for ws in /home/midang/.openclaw/workspace*/AGENTS.md; do
  cp "$ws" "${ws}.bak.$(date +%Y%m%d-%H%M%S)"
done
# Also backup alex's workspace (different path)
cp /home/midang/.openclaw/workspace/agents/alex/AGENTS.md \
   /home/midang/.openclaw/workspace/agents/alex/AGENTS.md.bak.$(date +%Y%m%d-%H%M%S)
```

**Critical:** 7 of 9 agent workspaces have NO git. Backups are the only rollback.

### Step 3: Apply Changes

**For PROTOCOLS.md reference changes (shared sections):**
- Edit PROTOCOLS.md itself — agents reference it, so they get the update automatically on next session
- No per-agent edits needed for shared content

**For per-agent section changes (3+ agents) — use clone fan-out:**
```
For each affected agent:
  1. Read current AGENTS.md
  2. Find insertion/replacement point
  3. Apply edit (use edit tool for precision)
  4. Verify edit didn't corrupt the file
```

**For per-agent section changes (<3 agents):**
- Edit each file manually with the edit tool
- Faster than clone overhead for small batches

### Step 4: Verify Rollout
```bash
# Confirm change is present in all affected files
grep -c "<new pattern>" /home/midang/.openclaw/workspace*/AGENTS.md 2>/dev/null
grep -c "<new pattern>" /home/midang/.openclaw/workspace/agents/*/AGENTS.md 2>/dev/null

# Confirm no corruption (file is valid markdown, key sections present)
for ws in /home/midang/.openclaw/workspace*/AGENTS.md; do
  echo "--- $(dirname $ws | xargs basename) ---"
  head -3 "$ws"  # Should show title + PROTOCOLS.md reference
done
```

### Step 5: Notify Agents
Dispatch each affected agent to reload:
```bash
openclaw agent --agent <id> --message \
  "Your AGENTS.md was updated: <describe change>. Re-read your AGENTS.md and acknowledge what changed." \
  --timeout 120 --json
```

**For bulk notifications (5+ agents):** run notifications in parallel with background exec.

**Wait for acknowledgment** from each agent before marking rollout complete.

### Step 6: Document
Update `memory/active-tasks.md` with rollout results.
Post summary to Discord product-team channel.

## Rollback Procedure
```bash
# Restore from backup
cp /home/midang/.openclaw/workspace-<id>/AGENTS.md.bak.<timestamp> \
   /home/midang/.openclaw/workspace-<id>/AGENTS.md

# Notify agent of rollback
openclaw agent --agent <id> --message \
  "Your AGENTS.md was rolled back to previous version. Re-read and acknowledge." \
  --timeout 120 --json
```

## Common Rollout Patterns

### Adding a new safety rule to all worker agents
Affected: main, dev, alex, fd, paa, dashboard-sync (NOT joe, king, spider — coordinators)
Insert into Safety Rules section of each AGENTS.md.

### Updating team roster (new agent added)
Affected: ALL agents' TOOLS.md files
Add new workspace path to "Team Workspaces" section.

### Changing escalation protocol
Affected: ALL agents' AGENTS.md
Usually a PROTOCOLS.md edit (shared section) — no per-agent edits needed.

## Anti-Patterns
- ❌ Editing PROTOCOLS.md AND inline copies in AGENTS.md (creates drift)
- ❌ Skipping backup before edits (no git = no rollback)
- ❌ Not verifying with grep after rollout (silent misses)
- ❌ Not notifying agents after changes (they don't re-read automatically)
- ❌ Rolling out during heavy agent activity (risk of concurrent file access)
