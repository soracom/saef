#!/usr/bin/env bash

# Validates that required artifacts exist before running slash commands.
#
# LANGUAGE FLEXIBILITY: For docs and release stages, this script checks for at least
# one language variant (ja/en) rather than requiring both. This allows features to be
# developed with --lang en, --lang ja, or --lang ja-en without breaking validation.

set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/common.sh"

# Check dependencies before proceeding
check_saef_dependencies

usage() {
  cat <<'EOF'
Usage: .claude/skills/saef-ops/scripts/check-context.sh --stage <refine|prd|spec|plan|implement|docs|release> [--slug <YYYY-MM-DD-slug>]

Examples:
  .claude/skills/saef-ops/scripts/check-context.sh --stage prd
  .claude/skills/saef-ops/scripts/check-context.sh --stage implement --slug 2025-01-15-recovery-email-enforcement
EOF
  exit 1
}

STAGE=""
FEATURE_FOLDER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --stage)
      STAGE="${2:-}"
      shift 2
      ;;
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

[[ -n "$STAGE" ]] || usage

# For refine stage, no existing folder is required - it creates one
if [[ "$STAGE" == "refine" ]]; then
  saef_info "Context OK for stage 'refine' (creates new feature folder)"
  exit 0
fi

FEATURE_FOLDER="$(resolve_feature_folder "$FEATURE_FOLDER")"
FEATURE_DIR="$(feature_path_from_folder "$FEATURE_FOLDER")"

require_directory "$FEATURE_DIR" "Feature directory not found: $FEATURE_DIR"

declare -a REQUIRED_FILES
declare -a REQUIRED_FILES_WITH_CONTENT

# Artifact naming convention:
# 1-business-statement.md (from /saef:1-refine)
# 2-prd.md, 2-pattern-analysis.md (from /saef:2-prd)
# 3-api-spec.yaml, 3-test-plan.md, 3-repo-analysis.md (from /saef:3-spec)
# 4-tasks.md, 4-stories/ (from /saef:4-plan)
# 5-quality-checklist.md, 5-pr-descriptions/ (from /saef:5-implement)
# 6-docs/ (from /saef:6-docs)
# 7-release/ (from /saef:7-release)

case "$STAGE" in
  prd)
    REQUIRED_FILES=()
    REQUIRED_FILES_WITH_CONTENT=("1-business-statement.md")
    ;;
  spec)
    REQUIRED_FILES=()
    REQUIRED_FILES_WITH_CONTENT=("2-prd.md" "2-pattern-analysis.md")
    ;;
  plan)
    REQUIRED_FILES=()
    REQUIRED_FILES_WITH_CONTENT=("2-prd.md" "3-api-spec.yaml" "3-test-plan.md")
    ;;
  implement)
    REQUIRED_FILES=()
    REQUIRED_FILES_WITH_CONTENT=("2-prd.md" "3-api-spec.yaml" "3-test-plan.md" "4-tasks.md")
    ;;
  docs)
    REQUIRED_FILES=()
    REQUIRED_FILES_WITH_CONTENT=("2-prd.md" "5-quality-checklist.md")
    ;;
  release)
    REQUIRED_FILES=()
    REQUIRED_FILES_WITH_CONTENT=("2-prd.md")
    # At least one language doc must exist
    if [[ ! -f "$FEATURE_DIR/6-docs/docs-ja.md" ]] && [[ ! -f "$FEATURE_DIR/6-docs/docs-en.md" ]]; then
      die "Missing required documentation: At least one of 6-docs/docs-ja.md or 6-docs/docs-en.md must exist for stage '$STAGE'"
    fi
    ;;
  *)
    die "Unsupported stage: $STAGE"
    ;;
esac

# Check files that just need to exist
for file in "${REQUIRED_FILES[@]}"; do
  require_file "$FEATURE_DIR/$file" "Missing required artifact for stage '$STAGE': $FEATURE_FOLDER/$file"
done

# Check files that need to exist AND have content
for file in "${REQUIRED_FILES_WITH_CONTENT[@]}"; do
  require_file_with_content "$FEATURE_DIR/$file" "Missing or empty artifact for stage '$STAGE': $FEATURE_FOLDER/$file"
done

saef_info "Context OK for stage '$STAGE' (feature: $FEATURE_FOLDER)"

