# discord-message-composer

Compose and route Discord messages correctly. Read this file to know exactly how to compose any Discord message in under 30 seconds.

---

## Quick-Start Checklist (run BEFORE every send)

1. **Resolve mentions** → use `<@NUMERIC_ID>` from the registry below — never display names
2. **Check threadId** → open `active-tasks.md`, find project's `threadId`
3. **Pick channel** → use routing table below
4. **Use `accountId: "oz"`** and `target: "channel:<id>"` format

---

## §1 — Bot User ID Registry

| Agent | Bot User ID | Mention Token |
|-------|-------------|---------------|
| Joe | `1479312981371130097` | `<@1479312981371130097>` |
| Alex | `1479333569594921123` | `<@1479333569594921123>` |
| Oz | `1479336016891347155` | `<@1479336016891347155>` |
| Dev | `1479410861373390878` | `<@1479410861373390878>` |
| Ford | `1481310423528636567` | `<@1481310423528636567>` |
| Muse | `1480067664260108361` | `<@1480067664260108361>` |
| Seer | `1479337110811967652` | `<@1479337110811967652>` |
| King | `1478402245535076402` | `<@1478402245535076402>` |
| Duc (human) | `177946652437381121` | `<@177946652437381121>` |

**Full registry:** `references/bot-ids.md`

---

## §2 — Channel Registry

| Channel | ID | Use For |
|---------|-----|---------|
| `#product-team` | `1479315677067214958` | Kick-offs, final completions, announcements, escalations, dispatches |
| `#marketing` | `1482427517020143908` | Marketing-related updates |
| Project thread | from `active-tasks.md` → `threadId` | Acks, progress updates, handoffs, blocking |

**accountId:** Always `"oz"` — `default` has no Discord token and will fail silently.
**target format:** `channel:<id>` — never a bare numeric ID.

---

## §3 — TSC-001 Routing Decision Tree

```
Is there a threadId for this project?
  YES → Is this a kick-off or FINAL completion?
          YES → Post to BOTH: thread AND #product-team
          NO  → Post to THREAD ONLY
  NO  → Ask King to create a thread first
```

| Message Type | Destination |
|--------------|-------------|
| Project kick-off | `#product-team` only |
| Task acknowledgment | Thread |
| Progress update | Thread |
| Handoff to next agent | Thread |
| Task completion | Thread **+** `#product-team` |
| Cross-project escalation | `#product-team` |
| Blocking / waiting | Thread |
| Protocol announcement | `#product-team` |
| Boot / online status | `#product-team` |
| Dispatch (Mode A/B) | `#product-team` |
| Duc-initiated reply (project-scoped) | Thread |
| Duc reply when Duc is IN thread | Thread |
| Team-wide announcement | `#product-team` |

---

## §4 — Pre-Send Validation Checklist (4 Steps)

### Step 1 — Mention Check
- [ ] All `@mentions` use `<@NUMERIC_ID>` format
- [ ] No plain text `@name` patterns (e.g., `@Joe`, `@Oz`)
- [ ] Handoff message mentions next agent's bot user ID
- [ ] Completion message mentions Duc `<@177946652437381121>` for visibility

### Step 2 — Channel Check
- [ ] Is there a `threadId` in `active-tasks.md` for this project?
- [ ] If yes: task update / handoff / progress → thread ONLY
- [ ] If yes: kick-off or final completion → BOTH thread and `#product-team`
- [ ] If no thread: post to `#product-team` and flag `⚠️ No thread for [PROJECT-ID]`

### Step 3 — Content Check
- [ ] Completion messages include: summary + output path + commit hash
- [ ] Handoff messages include: `Next: <@ID> — [action]`
- [ ] Ack messages include: task ID + plan + ETA
- [ ] No missing required fields for message type

### Step 4 — Account / Format Check
- [ ] `accountId: "oz"` (not `"default"`)
- [ ] Target format: `channel:<id>` (not bare numeric)
- [ ] For completions: `sessions_send` dispatcher FIRST, then Discord post

---

## §5 — Common Pitfalls

