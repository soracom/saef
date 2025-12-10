#!/bin/bash
# Check if a GitHub repository is archived
# Usage: check-archived.sh <repo-name>
# Returns: 0 if archived, 1 if active, 2 on error

set -e

REPO_NAME="$1"

if [ -z "$REPO_NAME" ]; then
    echo "Usage: $0 <repo-name>" >&2
    echo "Example: $0 soracom/soracom-api" >&2
    exit 2
fi

# Ensure repo name has org prefix
if [[ ! "$REPO_NAME" =~ / ]]; then
    REPO_NAME="soracom/$REPO_NAME"
fi

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed" >&2
    exit 2
fi

# Query GitHub for archive status
IS_ARCHIVED=$(gh repo view "$REPO_NAME" --json isArchived -q '.isArchived' 2>/dev/null || echo "error")

if [ "$IS_ARCHIVED" = "error" ]; then
    echo "Error: Could not check archive status for $REPO_NAME" >&2
    exit 2
fi

if [ "$IS_ARCHIVED" = "true" ]; then
    echo "ARCHIVED: $REPO_NAME is archived and cannot be modified" >&2
    exit 0
else
    exit 1
fi
