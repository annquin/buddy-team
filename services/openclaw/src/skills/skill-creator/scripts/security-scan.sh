#!/usr/bin/env bash
# security-scan.sh — SKC-SEC-001 Static Security Scanner
# Usage: security-scan.sh <skill-directory>
# Exit codes: 0=clean, 1=warn, 2=block
# Output: JSON to stdout
# Requires: bash, perl, python3 (all standard on macOS)

set -uo pipefail
# Note: -e (errexit) intentionally omitted — perl_match returns 1 on no-match which would abort script

SKILL_DIR="${1:-}"

if [[ -z "$SKILL_DIR" || ! -d "$SKILL_DIR" ]]; then
  echo '{"status":"error","findings":[],"error":"Usage: security-scan.sh <skill-directory>"}' >&2
  exit 3
fi

SKILL_DIR="${SKILL_DIR%/}"

findings=()
highest_tier=0  # 0=clean, 1=warn, 2=block

# ── Helpers ──────────────────────────────────────────────────────────────────

# json_escape: safely escape a string for JSON using python3
json_escape() {
  python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().rstrip("\n")))' <<< "$1"
}

add_finding() {
  local file="$1" line="$2" pattern="$3" tier="$4" context="$5"
  local escaped_context
  escaped_context="$(json_escape "$context")"
  findings+=("{\"file\":$(json_escape "$file"),\"line\":$line,\"pattern\":$(json_escape "$pattern"),\"tier\":\"$tier\",\"context\":$escaped_context}")
  if [[ "$tier" == "block" && $highest_tier -lt 2 ]]; then highest_tier=2; fi
  if [[ "$tier" == "warn"  && $highest_tier -lt 1 ]]; then highest_tier=1; fi
}

# perl_match: PCRE match portable across macOS + Linux (no grep -P)
# Uses raw byte patterns to avoid perl Unicode mode issues
# Usage: perl_match <pattern> <string>  → returns 0 if match, 1 if not
perl_match() {
  local pattern="$1" string="$2"
  echo "$string" | perl -ne "if (/$pattern/) { \$m=1; last } END { exit(\$m ? 0 : 1) }" 2>/dev/null
}

scan_file() {
  local filepath="$1"
  local relpath="${filepath#$SKILL_DIR/}"
  local is_script=0
  [[ "$filepath" == */scripts/* ]] && is_script=1

  local lineno=0
  while IFS= read -r raw_line; do
    lineno=$((lineno + 1))
    local line="$raw_line"

    # ── 🔴 BLOCK: Role override phrases ──────────────────────────────────────
    for pat in \
      "you are now" \
      "ignore previous" \
      "forget your instructions" \
      "new system prompt" \
      "act as" \
      "pretend you are" \
      "disregard"
    do
      if echo "$line" | grep -qi "$pat"; then
        add_finding "$relpath" "$lineno" "$pat" "block" "$line"
      fi
    done

    # ── 🔴 BLOCK: Hidden unicode (zero-width + RTL) — raw UTF-8 byte matching ─
    # U+200B/200C/200D = \xe2\x80\x8b/8c/8d, U+FEFF = \xef\xbb\xbf
    # RTL overrides U+202A-202E = \xe2\x80\xaa-\xae, U+2066-2069 = \xe2\x81\xa6-\xa9
    if perl_match '\xe2\x80[\x8b\x8c\x8d]|\xef\xbb\xbf|\xe2\x80[\xaa-\xae]|\xe2\x81[\xa6-\xa9]' "$line"; then
      add_finding "$relpath" "$lineno" "hidden_unicode" "block" "$line"
    fi

    # ── 🔴 BLOCK: Dangerous filesystem ops ───────────────────────────────────
    for pat in \
      "rm -rf" \
      "chmod 777" \
      "> /dev/" \
      "/etc/passwd" \
      "/etc/shadow" \
      "/System/Library"
    do
      if echo "$line" | grep -qF "$pat"; then
        add_finding "$relpath" "$lineno" "$pat" "block" "$line"
      fi
    done

    # ── 🟡 WARN: Code execution (skip scripts/ directory) ────────────────────
    if [[ $is_script -eq 0 ]]; then
      for pat in \
        "eval(" \
        "exec(" \
        "subprocess" \
        "os.system(" \
        "child_process" \
        "__import__"
      do
        if echo "$line" | grep -qF "$pat"; then
          add_finding "$relpath" "$lineno" "$pat" "warn" "$line"
        fi
      done
    fi

    # ── 🟡 WARN: Suspicious URLs — perl PCRE ─────────────────────────────────
    if perl_match 'http://\S+' "$line"; then
      add_finding "$relpath" "$lineno" "non_https_url" "warn" "$line"
    fi
    if perl_match 'https?://\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' "$line"; then
      add_finding "$relpath" "$lineno" "ip_address_url" "warn" "$line"
    fi

    # ── 🟡 WARN: Base64 blobs >100 chars (non-script files only) — perl PCRE ─
    if [[ $is_script -eq 0 ]]; then
      if perl_match '[A-Za-z0-9+/]{100,}={0,2}' "$line"; then
        add_finding "$relpath" "$lineno" "base64_blob" "warn" "$line"
      fi
    fi

    # ── 🟡 WARN: Data exfil patterns (non-script files only) ─────────────────
    if [[ $is_script -eq 0 ]]; then
      for pat in "curl " "wget " "fetch("; do
        if echo "$line" | grep -qF "$pat"; then
          add_finding "$relpath" "$lineno" "$pat" "warn" "$line"
        fi
      done
    fi

  done < "$filepath"
}

# ── Scan all text files in skill dir ─────────────────────────────────────────

while IFS= read -r -d '' filepath; do
  if file "$filepath" 2>/dev/null | grep -q "text"; then
    scan_file "$filepath"
  fi
done < <(find "$SKILL_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.py" -o -name "*.sh" -o -name "*.js" -o -name "*.ts" -o -name "*.json" \) -print0)

# ── Build JSON output ─────────────────────────────────────────────────────────

case $highest_tier in
  0) status="clean" ;;
  1) status="warn"  ;;
  2) status="block" ;;
  *) status="clean" ;;
esac

findings_json=""
for i in "${!findings[@]}"; do
  if [[ $i -gt 0 ]]; then findings_json+=","; fi
  findings_json+="${findings[$i]}"
done

echo "{\"status\":\"$status\",\"findings\":[$findings_json]}"

exit $highest_tier
