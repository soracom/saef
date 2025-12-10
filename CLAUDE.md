# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

SAEF (Soracom AI Engineering Framework) is an AI-assisted feature factory that guides features from ideation to release through a structured lifecycle using slash commands. Each command produces numbered artifacts stored in `outputs/<YYYY-MM-DD>-<slug>/`.

## Essential Commands

### Running SAEF Lifecycle
```bash
/saef:1-refine "feature idea"    # → 1-business-statement.md
/saef:2-prd                       # → 2-prd.md, 2-pattern-analysis.md
/saef:3-spec                      # → 3-api-spec.yaml, 3-test-plan.md, 3-repo-analysis.md
/saef:4-plan                      # → 4-tasks.md, 4-stories/
/saef:5-implement                 # → code in repos/, 5-quality-checklist.md, 5-pr-descriptions/
/saef:6-docs --lang ja-en         # → 6-docs/
/saef:7-release --lang ja-en      # → 7-release/
```

### Language Options
- `--lang en` - English only (default)
- `--lang ja` - Japanese only
- `--lang ja-en` - Bilingual (customer-facing features)

### Validation
```bash
.claude/skills/saef-ops/scripts/check-context.sh --stage <stage> [--slug <slug>]
.claude/skills/saef-ops/scripts/list-features.sh --verbose
```

### Setup

Hooks and permissions are configured in `.claude/settings.json` and load automatically when you open the project in Claude Code.

## Architecture

### Lifecycle Flow
```text
Feature Idea
    ↓ /saef:1-refine
1-business-statement.md
    ↓ /saef:2-prd
2-prd.md + 2-pattern-analysis.md
    ↓ /saef:3-spec
3-api-spec.yaml + 3-test-plan.md + 3-repo-analysis.md
    ↓ /saef:4-plan
4-tasks.md + 4-stories/
    ↓ /saef:5-implement
Code + Tests + 5-quality-checklist.md + 5-pr-descriptions/
    ↓ /saef:6-docs
6-docs/docs-ja.md + 6-docs/docs-en.md
    ↓ /saef:7-release
7-release/changelog-*.md
```

### Directory Structure
```text
saef/
├── .claude/
│   ├── commands/saef/       # Slash commands (1-refine.md through 7-release.md)
│   ├── skills/              # Specialized skills
│   ├── agents/              # quality-gate, release-ops
│   └── hooks/               # Validation hooks
├── docs/
│   ├── templates/           # Reference templates
│   ├── references/          # Standards and guidelines
│   └── repositories.yaml    # Repo catalog (triggers + clone URLs)
├── outputs/<YYYY-MM-DD>-<slug>/
│   ├── .saef-metadata            # Feature metadata
│   ├── 1-business-statement.md   # From /saef:1-refine
│   ├── 2-prd.md                  # From /saef:2-prd
│   ├── 2-pattern-analysis.md
│   ├── 3-api-spec.yaml           # From /saef:3-spec
│   ├── 3-test-plan.md
│   ├── 3-repo-analysis.md
│   ├── 4-tasks.md                # From /saef:4-plan
│   ├── 4-stories/
│   ├── 5-quality-checklist.md    # From /saef:5-implement
│   ├── 5-pr-descriptions/
│   ├── 6-docs/                   # From /saef:6-docs
│   └── 7-release/                # From /saef:7-release
└── repos/                        # Cloned product repos
```

## Key Principles

1. **Ask, don't assume** - Commands ask clarifying questions rather than inferring or fabricating information
2. **Pattern discovery** - `/saef:2-prd` searches recent PRs for similar features before asking technical questions
3. **Numbered artifacts** - Files are prefixed (1-, 2-, etc.) to show which command created them
4. **Local only** - `/saef:5-implement` commits locally but does NOT push or create PRs

## Working with Repositories

Clone repos into `./repos/` as needed. Team ownership comes from CODEOWNERS in each repo:
```bash
cat repos/<repo>/.github/CODEOWNERS
```

## Multiple Features

- 1 feature in outputs/: auto-selected
- 2+ features: use `--slug <YYYY-MM-DD-slug>`

## Troubleshooting

If stuck for 15+ minutes, escalate to user. Run `/saef:debug:review-session` after complex sessions to capture improvement opportunities.
