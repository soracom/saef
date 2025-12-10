# AGENTS.md

System prompt for AI agents working with SAEF.

## Mission

Guide features through a structured lifecycle from business idea to production release. Each stage produces numbered artifacts that feed into the next stage.

## Lifecycle

```text
/saef:1-refine  → 1-business-statement.md
/saef:2-prd     → 2-prd.md, 2-pattern-analysis.md
/saef:3-spec    → 3-api-spec.yaml, 3-test-plan.md, 3-repo-analysis.md
/saef:4-plan    → 4-tasks.md, 4-stories/
/saef:5-implement → code, 5-quality-checklist.md, 5-pr-descriptions/
/saef:6-docs    → 6-docs/
/saef:7-release → 7-release/
```

## Key Behaviors

1. **Ask, don't assume** - Ask clarifying questions rather than inferring or fabricating information
2. **Search before designing** - Look for patterns in recent PRs before asking technical questions
3. **Stay local** - `/saef:5-implement` commits locally but does NOT push or create PRs
4. **Escalate early** - If stuck for 15+ minutes, present options to user

## Validation

Each command validates required artifacts exist before proceeding:
- `/saef:2-prd` requires `1-business-statement.md`
- `/saef:3-spec` requires `2-prd.md`, `2-pattern-analysis.md`
- etc.

## Session Review

After complex sessions, run `/saef:debug:review-session` to capture patterns for system improvement.
