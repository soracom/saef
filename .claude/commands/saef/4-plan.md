---
description: Break down PRD and spec into tasks and stories. Outputs 4-tasks.md and 4-stories/
argument-hint: [--slug <YYYY-MM-DD-slug>]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# /saef:4-plan — Task Breakdown

Break down PRD and spec into actionable tasks. Do not create tasks for work that already exists.

## Step 1: Validate Context

```bash
.claude/skills/saef-ops/scripts/check-context.sh --stage plan [--slug <slug>]
```

Read prior artifacts:
- `outputs/<slug>/2-prd.md`
- `outputs/<slug>/3-api-spec.yaml`
- `outputs/<slug>/3-test-plan.md`
- `outputs/<slug>/3-repo-analysis.md`

## Step 2: Create Task Breakdown

Create `outputs/<slug>/4-tasks.md`:

```markdown
# Tasks

## Summary

| Category | Tasks | Estimate |
|----------|-------|----------|
| Backend | X | S/M/L |
| Frontend | X | S/M/L |
| Testing | X | S/M/L |

## Backend Tasks

- [ ] [BE] Task description
- [ ] [BE] Task description

## Frontend Tasks

- [ ] [FE] Task description
- [ ] [FE] Task description

## Testing Tasks

- [ ] [QA] Task description

## Documentation Tasks

- [ ] [DOC] Task description
```

**Rules**:
- Only create tasks for net-new work (check repo-analysis)
- Tag tasks: `[BE]`, `[FE]`, `[QA]`, `[DOC]`, `[OPS]`
- Keep tasks atomic (1-2 hours each)

## Step 3: Create Story Files (Optional)

If Shortcut integration needed, create individual story files in `outputs/<slug>/4-stories/`:

```markdown
# Story: <Title>

## Context
<Link to PRD requirement>

## Acceptance Criteria
- [ ] Criterion 1

## Technical Notes
<File paths, patterns to follow>
```

## Step 4: Offer Next Steps

```text
Tasks created. Would you like to:
a) Review and adjust
b) Proceed to /saef:5-implement
```

## Output

- `outputs/<slug>/4-tasks.md`
- `outputs/<slug>/4-stories/*.md` (optional)

## Arguments

- `--slug <YYYY-MM-DD-slug>` - Target feature folder
