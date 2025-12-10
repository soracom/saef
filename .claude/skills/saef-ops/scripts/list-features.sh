#!/usr/bin/env bash

# Lists all feature folders with status indicators.
#
# Usage: list-features.sh [--verbose]

set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Check dependencies before proceeding
check_saef_dependencies

usage() {
  cat <<'EOF'
Usage: .claude/skills/saef-ops/scripts/list-features.sh [--verbose]

Lists all feature folders under outputs/ with status information.

Options:
  --verbose    Show detailed status (which artifacts exist)

Examples:
  .claude/skills/saef-ops/scripts/list-features.sh
  .claude/skills/saef-ops/scripts/list-features.sh --verbose
EOF
  exit 0
}

VERBOSE=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --verbose|-v)
      VERBOSE=true
      shift
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

cd_repo_root

feature_count="$(list_feature_folders | wc -l)"

if [[ $feature_count -eq 0 ]]; then
  echo "No features found in outputs/"
  echo "Create a new feature with: /saef:refine"
  exit 0
fi

echo "Found $feature_count feature(s):"
echo ""

for folder in $(list_feature_folders); do
  feature_dir="$(feature_path_from_folder "$folder")"

  # Determine stage by checking which files exist
  stage="refine"
  if [[ -f "$feature_dir/business-statement.md" ]]; then
    stage="refine ✓"
  fi
  if [[ -f "$feature_dir/prd.md" ]]; then
    stage="prd ✓"
  fi
  if [[ -f "$feature_dir/api-spec.yaml" ]] && [[ -s "$feature_dir/api-spec.yaml" ]]; then
    stage="spec ✓"
  fi
  if [[ -f "$feature_dir/tasks.md" ]]; then
    stage="plan ✓"
  fi
  if [[ -f "$feature_dir/quality-checklist.md" ]]; then
    # Check if checklist is complete
    unchecked=$(grep -c '^\s*- \[ \]' "$feature_dir/quality-checklist.md" || echo 0)
    if [[ $unchecked -eq 0 ]]; then
      stage="implement ✓"
    else
      stage="implement (incomplete)"
    fi
  fi
  if [[ -f "$feature_dir/docs/docs-ja.md" ]] || [[ -f "$feature_dir/docs/docs-en.md" ]]; then
    stage="docs ✓"
  fi
  if [[ -f "$feature_dir/release/changelog-ja.md" ]] || [[ -f "$feature_dir/release/changelog-en.md" ]]; then
    stage="release ✓"
  fi

  echo "  $folder"
  echo "    Stage: $stage"

  if [[ "$VERBOSE" == true ]]; then
    echo "    Path: $feature_dir"
    echo "    Artifacts:"
    [[ -f "$feature_dir/business-statement.md" ]] && echo "      ✓ business-statement.md"
    [[ -f "$feature_dir/prd.md" ]] && echo "      ✓ prd.md"
    [[ -f "$feature_dir/pattern-analysis.md" ]] && echo "      ✓ pattern-analysis.md"
    [[ -f "$feature_dir/api-spec.yaml" ]] && [[ -s "$feature_dir/api-spec.yaml" ]] && echo "      ✓ api-spec.yaml"
    [[ -f "$feature_dir/test-plan.md" ]] && echo "      ✓ test-plan.md"
    [[ -f "$feature_dir/tasks.md" ]] && echo "      ✓ tasks.md"
    [[ -f "$feature_dir/quality-checklist.md" ]] && echo "      ✓ quality-checklist.md"
    [[ -f "$feature_dir/docs/docs-ja.md" ]] && echo "      ✓ docs/docs-ja.md"
    [[ -f "$feature_dir/docs/docs-en.md" ]] && echo "      ✓ docs/docs-en.md"
    [[ -f "$feature_dir/release/changelog-ja.md" ]] && echo "      ✓ release/changelog-ja.md"
    [[ -f "$feature_dir/release/changelog-en.md" ]] && echo "      ✓ release/changelog-en.md"
  fi

  echo ""
done

if [[ $feature_count -gt 1 ]]; then
  echo "Multiple features detected. Use --slug <folder> with SAEF commands."
fi
