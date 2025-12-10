#!/usr/bin/env bash

# Validates that quality-checklist.md is complete before progressing to docs/release.
#
# Usage: validate-quality-checklist.sh --slug <YYYY-MM-DD-slug>
#
# Exit codes:
#   0 = All items checked
#   1 = Incomplete checklist
#   2 = Invalid arguments or missing file

set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Check dependencies before proceeding
check_saef_dependencies

usage() {
  cat <<'EOF'
Usage: .claude/skills/saef-ops/scripts/validate-quality-checklist.sh [--slug <YYYY-MM-DD-slug>]

Validates quality-checklist.md completion. Returns exit code 0 if all items are checked,
exit code 1 if incomplete items remain.

Examples:
  .claude/skills/saef-ops/scripts/validate-quality-checklist.sh
  .claude/skills/saef-ops/scripts/validate-quality-checklist.sh --slug 2025-01-15-recovery-email
EOF
  exit 2
}

FEATURE_FOLDER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug)
      FEATURE_FOLDER="${2:-}"
      shift 2
      ;;
    --help|-h)
      usage
      ;;
    *)
      saef_error "Unknown argument: $1"
      usage
      ;;
  esac
done

FEATURE_FOLDER="$(resolve_feature_folder "$FEATURE_FOLDER")"
FEATURE_DIR="$(feature_path_from_folder "$FEATURE_FOLDER")"
CHECKLIST_FILE="$FEATURE_DIR/quality-checklist.md"

require_file "$CHECKLIST_FILE" "Quality checklist not found: $CHECKLIST_FILE"

# Count checked and unchecked items
TOTAL_ITEMS=$(grep -c '^\s*- \[[ x]\]' "$CHECKLIST_FILE" || echo 0)
CHECKED_ITEMS=$(grep -c '^\s*- \[x\]' "$CHECKLIST_FILE" || echo 0)
UNCHECKED_ITEMS=$(grep -c '^\s*- \[ \]' "$CHECKLIST_FILE" || echo 0)

if [[ $TOTAL_ITEMS -eq 0 ]]; then
  saef_error "No checklist items found in $CHECKLIST_FILE"
  exit 2
fi

if [[ $UNCHECKED_ITEMS -eq 0 ]]; then
  saef_info "✓ Quality checklist complete: $CHECKED_ITEMS/$TOTAL_ITEMS items checked (feature: $FEATURE_FOLDER)"
  exit 0
fi

# Report incomplete items
saef_error "✗ Quality checklist incomplete: $CHECKED_ITEMS/$TOTAL_ITEMS items checked, $UNCHECKED_ITEMS remaining"
echo "" >&2
echo "Unchecked items:" >&2
grep '^\s*- \[ \]' "$CHECKLIST_FILE" | head -10 >&2
if [[ $UNCHECKED_ITEMS -gt 10 ]]; then
  echo "... and $((UNCHECKED_ITEMS - 10)) more items" >&2
fi
echo "" >&2
saef_error "Complete all checklist items before proceeding to /saef:docs or /saef:release"
exit 1
