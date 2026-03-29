#!/bin/bash
# Repo hygiene check — finds convention violations
REPO_DIR="/home/midang/.openclaw/repo"
cd "$REPO_DIR" || exit 1

VIOLATIONS=""

# Check 1: Files at root that shouldn't be there
ROOT_FILES=$(find . -maxdepth 1 -type f ! -name "README.md" ! -name ".gitignore" ! -name ".mcp.json" ! -name "REPO.md" ! -name ".*" 2>/dev/null)
if [ -n "$ROOT_FILES" ]; then
  VIOLATIONS+="❌ Files at repo root (should be in subdirs):\n$ROOT_FILES\n\n"
fi

# Check 2: Dirs at root outside allowed set
ALLOWED_DIRS=".git .github .openclaw agents docs infra projects results"
for d in $(find . -maxdepth 1 -type d ! -name "." | sed 's|^\./||'); do
  if ! echo "$ALLOWED_DIRS" | grep -qw "$d"; then
    VIOLATIONS+="❌ Unknown directory at root: $d/\n"
  fi
done

# Check 3: Research files without date prefix
BAD_RESEARCH=$(find results/ docs/research/ -name "*.md" ! -name "README*" ! -name "seen.json" 2>/dev/null | while read f; do
  basename "$f" | grep -qvE "^[0-9]{4}-[0-9]{2}-[0-9]{2}" && echo "  $f"
done)
if [ -n "$BAD_RESEARCH" ]; then
  VIOLATIONS+="⚠️ Research files without YYYY-MM-DD prefix:\n$BAD_RESEARCH\n\n"
fi

# Check 4: Nesting too deep (>3 levels in content dirs)
DEEP=$(find agents/ docs/ projects/ results/ -mindepth 4 -type f 2>/dev/null | head -5)
if [ -n "$DEEP" ]; then
  VIOLATIONS+="⚠️ Files nested >3 levels deep:\n$DEEP\n\n"
fi

# Output
if [ -z "$VIOLATIONS" ]; then
  echo "✅ Repo hygiene: all clean"
else
  echo "🧹 Repo hygiene violations found:"
  echo -e "$VIOLATIONS"
fi
