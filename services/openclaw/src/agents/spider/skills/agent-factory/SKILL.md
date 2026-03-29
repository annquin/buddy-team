---
description: Create production-ready OpenClaw agents from role descriptions. Use when asked to create, set up, or build a new agent.
---

# Agent Factory

## Purpose
Guided workflow for creating a complete, production-ready OpenClaw agent from a role description or research input.

## When to Use
- Creating a new OpenClaw agent
- Setting up an agent workspace from scratch
- Generating agent configuration files from a role spec

## Workflow

### 1. Requirements Intake
Gather or extract from input:
- **Role:** What the agent does (one sentence)
- **Name:** Agent name and ID
- **Domain:** Area of expertise
- **Tools needed:** What tools the agent requires
- **Communicates with:** Other agents or humans
- **Special rules:** Any constraints or guardrails

If any are missing, ask before proceeding.

### 2. SOUL.md Generation
Target: ≤1,500 chars (ideally ~800-1,200)

Structure:
```markdown
# SOUL.md - <Name>

You are <Name>, a <role>.

<Mission in 1-2 sentences.>

## Vibe
<3-5 adjectives + concrete guidance>

## Rules
<5-8 numbered, actionable rules>

## Boundaries
<What agent does/doesn't do with redirect patterns>
```

Rules for SOUL.md:
- First paragraph = identity + mission (most important)
- 4-6 sections max
- No procedures (those go in AGENTS.md)
- No environment-specific info (that goes in TOOLS.md)
- Boundaries must include redirect patterns ("If asked X → respond Y")
- **Always include this rule:** `X. **Lost context?** Read \`memory/active-tasks.md\` immediately.`
- **Always include this rule:** `X. **Report to Discord.** Send start/progress/completion for every task. No silent work. **Non-negotiable — a task is NOT done until you post ✅ to Discord AND push-back to the dispatcher.**`

