#!/usr/bin/env bash

# Organizes Playwright MCP screenshots for a given feature slug.
# Copies raw captures into outputs/<slug>/docs/images/, optionally backs up old assets,
# and reminds the user how to annotate screenshots.

set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

usage() {
  cat <<'EOF'
Usage: .claude/skills/saef-ops/scripts/generate-screenshots.sh --slug <YYYY-MM-DD-slug> [--source <dir>] [--annotated-source <dir>] [--backup]

Examples:
  .claude/skills/saef-ops/scripts/generate-screenshots.sh --slug 2025-11-23-sim-history-internal-console
  .claude/skills/saef-ops/scripts/generate-screenshots.sh --slug ... --source /tmp/playwright --backup
EOF
  exit 1
}

FEATURE_FOLDER=""
SOURCE_DIR=".playwright-mcp/screenshots/original"
ANNOTATED_SOURCE=".playwright-mcp/screenshots/annotated"
DO_BACKUP=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug)
      FEATURE_FOLDER="${2:-}"
      shift 2
      ;;
    --source)
      SOURCE_DIR="${2:-}"
      shift 2
      ;;
    --annotated-source)
      ANNOTATED_SOURCE="${2:-}"
      shift 2
      ;;
    --backup)
      DO_BACKUP=true
      shift 1
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

[[ -n "$FEATURE_FOLDER" ]] || usage
FEATURE_DIR="$(feature_path_from_folder "$FEATURE_FOLDER")"
DOC_IMAGE_ROOT="$FEATURE_DIR/docs/images"
ORIGINAL_DIR="$DOC_IMAGE_ROOT/original"
ANNOTATED_DIR="$DOC_IMAGE_ROOT/annotated"
BACKUP_DIR="$DOC_IMAGE_ROOT/backup"

require_directory "$FEATURE_DIR" "Feature directory not found: $FEATURE_DIR"
mkdir -p "$ORIGINAL_DIR" "$ANNOTATED_DIR" "$BACKUP_DIR"

timestamp="$(date +%Y%m%d-%H%M%S)"

backup_if_needed() {
  local target="$1"
  local name="$2"
  if $DO_BACKUP && [[ -d "$target" ]] && [[ -n "$(ls -A "$target" 2>/dev/null)" ]]; then
    local dest="$BACKUP_DIR/${timestamp}-${name}"
    saef_info "Backing up existing $name images to $dest"
    mkdir -p "$dest"
    cp -R "$target"/. "$dest"/
  fi
}

copy_if_exists() {
  local src="$1"
  local dest="$2"
  local label="$3"
  if [[ -d "$src" ]] && ls "$src"/*.{png,jpg,jpeg} >/dev/null 2>&1; then
    saef_info "Copying $label from $src -> $dest"
    mkdir -p "$dest"
    cp "$src"/*.{png,jpg,jpeg} "$dest"/ 2>/dev/null || true
  else
    saef_info "No $label found in $src (skipping)"
  fi
}

backup_if_needed "$ORIGINAL_DIR" "original"
backup_if_needed "$ANNOTATED_DIR" "annotated"

copy_if_exists "$SOURCE_DIR" "$ORIGINAL_DIR" "raw screenshots"
copy_if_exists "$ANNOTATED_SOURCE" "$ANNOTATED_DIR" "annotated screenshots"

saef_info "Screenshot workspace prepared under $DOC_IMAGE_ROOT"
saef_info "Next steps:"
saef_info " 1. Use Playwright MCP (or browser) to capture any missing steps to $SOURCE_DIR."
saef_info " 2. Annotate using: python3 .claude/skills/saef-ops/scripts/annotate_screenshot.py <input.png> <output.png>"
saef_info " 3. Keep numbering in sync with outputs/<slug>/docs/docs-ja.md and docs-en.md."

