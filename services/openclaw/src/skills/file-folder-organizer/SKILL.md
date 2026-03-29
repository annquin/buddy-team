---
name: file-folder-organizer
description: Enforce repository structure and prevent stray files outside defined organization. Use to validate that expected directories exist, files are in correct locations, naming conventions are followed, and no orphaned files clutter the repo. Generates structure reports and auto-fix suggestions, with optional auto-fix for safe reorganizations. Prevents agents from creating structural mess in shared repositories.
---

# File/Folder Organizer

Enforce and validate repository structure. Use this skill to ensure consistent organization, prevent stray files, and maintain naming conventions across the repo.

## Quick Start

**To validate repo structure:**

```bash
file-org-validate \
  --path <repo-path> \
  --schema <schema-file> \
  --strict
```

**Example:**

```bash
file-org-validate \
  --path ~/projects/openclaw \
  --schema ~/.openclaw/skills/file-folder-organizer/references/openclaw-schema.json \
  --strict
```

**To auto-fix common issues:**

```bash
file-org-autofix \
  --path <repo-path> \
  --schema <schema-file> \
  --confirm
```

## Structure Report Format

**PASS Report:**

```
✅ PASS — Repository structure is valid

Schema: openclaw-schema
Location: ~/projects/openclaw
Checked: 142 files in 8 directories

Structure Validation:
  ✓ /docs — Present (8 files)
  ✓ /skills — Present (12 files)
  ✓ /scripts — Present (3 files)
  ✓ /src — Present (89 files)
  ✓ /.github — Present (22 files)

Naming Conventions:
  ✓ All skill dirs match: skill-[a-z0-9-]+
  ✓ All scripts match: [a-z_]+.py
  ✓ No stray files outside structure

Summary: All checks passed
```

**FAIL Report:**

```
⚠️ FAIL — Structure issues found (1 error, 3 warnings)

Errors:
  ✗ /src directory MISSING — Required but not found
  
Warnings:
  ⚠ Stray file: /random_script.py (outside /scripts)
  ⚠ Naming violation: /skills/MySkill/ should match skill-[a-z0-9-]+
  ⚠ Stray file: /JUNK.txt in root

Suggestions:
  • Create /src directory
  • Move /random_script.py to /scripts/random_script.py
  • Rename /skills/MySkill/ to /skills/my-skill/
  • Remove /JUNK.txt

Auto-fix available for: Move /random_script.py, Remove /JUNK.txt
Safe operations: 2/3
(Run with --autofix to apply safe suggestions)
```

## How It Works

1. **Load schema:** Parse structure definition (dirs, naming rules, required files)
2. **Scan repo:** Walk the directory tree and collect all files
3. **Validate dirs:** Check that required directories exist
4. **Check names:** Verify files/folders match naming conventions
5. **Detect strays:** Find files outside the defined structure
6. **Report:** Output findings with fix suggestions
7. **Auto-fix (optional):** Apply safe reorganizations

## Parameters

| Parameter | Required | Example | Notes |
|-----------|----------|---------|-------|
| `--path` | Yes | `~/projects/openclaw` | Repository root to validate |
| `--schema` | Yes | `schema.json` | Structure schema file (JSON or YAML) |
| `--strict` | No | flag | Fail on any warnings; default allows warnings |
| `--autofix` | No | flag | Apply safe auto-fixes (move, rename, remove stray files) |
| `--confirm` | No | flag | Don't prompt; apply fixes automatically with --autofix |
| `--ignore` | No | `.git,node_modules` | Comma-separated patterns to ignore |

## Schema Format

Define your repo structure in JSON:

```json
{
  "name": "openclaw",
  "version": "1.0",
  "description": "OpenClaw repository structure",
  "required_dirs": [
    {
      "path": "/docs",
      "description": "Documentation"
    },
    {
      "path": "/skills",
      "description": "AgentSkills"
    },
    {
      "path": "/src",
      "description": "Source code"
    }
  ],
  "naming_rules": [
    {
      "pattern": "^skills/[a-z0-9-]+/$",
      "description": "Skill dirs: lowercase, hyphens only"
    },
    {
      "pattern": "^scripts/[a-z_]+\\.py$",
      "description": "Scripts: snake_case Python files"
    },
    {
      "pattern": "^[A-Z]+\\.md$",
      "description": "Root docs: UPPERCASE markdown"
    }
  ],
  "allowed_at_root": [
    "README.md",
    "LICENSE",
    ".gitignore",
    ".github",
    "package.json"
  ],
  "ignore_patterns": [
    ".git",
    "node_modules",
    ".env",
    "*.pyc"
  ]
}
```

## When to Use This Skill

- **After agent work:** Validate that new files are in correct locations
- **Before merge:** Ensure PR doesn't introduce structural mess
- **Refactoring:** Reorganize stray files and fix naming conventions
- **Onboarding:** Set structure expectations for new team members
- **CI/CD gates:** Pre-build validation that repo is properly organized
- **Periodic maintenance:** Weekly/monthly structure audits

## Common Patterns

### Validate with strict mode (fail on warnings)

```bash
file-org-validate \
  --path ~/projects/my-repo \
  --schema schema.json \
  --strict
```

### Auto-fix common issues

```bash
file-org-autofix \
  --path ~/projects/my-repo \
  --schema schema.json \
  --confirm  # Don't prompt
```

### Ignore vendor directories

```bash
file-org-validate \
  --path ~/projects/my-repo \
  --schema schema.json \
  --ignore ".git,node_modules,vendor,.venv"
```

### Check specific subdirectory

```bash
file-org-validate \
  --path ~/projects/my-repo/src \
  --schema schema.json
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Schema file not found" | Verify schema path and permissions |
| "Required directory missing" | Create the directory or update schema |
| "Naming violations everywhere" | Review schema rules; may need adjustment for legacy code |
| "Stray files hard to categorize" | Add `allowed_at_root` or `ignore_patterns` to schema |
| "Auto-fix deleted too much" | Restore from git: `git checkout <files>` |

## Safety Notes

- **Preview first:** Always run without `--autofix` to see what will change
- **Backup:** Commit your work before running `--autofix`
- **Test:** Run in a branch first on large repos
- **Git tracking:** Auto-fix respects `.gitignore`

## Integration with Git

Works seamlessly with git-based repos:

```bash
# Validate before committing
file-org-validate --path . --schema schema.json

# Fix and commit
file-org-autofix --path . --schema schema.json --confirm
git add -A
git commit -m "refactor: enforce repository structure"
git push
```
