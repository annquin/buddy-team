#!/usr/bin/env bash
# check-workspace.sh — validate agent workspace integrity
# Usage: bash check-workspace.sh <workspace-path>
# Exit: 0=pass, 1=warnings, 2=critical failures

set -euo pipefail

WORKSPACE="${1:-}"
if [[ -z "$WORKSPACE" ]]; then
  echo "Usage: $0 <workspace-path>"
  echo "Example: $0 ~/.openclaw/workspace-dev"
  exit 2
fi

WORKSPACE="${WORKSPACE%/}"  # strip trailing slash
PASS=0
WARN=0
FAIL=0

check() {
  local level="$1" file="$2" msg="$3"
  if [[ "$level" == "FAIL" ]]; then
    echo "❌ FAIL: $msg"
    FAIL=$((FAIL+1))
  elif [[ "$level" == "WARN" ]]; then
    echo "⚠️  WARN: $msg"
    WARN=$((WARN+1))
  else
    echo "✅ OK:   $msg"
    PASS=$((PASS+1))
  fi
}

echo "🔍 Checking workspace: $WORKSPACE"
echo "---"

# Required files (must exist + non-empty)
REQUIRED=(SOUL.md AGENTS.md IDENTITY.md TOOLS.md USER.md MEMORY.md)
for f in "${REQUIRED[@]}"; do
  path="$WORKSPACE/$f"
  if [[ ! -f "$path" ]]; then
    check FAIL "$f" "$f missing"
  elif [[ ! -s "$path" ]]; then
    check FAIL "$f" "$f exists but is empty"
  else
    check OK "$f" "$f present and non-empty"
  fi
done

# Optional but expected files (warn if missing)
OPTIONAL=(BOOT.md BOOTSTRAP.md HEARTBEAT.md)
for f in "${OPTIONAL[@]}"; do
  path="$WORKSPACE/$f"
  if [[ ! -f "$path" ]]; then
    check WARN "$f" "$f missing (optional — expected for most agents)"
  else
    check OK "$f" "$f present"
  fi
done

# SOUL.md size check (≤1500 chars)
soul="$WORKSPACE/SOUL.md"
if [[ -f "$soul" ]]; then
  size=$(wc -c < "$soul" | tr -d ' ')
  if [[ "$size" -gt 1500 ]]; then
    check WARN "SOUL.md" "SOUL.md is ${size} chars (limit: 1500) — move procedures to AGENTS.md"
  else
    check OK "SOUL.md" "SOUL.md size OK (${size}/1500 chars)"
  fi
fi

# memory/ directory
if [[ ! -d "$WORKSPACE/memory" ]]; then
  check WARN "memory/" "memory/ directory missing"
else
  check OK "memory/" "memory/ directory present"
  if [[ ! -f "$WORKSPACE/memory/active-tasks.md" ]]; then
    check WARN "active-tasks.md" "memory/active-tasks.md missing"
  fi
fi

# Permissions — workspace files should be owner-readable (not world-readable)
for f in SOUL.md AGENTS.md TOOLS.md MEMORY.md; do
  path="$WORKSPACE/$f"
  if [[ -f "$path" ]]; then
    perms=$(stat -f "%A" "$path" 2>/dev/null || stat -c "%a" "$path" 2>/dev/null)
    if [[ "${perms: -1}" != "0" ]]; then
      check WARN "$f" "$f is world-readable (perms: $perms) — consider chmod 600"
    fi
  fi
done

echo "---"
echo "Result: ✅ $PASS passed | ⚠️  $WARN warnings | ❌ $FAIL failures"

if [[ "$FAIL" -gt 0 ]]; then
  echo "Status: CRITICAL — fix failures before editing"
  exit 2
elif [[ "$WARN" -gt 0 ]]; then
  echo "Status: WARNINGS — review before editing"
  exit 1
else
  echo "Status: CLEAN — safe to proceed"
  exit 0
fi
