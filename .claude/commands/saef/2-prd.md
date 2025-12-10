---
description: Generate PRD from the business statement. Analyzes recent PRs for patterns. Outputs 2-prd.md, 2-pattern-analysis.md
argument-hint: [--lang en|ja|ja-en] [--slug <YYYY-MM-DD-slug>]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# /saef:2-prd — PRD Generation

Convert the business statement into a technical PRD. Discover patterns from recent PRs. Do not infer or fabricate details - ask if unclear.

## Step 1: Validate Context

```bash
.claude/skills/saef-ops/scripts/check-context.sh --stage prd [--slug <slug>]
```

Read `outputs/<slug>/1-business-statement.md`.

## Step 2: Analyze Recent PRs for Patterns

**CRITICAL**: Before analyzing any repository, verify it is not archived:

```bash
# Check each repo before analysis
for repo in repos/*/; do
    repo_name=$(basename "$repo")
    if bash .claude/skills/saef-ops/scripts/check-archived.sh "soracom/$repo_name"; then
        echo "SKIPPING $repo_name: Repository is archived"
        continue
    fi
    # Proceed with PR analysis for active repos only
    cd "$repo" && gh pr list --state merged --limit 50 --json title,body,files
done
```

Also verify against `docs/repositories.yaml` - skip any repos marked with `archived: true`.

**Expected Performance**: Searching PRs across multiple repos typically takes 30-60 seconds depending on the number of repositories and GitHub API response time.

Look for:
- Similar UI components or pages
- Similar API endpoints
- Similar data models
- Reusable patterns

Document findings in `outputs/<slug>/2-pattern-analysis.md`:

```markdown
# Pattern Analysis

## Similar PRs Found

| PR | Repo | Relevance | Pattern |
|----|------|-----------|---------|
| #123 "Add SIM details page" | user-console | High | Table component, API integration |

## Reusable Patterns

- <Pattern 1>: <Where found, how to reuse>

## Net-New Work

- <What doesn't exist yet>
```

## Step 3: Ask Technical Questions

Ask 3-5 questions about gaps not answered by patterns:

- What data needs to be displayed/stored?
- What user roles need access?
- What error states should be handled?
- Any specific UI requirements?

**Wait for answers before proceeding.**

## Step 4: Write PRD

Create `outputs/<slug>/2-prd.md`:

```markdown
# PRD: <Feature Name>

| Field | Value |
|-------|-------|
| **Status** | Draft |
| **Author** | <from .saef-metadata> |
| **Repos** | <affected repos> |
| **Effort** | <T-shirt size: S/M/L/XL> |

## Problem

<From business statement>

## Solution

### User Stories

- As a <role>, I want to <action>, so that <benefit>

### Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-1 | <Functional requirement> | Must |
| FR-2 | <Functional requirement> | Should |

### Out of Scope

- <What we're NOT building>

## Technical Approach

<Based on pattern analysis - what to reuse, what's new>

## Open Questions

- [ ] <Unresolved question>
```

**Rules**:
- Reference patterns found, don't reinvent
- Only include verified information
- Mark assumptions as "Assumption - needs validation"

## Step 5: Offer Next Steps

```text
PRD saved. Would you like to:
a) Review and adjust
b) Proceed to /saef:3-spec
```

## Output

- `outputs/<slug>/2-prd.md`
- `outputs/<slug>/2-pattern-analysis.md`

## Arguments

- `--lang en|ja|ja-en` - Language (default: en)
- `--slug <YYYY-MM-DD-slug>` - Target feature folder
