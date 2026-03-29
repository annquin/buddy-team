---
name: spider-capacity
description: Capacity planning and optimization — maxConcurrent tuning, model tier assignment, context utilization, token efficiency, session management. Use for capacity questions, model optimization, or performance tuning.
---

# Spider Capacity — Planning & Optimization

## When to Use
- Adding new agents (will maxConcurrent handle it?)
- Model tier assignment for new or existing agents
- Token/context optimization requests
- Performance complaints (slow responses, queuing)
- AMO-style model optimization projects

## Concurrency Model

### Lane Architecture
```
Main lane:      maxConcurrent = 6  (inbound messages, heartbeats)
Subagent lane:  maxConcurrent = 12 (clones, spawned tasks)
Cron lane:      separate            (scheduled jobs)
Per-session:    serialized           (one run per session at a time)
```

**Key rules:**
- Agents registered ≠ agents running. 9 agents, 6 concurrent — others queue.
- Subagents do NOT count against main lane.
- Queued agents show typing indicator — user sees activity, not a wall.
- Queue is FIFO per lane.

### Tuning maxConcurrent

| Team Size | Recommended | Notes |
|-----------|-------------|-------|
| 1-3 agents | 2-3 | Minimal queuing risk |
| 4-7 agents | 4-6 | Current sweet spot |
| 8-12 agents | 6-8 | Bump if seeing queue delays |
| 12+ agents | 8-12 | Monitor API rate limits |

**When to increase:** Agents regularly wait >5s in queue. Check with verbose logs ("queued for Xms").
**When to decrease:** API rate limit errors (429), high memory usage, excessive parallel API calls.

**Current config:** maxConcurrent=6, subagents.maxConcurrent=12, maxChildrenPerAgent=5, maxSpawnDepth=1

## Model Tier Assignment

### Decision Framework

| Tier | Model | Cost Profile | Assign When |
|------|-------|-------------|-------------|
| T1 Opus 4.6 | `github-copilot/claude-opus-4.6` | Highest (subscription) | Architecture decisions, security audits, complex multi-step reasoning, agent creation |
| T2 Sonnet 4.6 | `github-copilot/claude-sonnet-4.6` | Medium | Daily dev work, config changes, troubleshooting, coordination |
| T3 Haiku 4.5 | `github-copilot/claude-haiku-4.5` | Lowest | Simple tasks, data sync, quick lookups, background workers |

### Current Assignments
| Agent | Model | Tier | Rationale |
|-------|-------|------|-----------|
| spider | Opus 4.6 | T1 | Platform decisions, agent creation, security |
| alex | Opus 4.6 | T1 | Deep research requires strong reasoning |
| joe | Opus 4.6 | T1 | Project planning, cross-team coordination |
| king | Sonnet 4.6 | T2 | Coordination, quality review |
| dev | Sonnet 4.6 | T2 | Daily coding, implementation |
| paa | Sonnet 4.6 | T2 | User-facing assistant |
| fd | Sonnet 4.6 | T2 | Frontend design |
| main (John) | Haiku 4.5 | T3 | Message relay, simple dispatch |
| dashboard-sync | Haiku 4.5 | T3 | Background data sync |

### When to Downgrade
- Agent doing simple/repetitive work → move from T1 to T2
- Background worker → T3
- Cost pressure → downgrade least-critical agents first

### When to Upgrade
- Agent making bad decisions or missing nuance → try higher tier
- New complex responsibilities added → reassess tier

## Context Window Optimization

### Check Context Usage
```
/context detail    # In any agent session — shows per-file token costs
```

### Optimization Levers
| Lever | Impact | How |
|-------|--------|-----|
| SOUL.md size | Direct — injected every turn | Keep ≤1,500 chars |
| AGENTS.md size | Direct — injected every turn | Move procedures to skills |
| Skills count | ~24 tokens per skill in system prompt | Only keep relevant skills |
| Compaction threshold | When context gets summarized | `compaction.memoryFlush.softThresholdTokens` (current: 8000) |
| Session idle reset | How long context persists | `idleMinutes` (current: 120) |
| Bootstrap total cap | Max chars across all bootstrap files | `bootstrapTotalMaxChars` (default: 150000) |

### Red Flags
- SOUL.md > 1,500 chars → procedures leaked into identity
- Total bootstrap > 100K chars → too many large files
- Agent hitting compaction every 2-3 turns → context too heavy
- `/context detail` shows truncated files → reduce file sizes

## Session Management

### Healthy Session Counts
- 75 active sessions (current) across 9 agents — normal
- Prune after 7 days, max 300 entries, rotate at 10MB (current settings)
- `dmScope: per-channel-peer` — one session per user per channel

### Cleanup
```bash
openclaw status    # Check session count
# Sessions auto-prune per config — manual cleanup rarely needed
```

## Quick Capacity Check (for new feature/agent)
1. How many agents will run simultaneously? → Check against maxConcurrent
2. Which model tier? → Match to task complexity
3. How much context? → Estimate bootstrap files + typical conversation
4. New channel binding? → One more Discord bot? Telegram bot?
5. Cron jobs added? → Check cron lane pressure
6. Subagent usage? → Check against subagent maxConcurrent (12)
