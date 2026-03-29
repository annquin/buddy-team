---
name: github-commit-validation
description: Verify that a pushed commit exists on the remote repository with correct metadata. Use after pushing a commit to validate that the commit hash exists on the expected branch, files are present in the remote tree, and file count/paths match the claim. Returns PASS/FAIL status with exact file listing, commit metadata, and remote URL. Solves verification problems like "I pushed but files aren't visible" or "Did my commit actually make it?"
---

# GitHub Commit Validation

Verify that a pushed commit exists on the remote with correct files and metadata. Use this skill after pushing to ensure the commit is truly on the remote and files are accessible.

## Quick Start

**To validate a commit:**

```bash
gh-commit-validate \
  --repo <owner/repo> \
  --commit <hash or branch> \
  --expected-files <file1,file2,...> \
  --expected-count <N>
```

**Example:**

```bash
gh-commit-validate \
  --repo openclaw/openclaw \
  --commit main \
  --expected-files SKILL.md,scripts/validate.py,references/schema.md \
  --expected-count 3
```

## Validation Output

The skill produces a structured report:

```
✅ PASS — Commit validation successful

Commit Metadata:
  Hash: a1b2c3d4...
  Branch: main
  Author: John <john@example.com>
  Message: feat(skills): add github-commit-validation
  Date: 2026-03-13T14:15:00Z

Remote Files (3 total):
  ✓ SKILL.md (1.2 KB)
  ✓ scripts/validate.py (2.3 KB)
  ✓ references/schema.md (0.8 KB)

Remote URL: https://github.com/openclaw/openclaw
Status: All files verified on remote
```

### FAIL Report Example

```
❌ FAIL — Commit validation failed

Commit Metadata:
  Hash: a1b2c3d4...
  Branch: main
  Status: ✓ Exists on remote

File Verification:
  ✓ SKILL.md (1.2 KB)
  ✗ scripts/validate.py — NOT FOUND
  ✗ references/schema.md — NOT FOUND

Expected 3 files, found 1.

Troubleshooting:
  • Check: Did you commit the files? (git status)
  • Check: Did you push? (git log origin/main)
  • Check: Are file paths correct? (git ls-tree -r <hash>)
```

## How It Works

1. **Locate the commit:** Resolve the hash or branch name on the remote
2. **Verify existence:** Confirm the commit exists in the remote repository
3. **List remote files:** Use `git ls-tree -r <hash>` to inspect exact file paths and sizes on the remote
4. **Compare:** Check that files match expected names, paths, and count
5. **Report:** Output PASS or detailed FAIL with remediation steps

## Parameters

| Parameter | Required | Example | Notes |
|-----------|----------|---------|-------|
| `--repo` | Yes | `openclaw/openclaw` | GitHub owner/repo. Uses SSH or HTTPS based on git config. |
| `--commit` | Yes | `a1b2c3d4` or `main` | Commit hash or branch name. Resolved on remote. |
| `--expected-files` | No | `SKILL.md,dir/file.py` | CSV list of expected paths. If omitted, any files pass. |
| `--expected-count` | No | `3` | Expected total file count. If omitted, count is not validated. |
| `--remote` | No | `origin` | Remote name. Defaults to `origin`. |

## When to Use This Skill

- **After pushing:** Verify that files are truly on the remote before claiming "done"
- **Cross-branch sync:** Ensure commits pushed to the correct branch (main vs. feature branch)
- **Debugging push failures:** Confirm whether the issue is a push failure or incorrect expectations
- **Agent handoff:** When passing work to another agent, validate the remote state first
- **Build/CI gates:** Before triggering CI/CD, verify commit structure is correct

## Common Patterns

### Validate a feature branch

```bash
gh-commit-validate \
  --repo <owner/repo> \
  --commit feature/my-work \
  --expected-files src/main.py,tests/test_main.py \
  --expected-count 2
```

### Validate main after merge

```bash
gh-commit-validate \
  --repo <owner/repo> \
  --commit main
```

### Validate and show all files

```bash
gh-commit-validate \
  --repo <owner/repo> \
  --commit HEAD
# Lists all files in the commit tree (no expectations)
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Commit not found on remote" | Ensure you pushed: `git push origin <branch>` |
| "Files don't match expectations" | Check file paths: `git ls-tree -r <hash>` |
| "Auth failed" | Ensure GitHub CLI is configured: `gh auth login` |
| "Repository not found" | Verify repo name and access permissions |

## Requirements

- Git installed and configured
- GitHub CLI (`gh`) installed and authenticated
- Write access to the repository (if using SSH push)
- Network connectivity to GitHub
