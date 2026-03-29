---
name: spider-feasibility
description: Platform feasibility review — structured assessment of whether the platform can support a proposed feature, agent, or architecture change. Use when reviewing PRDs, design specs, or feature proposals for platform compatibility.
---

# Spider Feasibility — Platform Review

## When to Use
- New PRD or design spec needs platform assessment
- New agent proposed — can the platform support it?
- Feature request — does the platform have the required capabilities?
- Architecture change — what's the blast radius?
- Dev asks "can we do X?" before building

## Input Template

Requester provides:
```markdown
## Platform Feasibility Review Request
- **What:** [Feature/agent/change description]
- **Spec path:** [Path to PRD/design doc, if any]
- **Needs assessment on:**
  - [ ] Config changes required?
  - [ ] New agent registration?
  - [ ] Channel binding?
  - [ ] Tool access changes?
  - [ ] Infrastructure (ports, services, cron)?
  - [ ] Feasibility blockers?
- **Target agent(s):** [Which agents are affected]
- **Timeline:** [When requester wants to start]
```

If requester doesn't provide this format, extract the relevant info from whatever they send.

## Review Checklist (24 items)

### Agent Registration
- [ ] Which agent(s) implement this? New or existing?
- [ ] Model tier? (Opus/Sonnet/Haiku — justify the choice)
- [ ] Tools needed? (list specific: browser, cron, exec, etc.)
- [ ] Added to agentToAgent.allow?

### Session Design
- [ ] How does the user interact? (DM, group, thread, cron-triggered?)
- [ ] Session lifetime acceptable at 120min idle reset?
- [ ] Does it need cross-session memory? If yes, what workspace file structure?
- [ ] Does memory_search need to find this data?

### Channel Binding
- [ ] Which channel? (Telegram, Discord, webchat, etc.)
- [ ] New bot token needed? (Telegram = yes for new agent)
- [ ] Group or DM? If group, added to groupAllowFrom?
- [ ] Channel-specific constraints? (rate limits, file size limits)

### Infrastructure
- [ ] New port/service needed? (Caddy config, systemd unit?)
- [ ] External dependencies? (Supabase, APIs, npm packages)
- [ ] Sudo required for any setup step? (flag as Duc blocker)
- [ ] Disk usage estimate?

### Integration
- [ ] Which agents does this communicate with? Via what mechanism?
- [ ] Data flow documented? (who writes, who reads, what format)
- [ ] Hook needed? If yes, which events?
- [ ] Cron needed? Schedule, payload, timeout?

### Operational
- [ ] Failure mode? What happens when dependencies are down?
- [ ] Rollback plan? (config backup + what to restore)
- [ ] Monitoring? How do we know it's broken?
- [ ] Does it increase maxConcurrent pressure?

## Output Template

```markdown
## Platform Feasibility Review: [Feature/Agent Name]

### Verdict: GO / CONDITIONAL / BLOCKED

### Summary
[1-2 sentence assessment]

### Config Changes Required
| File | Key | Current | Proposed |
|------|-----|---------|----------|
| openclaw.json | path.to.key | value | new value |

### Infrastructure Requirements
- [Ports, services, cron jobs, external deps]

### Blockers
- [Things that must happen first]
- [Duc manual steps if any]

### Risks
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| [risk] | low/med/high | low/med/high | [how to mitigate] |

### Estimated Work
- Spider config/infra: [time estimate]
- Duc manual steps: [list if any]
- Dev implementation: [estimate if relevant]

### Pre-Implementation Checklist for Requester
- [ ] [Items that must be done before Dev starts building]
```

## Verdict Criteria

**GO:** Platform supports this as-is or with minor config changes. No blockers. Spider can implement platform side independently.

**CONDITIONAL:** Platform can support this IF conditions are met first. Conditions are specific and actionable (e.g., "need Duc to run `sudo apt install X`", "need maxConcurrent bumped to 8").

**BLOCKED:** Platform cannot support this without significant work, missing capabilities, or external dependencies that don't exist yet. Explain what would need to change.

## Common Blockers Catalog

| Blocker | Type | Resolution |
|---------|------|------------|
| Needs sudo | Duc manual step | Flag with exact command |
| Needs new Telegram bot | Duc manual step | BotFather interaction required |
| Needs browser tool | Platform gap | `sudo apt install libnspr4 libnss3 libasound2` |
| Needs per-agent session config | Platform limitation | Not supported — use workarounds |
| Needs file watcher | Platform limitation | Use message trigger pattern instead |
| Needs real-time agent-to-agent streaming | Platform limitation | Not supported — use async messaging |
| Needs environment separation | Platform gap | No staging env exists |
| maxConcurrent pressure | Config tuning | Bump value, monitor API limits |
| Context window pressure | Optimization | Reduce bootstrap files, move to skills |

## Integration with Other Skills
- After GO verdict → use `spider-capacity` for model/concurrency decisions
- After agent creation needed → use `agent-factory` for workspace setup
- After config changes identified → follow Config Modification Workflow in AGENTS.md