| Pitfall | ❌ Wrong | ✅ Right |
|---------|---------|---------|
| Display name mention | `@Joe` | `<@1479312981371130097>` |
| Wrong channel for update | Post to #product-team | Post to thread |
| Missing output path | `"Task done"` | `"Task done. Output: path/to/file.md (commit abc1234)"` |
| Wrong account | `accountId: "default"` | `accountId: "oz"` |
| Bare numeric target | `target: "1479315677067214958"` | `target: "channel:1479315677067214958"` |
| Bot ID as display name | `<@OzBot>` | `<@1479336016891347155>` |
| Missing threadId check | Always post to #product-team | Check `active-tasks.md` for threadId first |
| Missing reply-to push | Discord only | `sessions_send` FIRST, then Discord |
| Stale threadId | Use threadId from memory without checking | Verify thread still active; fall back to #product-team if archived |
| Double-posting | Post to both thread AND #product-team for every message | Thread only for updates; BOTH only for kick-off + final completion |

---

## §6 — Template Library (9 Templates)

### T1 — Task Acknowledgment
```
📋 [AgentName]: Acknowledged [TASK-ID]. Plan: <plan>. ETA: <estimate>.
```
**Channel:** Thread (if threadId exists), else `#product-team`

---

### T2 — Task Completion
```
📋 [AgentName]: ✅ Done: <summary>. Output: <path> (commit `<hash>`).
```
**Channel:** Thread + `#product-team`
**Required:** `sessions_send` to dispatcher BEFORE Discord post

---

### T3 — Handoff
```
✅ [AgentName]: [TASK-ID] T<N> done. <summary>.
Next: <@NEXT_AGENT_BOT_ID> — [action]. Reply-To: `agent:<name>:main`
```
**Channel:** Thread ONLY

---

### T4 — Escalation to Duc
```
<@177946652437381121> ⚠️ [AgentName]: [ISSUE]. [Context]. Needs: [action].
```
**Channel:** `#product-team`

---

### T5 — Blocking / Waiting
```
⚠️ [AgentName]: [TASK-ID] blocked. Blocker: <description>. Waiting on: <@ID>.
```
**Channel:** Thread

---

### T6 — Protocol Announcement
```
📢 [AgentName]: **[PROTOCOL-ID] rollout** — [description of change]. Effective immediately. Full details: `<path>`.
```
**Channel:** `#product-team`
**Also:** `sessions_send` to each affected agent

---

### T7 — Boot / Online Status
```
🟢 [AgentName]: Back online after gateway restart. No pending tasks.
```
**Channel:** `#product-team`

---

### T8 — Dispatch (Mode A — ≤3 sentences)
```
<@AGENT_BOT_ID> **[TASK-ID]:** [Full task in ≤3 sentences]. Reply-To session: agent:<sender>:main
```
**Channel:** `#product-team`

---

### T9 — Dispatch (Mode B — >3 sentences)
```
<@AGENT_BOT_ID> **[TASK-ID]:** New task brief at /Users/clawbot/.openclaw/workspace/requests/<TASK-ID>.md. Reply-To session: agent:<sender>:main
```
**Channel:** `#product-team`

---

## §7 — Mention Format Rules

| ✅ Correct | ❌ Incorrect |
|-----------|-------------|
| `<@177946652437381121>` | `@Duc` |
| `<@1479336016891347155>` | `@OzBot - OpenClaw Expert` |
| `<@1479312981371130097>` | `@joe` |
| `Next: <@1479410861373390878>` | `Next: @Dev` |

1. Every `@mention` MUST use `<@NUMERIC_ID>` format — no display names, ever
2. Handoff messages MUST mention next agent by bot user ID
3. Completion messages MUST mention Duc `<@177946652437381121>` for visibility
4. Extract `authorId` directly from inbound message payload when available

---

## §8 — message() Tool Usage

```javascript
message(
  action="send",
  channel="discord",
  target="channel:1479315677067214958",   // #product-team
  // OR:
  target="channel:<threadId>",             // project thread
  accountId="oz",
  message="<composed message here>"
)
```

**For completions — order matters:**
1. `sessions_send(sessionKey: "<replyToSession>", message: "...", timeoutSeconds: 0)`
2. `message(action="send", ...)` → thread
3. `message(action="send", ...)` → `#product-team`
