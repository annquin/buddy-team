---
description: OpenClaw troubleshooting — 4-step triage, openclaw doctor (19 checks), 12 log patterns, compaction vs pruning, context debugging.
---

# Spider Troubleshooting Reference

## 4-Step Triage (Expanded)

### Step 1: `openclaw doctor`
- Runs 19 check categories: config validation, legacy migrations, state integrity, model auth, gateway health, supervisor config, workspace tips
- Use `--fix` to auto-repair known issues
- Always run first — most issues show up here

### Step 2: `openclaw channels status --probe`
- Tests live connectivity to each configured channel
- Shows auth status, connection latency, error messages
- `--probe` is critical — without it, only shows config, not actual connectivity

### Step 3: `openclaw status`
- Gateway uptime, active sessions, system resource usage
- Agent status, loaded models, memory usage

### Step 4: `openclaw logs --tail`
- Real-time log stream
- Filter by subsystem: `--filter channels.telegram`
- 6 log levels: trace, debug, info, warn, error, fatal
- Sensitive data auto-redacted

## 12 Common Log Patterns

| Pattern | Meaning | Action |
|---------|---------|--------|
| `drop guild message` | Group policy filtering message | Check group policy + allowlist |
| `sender filtered by policy` | DM policy rejecting sender | Check dmPolicy + dmScope |
| `SYSTEM_RUN_DENIED` | Exec blocked by security policy | Check exec mode + allowlist |
| `model auth failed` | Invalid or expired API key | Verify model provider keys |
| `context overflow` | Conversation exceeded token limit | Compact or prune context |
| `session reset (idle)` | Session auto-reset by idle timer | Expected if resetMode: "idle" |
| `tool schema cost` | Tool definitions consuming tokens | Reduce tool profile scope |
| `sandbox timeout` | Sandboxed command exceeded limit | Increase timeout or optimize command |
| `config hot-reload` | Config change applied without restart | Normal — informational |
| `gateway restart required` | Config change needs restart | Run `openclaw gateway restart` |
| `rate limit exceeded` | Too many API/config requests | Back off, check rate limits |
| `binding match: <agent>` | Channel routing matched agent | Useful for debugging routing order |

## `openclaw doctor` — 19 Check Categories

1. Config file syntax + schema validation
2. Unknown/deprecated keys
3. Legacy config migrations
4. Model provider authentication
5. Model availability + fallback chains
6. Channel configuration validity
7. Channel credential presence
8. Agent workspace existence
9. Agent config completeness
10. Tool profile validation
11. Exec security policy check
12. Sandbox configuration
13. Gateway bind + auth settings
14. Session config (reset mode, limits)
15. Memory config validation
16. Cron job validation
17. Hook configuration
18. Supervisor/main agent config
19. Workspace file size warnings

## Compaction vs Pruning

| | Compaction | Pruning |
|--|-----------|---------|
| **Persistence** | Permanent — rewrites transcript | Transient — per-request only |
| **What happens** | Model summarizes conversation, replaces old messages | Old messages dropped from context window |
| **Disk effect** | Transcript file is rewritten | No disk change |
| **When to use** | Long-running sessions, memory management | Immediate context relief, keeping recent messages |
| **Triggered by** | `/compact` command or auto-compact threshold | Automatic when context exceeds limit |
| **Risk** | Loses detail from old messages permanently | Old messages still on disk, just not in context |

## Context Debugging

```bash
openclaw context detail    # Per-file token costs
openclaw context list      # All loaded context files
```

**Hidden token costs:**
- Tool schemas: ~8K+ tokens for `full` profile — biggest hidden cost
- Skills: loaded on-demand, but check which are active
- Workspace files: SOUL.md + AGENTS.md + others loaded every session

**If context is tight:**
1. Check tool profile — switch from `full` to `coding` (saves ~4K tokens)
2. Check loaded skills — disable unused ones
3. Check workspace file sizes — trim AGENTS.md, move reference to skills
4. Check conversation length — compact or start fresh session

## 6 Common Startup Failures

| Failure | One-Line Fix |
|---------|-------------|
| `EADDRINUSE` | Another instance running — `openclaw gateway stop` first |
| `config parse error` | Syntax error in openclaw.json — run `openclaw doctor` |
| `unknown key` | Typo in config key — check spelling |
| `model provider not found` | Missing API key or provider not installed |
| `workspace not found` | Agent workspace path doesn't exist — check `agents[].workspace` |
| `permission denied` | File permissions — check ownership of workspace dirs |
