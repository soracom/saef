#!/usr/bin/env bash

# Create minimal feature folder structure.
# Does NOT copy templates - each /saef:* command creates its own artifacts.

set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

check_saef_dependencies

ROOT_DIR="$(get_repo_root)"

usage() {
  cat <<'EOF'
Usage: .claude/skills/saef-ops/scripts/init-feature.sh "<feature description>"

Creates: outputs/<YYYY-MM-DD>-<slug>/ with minimal folder structure.
Each /saef:* command creates its own numbered artifacts.

Example:
  .claude/skills/saef-ops/scripts/init-feature.sh "Recovery email enforcement"
EOF
  exit 1
}

[[ $# -gt 0 ]] || usage

FEATURE_INPUT="$*"
SLUG="$(slugify "$FEATURE_INPUT")"
[[ -z "$SLUG" ]] && die "Unable to derive slug from: $FEATURE_INPUT"

FOLDER_NAME="$(make_feature_folder_name "$SLUG")"
FEATURE_DIR="$(feature_path_from_folder "$FOLDER_NAME")"

# Check for folder collision and append counter if needed
if [[ -d "$FEATURE_DIR" ]]; then
  saef_info "Folder $FOLDER_NAME already exists, finding available name..."
  COUNTER=2
  BASE_FOLDER_NAME="$FOLDER_NAME"
  while [[ -d "$FEATURE_DIR" ]]; do
    FOLDER_NAME="${BASE_FOLDER_NAME}-${COUNTER}"
    FEATURE_DIR="$(feature_path_from_folder "$FOLDER_NAME")"
    COUNTER=$((COUNTER + 1))
    if [[ $COUNTER -gt 10 ]]; then
      die "Too many collisions for feature folder. Please use a more specific feature name."
    fi
  done
  saef_info "Using folder name: $FOLDER_NAME"
fi

# Create minimal folder structure only
mkdir -p "$FEATURE_DIR"
mkdir -p "$FEATURE_DIR/4-stories"
mkdir -p "$FEATURE_DIR/5-pr-descriptions"
mkdir -p "$FEATURE_DIR/6-docs/images"
mkdir -p "$FEATURE_DIR/7-release"

# Create metadata file with feature info
cat > "$FEATURE_DIR/.saef-metadata" <<EOF
slug: $FOLDER_NAME
created: $(date -Iseconds)
requester: $(git config user.name 2>/dev/null || echo "unknown") <$(git config user.email 2>/dev/null || echo "unknown")>
EOF

saef_info "Feature folder created: outputs/$FOLDER_NAME"
saef_info "Run /saef:1-refine to create business statement"
echo "$FOLDER_NAME"
