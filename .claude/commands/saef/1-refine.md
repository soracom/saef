---
description: Refine raw feature idea into a structured business statement. Writes outputs/<date>-<slug>/1-business-statement.md
argument-hint: ["<feature idea>"] [--lang en|ja|ja-en] [--productboard <id1,id2,...>] [--shortcut <id1,id2,...>]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# /saef:1-refine — Feature Intake

Convert a raw feature idea into a concise business statement. Ask clarifying questions for any information you cannot verify. Do not infer, extrapolate, or fabricate details.

## Step 1: Initialize Workspace

```bash
.claude/skills/saef-ops/scripts/init-feature.sh "<feature title>"
```

Get requester info from git:
```bash
git config user.name
git config user.email
```

## Step 2: Gather Context

If `--productboard` or `--shortcut` provided, pull that context first.

## Step 3: Ask Clarifying Questions

**CRITICAL**: Do not assume or fabricate information. If you cannot verify something, ask.

Ask 3-7 focused questions using this **exact format** for better readability:

```markdown
## Question 1: [Short Topic]

[Full question text in plain language]

**Why this matters**: [One sentence explaining why you need this information]

**Options**:
- A) **[Short label]** - Detailed description with context
- B) **[Short label]** - Detailed description with context
- C) **[Short label]** - Detailed description with context
- D) **[Short label]** - Detailed description with context
- E) **Other** - Please specify

---
```

**End questions section with:**
```markdown
**Please answer these questions so I can create an accurate business statement!**
```

**Example of proper formatting:**
```markdown
## Question 1: How Often?

How often do internal console users need to reference this information when troubleshooting?

**Why this matters**: Helps us understand the frequency of this workflow and quantify potential time savings.

**Options**:
- A) **Multiple times daily (10+)** - Very high frequency, constant part of daily troubleshooting work
- B) **A few times daily (3-5)** - Regular occurrence during typical support shifts
- C) **Weekly (5-10 times)** - Occasional need across the team
- D) **Rarely (monthly)** - Infrequent but critical when needed
- E) **Other** - Please specify frequency

---
```

**Base questions to cover:**
- Who experiences this problem? (specific roles, team sizes)
- How often? (daily, weekly, per incident)
- What's the current workaround?
- Why now? (deadline, customer commitment, compliance, or "no urgency")
- What does success look like? (specific metrics if known)

**Add domain-specific questions based on feature type:**

If request mentions "internal console" or "admin" or "internal tool":
- Add: "Is this for internal users only, or will [subject] be visible to customers?"
- Add: "Should this respect Root vs SAM user permissions?"

If request mentions "API" or "endpoint" or "customer-facing":
- Add: "Does this require localization (Japanese + English)?"
- Add: "Does this affect existing API contracts or versions?"

If request mentions "security" or "audit" or "compliance":
- Add: "What compliance requirements apply (GDPR, SOC2, etc.)?"
- Add: "What audit trail or logging is needed?"

**Wait for answers before proceeding.**

## Step 4: Write Business Statement

**File Workflow**: For new files, use this sequence to avoid tool errors:
1. `Bash`: `touch outputs/<slug>/1-business-statement.md`
2. `Read`: Read the (empty) file
3. `Edit`: Write the full content

Create `outputs/<slug>/1-business-statement.md` with:

```markdown
# Business Statement: <Feature Name>

| Field | Value |
|-------|-------|
| **Requester** | <git user.name> (<git user.email>) |
| **Date** | <YYYY-MM-DD> |
| **Slug** | <folder-slug> |

## Problem

<2-3 sentences: Who has this problem, what is the pain, how often>

## Proposed Solution

<2-3 sentences: What we would build>

## Why Now

<1-2 sentences: Deadline, commitment, or "no specific deadline">

## Success Criteria

- <Measurable outcome 1>
- <Measurable outcome 2>

## Open Questions

- [ ] <Question needing answer>

## Context Links

- ProductBoard: <IDs or N/A>
- Shortcut: <IDs or N/A>
- Slack: <URL or N/A>
```

**Rules**:
- Keep it under 1 page
- Only include facts you can verify or that user provided
- Mark unknowns as "TBD - needs clarification"
- Do NOT infer statistics, percentages, or metrics

## Step 5: Offer Iteration Loop

After writing the business statement, ALWAYS say:

```text
I've created your business statement at outputs/<slug>/1-business-statement.md.

Would you like to make any adjustments? You can ask me to:
- Update the problem description or proposed solution
- Clarify success criteria or open questions
- Add or modify context links

Or say 'looks good' to finish, and I'll suggest next steps.
```

Continue iterating until user signals completion with phrases like:
- "looks good" / "that's fine" / "approved"
- "proceed to [next command]"
- "next step"

## Step 6: Validate and Suggest Next Command

Before suggesting the next command, validate it exists:

```bash
# Check if next command exists
ls .claude/commands/saef/2-prd.md
```

If exists:
```text
Next, run: /saef:2-prd --slug <slug>
```

If missing:
```text
Note: /saef:2-prd doesn't exist yet. Your business statement is ready at outputs/<slug>/1-business-statement.md
```

## Output

- `outputs/<slug>/1-business-statement.md`

## Arguments

- `--lang en|ja|ja-en` - Language (default: en)
- `--productboard <ids>` - Pull ProductBoard context
- `--shortcut <ids>` - Pull Shortcut context
