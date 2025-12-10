#!/usr/bin/env bash

# Shared helper functions for SAEF automation scripts.
# Inspired by GitHub's Spec Kit but simplified for this repository layout.

set -euo pipefail

# -----------------------------
# Dependency checks
# -----------------------------

check_dependencies() {
  local missing_deps=()

  for cmd in "$@"; do
    if ! command -v "$cmd" &> /dev/null; then
      missing_deps+=("$cmd")
    fi
  done

  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    saef_error "Missing required dependencies: ${missing_deps[*]}"
    echo "" >&2
    echo "Please install missing dependencies:" >&2
    for dep in "${missing_deps[@]}"; do
      case "$dep" in
        jq)
          echo "  - jq: https://stedolan.github.io/jq/download/" >&2
          echo "    Ubuntu/Debian: sudo apt-get install jq" >&2
          echo "    macOS: brew install jq" >&2
          ;;
        python3)
          echo "  - python3: https://www.python.org/downloads/" >&2
          echo "    Ubuntu/Debian: sudo apt-get install python3" >&2
          echo "    macOS: brew install python3" >&2
          ;;
        git)
          echo "  - git: https://git-scm.com/downloads" >&2
          echo "    Ubuntu/Debian: sudo apt-get install git" >&2
          echo "    macOS: brew install git" >&2
          ;;
        *)
          echo "  - $dep: Please install via your package manager" >&2
          ;;
      esac
    done
    echo "" >&2
    die "Cannot proceed without required dependencies"
  fi
}

# Check common SAEF dependencies (called by most scripts)
check_saef_dependencies() {
  check_dependencies git
}

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(CDPATH="" cd "$SCRIPT_DIR/../../../.." && pwd)"

# -----------------------------
# Logging helpers
# -----------------------------

saef_info() {
  echo "[saef] $*" >&2
}

saef_error() {
  echo "[saef][error] $*" >&2
}

die() {
  saef_error "$@"
  exit 1
}

# -----------------------------
# Repository helpers
# -----------------------------

get_repo_root() {
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    git rev-parse --show-toplevel
  else
    echo "$REPO_ROOT"
  fi
}

# Returns 0 if the repository is backed by git, otherwise 1.
has_git() {
  git rev-parse --show-toplevel >/dev/null 2>&1
}

# Ensures we are operating from repository root for any script that sources this file.
cd_repo_root() {
  cd "$(get_repo_root)"
}

# -----------------------------
# Feature helpers
# -----------------------------

slugify() {
  local value="${1:-}"
  value="$(echo "$value" | tr '[:upper:]' '[:lower:]')"
  value="$(echo "$value" | sed -E 's/[^a-z0-9]+/-/g')"
  value="$(echo "$value" | sed -E 's/^-+|-+$//g')"
  echo "$value"
}

# Creates canonical folder name: <date>-<slug>
make_feature_folder_name() {
  local slug="${1:-}"
  [[ -z "$slug" ]] && die "Missing slug for feature folder"
  local date_part
  date_part="$(date +%Y-%m-%d)"
  echo "${date_part}-${slug}"
}

is_feature_folder() {
  local name="$1"
  [[ "$name" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}- ]]
}

feature_root() {
  echo "$(get_repo_root)/outputs"
}

feature_path_from_folder() {
  local folder="${1:-}"
  echo "$(feature_root)/${folder}"
}

