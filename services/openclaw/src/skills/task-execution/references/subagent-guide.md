# Subagent Delegation Guide

## When to Delegate

| Signal | Action |
|--------|--------|
| Todo is 🟡 medium (2-10 min) | Consider delegating if self-contained |
| Todo is 🔴 heavy (>10 min) | Strongly recommend delegating |
| Todo depends on prior todo output | Do NOT delegate — needs your context |
| Todo needs cross-file coordination | Do NOT delegate — too much shared state |
| Todo is 🟢 light (<2 min) | Do NOT delegate — overhead exceeds savings |

## How to Delegate

```python
sessions_spawn(
  task: """
  <Clear, self-contained instructions>
  
  Input: <what the subagent needs — file paths, data, context>
  Output: <exactly what to produce — file path, format>
  Constraints: <any rules — don't modify X, use Y format>
  """,
  mode: "run"
)
```

### Writing Good Subagent Tasks

**Include:**
- Full context (subagent has no memory of your conversation)
- Exact input file paths
- Expected output format and location
- Constraints and boundaries

**Omit:**
- Your internal reasoning — just give instructions
- References to "previous discussion" — subagent has none

## Limits

- Max 5 subagents per agent (`maxChildrenPerAgent: 5`)
- Subagent lane limit: 12 total across all agents
- Max depth: 1 (subagents cannot spawn sub-subagents)
- Each subagent gets a clean context — no shared memory

## Review Protocol

1. **Always review subagent output** before marking todo done
2. Check: complete? correct? follows constraints?
3. If invalid: note what's wrong, redo yourself or respawn with specific feedback
4. If valid: mark done, include "(subagent, <time>)" in Discord update

## Parallel Execution

Independent todos can run as parallel subagents:
```
Todo #2 (independent) → spawn subagent A
Todo #3 (independent) → spawn subagent B
# Both run simultaneously on the subagent lane
```

Dependent todos must be sequential:
```
Todo #2 → complete → use output for Todo #3
```

## Anti-Patterns

- ❌ Delegating without reviewing output (blind trust)
- ❌ Spawning subagents for light tasks (overhead > savings)
- ❌ Passing vague instructions ("figure it out")
- ❌ Forgetting to include file paths in task description
- ❌ Spawning 5+ subagents without checking lane pressure
