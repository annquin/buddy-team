#!/bin/bash
# Feature reconciliation script — run twice daily
# Checks projects→features mapping, validates indexes, reports gaps

set -euo pipefail
REPO="${1:-/Users/clawbot/.openclaw/workspace/buddy-team}"
CHANGES=0
REPORT=""

cd "$REPO"

# 1. Check all projects with parent_service have Feature ID
echo "=== Checking project→feature mapping ==="
for status in projects/*/STATUS.md; do
  proj=$(basename "$(dirname "$status")")
  parent=$(grep -o 'parent_service.*|.*|' "$status" 2>/dev/null | sed 's/.*| *\([^ |]*\) *|/\1/' || true)
  fid=$(grep -o 'Feature ID.*|.*|' "$status" 2>/dev/null | sed 's/.*| *\([^ |]*\) *|/\1/' || true)
  
  if [ -n "$parent" ] && [ -z "$fid" ]; then
    echo "⚠️  $proj: has parent_service=$parent but no Feature ID"
    REPORT="$REPORT\n⚠️ $proj: missing Feature ID"
    CHANGES=$((CHANGES + 1))
  fi
  
  if [ -n "$fid" ] && [ -n "$parent" ]; then
    # Check feature file exists
    ffile="services/$parent/features/${fid}.md"
    if [ ! -f "$ffile" ]; then
      echo "❌ $proj: Feature ID=$fid but file $ffile missing"
      REPORT="$REPORT\n❌ $proj: feature file missing for $fid"
      CHANGES=$((CHANGES + 1))
    fi
  fi
done

# 2. Check all feature files appear in FEATURES.md
echo ""
echo "=== Checking FEATURES.md indexes ==="
for svc_dir in services/*/; do
  svc=$(basename "$svc_dir")
  index="$svc_dir/FEATURES.md"
  [ -f "$index" ] || continue
  
  for feat in "$svc_dir/features/"*.md; do
    [ -f "$feat" ] || continue
    fname=$(basename "$feat")
    fid="${fname%.md}"
    if ! grep -q "$fid" "$index"; then
      echo "⚠️  $svc: $fid not in FEATURES.md"
      REPORT="$REPORT\n⚠️ $svc: $fid missing from index"
      CHANGES=$((CHANGES + 1))
    fi
  done
done

# 3. Check for standalone projects that might need a service
echo ""
echo "=== Standalone projects (review if should map to service) ==="
for status in projects/*/STATUS.md; do
  proj=$(basename "$(dirname "$status")")
  standalone=$(grep -c 'standalone.*true' "$status" 2>/dev/null || true)
  if [ "$standalone" -gt 0 ]; then
    echo "ℹ️  $proj: standalone (no service)"
  fi
done

# 4. Summary
echo ""
echo "=== Summary ==="
if [ "$CHANGES" -eq 0 ]; then
  echo "✅ All clean — no issues found"
else
  echo "⚠️  $CHANGES issue(s) found"
  echo -e "$REPORT"
fi

exit $CHANGES
