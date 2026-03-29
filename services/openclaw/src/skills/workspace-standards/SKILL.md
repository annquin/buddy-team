---
name: workspace-standards
description: Agent workspace rules — canonical files, what's safe to edit, modification guide, and integrity check. Use when reading or modifying any agent workspace file (SOUL.md, AGENTS.md, IDENTITY.md, TOOLS.md, USER.md, MEMORY.md, BOOT.md, BOOTSTRAP.md, HEARTBEAT.md), creating a new agent workspace, auditing workspace health, or when asked about workspace structure, naming conventions, or ownership. Also use before any cross-workspace edit.
---

# Workspace Standards

**Spec:** `projects/aws-001/SPEC.md` — authoritative reference for all rules below.
**Last validated:** 2026-03-22 — 13/13 agents PASS (see `projects/aws-001/audit/VALIDATION.md`)

---

## Canonical File Set

Every agent workspace contains exactly these 9 files:

```
workspace-<agent>/
├── SOUL.md        ← persona, tone, rules            (≤1,500 chars)
├── AGENTS.md      ← procedures, protocols, groups   (target ≤15,000 chars)
├── IDENTITY.md    ← name, emoji, avatar             (≤500 chars)
├── TOOLS.md       ← tool environment, commands      (≤600 chars recommended)
├── USER.md        ← human profile + team roster     (≤600 chars recommended)
├── MEMORY.md      ← long-term persistent facts      (≤600 lines)
├── BOOT.md        ← gateway restart recovery        (≤20 lines)
├── BOOTSTRAP.md   ← context-loss hint               (≤200 chars)
├── HEARTBEAT.md   ← periodic monitoring checklist   (≤20 lines)
└── memory/        ← dated memory files (YYYY-MM-DD.md)
```

**Exception:** Muse omits BOOT.md and BOOTSTRAP.md — no persistent state requiring restart recovery (SPEC §3.8).

---

## Size Limits (hard flags)

| File | Limit | Flag if |
|------|-------|---------|
| SOUL.md | 1,500 chars | > 1,500 chars |
| AGENTS.md | 15,000 chars | > 15,000 chars (truncation risk) |
| MEMORY.md | 600 lines | > 600 lines |
| BOOT.md | 20 lines | > 20 lines |
| HEARTBEAT.md | 20 lines | > 20 lines |
| BOOTSTRAP.md | 200 chars | > 200 chars |

---

## AGENTS.md — 6-Group Standard

Every AGENTS.md must contain all 6 groups:

| Group | Name | Required content |
|-------|------|-----------------|
| A | Unbreakable Rules | No-Guess Rule (MANDATORY) |
| B | Request & Task Execution | Request Decomposition Protocol + Task Execution Protocol |
| C | Communication | COMM-001 Completion Reporting + Task Acknowledgment |
| D | Memory & Context | MEM-001 Memory Protocol + CTX-001 Context Switch |
| E | Product & Ownership | PLF-001 Product Lifecycle + My Ownership + Safety Rules |
| F | Agent-Specific | Role-specific protocols, tools, domain procedures |

Verify presence: `grep -l "Request Decomposition Protocol\|COMM-001\|MEM-001\|PLF-001\|My Ownership" <agents-file>`

---

## Before Modifying Any Workspace File

```bash
# 1. Run integrity check
bash ~/.openclaw/skills/workspace-standards/scripts/check-workspace.sh <workspace-path>

# 2. Check size constraints (SOUL.md most common violation)
wc -c <workspace-path>/SOUL.md
wc -l <workspace-path>/BOOT.md <workspace-path>/HEARTBEAT.md

# 3. Back up before editing
cp <file> <file>.bak-<task-id>-$(date -u +%Y-%m-%dT%H:%M)Z

# 4. Edit

# 5. Re-run integrity check
bash ~/.openclaw/skills/workspace-standards/scripts/check-workspace.sh <workspace-path>
```

Backup naming: `<file>.bak-<task-id>-<YYYY-MM-DDTHH:MM>Z`

---

## Quick Edit Safety Matrix

| File | Safe to edit? | Requires |
|------|--------------|---------|
| SOUL.md | ⚠️ Careful | King review if changing persona/rules; size check mandatory |
| AGENTS.md | ⚠️ Careful | Silent Change Broadcast after any protocol change |
| IDENTITY.md | ✅ Yes | No special steps |
| TOOLS.md | ✅ Yes | No special steps |
| USER.md | ✅ Yes | No special steps |
| MEMORY.md | ⚠️ Append-only | Never delete existing entries |
| BOOT.md | ✅ Yes | Keep ≤20 lines |
| BOOTSTRAP.md | ✅ Yes | Keep ≤200 chars |
| HEARTBEAT.md | ✅ Yes | Keep ≤20 lines |

---

## Integrity Check — Pass/Fail Criteria

Run to validate any workspace:

```bash
bash ~/.openclaw/skills/workspace-standards/scripts/check-workspace.sh <workspace-path>
```

**PASS requires all of:**
- All 9 canonical files present (Muse: 7)
- SOUL.md ≤ 1,500 chars
- MEMORY.md ≤ 600 lines
- BOOT.md ≤ 20 lines
- HEARTBEAT.md ≤ 20 lines
- AGENTS.md ≤ 15,000 chars
- AGENTS.md has all 6 groups (A–F)
- No stray `.md` files (except PROTOCOLS.md in `workspace/`)

---

## Cross-Workspace Edits (Oz only)

Only Oz may edit other agents' workspace files (agent creation, maintenance, protocol rollouts).

1. Back up every file before touching it
2. Verify with `grep` or `wc` after writing
3. Re-run `check-workspace.sh` on the target workspace
4. Commit affected files to buddy-team repo when possible

---

## Content Rules by File

### SOUL.md
- Persona, tone, core rules, boundaries only
- NO: protocols, tool paths, IDs, long checklists
- SOUL.md is for WHO the agent is — procedures go in AGENTS.md

### AGENTS.md
- Groups A–F (see above)
- Verbose protocol text → compress to pointer: "Full steps: PROTOCOLS.md §X"
- Role-specific procedures → Group F
- NO: personality prose, IDs/keys (MEMORY.md), duplicated content

### MEMORY.md
- Facts the agent needs recalled every session: Discord IDs, session keys, active project names, key decisions
- NO: procedures >5 lines (→ Skill), repo paths/git config (→ TOOLS.md), temporary task state (→ `memory/active-tasks.md`)
- Litmus test: "Is this a fact I recall, or a procedure I follow?" Facts → MEMORY.md. Procedures → AGENTS.md or Skill.

### BOOT.md
- Gateway restart recovery steps only
- Use the standard 15-line template (see `references/canonical-files.md`)
- NO: agent documentation, personality, protocols

### HEARTBEAT.md
- Ordered check steps + HEARTBEAT_OK fallback
- Keep concrete and actionable
- NO: prose descriptions, large tables

---

## References

- `references/canonical-files.md` — full registry with owner, purpose, size limit, edit policy
- `projects/aws-001/SPEC.md` — authoritative workspace standard spec
- `projects/aws-001/audit/VALIDATION.md` — last full audit results
