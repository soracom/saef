---
name: soracom-screenshot-generator
description: Organizes E2E test screenshots from CI/CD artifacts (user-console-monorepo), backs up previous assets, and guides annotation workflow for documentation.
---

# Soracom Screenshot Generator Skill

Use this skill whenever `/saef:docs` needs to prepare screenshots. It leverages E2E test screenshots already captured during CI/CD runs in user-console-monorepo rather than requiring manual Playwright MCP captures.

## Responsibilities
1. Pull screenshots from CI/CD test artifacts (GitHub Actions artifacts, test result storage)
2. Organize relevant screenshots into `outputs/<slug>/docs/images/original`
3. Back up existing assets before overwriting
4. Guide annotation workflow for adding callouts/highlights
5. Keep screenshot numbering in sync with documentation steps

## Source Options

**Option 1: GitHub Actions Artifacts** (recommended)
```bash
# Download latest E2E test artifacts from user-console-monorepo
gh run download --repo soracom/user-console-monorepo --name playwright-screenshots --dir /tmp/screenshots

# Copy relevant screenshots to feature folder
.claude/skills/saef-ops/scripts/generate-screenshots.sh --slug <YYYY-MM-DD-slug> --source /tmp/screenshots --backup
```

**Option 2: Local Test Run**
```bash
# Run E2E tests locally in user-console-monorepo
cd repos/user-console-monorepo
pnpm test:e2e --grep "<feature-name>"

# Copy screenshots from test output
.claude/skills/saef-ops/scripts/generate-screenshots.sh --slug <YYYY-MM-DD-slug> --source repos/user-console-monorepo/test-results/screenshots --backup
```

**Option 3: Stored Test Results**
```bash
# If screenshots are stored in a shared location (S3, artifact storage)
.claude/skills/saef-ops/scripts/generate-screenshots.sh --slug <YYYY-MM-DD-slug> --source <path-to-stored-screenshots> --backup
```

## Annotation Workflow
1. Review raw screenshots in `outputs/<slug>/docs/images/original/`
2. Identify which screenshots need annotations (callouts, highlights, step numbers)
3. Run `python3 .claude/skills/saef-ops/scripts/annotate_screenshot.py <input.png> <output.png>` to add callouts
4. Store annotated files under `outputs/<slug>/docs/images/annotated/` with numeric prefixes (`01_login.png`, `02_form.png`)
5. Reference these filenames in `outputs/<slug>/docs/docs-ja.md` / `docs-en.md`

## Screenshot Naming Convention
- Use numeric prefixes matching documentation step order: `01_`, `02_`, `03_`
- Use descriptive names: `01_login_screen.png`, `02_form_input.png`, `03_confirmation.png`
- Keep original and annotated versions synchronized

## References
- `.claude/skills/saef-ops/scripts/generate-screenshots.sh`
- `.claude/skills/saef-ops/scripts/annotate_screenshot.py`
- Patterns learned from `soracom/user-doc-generator`
