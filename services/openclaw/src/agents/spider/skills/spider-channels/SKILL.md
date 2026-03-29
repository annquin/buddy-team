---
description: OpenClaw channels — 25+ channel setup guides, routing, broadcast groups, DM/group policies, troubleshooting.
---

# Spider Channels Reference

## Channel Overview

10 built-in + 13+ plugin channels. All run simultaneously.

| Channel | Transport | Type | Setup Difficulty |
|---------|-----------|------|-----------------|
| Telegram | Bot API | Built-in | Easy — just bot token |
| Discord | Bot gateway | Built-in | Easy — bot token + intents |
| Slack | Socket Mode | Built-in | Medium — app manifest |
| WhatsApp | Baileys/Cloud | Built-in | Medium — QR pairing |
| Signal | signal-cli | Built-in | Hard — number registration |
| iMessage | BlueBubbles | Plugin | Hard — Mac + BlueBubbles server |
| Webchat | HTTP/WS | Built-in | Easy — built into gateway |
| SMS | Twilio | Plugin | Medium — Twilio account |
| Email | IMAP/SMTP | Plugin | Medium — app passwords |
| Matrix | matrix-sdk | Plugin | Medium — homeserver + token |
| Google Chat | Chat API | Plugin | Hard — Workspace admin |
| Microsoft Teams | Bot Framework | Plugin | Hard — Azure app registration |
| LINE | Messaging API | Plugin | Medium — developer account |

## Channel Routing

Bindings evaluated **in order — first match wins**.

```json5
{
  channels: {
    bindings: [
      { channel: "telegram", agent: "spider", match: "/platform *" },
      { channel: "telegram", agent: "joe", match: "/plan *" },
      { channel: "telegram", agent: "john" }  // default fallback
    ]
  }
}
```

Session keys are deterministic per context type (channel + user/group + agent).

## DM & Group Policies

| DM Policy | Behavior |
|-----------|----------|
| `pairing` | User must pair via code first (recommended) |
| `allowlist` | Only listed users/numbers |
| `open` | Anyone can DM (⚠️ requires `dmScope` wildcard) |
| `disabled` | No DMs at all |

| Group Policy | Behavior |
|--------------|----------|
| `all` | Respond in any group |
| `allowlist` | Only listed groups |
| `disabled` | No group responses |

**Always set `requireMention: true` for groups** — prevents responding to every message.

## Broadcast Groups

Multiple agents process the same message simultaneously:
```json5
{
  channels: {
    broadcastGroups: {
      "dev-team": ["john", "spider"]  // both see every message
    }
  }
}
```

## Channel-Specific Features

| Feature | Telegram | Discord | Slack | WhatsApp |
|---------|----------|---------|-------|----------|
| Inline buttons | ✅ | ✅ | ✅ | ❌ |
| Voice messages | ✅ | ✅ | ❌ | ✅ |
| Reactions | ✅ | ✅ | ✅ | ✅ |
| Read receipts | ❌ | ❌ | ❌ | ✅ |
| File attachments | ✅ | ✅ | ✅ | ✅ |
| Ack reactions | ✅ | ✅ | ✅ | ✅ |

## Common Channel Troubleshooting

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Bot doesn't respond in group | `requireMention: true` and not mentioned | Mention bot or set `false` |
| `drop guild message` in logs | Group policy filtering | Check group allowlist |
| `sender filtered by policy` | DM policy rejecting user | Check dmPolicy + dmScope |
| Bot responds but wrong agent | Binding order wrong | Reorder bindings (first match wins) |
| Channel shows "disconnected" | Auth token expired or network | Re-auth, check `channels status --probe` |
| Duplicate responses | Multiple bindings match | Narrow match patterns |
| Messages delayed | Rate limiting or slow model | Check model latency, channel rate limits |
| Bot crashes on voice message | Transcription not configured | Configure whisper/transcription model |

## Testing

```bash
openclaw channels status          # List configured channels
openclaw channels status --probe  # Live connectivity check
```

Always `--probe` when diagnosing — status alone only shows config, not connectivity.
