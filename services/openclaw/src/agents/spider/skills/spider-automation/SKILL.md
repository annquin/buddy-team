---
description: OpenClaw automation — cron jobs, heartbeats, hooks, BOOT.md, webhooks, scheduling, 10 automation anti-patterns.
---

# Spider Automation Reference

## Cron vs Heartbeat Decision

| Factor | Heartbeat | Cron |
|--------|-----------|------|
| **Schedule precision** | Approximate (batched) | Exact (cron expression) |
| **Context** | Full main-session context | Isolated or main |
| **Cost** | Cheaper (batches all tasks in one turn) | One turn per job |
| **Use when** | Routine checks, reminders, memory maintenance | Exact-time reports, scheduled audits, external triggers |
| **HEARTBEAT.md** | Required — defines what to check | Not used |

**Rule of thumb:** If timing must be exact → cron. If "roughly every X" is fine → heartbeat.

## Three Schedule Kinds

| Kind | Syntax | Behavior |
|------|--------|----------|
| `at` | ISO timestamp | One-shot, auto-deletes after firing |
| `every` | Interval string (`"30m"`, `"6h"`) | Recurring at fixed interval |
| `cron` | Standard cron expression | Recurring with timezone support |

```json5
// Examples
{ schedule: { at: "2026-03-06T09:00:00Z" } }
{ schedule: { every: "6h" } }
{ schedule: { cron: "0 9 * * 1-5", timezone: "Asia/Bangkok" } }
```

## Two Payload Kinds

| Kind | Behavior | Use When |
|------|----------|----------|
| `systemEvent` | Enqueues for next heartbeat cycle | Cheap, batched, approximate |
| `agentTurn` | Dedicated isolated agent turn | Exact timing, independent execution |

## Wake Events

| Mode | Behavior |
|------|----------|
| `wakeMode: "now"` | Triggers immediate heartbeat turn |
| `wakeMode: "next-heartbeat"` | Batches into next regular heartbeat cycle |

**Cost optimization:** Use `"next-heartbeat"` for non-urgent events. `"now"` costs a full model turn.

## Delivery Modes

| Mode | Where Output Goes |
|------|------------------|
| `none` | No output (fire-and-forget) |
| `announce` | Sends to configured channel |
| `main` | Runs in main session context |
| `isolated` | Fresh isolated session |
| `webhook` | HTTP POST to external URL |

## Hooks System

4 bundled hooks:

| Hook | Purpose | Event |
|------|---------|-------|
| `session-memory` | Auto-save session memory | `session:end` |
| `bootstrap-extra-files` | Inject extra files into context | `session:start` |
| `boot-md` | Run BOOT.md at gateway start | `gateway:start` |
| `audit-log` | Log all agent actions | Multiple events |

7+ hook events: `gateway:start`, `gateway:stop`, `session:start`, `session:end`, `message:in`, `message:out`, `tool:call`

Custom hooks via TypeScript handlers in `hooks/` directory.

## Webhooks (External Hooks)

HTTP endpoint for external triggers (GitHub, Gmail, monitoring):
```json5
{
  webhooks: {
    endpoints: [{
      path: "/hook/github",
      token: "secret-token",
      agent: "john",
      delivery: "isolated"
    }]
  }
}
```

Token-authenticated. Supports `model` and `thinking` overrides per endpoint.

## BOOT.md

Optional startup script via `boot-md` hook. Runs once at gateway start. Use for:
- Environment validation
- Pre-flight checks
- Initial state setup

## 10 Automation Anti-Patterns

| # | Anti-Pattern | Why It's Bad | Do Instead |
|---|-------------|-------------|------------|
| 1 | Frequent isolated cron jobs (every 5m) | Expensive — each is a full model turn | Use heartbeat with `next-heartbeat` batching |
| 2 | Long HEARTBEAT.md (2000+ chars) | Eats context every heartbeat cycle | Keep under 500 chars, link to files for detail |
| 3 | Expensive models for routine cron | Opus for a daily status check | Use Haiku for routine automation |
| 4 | Polling loops in exec | `while true; sleep 5` wastes resources | Use cron or hooks instead |
| 5 | Cron without error handling | Silent failures | Add delivery mode to capture output |
| 6 | Heartbeat for exact-time tasks | Timing drift, batching delays | Use cron with exact schedule |
| 7 | Too many simultaneous cron jobs | Context thrashing, rate limits | Stagger schedules, batch related tasks |
| 8 | Webhook without token auth | Open to abuse | Always set token |
| 9 | `wakeMode: "now"` for non-urgent events | Unnecessary cost | Use `"next-heartbeat"` |
| 10 | Cron that modifies config | Unattended config changes = risk | Cron should report, human should approve changes |
