---
description: Generate OpenAPI 3.1+ spec and test plan from PRD. Outputs 3-api-spec.yaml, 3-test-plan.md, 3-repo-analysis.md
argument-hint: [--slug <YYYY-MM-DD-slug>]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# /saef:3-spec — API Spec & Test Plan

Generate OpenAPI spec and test plan from PRD. Do not infer details - ask if unclear.

## Step 1: Validate Context

```bash
.claude/skills/saef-ops/scripts/check-context.sh --stage spec [--slug <slug>]
```

Read `outputs/<slug>/2-prd.md` and `outputs/<slug>/2-pattern-analysis.md`.

## Step 2: Analyze Repositories

Check which repos are available and verify none are archived:
```bash
ls repos/

# CRITICAL: Check each repo is not archived
for repo in repos/*/; do
    repo_name=$(basename "$repo")
    if bash .claude/skills/saef-ops/scripts/check-archived.sh "soracom/$repo_name"; then
        echo "WARNING: $repo_name is archived - exclude from analysis"
    fi
done
```

Also check `docs/repositories.yaml` and skip any repos marked with `archived: true`.

For each **active** repo from PRD, document what exists vs needs creation in `outputs/<slug>/3-repo-analysis.md`:

```markdown
# Repository Analysis

| Repo | Available | Existing Patterns | Net-New |
|------|-----------|-------------------|---------|
| user-console-monorepo | Yes | Table components, API hooks | New page |
| soracom-api | Yes | Similar endpoints | New endpoint |
```

## Step 3: Generate API Spec (if API changes)

Create `outputs/<slug>/3-api-spec.yaml` following OpenAPI 3.1 or later:

- Paths: snake_case (`/sims/{sim_id}`)
- operationIds: camelCase (`getSimDetails`)
- Error codes: AAA0000 format

If no API changes needed, create file noting "No API changes required".

## Step 4: Generate Test Plan

Create `outputs/<slug>/3-test-plan.md`:

```markdown
# Test Plan

## Summary

| Type | Count | Description |
|------|-------|-------------|
| Unit | X | Business logic |
| Integration | X | DB, external services |
| E2E | X | User flows (Root + SAM) |

## Test Cases

### Unit Tests
- [ ] Test case 1
- [ ] Test case 2

### E2E Tests (Root User)
- [ ] Test case 1

### E2E Tests (SAM User)
- [ ] Test case 1
```

## Step 5: Offer Next Steps

```text
Spec and test plan saved. Would you like to:
a) Review and adjust
b) Proceed to /saef:4-plan
```

## Output

- `outputs/<slug>/3-api-spec.yaml`
- `outputs/<slug>/3-test-plan.md`
- `outputs/<slug>/3-repo-analysis.md`

## Arguments

- `--slug <YYYY-MM-DD-slug>` - Target feature folder
