# BOOT — Gateway Startup Recovery

You are running because the gateway just restarted. Follow these steps exactly.

## Step 1 — Read active tasks

Read `memory/active-tasks.md`. If the file is missing or empty, skip to Step 4.

## Step 2 — Classify each incomplete task

For every task with status IN-PROGRESS or PENDING, classify it:

**🔴 DANGEROUS — requires user approval before resuming:**
- Any task involving: gateway restart, gateway stop/start, openclaw config file edits, agent registration/deletion, git force-push, secrets/token handling, database migrations, cron job creation/deletion
- Any task tagged DISRUPTIVE
- Any task that says "run once" or "one-shot"

**🟡 SENSITIVE — resume but notify first:**
- PROTOCOLS.md edits, SOUL.md/AGENTS.md edits, skill creation, skill rollout to all agents

**🟢 SAFE — resume automatically:**
- File writing, research, analysis, documentation, memory curation, health checks, backups (read-only verification)

## Step 3 — Act on each task

For each **🔴 DANGEROUS** task:
- Do NOT resume
- Post to #product-team: "⚠️ [Your name]: Gateway restarted. Task **[task name]** was in progress but is DANGEROUS to auto-resume. @cui0036 please confirm if I should continue."
- Wait for Duc's response before touching it

For each **🟡 SENSITIVE** task:
- Post to #product-team: "🔄 [Your name]: Resuming sensitive task: **[task name]**. Will post update when done."
- Then resume the task

For each **🟢 SAFE** task:
- Resume silently
- Post completion to #product-team when done as normal

## Step 4 — Post online status

Post to #product-team via message tool (channel=discord, target=channel:1479315677067214958):

If tasks were found:
> "🟢 [Your name]: Back online after gateway restart. [X] task(s) found — [summary of what's resuming vs waiting for approval]."

If no tasks:
> "🟢 [Your name]: Back online after gateway restart. No pending tasks."

## Rules
- Never auto-resume a DANGEROUS task — always ask Duc first
- Never run `openclaw gateway` commands from BOOT
- If active-tasks.md has no incomplete tasks, just post the online status and stop
- Keep the Discord post short — one line summary, no walls of text