list_feature_folders() {
  local root
  root="$(feature_root)"
  if [[ -d "$root" ]]; then
    for dir in "$root"/*; do
      local base
      base="$(basename "$dir")"
      if [[ -d "$dir" ]] && is_feature_folder "$base"; then
        echo "$base"
      fi
    done | sort
  fi
}

latest_feature_folder() {
  list_feature_folders | tail -n 1
}

resolve_feature_folder() {
  local folder="${1:-}"
  if [[ -n "$folder" ]]; then
    # Explicit slug provided - verify it exists
    local feature_path
    feature_path="$(feature_path_from_folder "$folder")"
    if [[ ! -d "$feature_path" ]]; then
      die "Feature folder not found: $folder (expected at $feature_path)"
    fi
    echo "$folder"
    return
  fi

  # No slug provided - auto-discover with safety checks
  local feature_count
  feature_count="$(list_feature_folders | wc -l)"

  if [[ $feature_count -eq 0 ]]; then
    die "No feature directories found under outputs/. Run /saef:refine first."
  elif [[ $feature_count -eq 1 ]]; then
    # Single feature - auto-select without confirmation
    local latest
    latest="$(latest_feature_folder)"
    saef_info "Auto-selected feature: $latest (only feature found)"
    echo "$latest"
  else
    # Multiple features - require explicit slug for safety
    saef_error "Multiple features found. Please specify which one to use with --slug:"
    echo "" >&2
    list_feature_folders | sed 's/^/  - /' >&2
    echo "" >&2
    die "Specify --slug <folder> to avoid operating on the wrong feature"
  fi
}

# -----------------------------
# Language metadata helpers
# -----------------------------

# Stores language preference for a feature
set_feature_language() {
  local feature_dir="$1"
  local lang="${2:-en}"

  local metadata_file="$feature_dir/.saef-metadata"
  mkdir -p "$feature_dir"

  cat > "$metadata_file" <<EOF
# SAEF Feature Metadata
# Auto-generated - do not edit manually
LANGUAGE=$lang
CREATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
EOF

  saef_info "Language preference set to: $lang"
}

# Retrieves language preference for a feature
get_feature_language() {
  local feature_dir="$1"
  local default_lang="${2:-en}"

  local metadata_file="$feature_dir/.saef-metadata"

  if [[ -f "$metadata_file" ]]; then
    # Extract LANGUAGE value from metadata
    local lang
    lang=$(grep '^LANGUAGE=' "$metadata_file" | cut -d= -f2)
    if [[ -n "$lang" ]]; then
      echo "$lang"
      return
    fi
  fi

  # No metadata found - return default
  echo "$default_lang"
}

# Resolves language with inheritance: explicit flag > feature metadata > default
resolve_language() {
  local explicit_lang="${1:-}"
  local feature_folder="${2:-}"
  local default_lang="${3:-en}"

  # Explicit flag always wins
  if [[ -n "$explicit_lang" ]]; then
    echo "$explicit_lang"
    return
  fi

  # Try to inherit from feature metadata
  if [[ -n "$feature_folder" ]]; then
    local feature_dir
    feature_dir="$(feature_path_from_folder "$feature_folder")"
    if [[ -d "$feature_dir" ]]; then
      local inherited_lang
      inherited_lang="$(get_feature_language "$feature_dir" "")"
      if [[ -n "$inherited_lang" ]]; then
        saef_info "Inherited language from feature metadata: $inherited_lang"
        echo "$inherited_lang"
        return
      fi
    fi
  fi

  # Fall back to default
  echo "$default_lang"
}

# -----------------------------
# Validation helpers
# -----------------------------

require_directory() {
  local dir="$1"
  local message="${2:-Directory missing: $dir}"
  [[ -d "$dir" ]] || die "$message"
}

require_file() {
  local file="$1"
  local message="${2:-File missing: $file}"
  [[ -f "$file" ]] || die "$message"
}

# Requires file to exist AND have non-empty content
require_file_with_content() {
  local file="$1"
  local message="${2:-File missing or empty: $file}"

  if [[ ! -f "$file" ]]; then
    die "$message (file does not exist)"
  fi

  # Check if file is empty (ignoring whitespace-only lines)
  if [[ ! -s "$file" ]] || ! grep -q '[^[:space:]]' "$file" 2>/dev/null; then
    die "$message (file exists but is empty - generate content first)"
  fi
}

# Usage: ensure_template_exists <path> <template_content>
ensure_file_with_content() {
  local path="$1"
  local content="$2"
  if [[ ! -f "$path" ]]; then
    printf "%s" "$content" >"$path"
  fi
}

