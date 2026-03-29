# Pre-Flight Checklist

Run before applying any PROTOCOLS.md change.

## Mandatory Checks

- [ ] **Line count:** `wc -l PROTOCOLS.md` — must be ≤250 after change
- [ ] **No duplicates:** New content doesn't repeat an existing section or skill
- [ ] **All agents listed:** Any registry/list includes all 9 current agents
- [ ] **No stale references:** No mentions of deregistered agents, old paths, or deprecated tools
- [ ] **Session keys correct:** All session keys match `agent:<id>:main` pattern
- [ ] **Imperative voice:** No "you should" / "agents are expected to" — use direct commands
- [ ] **Concrete format:** Every rule has an example, template, or format spec (not just prose)
- [ ] **MANDATORY/RECOMMENDED tag:** Every section header has one

## Severity Assessment

Before committing, classify the change:

| Severity | Definition | Extra Steps |
|----------|-----------|-------------|
| **Low** | Wording fix, typo, formatting | Commit directly |
| **Medium** | New section, removed section, changed rule | Announce on Discord |
| **High** | Changes agent behavior significantly | Announce + recommend session resets |
| **Critical** | Changes communication, dispatch, or safety rules | Get Duc/King approval first |

## Rollback

If a change causes issues:
```bash
git -C /home/midang/.openclaw/workspace log --oneline -5 -- PROTOCOLS.md
git -C /home/midang/.openclaw/workspace checkout <commit>^ -- PROTOCOLS.md
git -C /home/midang/.openclaw/workspace commit -m "protocols: rollback <reason>"
```
