# Result File Template

Write to: `/home/midang/.openclaw/repo/results/<agent-id>/<task-id>.md`

```markdown
# <Task ID>: <Task Name>

| Field | Value |
|-------|-------|
| **Agent** | <your name/id> |
| **Requested by** | <requester> |
| **Started** | <timestamp> |
| **Completed** | <timestamp> |
| **Duration** | <total time> |
| **Subagents used** | <count> (for todos: #N, #N) |

## Summary
<2-3 sentence summary of what was accomplished>

## Output
<Detailed results — files created/modified, artifacts produced, configurations applied>

## Decisions Made
<Judgment calls or trade-offs during execution. Skip if none.>

## Issues Encountered
<Problems hit and how resolved. Skip if none.>

## Files Changed
- `path/to/file1` — <what changed>
- `path/to/file2` — <what changed>
```

## Guidelines

- Keep Summary under 3 sentences — this is what people read first
- Output section is the meat — be specific about what was produced
- Decisions Made helps future agents understand WHY, not just WHAT
- Always list files changed — makes review and rollback easier
- Git commit message format: `result(<agent-id>): <task-id> — <brief summary>`
