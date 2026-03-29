# Team Workflow Skill

> **Summary:** Defines the end-to-end team collaboration process — from idea to delivery. Covers project lifecycle, communication rules, handoff protocol, and deliverable standards. Every agent follows this when working on features, projects, or products.

## When to Use
- Starting a new feature, project, or product
- Joining an in-progress project
- Handing off work to another agent
- Reviewing or approving deliverables
- Monitoring project execution

---

## Project Lifecycle (7 Phases)

### Phase 1: Initiation
**Anyone** (user or agent) can propose a new feature/project/product.

1. Initiator writes a brief description of the idea
2. Initiator brings it to **Joe** (Project Manager)

### Phase 2: Specification
**Owner: Joe**

1. Joe works with the initiator to spec out requirements
2. Joe ensures everything is **clean, clear, and complete**
3. If anything is unclear → Joe clarifies with **Duc** (user) via John
4. Output: Draft spec/PRD in `projects/<slug>/`

### Phase 3: Vision Alignment
**Owner: Joe + King**

1. Joe presents the spec to **King** (Principal PM)
2. King validates alignment with **product vision and mission**
3. If misaligned → King provides direction, Joe revises
4. Output: Vision-approved spec

### Phase 4: Team Collaboration
**Owner: Joe (coordination), all relevant agents**

1. Joe identifies which agents are needed:
   - **Expert agents** related to the feature (Ford for UI, Dev for code, Oz for infra, etc.)
   - **Alex** for any research needed
   - **Joe** for documentation, proposals, and planning
2. Team collaborates to refine the spec, create designs, research unknowns
3. Joe documents the plan with **named task assignments**
4. Output: Final proposal with task breakdown + owner assignments

### Phase 5: Review & Approval
**Owner: King → User**

1. Joe sends the proposal to **King** for review
2. King reviews with the team — all **contributing agents sign off**
3. King sends the approved proposal to **Duc** (user) via John
4. Duc reviews:
   - ✅ **Approved** → King announces to team: "Ready to start"
   - ❌ **Not approved** → Goes back to team for revision (repeat Phase 4-5)

### Phase 6: Execution
**Owner: Each assigned agent**

1. Each agent reads the plan and finds **tasks with their name assigned**
2. Each agent executes their assigned tasks independently
3. **Collaborative tasks** (e.g., "Website = Ford + Dev"):
   - The **first named agent** initiates communication with other assigned agents
   - Example: "Website = Ford + Dev" → Ford starts, pulls in Dev
4. **King monitors** execution status and nudges task owners who are slacking
5. When a task is done:
   - Update the project doc with your delivery + artifact links
   - Send `sessions_send` to the **next task owner** that they can start

### Phase 7: Completion
**Owner: King**

1. King validates all deliverables with the team
2. King reports final status to **Duc** (user) via John
3. Duc reviews before declaring project **completed**
4. If issues found → back to relevant agents for fixes

---

## Handoff Protocol

Every task handoff between agents MUST include these 5 fields:

```
1. FROM: [your agent name]
2. TO: [target agent name]
3. TASK: [1-sentence description]
4. DELIVERABLE: [exact file path or expected output]
5. DEADLINE: [timestamp, duration, or "ASAP"]
```

**Rules:**
- **Receiver must acknowledge within 15 min:** "Accepted, ETA [time]" or "Rejected — [reason]"
- No ack within 15 min → escalate to Oz (agent may be down)
- **Deliverables go to repo/workspace files**, not inline messages. The handoff message contains a pointer to the file.
- Mid-task handoffs must include: what's done + what's remaining

## Monitoring & Deadline Enforcement

**King uses exception-based monitoring** — agents self-report, King nudges only when:

| Situation | Action |
|-----------|--------|
| ETA missed by <2 hours | Auto-grace — agent self-reports delay |
| ETA missed by 2-8 hours | King nudges: "Status on [task]? Need help?" |
| ETA missed by >8 hours | King escalates: reassign or descope |
| No start ack within 15 min | Escalate to Oz |
| Blocker reported | King decides: reassign, descope, or unblock |

**Phase SLAs (guidelines, not rigid):**

| Phase | SLA | Escalation |
|-------|-----|-----------|
| Propose → Spec | 24h | King nudges Joe |
| Spec → Approve | 4h | Oz nudges King |
| Approve → Execute start | 1h | King nudges assigned agent |
| Validate → Ship | 24h | Joe nudges King |

---

## Communication Protocol

| Channel | When |
|---------|------|
| **Telegram via John** | User ↔ Team communication (Duc sends/receives through John) |
| **`sessions_send`** | Agent ↔ Agent direct communication (task handoffs, questions, updates) |
| **Discord #product-team** | Announcements, status updates, completion reports |
| **Project docs** (`projects/<slug>/`) | Persistent plans, specs, decisions, deliverables |

### Rules
1. **Never assume another agent saw your work** — explicitly notify via `sessions_send`
2. **Task handoffs require a message**: "Task X is done. [link to deliverable]. You can start Task Y."
3. **Status updates go to Discord** — don't keep progress silent
4. **Blockers get escalated immediately** — to Joe (coordination) or King (decision-needed)
5. **User questions always route through John** — never message Duc directly from other agents

---

## Deliverable Standards

### Summary-First Format (MANDATORY)
Every created document must have this structure:

```markdown
# Title

> **Summary:** 2-3 sentence overview of what this document contains,
> key decisions made, and outcomes. An agent reading only this summary
> should have enough context to decide if they need the full document.

## Details
... (full content below)
```

### Artifact Linking
When completing a task, always include:
- **File path** or **repo path** to deliverables
- **Commit hash** if pushed to repo
- **Brief description** of what was delivered

Example:
```
✅ Task: Design system tokens
Delivered: `/workspace-fd/design-system/tokens.css` (commit `abc1234`)
Description: CSS custom properties for colors, spacing, typography. 47 tokens total.
```

---

## Role Quick Reference

| Role | Responsibilities in Project Lifecycle |
|------|--------------------------------------|
| **Joe** | Spec requirements, plan tasks, assign owners, coordinate team, document |
| **King** | Validate vision alignment, review proposals, monitor execution, report to user, nudge slackers |
| **Alex** | Research unknowns, provide data/analysis to inform decisions |
| **Ford (FD)** | UI/UX design, frontend implementation |
| **Dev** | Backend/full-stack implementation, technical architecture |
| **Oz** | Infrastructure, platform, agent config, deployment |
| **John** | User communication relay (Telegram ↔ Team) |
| **PAA** | User-facing assistant tasks |
| **Dashboard-sync** | Dashboard data sync, monitoring automation |
| **Seer** | Spiritual readings (astrology, numerology, etc.) |

---

## Anti-Patterns

❌ **Starting work without a spec** — Always go through Joe first
❌ **Skipping vision check** — King must validate alignment before team collaboration
❌ **Silent completion** — Always announce + link deliverables when done
❌ **Assuming handoffs** — Explicitly notify the next person via `sessions_send`
❌ **Bypassing John for user comms** — All user communication goes through John
❌ **Unassigned tasks** — Every task needs a named owner before execution starts
❌ **No summary on deliverables** — Summary-first format is mandatory
