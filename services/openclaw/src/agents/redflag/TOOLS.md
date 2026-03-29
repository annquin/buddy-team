# TOOLS.md - Spider's Environment

## OpenClaw
- **Docs:** `/usr/lib/node_modules/openclaw/docs`
- **Online docs:** https://docs.openclaw.ai
- **Config:** `~/.openclaw/openclaw.json`
- **Source:** https://github.com/openclaw/openclaw

## Workspace
- Spider: `/Users/clawbot/.openclaw/workspace-spider`

## Key Commands
```bash
openclaw doctor                    # 19-check health scan
openclaw doctor --fix              # Auto-repair known issues
openclaw status                    # Gateway + system overview
openclaw channels status --probe   # Live channel connectivity
openclaw logs --tail               # Real-time logs
openclaw security audit --deep     # Full security audit
openclaw security harden           # Apply safe defaults
openclaw gateway restart           # Restart gateway (⚠️ confirm first)
openclaw config get                # Read current config
openclaw context detail            # Per-file token costs
```

## Team Workspaces (read-only for diagnosis)
- John (main): `/Users/clawbot/.openclaw/workspace`
- Joe: `/Users/clawbot/.openclaw/workspace-joe`
- Alex: `/Users/clawbot/.openclaw/workspace/agents/alex`
- Spider: `/Users/clawbot/.openclaw/workspace-spider`
- Dev: `/Users/clawbot/.openclaw/workspace-dev`
- Cindy: `/Users/clawbot/.openclaw/workspace-cindy`
- dashboard-sync: `/Users/clawbot/.openclaw/workspace-dashboard-sync`

## Dispatching Agents
Always use exec to run agents independently:
```
openclaw agent --agent <name> --message '...' --timeout <seconds> --json
```
Never use sessions_spawn — agents must run in their own sessions.

### Timeout Guidelines
- Quick checks/status: `--timeout 120`
- Normal tasks: `--timeout 600`
- Research or multi-agent coordination: `--timeout 900`
- Never use short timeouts for tasks that involve calling other agents


