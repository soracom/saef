---
description: Implement feature code and tests. Outputs code in repos, 5-quality-checklist.md, and 5-pr-descriptions/
argument-hint: [--slug <YYYY-MM-DD-slug>]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# /saef:5-implement — Implementation

Implement code and tests. Commit to local feature branches. Generate PR descriptions with SAEF metadata.

**Optional**: Can push branches and create PRs with SAEF labels if user requests and GitHub CLI is authenticated.

## Step 1: Validate Context

```bash
.claude/skills/saef-ops/scripts/check-context.sh --stage implement [--slug <slug>]
```

Read prior artifacts:
- `outputs/<slug>/2-prd.md`
- `outputs/<slug>/3-api-spec.yaml`
- `outputs/<slug>/3-test-plan.md`
- `outputs/<slug>/4-tasks.md`

## Step 1.5: Verify GitHub Authentication

**REQUIRED**: Verify GitHub CLI authentication before implementation:

```bash
gh auth status
```

If not authenticated:
1. Alert user: "GitHub CLI not authenticated. PRs cannot be created."
2. Ask: "Would you like to continue implementation without PR creation, or authenticate first?"
3. If user continues, PRs will need manual creation later

## Step 2: Verify Repositories & Create Feature Branches

**CRITICAL**: Before implementing in any repository, verify it is not archived:

```bash
# Check each affected repo
for repo in <affected-repos>; do
    # Verify not archived
    if bash .claude/skills/saef-ops/scripts/check-archived.sh "soracom/$repo"; then
        echo "ERROR: $repo is archived and cannot be modified"
        echo "Ask user for migration strategy or alternative approach"
        exit 1
    fi

    # Check against repositories.yaml
    if grep -A 3 "name: $repo" docs/repositories.yaml | grep -q "archived: true"; then
        echo "ERROR: $repo is marked as archived in repositories.yaml"
        exit 1
    fi

    # Safe to create feature branch
    cd repos/$repo
    git checkout -b <feature-slug>
done
```

If any repository is archived:
1. **STOP implementation immediately**
2. Alert the user that the repo is archived
3. Ask for migration strategy or alternative implementation approach

## Step 3: Implement Code

Follow tasks from `4-tasks.md`. Mark each task complete as you finish:

```markdown
- [x] [BE] Implement endpoint - done in repos/soracom-api/...
```

**Write complete working code, not boilerplate.**

## Step 4: Write Tests

Follow `3-test-plan.md`:
- Unit tests
- Integration tests
- E2E tests (Root + SAM users)

## Step 5: Local Validation

Run tests locally before committing:
```bash
# Example for each repo type
npm run test
./gradlew test
make test
```

## Step 6: Commit Changes

Commit to local branches (do NOT push):
```bash
git add .
git commit -m "<feature>: <description>"
```

## Step 7: Create Quality Checklist

Create `outputs/<slug>/5-quality-checklist.md`:

```markdown
# Quality Checklist

## Code Quality
- [ ] Code follows repo conventions
- [ ] No hardcoded values
- [ ] Error handling implemented

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] E2E tests pass (Root user)
- [ ] E2E tests pass (SAM user)

## Documentation
- [ ] Code comments where needed
- [ ] API docs updated (if applicable)
```

## Step 8: Generate PR Descriptions with SAEF Metadata

For each repo with changes, create `outputs/<slug>/5-pr-descriptions/pr-<repo>.md`:

**Follow each repo's existing PR template** (e.g., `.github/PULL_REQUEST_TEMPLATE.md` or `.github/pull_request_template.md`)

**Add SAEF metadata section** at the end:

```markdown
## SAEF Generated PR

**Feature**: `<slug>`
**Stage**: `5-implement`
**Generated**: `<ISO 8601 timestamp>`

**SAEF Artifacts**:
- [Business Statement](../../../../saef/outputs/<slug>/1-business-statement.md)
- [PRD](../../../../saef/outputs/<slug>/2-prd.md)
- [API Spec](../../../../saef/outputs/<slug>/3-api-spec.yaml)
- [Test Plan](../../../../saef/outputs/<slug>/3-test-plan.md)
- [Tasks](../../../../saef/outputs/<slug>/4-tasks.md)

**PR Labels** (to be applied):
- `saef:generated`
- `saef:stage:5-implement`
- `saef:feature-type:<backend|frontend|fullstack>`
```

**GitHub CLI command to create PR**:
```bash
gh pr create \
  --title "<title>" \
  --body-file outputs/<slug>/5-pr-descriptions/pr-<repo>.md \
  --label "saef:generated,saef:stage:5-implement,saef:feature-type:<type>"
```

**User actions after this command**:
1. Review code changes in each repo
2. Push branches: `git push origin <branch>` or `git push --force-with-lease origin <branch>` if updating
3. Create PRs using `gh pr create` command from PR description file

## Step 9: Offer to Push and Create PRs

Ask user if they want to push branches and create PRs now:

```text
Implementation complete. Local branches ready.

GitHub CLI authenticated: <yes/no>

Would you like me to:
a) Push branches and create PRs now (requires GitHub auth)
b) Show manual push/PR commands for you to run
c) Review changes first
d) Proceed to /saef:6-docs
```

If user chooses (a) and GitHub is authenticated:
1. Push each branch: `git push origin <branch>` or `git push --force-with-lease origin <branch>`
2. Create PRs with: `gh pr create --title "..." --body-file outputs/<slug>/5-pr-descriptions/pr-<repo>.md --label "saef:generated,..."`
3. Report PR URLs to user

## Output

- Code in `repos/<repo>/` (local branches, not pushed)
- `outputs/<slug>/5-quality-checklist.md`
- `outputs/<slug>/5-pr-descriptions/pr-<repo>.md`
- Updated `outputs/<slug>/4-tasks.md` (tasks marked complete)

## Arguments

- `--slug <YYYY-MM-DD-slug>` - Target feature folder

## Troubleshooting

If stuck for more than 15 minutes on an issue:
1. Document what you tried
2. Ask user for guidance
3. Do not continue without direction
