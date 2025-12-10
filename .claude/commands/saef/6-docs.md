---
description: Generate user guides and developer docs. Outputs 6-docs/
argument-hint: [--lang en|ja|ja-en] [--slug <YYYY-MM-DD-slug>]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# /saef:6-docs — Documentation

> **🧪 EXPERIMENTAL**: This command is defined but not yet fully validated in production. Please report any issues you encounter.

Generate user-facing documentation based on implementation.

## Step 1: Validate Context

```bash
.claude/skills/saef-ops/scripts/check-context.sh --stage docs [--slug <slug>]
```

Read prior artifacts:
- `outputs/<slug>/2-prd.md`
- `outputs/<slug>/3-api-spec.yaml`
- `outputs/<slug>/5-quality-checklist.md`

## Step 2: Generate Documentation

Based on `--lang` flag, create docs in `outputs/<slug>/6-docs/`:

### For Japanese (--lang ja or ja-en)

Create `outputs/<slug>/6-docs/docs-ja.md`:

```markdown
# <Feature>の使い方

## 概要

<What this feature does>

## 前提条件

- <Prerequisite 1>

## 手順

1. <Step 1>
2. <Step 2>

## 関連ドキュメント

- <Link>
```

### For English (--lang en or ja-en)

Create `outputs/<slug>/6-docs/docs-en.md`:

```markdown
# <Feature> Guide

## Overview

<What this feature does>

## Prerequisites

- <Prerequisite 1>

## Usage

1. <Step 1>
2. <Step 2>

## API Reference

<If applicable, from api-spec>

## Related Resources

- <Link>
```

## Step 3: Offer Next Steps

```text
Documentation saved. Would you like to:
a) Review and adjust
b) Proceed to /saef:7-release
```

## Output

- `outputs/<slug>/6-docs/docs-ja.md` (if --lang ja or ja-en)
- `outputs/<slug>/6-docs/docs-en.md` (if --lang en or ja-en)

## Arguments

- `--lang en|ja|ja-en` - Language (default: en)
- `--slug <YYYY-MM-DD-slug>` - Target feature folder
