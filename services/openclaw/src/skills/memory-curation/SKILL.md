---
name: memory-curation
description: Curate durable knowledge across `MEMORY.md`, `memory/YYYY-MM-DD.md`, topic memory files, and `.learnings/`. Use when: (1) a significant task finished, (2) you learned a correction or durable lesson, (3) the user says “remember this”, (4) session context is getting full, or (5) you need a fast capture of something worth saving before it is lost. NOT for routine status updates, transient acknowledgments, or ordinary memory reads.
---

# Memory Curation

Persist the knowledge that should survive compaction, resets, and handoffs.

## Storage Map — Where Things Go

Use this placement guide first.

### `MEMORY.md`
Put information here when it is durable reference material:
- user preferences
- ownership / responsibilities
- durable decisions
- stable architecture or process truths
- corrections that will matter again later

### `memory/YYYY-MM-DD.md`
Put information here when it is important but still date-scoped:
- task outcomes
- research summaries
- failures + fixes
- temporary context likely useful for the next days/weeks

### `memory/<topic>.md`
Put information here when one topic is too large or specialized for `MEMORY.md`:
- project-specific reference material
- long-running topic knowledge
- overflow from `MEMORY.md`

### `.learnings/LEARNINGS.md`
Put information here when it is a reusable lesson about **how work was done**:
- mistakes and corrections
- failed assumptions
- process lessons
- “next time do X before Y” guidance

### `memory/active-tasks.md`
Use only for crash recovery / current task state. Do **not** treat it as durable memory.

---

## Mode Selector

## Mode 1 — `fast-capture`
Use when something important might be lost if you do not save it now.

**When to use**
- context is getting long
- you just received an important correction
- you finished a task and want to save the minimum durable fact now

**Workflow**
1. Write the smallest useful durable summary
2. Choose the right destination using the Storage Map above
3. Save now, refine later if needed

## Mode 2 — `curate-entry`
Use after significant work, research, or decisions.

**Workflow**
1. Apply the persistence test
2. Choose destination (`MEMORY.md`, daily log, topic file, or `.learnings/`)
3. Check for duplicates before writing
4. Save in a concise, searchable format

## Mode 3 — `promote`
Use when daily logs contain facts that deserve promotion into durable memory.

**Workflow**
1. Read older daily logs
2. Pull out durable facts
3. Rewrite them into `MEMORY.md` or topic memory form
4. Remove or mark redundant daily content if appropriate

## Mode 4 — `consolidate`
Use when memory is cluttered or repetitive.

**Workflow**
1. Merge duplicate entries
2. Mark superseded facts
3. Move overflow into topic files
4. Keep `MEMORY.md` lean and retrievable

---

## Persistence Test

Ask these questions before writing:

| Question | If YES | If NO |
|---|---|---|
| Will this matter in 7+ days? | Persist somewhere | Probably skip |
| Would losing it cause a future mistake? | `MEMORY.md` or `.learnings/` | Daily log at most |
| Is it a durable fact/decision/lesson? | Persist | Skip or keep temporary |
| Is it mainly about process failure or correction? | `.learnings/LEARNINGS.md` | Another destination |
| Is it mainly about user/project/reference state? | `MEMORY.md` / topic file / daily log | — |

---

## Writing Rules
- Lead with a natural-language heading
- Include exact identifiers in backticks when useful
- Prefer concise prose or bullets over long narration
- Save validated facts, not speculation
- Do not store routine acknowledgments or raw tool output

## Recommended Formats

### For `MEMORY.md`
```markdown
## [Searchable topic heading]
[2-3 sentence durable summary with identifiers in `backticks`]
```

### For daily logs
```markdown
## [Topic]
- **What:** [fact/decision]
- **Why:** [reason]
- **Tags:** `task-id`, `agent-name`, `topic`
```

### For `.learnings/LEARNINGS.md`
```markdown
## [Learning ID or short topic]
**Summary:** [what went wrong / what was learned]
**Suggested Action:** [what to do differently next time]
**Tags:** `verification`, `research`, `config`
```

---

## Practical Rules of Thumb
- **Remember this / durable preference / stable correction** → `MEMORY.md`
- **Task outcome / dated summary / short-term useful context** → `memory/YYYY-MM-DD.md`
- **Big specialized topic** → `memory/<topic>.md`
- **Process lesson / mistake / correction pattern** → `.learnings/LEARNINGS.md`
- **Current task tracking** → `memory/active-tasks.md`

If unsure, use `fast-capture` first, then clean it up later with `promote` or `consolidate`.
