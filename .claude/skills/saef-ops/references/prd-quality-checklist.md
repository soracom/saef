# PRD Quality Checklist

Use this checklist to self-evaluate PRD quality before finalizing.

## Completeness Check (all required content)

- [ ] All PRD sections filled with concrete details (no "TBD", no "To be determined", no empty sections)?
- [ ] Success metrics quantified with numbers (e.g., "50+ users in month 1", not "improve adoption")?
- [ ] Repos correctly identified and justified (checked against repository catalog triggers)?
- [ ] Pattern-analysis.md referenced if similar features found (link to `./pattern-analysis.md`)?
- [ ] UI changes have 2+ UX evidence examples from last 180 days (if applicable, see `./ux-evidence.md`)?
- [ ] Edge cases addressed (empty states, API errors, permission denied, null data)?

## Quality Check (content is meaningful)

### Success Metrics
- [ ] Metrics are measurable by the team mentioned (not aspirational)?
  - Good: "Reduce MTTR from 30min to 10min (CloudWatch logs, weekly review by CRE team)"
  - Bad: "Improve operational efficiency" (too vague to measure)

### Functional Requirements
- [ ] Requirements are concrete (not vague)?
  - Good: "Display subscriber history table with columns: timestamp, field, old_value, new_value, operator"
  - Bad: "Show relevant information about changes" (what information? what format?)

### Repository Ownership
- [ ] Affected repos have team ownership documented (from repositories.yaml)?
  - Each repo should list team (e.g., "user-console-monorepo → Frontend team (@frontend-team)")

### Effort Estimate
- [ ] Estimate justified (compared to similar features)?
  - Reference pattern-analysis.md if available
  - Compare to known features (e.g., "Similar to SIM history feature which was 5 story points")

## Self-Critique Questions

1. If a new engineer reads this PRD, can they understand WHAT to build without asking clarifying questions?
2. Are success metrics specific enough that we can check them 30/60/90 days after launch?
3. Did I explain why technical decisions were made (not just what decisions)?
4. For each repo affected, did I explain what changes are needed (not just list repos)?

## Iteration Guidance

- **First pass**: If any [ ] unchecked, fix gaps and re-check (common - do this)
- **Second pass**: If still gaps remain, note them in "Open Questions" section (acceptable)
- **Do NOT iterate more than twice** (diminishing returns, better to flag for /saef:spec)

## Output Quality Signal

| Signal | Criteria | Action |
|--------|----------|--------|
| ✅ **Green** (ready) | All checkboxes checked, self-critique passed | High quality, proceed |
| ⚠️ **Yellow** (acceptable) | 1-2 minor gaps noted in "Open Questions" | Acceptable, flag for /saef:spec to resolve |
| ❌ **Red** (needs work) | 3+ major gaps unchecked | Stop and ask user for more context |

## If Red (Needs Work)

Present gaps to user:
```
I've identified some gaps in the PRD that need your input:
1. [Gap 1]
2. [Gap 2]
3. [Gap 3]

Would you like me to:
a) Continue with assumptions (note them in Open Questions)
b) Wait for your clarification before proceeding
```
