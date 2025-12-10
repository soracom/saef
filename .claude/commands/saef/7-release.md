---
description: Generate changelog drafts. Outputs 7-release/
argument-hint: [--lang en|ja|ja-en] [--slug <YYYY-MM-DD-slug>]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# /saef:7-release — Changelog

> **🧪 EXPERIMENTAL**: This command is defined but not yet fully validated in production. Please report any issues you encounter.

Generate customer-facing changelog drafts. Optional command - only run when public announcement is needed.

## Step 1: Validate Context

```bash
.claude/skills/saef-ops/scripts/check-context.sh --stage release [--slug <slug>]
```

Read prior artifacts:
- `outputs/<slug>/2-prd.md`
- `outputs/<slug>/6-docs/`

## Step 2: Generate Changelog

Based on `--lang` flag, create changelogs in `outputs/<slug>/7-release/`:

### For Japanese (--lang ja or ja-en)

Create `outputs/<slug>/7-release/changelog-ja.md`:

```markdown
---
title: "<Feature Name>"
labels: ["User Console", "API", "New"]
publishOn: "YYYY-MM-DD"
isDraft: true
---

## 概要

<What's new, 1-2 sentences>

## 詳細

<Benefits to users>

## 利用方法

<How to access/use>
```

### For English (--lang en or ja-en)

Create `outputs/<slug>/7-release/changelog-en.md`:

```markdown
---
title: "<Feature Name>"
labels: ["User Console", "API", "New"]
publishOn: "YYYY-MM-DD"
isDraft: true
---

## Summary

<What's new, 1-2 sentences>

## Details

<Benefits to users>

## How to Use

<How to access/use>
```

## Step 3: Offer Next Steps

```text
Changelog drafts saved. Would you like to:
a) Review and adjust
b) Feature lifecycle complete
```

## Output

- `outputs/<slug>/7-release/changelog-ja.md` (if --lang ja or ja-en)
- `outputs/<slug>/7-release/changelog-en.md` (if --lang en or ja-en)

## Arguments

- `--lang en|ja|ja-en` - Language (default: en)
- `--slug <YYYY-MM-DD-slug>` - Target feature folder

## Notes

- This command is optional - only needed for public announcements
- User is responsible for copying to changelog repo and publishing
