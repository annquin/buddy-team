# Canonical Files Registry

All 9 canonical workspace files — owners, purposes, size limits, and edit policies.
**Last updated:** 2026-03-22 per AWS-001 SPEC.md

---

## File Registry

| File | Owner | Purpose | Size Limit | Edit Policy |
|------|-------|---------|-----------|------------|
| `SOUL.md` | Oz (creation) / King (character review) | Persona, tone, rules, boundaries. OpenClaw loads this as system prompt seed. | **≤1,500 chars (hard)** | Character/tone changes need King review. Procedures → AGENTS.md, not here. |
| `AGENTS.md` | Oz | Procedures, protocols, workflows (Groups A–F). | **Target ≤15,000 chars** | Protocol changes require Silent Change Broadcast. Groups A–F required. |
| `IDENTITY.md` | Oz | Agent name, emoji, avatar URL. Display identity only. | **≤500 chars** | Safe to edit. No approval needed. |
| `TOOLS.md` | Oz | Tool environment, commands, API keys, key paths. | **≤600 chars recommended** | Safe to edit. Keep secrets out of logs. |
| `USER.md` | Oz | Duc profile + team roster with roles. | **≤600 chars recommended** | Safe to edit. Keep roster current. |
| `MEMORY.md` | Agent (self) | Long-term persistent facts, key decisions, platform state. | **≤600 lines** | **Append-only.** Never delete or overwrite existing entries. |
| `BOOT.md` | Oz | Gateway restart recovery steps. Always loaded by OpenClaw. | **≤20 lines** | Safe to edit. Use standard 15-line template. |
| `BOOTSTRAP.md` | Oz | Context-loss recovery hint. Always loaded by OpenClaw. | **≤200 chars** | Safe to edit. Typically: "If context incomplete, read memory/active-tasks.md". |
| `HEARTBEAT.md` | Oz | Periodic health check steps + HEARTBEAT_OK fallback. | **≤20 lines** | Safe to edit. Concrete ordered steps only. |

**Exception:** Muse omits BOOT.md and BOOTSTRAP.md (no restart recovery needed — SPEC §3.8).

---

## AGENTS.md Groups A–F (required)

| Group | Content | Check |
|-------|---------|-------|
| A — Unbreakable Rules | No-Guess Rule (MANDATORY) | `grep "No-Guess Rule"` |
| B — Request & Task Execution | Request Decomposition Protocol + Task Execution Protocol | `grep "Request Decomposition"` |
| C — Communication | COMM-001 Completion Reporting + Task Acknowledgment | `grep "COMM-001"` |
| D — Memory & Context | MEM-001 + CTX-001 | `grep "MEM-001"` |
| E — Product & Ownership | PLF-001 + My Ownership + Safety Rules | `grep "PLF-001"` |
| F — Agent-Specific | Domain procedures, role-specific protocols | (role-dependent) |

---

## memory/ Directory

| Path | Owner | Purpose | Policy |
|------|-------|---------|--------|
| `memory/YYYY-MM-DD.md` | Agent (self) | Daily task findings, decisions, lessons | Append-only. |
| `memory/active-tasks.md` | Agent (self) | Crash-recoverable task state | Edit freely — operational scratchpad. |
| `memory/lessons.md` | Agent (self) | Root cause analyses, post-incident lessons | Append-only. |
| `memory/quality-lessons.md` | Oz | Cross-agent quality standards | Append-only. |
| `memory/agents-created.md` | Oz | Agent creation registry | Append-only. |

---

## Content Rules

### SOUL.md — WHO the agent is
- ✅ Persona, tone, communication style, core rules (≤10), boundaries
- ❌ Procedures, step-by-step workflows, tool paths, IDs, long checklists

### AGENTS.md — HOW the agent operates
- ✅ Groups A–F, role-specific protocols, compressed protocol pointers
- ❌ Personality prose, full protocol text (compress to pointer → PROTOCOLS.md), duplicates
- Compress verbose blocks: "Full steps: PROTOCOLS.md §X" not the full procedure

### MEMORY.md — WHAT the agent remembers
- ✅ Discord IDs, session keys, active project names, key decisions, lessons
- ❌ Procedures >5 lines, repo paths/git config (→ TOOLS.md), temporary task state (→ active-tasks.md)
- Litmus test: "Is this a fact I recall, or a procedure I follow?" → Facts go here, procedures go in AGENTS.md or a Skill

### BOOT.md — RESTART recovery
- ✅ Classification table (DANGEROUS/SENSITIVE/SAFE) + Discord post template
- ❌ Agent documentation, personality, protocols
- Template: 15-line standard (task classification table + post-online instructions)

### HEARTBEAT.md — PERIODIC monitoring
- ✅ Ordered numbered checks + HEARTBEAT_OK fallback
- ❌ Prose descriptions, large tables, personality

---

## Silent Change Broadcast Rule

Required whenever `AGENTS.md` or `PROTOCOLS.md` is modified:

```
1. Post to Discord #product-team: brief description of change
2. sessions_send to John (agent:main:main) with change summary
3. Then apply the change
```

Without this, agents in active sessions won't see the update until their next session load.
