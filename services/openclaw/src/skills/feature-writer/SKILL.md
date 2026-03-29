---
name: feature-writer
description: Write, update, and reconcile feature specs for services. Use when creating a new feature spec, updating existing features after project changes, reconciling projects→features mapping, running feature cleanup/audit, or consolidating overlapping features. Triggers on phrases like "write feature spec", "update features", "feature cleanup", "reconcile features", "feature audit", "map projects to features".
---

# Feature Writer

Write and maintain feature specs for services in the buddy-team repo.

## Repo Structure

```
buddy-team/
├── services/<service-id>/
│   ├── FEATURES.md              # Index with linked table
│   └── features/<FEATURE-ID>.md  # Individual feature specs
└── projects/<project-id>/
    └── STATUS.md                 # Must have parent_service + Feature ID
```

## Feature Spec Template

Every feature file at `services/<service>/features/<ID>.md`:

```markdown
# [FEATURE_ID]: [Name]

## Status
[Deployed | Build | Spec | Closing] — [1-line current state]

## Problem
[What problem does this solve? 2-3 sentences]

## Solution
[What does this feature do? 4-8 sentences: scope, mechanics, key behaviors]

## Current Implementation
[What's actually deployed today? Concrete files, configs, protocol sections.]
- File/config: description
[If nothing deployed: "Not yet implemented."]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
[3-8 criteria]

## Dependencies
- **Depends on:** [feature IDs or "None"]
- **Depended on by:** [feature IDs or "None"]

## Owner
[Role, not person name]

## Notes
[Merge history, closing notes, project IDs, etc.]
```

## FEATURES.md Index Template

```markdown
# [Service Name] — Feature Index

| Feature ID | Name | Status | Description | Dependencies |
|------------|------|--------|-------------|--------------|
| [ID](features/ID.md) | Name | Status | 1-2 sentence description | Deps |
```

**Rules:**
- Every Feature ID in the table MUST be a clickable link to `features/<ID>.md`
- Keep descriptions to 1-2 sentences max in the index

## Feature ID Conventions

- OpenClaw service: `OPENCLAW-F001`, `OPENCLAW-F002`, etc.
- Mission-control service: `MCTL-F001`, `MCTL-F002`, etc.
- New services: `<SERVICE_SHORT>-F001`, etc.
- IDs are sequential. Gaps from merges are OK — don't renumber.

## When to Create a Feature

Every project that has `parent_service:` in its STATUS.md should map to a feature. Create a feature when:
1. A new project is created under a service
2. Multiple projects should be consolidated into one feature
3. A capability exists in production but has no feature doc

## When to Update Features

- Project status changes → update feature Status line
- Project scope changes → update Solution + Acceptance Criteria
- New implementation deployed → update Current Implementation
- Project closes → update Notes with outcome

## Consolidation Rules

Merge features when:
1. Two features solve the same problem for different agents (e.g., Dev Skills + PM Skills → Skill Framework)
2. One feature is a subset of another
3. Features share >50% of acceptance criteria

When merging:
- Pick the broader feature as the survivor
- Add merge history to Notes
- Update all project STATUS.md `Feature ID` fields
- Delete the absorbed feature file
- Update FEATURES.md index

## Reconciliation Checklist (run twice daily)

Run `scripts/reconcile-features.sh` or manually:

1. **Scan projects:** `find projects -name STATUS.md` — check each has `parent_service:` + `Feature ID`
2. **Check orphans:** Any project with `parent_service:` but no matching feature file → create feature
3. **Check stale:** Any feature file with no matching project → mark Closing or delete
4. **Validate index:** Every feature file must appear in FEATURES.md with correct link
5. **Status sync:** Feature status should reflect latest project status
6. **Report:** Post summary to #product-team if changes were made
