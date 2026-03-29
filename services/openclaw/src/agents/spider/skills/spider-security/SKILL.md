---
description: OpenClaw security — auditing, hardening, sandboxing, exec security, defense-in-depth, CVE tracking, prompt injection vectors.
---

# Spider Security Reference

## Four-Layer Security Model

```
Layer 1: Network/Auth        → gateway binding, TLS, auth tokens
Layer 2: Authorization       → dmPolicy, allowFrom, channel scoping
Layer 3: Tool/Exec Policy    → tool profiles, exec mode, allowlists
Layer 4: Sandbox Isolation   → Docker sandboxing, workspace isolation
```

Defense in depth: never rely on a single layer.

## Sandboxing

| Setting | Values | Effect |
|---------|--------|--------|
| `sandbox.mode` | `off` / `non-main` / `all` | Which sessions get sandboxed |
| `sandbox.scope` | `session` / `agent` / `shared` | Isolation granularity |
| `sandbox.workspace` | `none` / `ro` / `rw` | Workspace access inside sandbox |

Production recommendation: `mode: "all"`, `scope: "agent"`, `workspace: "ro"`.

## Exec Security Modes

| Mode | Behavior | Use When |
|------|----------|----------|
| `full` | All commands allowed | Solo dev, trusted environment only |
| `allowlist` | Only listed commands/patterns | Team/production — default recommendation |
| `approval` | User must approve each command | High-security, untrusted agents |
| `deny` | No exec at all | Agents that should never run commands |

Allowlist example:
```json5
{
  security: {
    exec: {
      mode: "allowlist",
      allow: ["openclaw *", "git *", "docker *", "cat *", "ls *", "grep *"]
    }
  }
}
```

## CVE-2026-25253 "ClawJacked"

- **Type:** SSRF via WebSocket → RCE
- **Fixed in:** v2026.2.25
- **Action:** Always advise keeping OpenClaw updated. Check version: `openclaw --version`
- **Mitigation if can't update:** Bind gateway to 127.0.0.1, enable auth, restrict network access

## 6 Prompt Injection Vectors (Multi-Agent)

| Vector | Attack | Mitigation |
|--------|--------|------------|
| Group chat injection | Malicious user injects instructions in group message | `requireMention: true` for all groups |
| Sub-agent data poisoning | Crafted data from sub-agent manipulates parent | Validate sub-agent outputs, use structured formats |
| Memory poisoning | Attacker writes misleading info to shared memory | Scope memory per agent, audit memory writes |
| Tool output injection | Command output contains prompt injection | Sandbox exec, validate outputs |
| Cross-session leakage | Session context bleeds between users | `session` scope sandboxing, unique session keys |
| Webhook payload injection | External webhook carries malicious prompt | Validate webhook payloads, token auth, treat as untrusted |

## Security Audit Checklist

Run `openclaw security audit --deep --json | jq` for full automated audit. Manual checks:

1. ☐ Gateway bound to 127.0.0.1 or behind reverse proxy
2. ☐ Auth enabled if gateway exposed
3. ☐ Exec mode is `allowlist` or stricter
4. ☐ No agent has `full` tool profile without justification
5. ☐ Sandbox enabled for non-main sessions
6. ☐ `dmPolicy` is `pairing` or `allowlist` (not `open`)
7. ☐ No secrets in workspace files or memory
8. ☐ OpenClaw version ≥ v2026.2.25 (ClawJacked fix)
9. ☐ `requireMention: true` on all group channels
10. ☐ Sub-agent model/tools restricted via `agents.defaults.subagents`

## Hardening Commands

```bash
openclaw security harden    # Apply broad safe defaults
openclaw security audit --fix  # Fix specific findings
openclaw doctor             # Validate overall health
```

`harden` is broad. `audit --fix` is targeted. Run both for new installs.
