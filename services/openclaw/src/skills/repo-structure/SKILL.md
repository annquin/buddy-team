---
name: repo-structure
description: Repo structure rules for buddy-team. Load before creating any file or directory in the buddy-team repo. Triggers: creating folders, adding new files, moving files, any git add/commit in buddy-team repo.
---

# Repo Structure Rules

## Before Creating Any File or Directory

Answer these 5 questions:
1. Is this a project spec/plan? → `projects/<project-id>/` only
2. Is this a service definition? → `services/openclaw/` or `services/mission-control/` ONLY
3. Is this documentation/research? → `docs/research/`, `docs/specs/`, `docs/templates/`, `docs/personas/`, or `docs/legacy/`
4. Is this a skill? → `~/.openclaw/skills/` — NOT in the repo
5. Is this a test artifact? → `projects/<test-id>/` — clean up after test completes

## Canonical Structure

```
buddy-team/
├── README.md, PRODUCT.md, MISSION.md   ← root-level docs only, no new dirs
├── projects/           ← project specs (SPEC.md, TASKS.md, STATUS.md)
│   └── <project-id>/  ← flat — no nesting inside project dirs
├── services/           ← ONLY: openclaw/ and mission-control/
│   ├── openclaw/
│   └── mission-control/
├── docs/               ← documentation
│   ├── research/
│   ├── specs/
│   ├── personas/
│   ├── templates/
│   └── legacy/
└── infra/              ← temporary (being migrated out)
```

## Hard Rules

| Rule | Violation Example | Correct Location |
|------|-----------------|-----------------|
| `services/` only has openclaw + mission-control | `services/e2e-collab-test/` | `projects/e2e-collab-test/` |
| No new root-level dirs | `results/` at root | `docs/` or `projects/` subdir |
| Skills NOT in repo | `services/my-skill/` | `~/.openclaw/skills/my-skill/` |
| No test artifacts in `services/` | `services/poc-test/` | `projects/poc-test/` |
| No nesting inside `projects/<id>/` | `projects/foo/bar/baz/` | `projects/foo/baz/` (flat) |

## When in Doubt

Ask: "Would Duc need to clean this up manually?" If yes — find the correct location first.
