# Enhancement: PR Feedback Agent

**Status**: Proposed
**Priority**: High
**Category**: Implementation Quality & Developer Experience
**Created**: 2025-12-11

## Problem Statement

The current `/saef:5-implement` workflow stops after creating PRs with SAEF metadata. When reviewers provide feedback or CI/CD builds fail, the system cannot automatically respond, requiring manual intervention to:

1. Fix compilation errors (e.g., invalid enum constants)
2. Address reviewer questions and code feedback
3. Add missing test data discovered through CI failures
4. Update implementation based on review comments
5. Iterate until PR approval

**Real example from PR #548:**
- Initial implementation used try-catch that swallowed exceptions
- CI test failed due to missing test data for IMSI
- Used invalid enum constant `ActivationStatus.active` (should be `black`)
- Reviewer questioned whether JP SIMs have registration secret data
- Required 3 additional commits to address feedback

## Proposed Solution

Create a PR feedback agent that monitors SAEF-generated PRs and automatically responds to feedback.

### Phase 1: Read-Only Monitoring

**Capabilities:**
- Monitor GitHub PR comments and reviews for SAEF-labeled PRs
- Track CI/CD build status via AWS CodeBuild/GitHub Actions
- Parse build logs for compilation errors and test failures
- Alert when human intervention is needed

**Infrastructure Requirements:**
- **GitHub**: Read access to PR comments, reviews, CI status
- **AWS**: Read-only access to:
  - CodeBuild logs and build status
  - DynamoDB table schemas (for validation)
  - CloudWatch logs (for runtime errors)
- **Repository**: Read access to test data builders and model definitions

### Phase 2: Automated Response

**Capabilities:**
- Fix compilation errors automatically
  - Search codebase for valid enum values
  - Verify against actual usage patterns
  - Add missing imports
- Add missing test data
  - Analyze test failures to identify missing fixtures
  - Find related test data builders
  - Generate appropriate test data with correct relationships
- Respond to reviewer questions
  - Research codebase for answers
  - Cite sources with file paths and line numbers
  - Update implementation if needed
- Update PR with fixes
  - Commit changes with descriptive messages
  - Reference reviewer comments in commit messages
  - Update PR comment thread with explanations

**Infrastructure Requirements (additional):**
- **GitHub**: Write access to:
  - Push commits to feature branches
  - Add PR comments with responses
  - Update PR descriptions with additional context
- **MCP Access**: Integration with project-specific MCP servers for:
  - Database schema queries
  - Build log analysis
  - Test execution results

### Phase 3: Intelligent Learning

**Capabilities:**
- Learn from past PR feedback patterns
- Build knowledge base of common issues and fixes
- Suggest improvements to `/saef:2-prd` based on feedback history
- Pre-validate implementations against known patterns

## Implementation Design

### Agent Architecture

```text
PR Feedback Agent
├── Monitor Loop
│   ├── GitHub PR watcher (webhooks or polling)
│   ├── CI/CD status checker
│   └── Build log analyzer
├── Analysis Engine
│   ├── Error parser (compilation, test, runtime)
│   ├── Reviewer comment classifier
│   └── Source code investigator
├── Fix Generator
│   ├── Code fix synthesizer
│   ├── Test data generator
│   └── Documentation updater
└── Response Executor
    ├── Git operations (commit, push)
    ├── GitHub operations (comment, update)
    └── Notification system
```

### Configuration

Add to `.claude/agents/pr-feedback-agent.md`:

```yaml
triggers:
  - github_pr_comment (SAEF-labeled PRs)
  - github_pr_review (SAEF-labeled PRs)
  - ci_build_failure (SAEF branches)

permissions:
  github:
    read: [prs, comments, reviews, checks]
    write: [commits, comments]
  aws:
    read: [codebuild:*, dynamodb:DescribeTable, logs:*]

monitoring:
  poll_interval: 5m
  max_auto_fix_attempts: 3
  require_human_approval: [architectural_changes, new_dependencies]
```

### Example Flow

1. **CI Build Fails** on feature/display-puk-subscriber-page
   ```text
   Agent detects: compilation error at SIMCardManagementBuilder.java:89
   "cannot find symbol: variable active"
   ```

2. **Agent Investigates**
   - Searches for ActivationStatus enum usage patterns
   - Finds: `ActivationStatus.black` used for activated SIMs
   - Verifies: Test subscriber is active (from SubscriberBuilder)

