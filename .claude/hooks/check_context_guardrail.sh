#!/usr/bin/env bash
set -euo pipefail

# Check for required dependency (jq)
if ! command -v jq &> /dev/null; then
  echo "[saef][error] Missing required dependency: jq" >&2
  echo "Please install jq: https://stedolan.github.io/jq/download/" >&2
  exit 1
fi

payload="$(cat)"

command_name="$(jq -r '.tool_input.command // empty' <<<"$payload")"
if [[ -z "$command_name" ]]; then
  exit 0
fi

case "$command_name" in
  "/saef:1-refine") stage="refine" ;;
  "/saef:2-prd") stage="prd" ;;
  "/saef:3-spec") stage="spec" ;;
  "/saef:4-plan") stage="plan" ;;
  "/saef:5-implement") stage="implement" ;;
  "/saef:6-docs") stage="docs" ;;
  "/saef:7-release") stage="release" ;;
  *) exit 0 ;;
esac

slug="$(jq -r '.tool_input.arguments[]? | select((.name // "") == "slug") | .value // empty' <<<"$payload")"

script="$CLAUDE_PROJECT_DIR/.claude/skills/saef-ops/scripts/check-context.sh"

if [[ -n "$slug" ]]; then
  "$script" --stage "$stage" --slug "$slug"
else
  "$script" --stage "$stage"
fi

