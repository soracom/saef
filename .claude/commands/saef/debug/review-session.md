---
description: Analyze conversation history to extract systemic improvements for SAEF. Creates structured review in outputs/session_reviews/
argument-hint: [--output <custom-filename>]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# /saef:debug:review-session — Session Analysis for System Improvement

Analyze the current conversation to identify patterns in Claude's behavior that reveal gaps in SAEF system design. Focus on generalizable insights, not one-off fixes.

<context>
- **Input**: Current conversation history
- **Output**: `outputs/session_reviews/<timestamp>-session-analysis.md`
</context>

<instructions>

## 1. Initialize Review

```bash
mkdir -p outputs/session_reviews
TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
REVIEW_FILE="outputs/session_reviews/${TIMESTAMP}-session-analysis.md"
```

## 2. Analyze Conversation

Scan for:

| Category | What to Look For |
|----------|------------------|
| Commands | Which `/saef:*` ran? Order? Errors? |
| Tool Calls | Sequences, errors, inefficiencies |
| User Interventions | Corrections, clarifications, "what next?" |

## 3. Extract Patterns

For each pattern, document:

```markdown
### Pattern: [Short Name]

**Observed Behavior**: [What Claude did]
**Conversation Context**: Turn #, user input, Claude response
**Root Cause**:
- [ ] Missing instruction
- [ ] Ambiguous instruction
- [ ] Tool constraint
- [ ] Missing capability
- [ ] Unclear workflow

**Generalization**: [How this applies broadly]
**Applicability**: Commands affected, Frequency, Severity
```

## 4. Categorize Patterns

| Category | Description |
|----------|-------------|
| A. Prompt Engineering | Missing/ambiguous instructions |
| B. Workflow Design | Gaps in lifecycle, broken transitions |
| C. Tool/Capability | Missing scripts, tool constraints |
| D. User Experience | Unclear next steps, missing guidance |

## 5. Prioritize by Impact

- **Frequency**: Per-session, per-feature-type, one-time
- **Severity**: Critical, High, Medium, Low
- **Scope**: System-wide, command-specific, scenario-specific

## 6. Generate Recommendations

For high-impact patterns:
1. Specific change (exact text to add/modify)
2. Validation (how to test)
3. Broader application

## 7. Write Review Document

```markdown
# Session Analysis: [Date/Time]

## Metadata
- Commands Used, Duration, User Iterations

## Executive Summary
- 3-5 highest-impact findings

## Patterns by Category
### A. Prompt Engineering Issues
### B. Workflow Design Issues
### C. Tool/Capability Gaps
### D. User Experience Issues

## Prioritized Recommendations
### Critical (Do First)
### High Priority
### Medium Priority

## Testing Plan
- [ ] Test scenario, expected behavior, validation

## Appendix: Tool Call Sequence
## Appendix: User Intervention Log
```

</instructions>

<guidelines>

**DO**:
- Extract patterns that apply to multiple scenarios
- Identify systemic gaps in prompts, workflows, tools
- Provide concrete, actionable changes
- Categorize by root cause

**DON'T**:
- Focus on one-off issues specific to this session
- Propose changes that only help this specific feature type
- Make assumptions without evidence from conversation

</guidelines>

<output>
- `outputs/session_reviews/<timestamp>-session-analysis.md`
- Or with `--output <name>`: `outputs/session_reviews/<name>-session-analysis.md`
</output>

## 8. Offer to Implement Improvements

After writing the review document, ask the user:

```text
Session analysis complete. Would you like to:
a) Review the analysis file
b) Implement high-priority improvements now and create a PR
c) Done (no action needed)
```

If user selects **b) Implement improvements**:

1. Read the Critical and High Priority recommendations from the review file
2. For each recommendation:
   - Apply the suggested changes to the relevant files
   - Test the changes if applicable
   - Mark the recommendation as completed
3. Create a PR description file in the same session_reviews folder:

```markdown
# PR: SAEF Improvements from Session Review

**Session Review**: outputs/session_reviews/<timestamp>-session-analysis.md

## Summary

Improvements identified from session review on <date>:
- <Brief description of improvement 1>
- <Brief description of improvement 2>

## Type of Change

- [x] Bug fix (addresses issues encountered in session)
- [ ] New feature
- [ ] Breaking change
- [x] Documentation update

## Motivation

These changes address systemic issues identified during a SAEF session. See the full session review for detailed analysis.

## Changes Made

<List specific files changed and what was modified>

## Testing

<Describe how changes were tested>

## Impact

- [x] Slash commands
- [x] Skills
- [ ] Hooks
- [ ] Templates
- [x] Documentation

## Checklist

- [x] Changes based on actual usage and session review
- [x] Documentation updated
- [x] Maintains backward compatibility

## Related Session Review

See: outputs/session_reviews/<timestamp>-session-analysis.md
```

4. Save as `outputs/session_reviews/<timestamp>-pr-description.md`
5. Inform user:
   ```text
   Improvements implemented. PR description created at:
   outputs/session_reviews/<timestamp>-pr-description.md

   Next steps:
   1. Review the changes
   2. Create a PR to the SAEF repository
   3. Copy the PR description from the file above
   ```

## Usage

```bash
/saef:debug:review-session                          # Auto-timestamp filename
/saef:debug:review-session --output 2025-12-08-test # Custom filename
```