### 3. AGENTS.md Generation
No hard length limit, but keep focused. Include:
- Session startup routine (what to read first — must include `memory/active-tasks.md` for crash recovery)
- Core workflow (step-by-step for the agent's main job)
- Safety rules (must include the expert consultation rule: "Before acting in another agent's domain, consult them first" with lookup table)
- Output standards
- Tool usage guidance specific to the role

Every agent's "Every Session" section should follow this pattern:
```markdown
## Every Session (or Context Recovery)
1. Read `SOUL.md` — who you are
2. Check `memory/active-tasks.md` — resume any incomplete work from a previous session
3. Read any domain-specific memory files

**Trigger this sequence on:** new session, after context compaction, after reconnect, or any time context feels incomplete.
```

### 3b. Standard Sections (MANDATORY)

Every agent's AGENTS.md MUST include these two sections. Tailor the specifics (git vs no-git, domain-specific steps) but keep the structure:

#### Task Lifecycle
```markdown
## Task Lifecycle (MANDATORY)

Every non-trivial task follows this lifecycle. No exceptions.

### Starting a Task
- Check `memory/active-tasks.md` for incomplete work from a previous session — resume if found
- If carrying context from a previous task: compact or request a fresh session
- If unable to get a fresh session: summarize prior work, then mentally reset
- Confirm understanding of the task before beginning
- Write task checklist to `memory/active-tasks.md` before starting work

### During a Task
- Stay focused on current task only
- Update `memory/active-tasks.md` as steps complete (persists progress across crashes)
- New unrelated request arrives: finish current first
- Urgent interrupt: park current work (write to disk, WIP commit, update active-tasks.md), then handle urgent in clean context

### Completing a Task
1. Write all outputs to disk
2. Git commit & push (if applicable)
3. Mark task done in `memory/active-tasks.md` (or remove entry)
4. Report results to requester
5. NOT complete until outputs are persisted

### Between Tasks
- Previous context is stale — do not carry forward
- Start next task as if new session
```

#### Task Execution Protocol
```markdown
## Task Execution Protocol (MANDATORY)

For any task with 2+ steps:

### Plan
Output a checklist before doing work:
- [ ] Step 1: <concrete action>
- [ ] ...
- [ ] Final: Persist results + report summary

### Execute & Track
Update checklist as you go. Report progress after each step (or every 2-3 for fast tasks).

### Complete
Output final checklist + summary + output location.
```

Tailor both sections to the agent's domain:
- Research agents: batching strategy ties into Task Lifecycle
- Dev agents: git commit is part of "Completing a Task"
- Q&A agents: may skip Execution Protocol (simple request/response)
- Document any exceptions in agents-created.md

#### Step 0 Rule for Named Workflows

If the agent has a named multi-step workflow (e.g. "Research Workflow", "Project Workflow", "Build Pipeline"), embed **Step 0: Log Task Plan** as the literal first step of that workflow:

```markdown
### Step 0: Log Task Plan
Before ANY other work:
1. Write task summary + checklist to `memory/active-tasks.md`
2. Include: task name, requester, date, numbered steps
3. This is your crash recovery. If you get killed mid-task, the next session reads this file and resumes.

Do NOT skip this step. Do NOT combine it with Step 1. Write the file first, then proceed.
```

**Why this exists:** Task Lifecycle says "write to active-tasks.md before starting work" but it's a general section. Agents follow their domain-specific workflow steps, not the general lifecycle. Embedding Step 0 directly into the workflow they follow makes it impossible to skip.

**Placement rules:**
- Task Lifecycle + Task Execution Protocol go ABOVE named workflows in AGENTS.md (read order matters)
- Step 0 goes inside the named workflow as its first step (redundant with lifecycle, intentionally)

#### Completion Reporting
```markdown
## Completion Reporting (MANDATORY — NO EXCEPTIONS)

Every dispatched task MUST end with BOTH of these, in order:

1. **Discord update:** Post ✅/❌/⚠️ to `#product-team` via `message(action='send', channel='discord', target='channel:1479315677067214958', message='<emoji> <Name>: ✅ Done: <summary>. Output: <path>')`
2. **Push-back to dispatcher:** `sessions_send(sessionKey: "<dispatcher-session-key>", message: "<Name> here. Task complete. Result: <summary>. Output: <path>.", timeoutSeconds: 0)`

**A task is NOT complete until both are sent.** Do not clear `active-tasks.md` until reporting is done.
```

Tailor for the agent:
- Research agents: add step 3 "Notify stakeholders waiting on your research via sessions_send"
- Use the agent's emoji and name in the Discord message template
- If the agent has no Discord account, it can still post via the `message` tool (routes through default account)

### 4. IDENTITY.md Generation
```markdown
# IDENTITY.md - Who Am I?

- **Name:** <name>
- **Creature:** <brief description>
- **Vibe:** <style> <emoji>
- **Emoji:** <signature emoji>
```

### 5. Supporting Files
- **USER.md** — Team info (Duc, timezone, preferences). MUST include the full team roster:
    ```markdown
    ## Team
    - **John (main)** — Personal assistant, Telegram proxy to Duc, team aggregator
    - **King** — Principal PM, strategic decisions, cross-project oversight
    - **Joe** — Project Manager, plans and tracks
    - **Alex** — Deep Research Specialist
    - **Dev** — Developer, dashboard, feature implementation
    - **Spider** — Platform Engineer, agent lifecycle
    - **FD** — Feature Discovery, UI/UX design
    - **PAA** — Personal Assistant Agent (user-facing)
    - **Dashboard-sync** — Dashboard automation
    - **GitHub:** cuihuibot
    - **Git email:** john@openclaw.ai
    ```
    Omit the new agent itself from its own roster. Update all existing agents' USER.md files to include the new agent (see Step 9).
- **TOOLS.md** — Environment paths, repo locations, relevant tool notes. MUST include full team workspace roster:
    ```
    John (main): /home/midang/.openclaw/workspace
    King: /home/midang/.openclaw/workspace-king
    Joe: /home/midang/.openclaw/workspace-joe
    Alex: /home/midang/.openclaw/workspace/agents/alex
    Spider: /home/midang/.openclaw/workspace-spider
    Dev: /home/midang/.openclaw/workspace-dev
    FD: /home/midang/.openclaw/workspace-fd
    PAA: /home/midang/.openclaw/workspace-paa
    Dashboard-sync: /home/midang/.openclaw/workspace-dashboard-sync
    ```
- **MEMORY.md** — Initial index pointing to memory/ subdirectory
- **HEARTBEAT.md** — Empty unless periodic tasks are needed
- **BOOTSTRAP.md** — Context recovery reminder, injected every turn from disk:
    ```markdown
    ⚠️ CONTEXT CHECK: If you're unsure what you were working on, if context feels incomplete, or if you just reconnected — read `memory/active-tasks.md` immediately before doing anything else.
    ```
- **memory/** — Create directory with initial files:
  - **memory/active-tasks.md** — Persistent task tracker for crash recovery. Format:
    ```markdown
    # Active Tasks
    
    ## <Task Name>
    - **Status:** in-progress | parked | done
    - **Started:** <timestamp>
    - **Checklist:**
      - [x] Step 1
      - [ ] Step 2
      - [ ] ...
    - **Notes:** <any context needed to resume>
    ```

### 6. Registration Commands
Generate the exact commands:
```bash
# Create workspace
mkdir -p ~/.openclaw/workspace-<id>/{memory,skills}

# Register agent
openclaw agents add <id> --workspace ~/.openclaw/workspace-<id>

# Set identity (after IDENTITY.md is in place)
openclaw agents set-identity --agent <id> --from-identity
```

### 7. Tool Access Configuration
Generate the openclaw.json agent entry:
```json5
{
  id: "<id>",
  tools: {
    profile: "coding",  // start here, justify any upgrade
    allow: [],           // add only what's needed
    deny: []             // explicitly deny what's not needed
  }
}
```

### 8. Validation
Run the 10-point checklist and report results:
1. SOUL.md ≤1,500 chars
2. AGENTS.md has mission + workflows + safety
3. IDENTITY.md has name + emoji + vibe
4. Role boundaries with redirect patterns
5. Tool access scoped
6. Safety rules present
7. Smoke test passed
8. Context not truncated
9. Memory operations work
10. Documented in agents-created.md

### 9. Team Roster Update (MANDATORY)
After creating any new agent, update the team roster in ALL existing agents' TOOLS.md files:
1. List all workspace directories: `ls -d /home/midang/.openclaw/workspace*` + `ls -d /home/midang/.openclaw/workspace/agents/*/`
2. For each active agent's TOOLS.md, add the new agent to their "Team Workspaces" section
3. Update the agent-factory SKILL.md template roster (section 5, TOOLS.md bullet)

**Always include John (main agent, workspace: /home/midang/.openclaw/workspace/) in team-wide rollouts.** Adapt for his PM role but core protocols apply. Never skip John.
4. Verify with: `grep -c "<new-agent-id>" /home/midang/.openclaw/workspace*/TOOLS.md`

**This prevents stale rosters that cause missed rollouts.**

### 10. Notify & Reload (MANDATORY)
After creating or updating any agent's workspace files:
1. Dispatch the agent: `openclaw agent --agent <id> --message 'Your workspace files were updated: <list files>. Reload SOUL.md, AGENTS.md, TOOLS.md, and any changed skills. Acknowledge what changed and flush to memory (memory/YYYY-MM-DD.md or MEMORY.md).' --timeout 120 --json`
2. Confirm acknowledgment before marking the task complete.
3. For bulk updates (multiple agents), notify each affected agent.

**Agents don't know their files changed until you tell them.**

## Output Format
Present the complete agent as:
1. All file contents (ready to write)
2. Registration commands (ready to run)
3. Tool access config (ready to add to openclaw.json)
4. Smoke test commands (ready to verify)
5. Checklist results (pass/fail per item)
