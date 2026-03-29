---
description: OpenClaw configuration — openclaw.json structure, precedence, hot-reload, top 10 misconfigurations, recommended configs for solo/team/production.
---

# Spider Config Reference

## openclaw.json Structure

25+ top-level sections. Key ones:

| Section | Purpose | Hot-reload? |
|---------|---------|-------------|
| `agents` | Agent configs, defaults, sub-agent settings | ✅ Yes |
| `tools` | Global tool profiles, allow/deny | ✅ Yes |
| `security` | Exec policy, sandbox, auth | ✅ Yes |
| `models` | Provider keys, model routing, fallbacks | ✅ Yes |
| `channels` | Channel bindings, DM/group policy | ✅ Yes |
| `memory` | Memory config, search settings | ✅ Yes |
| `sessions` | Reset modes, caps, transcript limits | ✅ Yes |
| `gateway.*` | Bind address, port, auth | ❌ Restart |
| `discovery.*` | mDNS, device pairing | ❌ Restart |
| `canvasHost.*` | Canvas server config | ❌ Restart |
| `plugins.*` | Plugin loading | ❌ Restart |

## Config Precedence Chain

```
per-session → per-agent → agent defaults → global → built-in
(highest)                                           (lowest)
```

- `deny` always wins over `allow` at every level
- Agent-level: `agents[].tools.deny` overrides `agents[].tools.allow`
- Legacy alias: `agent.` = `agents.defaults.`

## Config Splitting

`$include` supports nested files up to 10 levels deep. Use for large configs:
```json
{ "$include": "./agents.json" }
```

## Config RPCs

Rate-limited: 3 requests per 60s per device+IP. Gateway restart coalesced with 30s cooldown.

## Top 10 Misconfigurations

| # | Misconfiguration | Symptom | Fix |
|---|-----------------|---------|-----|
| 1 | Unknown keys in openclaw.json | Startup blocked | Remove or fix typo |
| 2 | Missing API keys for configured models | Model calls fail silently | Add keys or remove model |
| 3 | `dmPolicy: "open"` without wildcard scope | DMs rejected | Set `dmScope` or use `"pairing"` |
| 4 | Shared `agentDir` across agents | Agents overwrite each other's state | Unique workspace per agent |
| 5 | Default `full` tool profile | Over-permissive agents | Use `coding` or explicit groups |
| 6 | No `dmScope` for multi-user setup | Wrong user gets responses | Configure `dmScope` per channel |
| 7 | Gateway binding to 0.0.0.0 without auth | Open to network | Bind to 127.0.0.1 or add auth |
| 8 | Oversized BOOTSTRAP.md / workspace files | Context overflow | Keep under 4K chars total |
| 9 | `config.patch` without reading baseHash | Race condition on concurrent edits | Always `config.get` first |
| 10 | Tool profile `full` on sub-agents | Sub-agents inherit excessive access | Set `agents.defaults.subagents.model` + restrict tools |

## Recommended Configs

### Solo (single user, local)
```json5
{
  security: { exec: { mode: "full" } },
  tools: { profile: "coding" },
  sessions: { resetMode: "daily" }
}
```

### Team (multi-user, shared server)
```json5
{
  security: { exec: { mode: "allowlist" }, sandbox: { mode: "non-main" } },
  tools: { profile: "coding" },
  dmPolicy: "pairing",
  sessions: { resetMode: "idle", idleMinutes: 60 }
}
```

### Production (exposed, multi-agent)
```json5
{
  security: { exec: { mode: "allowlist" }, sandbox: { mode: "all", scope: "agent" } },
  tools: { profile: "coding", deny: ["browser", "nodes"] },
  gateway: { auth: true, bind: "127.0.0.1" },
  dmPolicy: "allowlist",
  sessions: { resetMode: "idle", idleMinutes: 30, maxSessions: 50 }
}
```
