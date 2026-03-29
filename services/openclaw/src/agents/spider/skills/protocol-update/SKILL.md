---
name: protocol-update
description: Update PROTOCOLS.md — the shared team-wide protocol file. Use when adding, modifying, removing, or auditing protocols. NOT for agent-specific AGENTS.md changes (those are direct edits). Triggers on requests involving shared team rules, cross-agent standards, or PROTOCOLS.md maintenance.
---

# Protocol Update Skill

PROTOCOLS.md (`/home/midang/.openclaw/workspace/PROTOCOLS.md`) defines always-on team-wide behavior for all agents. Every token costs N× (once per agent per turn), so brevity is critical.

## Protocol File Rules

- **Owner:** Spider (only Spider writes to PROTOCOLS.md)
- **Location:** `/home/midang/.openclaw/workspace/PROTOCOLS.md`
- **Max size:** 250 lines / ~2,500 tokens (hard ceiling)
- **Git repo:** `/home/midang/.openclaw/workspace/` (commit every change)

## Change Workflow

### 1. Assess Impact

Before any edit, answer:
- How many agents does this affect? (all 9 = protocol, <3 = put in agent AGENTS.md instead)
- Does this duplicate something already in a skill? (if yes, don't add — skills are on-demand, protocols are always-on)
- Is this a permanent rule or a temporary process? (temporary → don't add)

**Decision matrix:**
| Scope | Permanent? | Actionable? | → Location |
|-------|-----------|-------------|------------|
| All agents | Yes | Yes | PROTOCOLS.md |
| All agents | Yes | No (philosophy) | Keep to 1 line or skip |
| 1-3 agents | Yes | Yes | Agent's AGENTS.md |
| Any | No | Any | Don't codify |

### 2. Draft the Change

Read current file: `read("/home/midang/.openclaw/workspace/PROTOCOLS.md")`

**Writing rules:**
- Imperative voice ("Post to Discord", not "You should post to Discord")
- Max 15 lines per protocol section
- No redundancy — if two sections say similar things, merge
- Include a concrete example or format template (1-2 lines max)
- Every section needs `(MANDATORY)` or `(RECOMMENDED)` tag
- No prose explanations — agents are smart, give the rule + format

**Anti-patterns to avoid:**
- ❌ Duplicating what's in a skill (clone management, task execution)
- ❌ Vague aspirational statements ("strive for quality")
- ❌ Rules no one follows or can enforce
- ❌ Agent-specific procedures (those go in AGENTS.md)
- ❌ Sections over 20 lines (split into subsections or extract to skill)

### 3. Validate Before Applying

Run the pre-flight checklist. See `references/preflight-checklist.md`.

### 4. Apply + Commit

```bash
# Edit with surgical precision
edit(path="/home/midang/.openclaw/workspace/PROTOCOLS.md", old_string="...", new_string="...")

# Commit
exec("cd /home/midang/.openclaw/workspace && git add PROTOCOLS.md && git commit -m 'protocols: <change summary>'")
```

### 5. Post-Change Broadcast

**Always** announce to Discord:
```
message(action='send', channel='discord', target='channel:1479315677067214958',
  message='🧙 Spider: ⚠️ PROTOCOLS.md updated — <what changed>. Agents: session reset recommended.')
```

### 6. Propagate If Needed

If the change affects how agents reference PROTOCOLS.md (new section names, removed sections):
- Update each agent's AGENTS.md reference line
- Verify: `exec("grep -c 'PROTOCOLS.md' /home/midang/.openclaw/workspace*/AGENTS.md")`

## Audit Mode

When auditing (not changing) PROTOCOLS.md:

1. Read the full file
2. Check each section against:
   - **Staleness:** References to removed agents, old config, outdated tools?
   - **Bloat:** Section over 15 lines? Can it be compressed or extracted to a skill?
   - **Enforcement:** Is this rule actually followed? If not, delete or fix.
   - **Duplication:** Does a skill already cover this? If yes, remove from protocols.
   - **Missing agents:** Are all current agents represented in registries/lists?
3. Report findings as a table: `| # | Issue | Section | Severity | Fix |`
