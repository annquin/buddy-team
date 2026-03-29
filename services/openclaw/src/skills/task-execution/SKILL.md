---
name: task-execution
description: Standard task execution workflow for all team agents — task ID coordination with Joe, todo planning, subagent delegation, Discord status tracking, and result documentation. Use when receiving any non-trivial task (2+ steps), dispatched work from King/Joe/Duc, or project tasks requiring tracking. NOT for John (main) or subagents.
---

# Task Execution Workflow

Execute tasks in 5 phases. Never skip phases. Update Discord at every phase transition.

## Phase 1: Receive & Register

1. **Get or confirm Task ID.** If the request has no task ID (e.g., `DSK-001`):
   ```
   sessions_send(sessionKey: "agent:joe:main",
     message: "New task needs ID. Agent: <you>. Brief: <one-line>. Project: <if known>.",
     timeoutSeconds: 30)
   ```
   Use the returned ID for all tracking. If Joe times out, use format `<AGENT>-ADHOC-<YYYYMMDD>` and note "pending Joe ID."

2. **Find the Discord thread.** Check if the project has a thread:
   - Read Joe's thread registry: `cat /Users/clawbot/.openclaw/workspace-joe/memory/active-tasks.md` (Thread Registry table)
   - If thread exists → use `channel:<threadId>` for all updates
   - If no thread → post to product-team channel: `1479315677067214958`

3. **Post acknowledgment to Discord:**
   ```
   🟢 **<Your Name> — Task Received**
   **Task:** <ID> — <brief description>
   **From:** <requester>
   **Status:** Planning
   ```

## Phase 2: Plan

1. **Brainstorm todos.** Break the task into concrete steps. Tag each:
   - 🟢 **Light** (<2 min, do yourself)
   - 🟡 **Medium** (2-10 min, subagent candidate)
   - 🔴 **Heavy** (>10 min, subagent recommended)

2. **Write plan to `memory/active-tasks.md`:**
   ```markdown
   ## <Task ID>: <Task Name>
   - **Status:** in-progress
   - **From:** <requester> | **Started:** <timestamp>
   - **Thread:** <discord threadId or "product-team">
   - **Todos:**
     - [ ] 1. <todo> 🟢
     - [ ] 2. <todo> 🟡 → subagent
     - [ ] 3. <todo> 🔴 → subagent
     - [ ] 4. <todo> 🟢
     - [ ] 5. Write results to repo
   - **Result path:** repo/results/<agent-id>/<task-id>.md
   ```
   This file is your crash recovery. If your session resets, the next session reads this and resumes.

3. **Post todo list to Discord:**
   ```
   📋 **<Your Name> — Task Plan: <Task ID>**
   1. ☐ <todo> 🟢
   2. ☐ <todo> 🟡 (subagent)
   3. ☐ <todo> 🔴 (subagent)
   4. ☐ <todo> 🟢
   5. ☐ Write results
   ```

## Phase 3: Execute

Work todos top-to-bottom. Parallel where independent.

**Light todos → do yourself:**
- Execute → mark `[x]` in active-tasks.md → Discord update:
  `✅ **<Name>** — <Task ID> #<n>: <todo> (self, <time>)`

**Medium/Heavy todos → delegate to subagent:**
- See `references/subagent-guide.md` for delegation rules and patterns
- Spawn: `sessions_spawn(task: "<detailed instructions>", mode: "run")`
- On completion: review output → mark `[x]` → Discord update:
  `✅ **<Name>** — <Task ID> #<n>: <todo> (subagent, <time>)`

**On blocker:**
- Update active-tasks.md with blocker details
- Discord: `⚠️ **<Name>** — <Task ID> blocked: <todo> — <reason>`
- Continue non-blocked todos

## Phase 4: Document

Write results to shared repo:
```
/Users/clawbot/.openclaw/workspace/buddy-team/results/<agent-id>/<task-id>.md
```

See `references/result-template.md` for the file format.

Git commit if repo is git-enabled:
```bash
cd /Users/clawbot/.openclaw/workspace/buddy-team
git add results/
git commit -m "result(<agent-id>): <task-id> — <brief>"
git push
```

## Phase 5: Complete

1. **MANDATORY — Notify Duc via John (FIRST, before anything else):**
   ```
   sessions_send(sessionKey: "agent:main:telegram:direct:8292762831",
     message: "🏁 <Your Name> completed <Task ID>: <one-line summary>. Result: repo/results/<agent-id>/<task-id>.md",
     timeoutSeconds: 15)
   ```
   John relays to Duc on Telegram. NEVER skip this. NEVER "plan to do it later."
2. Mark done in `memory/active-tasks.md` (change status to `done` or remove entry)
3. **Discord completion:**
   ```
   🏁 **<Your Name> — Task Complete: <Task ID>**
   **Summary:** <one-line result>
   **Result:** repo/results/<agent-id>/<task-id>.md
   **Duration:** <total time>
   **Subagents used:** <count> | **Todos:** <completed>/<total>
   ```
4. Report to requester via sessions_send if different from Duc

## Quick Reference
```
Receive  → 🟢 Ack + get task ID from Joe
Plan     → 📋 Todo list (tag 🟢🟡🔴, identify subagent work)
Execute  → ✅ Per-todo update (note: self or subagent + time)
Document → 📝 Write results to repo/results/
Complete → 🏁 FIRST: sessions_send to John → then Discord + requester
```