3. **Agent Fixes**
   - Changes `ActivationStatus.active` → `ActivationStatus.black`
   - Commits: "Fix ActivationStatus for JP test data"
   - Adds comment explaining the fix with source citations

4. **Reviewer Asks**: "Does JP coverage also have PUK data?"

5. **Agent Responds**
   - Searches for PassCode usage in SubscriberRegistrationDetailService
   - Finds both PUK and PassCode map to registrationSecret
   - Updates implementation to support both coverage types
   - Comments with code references and explanation

## Benefits

1. **Faster PR Iteration**: Reduces time from feedback to fix from hours to minutes
2. **Better Code Quality**: Agent verifies fixes against actual codebase patterns
3. **Knowledge Capture**: Documents reasoning and sources for all changes
4. **Reduced Context Switching**: Developers don't need to interrupt other work to fix minor issues
5. **Learning Loop**: System improves PRD quality based on common implementation issues

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Agent makes incorrect fixes | Require human approval for non-trivial changes; limit to compilation/test fixes |
| Security concerns with write access | Use dedicated GitHub App with scoped permissions; audit all automated commits |
| Over-reliance on automation | Maintain human review requirement; agent assists but doesn't replace reviewers |
| Infrastructure cost | Start with polling; move to webhooks; implement smart caching |

## Success Metrics

- **Time to Fix**: Median time from CI failure to fix commit < 10 minutes
- **Auto-Fix Rate**: % of compilation/test errors fixed without human intervention > 80%
- **False Fix Rate**: % of automated fixes that need revert < 5%
- **PR Cycle Time**: Average commits per PR reduced by 30%

## Infrastructure Access Requirements

### AWS Read-Only Access

**Required Services:**
- **CodeBuild**: Build logs, status, test reports
- **DynamoDB**: Table schemas, attribute definitions (not data)
- **CloudWatch Logs**: Application logs from test runs
- **S3**: Build artifacts, test coverage reports

**IAM Policy Example:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:BatchGetProjects",
        "dynamodb:DescribeTable",
        "logs:GetLogEvents",
        "logs:FilterLogEvents",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:codebuild:*:*:project/internal-console-*",
        "arn:aws:dynamodb:*:*:table/*",
        "arn:aws:logs:*:*:log-group:/aws/codebuild/*",
        "arn:aws:s3:::codebuild-*"
      ]
    }
  ]
}
```

### GitHub Access

**Required Permissions:**
- Read: repository, pull requests, checks, contents
- Write: pull requests (comments), contents (commits to feature branches)

**GitHub App Scopes:**
- `checks:read` - CI status
- `contents:write` - Push commits (feature branches only)
- `pull_requests:write` - Comment and update PRs
- `metadata:read` - Repository metadata

## Implementation Phases

### Phase 1 (MVP): Compilation Error Fixer
- Monitor CI builds for SAEF PRs
- Detect compilation errors
- Search for valid values in codebase
- Auto-commit fixes with citations
- **Effort**: 2-3 weeks

### Phase 2: Test Data Generator
- Detect test failures from missing data
- Generate appropriate test fixtures
- Validate data relationships (ICCID ↔ IMSI)
- **Effort**: 3-4 weeks

### Phase 3: Review Response System
- Parse reviewer comments
- Research codebase for answers
- Generate responses with citations
- Auto-implement requested changes
- **Effort**: 4-6 weeks

### Phase 4: Learning & Prediction
- Build knowledge base from PR history
- Predict common issues during PRD phase
- Suggest validation checks
- **Effort**: Ongoing

## Related Documents

- [/saef:5-implement command](.claude/commands/saef/5-implement.md)
- [SAEF GitHub Lifecycle](../references/github-lifecycle.md)
- [Quality Checklist Template](../templates/quality-checklist.md)

## Open Questions

1. Should agent have blanket write access or require per-commit approval?
2. How to handle authentication for AWS resources (IAM role, credentials)?
3. Should agent run as GitHub Action, standalone service, or Claude Desktop agent?
4. What's the escalation path when agent can't resolve feedback?
5. How to prevent agent from pushing to main/master branches?

## References

**Real-world examples that motivated this enhancement:**
- PR #548: Display PUK on Subscriber Page
  - Issue: Invalid `ActivationStatus.active` enum constant
  - Issue: Missing test data for IMSI 295059990045088
  - Issue: Reviewer questioned JP SIM PUK availability
  - Resolution: 3 additional manual commits over 30+ minutes
