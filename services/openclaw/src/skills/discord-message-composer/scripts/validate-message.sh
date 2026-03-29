#!/usr/bin/env bash
# validate-message.sh — Pre-send Discord message validation helper
# Usage: echo "your message" | bash validate-message.sh
# Or:    bash validate-message.sh "your message text"

set -euo pipefail

MSG="${1:-}"
if [[ -z "$MSG" ]]; then
  read -r -d '' MSG || true
fi

ERRORS=0

# Check 1: plain text @mentions
if echo "$MSG" | grep -qE '@[A-Za-z][A-Za-z0-9_-]+([^>]|$)' ; then
  # Might be a valid <@ID> — check for naked @word not preceded by <
  if echo "$MSG" | grep -qP '(?<!<)@[A-Za-z]'; then
    echo "❌ FAIL: Plain text @mention detected. Use <@NUMERIC_ID> format." >&2
    ERRORS=$((ERRORS + 1))
  fi
fi

# Check 2: invalid <@Name> pattern (non-numeric ID)
if echo "$MSG" | grep -qE '<@[^0-9>][^>]*>'; then
  echo "❌ FAIL: Non-numeric ID in mention (e.g. <@OzBot>). Use <@NUMERIC_ID>." >&2
  ERRORS=$((ERRORS + 1))
fi

if [[ $ERRORS -eq 0 ]]; then
  echo "✅ PASS: Message validation OK."
  exit 0
else
  echo "Fix $ERRORS error(s) before sending." >&2
  exit 1
fi
