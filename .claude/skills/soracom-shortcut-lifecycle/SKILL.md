---
name: soracom-shortcut-lifecycle
description: Maps SAEF artifacts (business statement → docs) to Soracom Shortcut epics/stories, including status transitions, MCP tool usage, and GitHub linkage.
---

# Soracom Shortcut Lifecycle Skill

Use this skill whenever `/saef:refine`, `/saef:plan`, `/saef:implement`, or `/saef:docs` needs to read/update Shortcut. Everything below is derived from the README “Workflow Reference” section, `docs/templates/tasks-template.md`, and the slash-command specs under `.claude/commands/saef/*`.

## 1. Artifact Sources

Every Shortcut update must reference concrete files inside `outputs/<yyyy-mm-dd-slug>/`:

- `business-statement.md` – created by `.claude/skills/saef-ops/scripts/init-feature.sh`
- `prd.md`, `pattern-analysis.md`, `ux-evidence.md` – `/saef:prd`
- `api-spec.yaml`, `test-plan.md` – `/saef:spec`
- `tasks.md`, `quality-checklist.md`, optional `stories/*.md` – `/saef:plan`
- Implementation evidence: PR links, code paths from `/saef:implement`
- Docs: `outputs/<slug>/docs/docs-ja.md`, `docs-en.md`, `api-reference.md`, `faq.md`

Always capture the slug produced by `init-feature.sh` and pass it via `--slug` to every command. The slug is the bridge between SAEF folders and Shortcut records.

## 2. SAEF ↔ Shortcut Status Map

| SAEF Stage                                    | Shortcut Status | Update Details                                                                                                                                             |
|----------------------------------------------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `/saef:refine` (business statement scaffolded) | `idea` → `triage` | Comment with business-statement summary + `outputs/<slug>/business-statement.md`. Tag product owner identified in the business statement.                 |
| `/saef:prd` / `/saef:spec` in progress       | `triage` → `planning` | Link `prd.md`, `pattern-analysis.md`, `repo-analysis.md`, `api-spec.yaml`, `test-plan.md`. Call `.claude/skills/saef-ops/scripts/check-context.sh --stage prd|spec` before edits. |
| `/saef:plan` approved (`tasks.md` ready)     | `planning` → `implementation` | Attach `tasks.md`, `quality-checklist.md`, optional `stories/*.md`. Record dependency graph + estimates inside the ticket description.                      |
| `/saef:implement` running                    | stay `implementation` | Post branch/PR info, test status, and reference to `outputs/<slug>/tasks.md` items being checked off.                                                      |
| `/saef:docs` running                         | `implementation` → `docs` | Confirm `outputs/<slug>/docs/docs-ja.md` + `docs-en.md`, screenshot bundles, diagrams. Mention screenshot folder path + release blockers.                  |
| Release + docs published (`/saef:release`)   | `docs` → `done` | Paste changelog URL + doc PR links. Reference signed `quality-checklist.md`.                                                                               |

## 3. Shortcut Ticket Structure

- **Title:** Mirror PRD feature title (bilingual when available).
- **Description template (Markdown inside Shortcut):**
  ```markdown
  ## Context
  - SAEF folder: outputs/<slug>/
  - Business statement: outputs/<slug>/business-statement.md
  - PRD: outputs/<slug>/prd.md

  ## Plan & Tests
  - Tasks checklist: outputs/<slug>/tasks.md
  - Quality gates: outputs/<slug>/quality-checklist.md
  - API/Test artifacts: api-spec.yaml, test-plan.md

  ## Implementation
  - Branch: sc-<story-id>-<slug>
  - PRs: <links>

  ## Docs & Release
  - JP docs: outputs/<slug>/docs/docs-ja.md → website-users
  - EN docs: outputs/<slug>/docs/docs-en.md → website-developers
  - Changelog: outputs/<slug>/release/changelog.md (if generated)
  ```

## 4. Epic & Story Creation (from `/saef:plan`)

`/saef:plan` already defines how to create Shortcut structures. When you need to read/update Shortcut, **use the Shortcut MCP server** (commands summarized in `.claude/skills/soracom-documentation-writer/references/website-developers-agent-guidelines.md`); do not call the REST API directly.

1. Validate context:
   ```bash
   .claude/skills/saef-ops/scripts/check-context.sh --stage plan --slug <slug>
   ```
2. Convert `tasks.md` into epics/stories:
   - For each **Phase** block in `docs/templates/tasks-template.md`, emit an epic (Phase 1–5).
   - Each checklist item becomes a story or sub-task. Use `[BE]`, `[FE]`, `[OPS]`, `[DOC]` tags to set Shortcut labels.
   - Respect `[P]` flag to mark parallelizable work (set Shortcut `workflow_state: "Ready for Dev"` but keep dependencies).
3. Shortcut MCP commands (examples):
   - `mcp__mcp-shortcut__search-stories` / `get-story` – confirm existing work before creating new items.
   - `mcp__mcp-shortcut__create-story`, `update-story`, `create-story-comment`, `add-external-link-to-story` – build epics/stories and keep them up to date.
   - `mcp__mcp-shortcut__get-story-branch-name` – share branch names with engineering.
   Record every returned `storyPublicId` in `outputs/<slug>/shortcut-stories.json`.
4. Export mapping to `outputs/<slug>/shortcut-stories.json` so `/saef:implement` and `/saef:docs` can update statuses without re-reading Shortcut.

## 5. Shortcut MCP Operations & GitHub Integration

- Use MCP helpers (`get-current-user`, `assign-current-user-as-owner`, `unassign-current-user-as-owner`) to manage ownership.
- Workflow state updates go through `mcp__mcp-shortcut__update-story` (IDs: Started `500000006`, Ready for Review `500000007`, Approved `500000008`, Completed `500000009`).
- Post status notes via `create-story-comment` and attach PR URLs with `add-external-link-to-story`. Always include the relevant SAEF artifact path in each comment.

- Branch naming: `git checkout -b sc-<story-id>-<slug>` (see `.claude/skills/soracom-backend-guidelines/references/release-process.md`).
- PR title: `[Shortcut #<story-id>] <Feature summary>`.
- Include Shortcut URL + `outputs/<slug>` references in PR body.
- `/saef:implement` must update Shortcut when:
  - Story work starts (status → `in progress` or `implementation`).
  - Tests pass (comment linking to CI output).
  - PR merges (status → `docs` and attach merge commit).

## 6. Comment & Approval Patterns

- **Blockers:** Use fenced snippet:
  ```bash
  ⚠️ Blocker: <summary>
  Impact: <e.g., prevents `/saef:plan` approval>
  Owner: <name> | Next check-in: <date>
  ```

- **Approvals:** `✅ PRD approved by <name> (YYYY-MM-DD)` referencing `outputs/<slug>/prd.md`.
- **QA sign-off:** `✅ QA complete – see outputs/<slug>/quality-checklist.md (tests: unit ✓, contract ✓, E2E ✓)`.
- **Docs ready:** `📝 Docs synced to website-users / website-developers (see file paths).`

## 7. References

- `README.md` (“Workflow Reference”) – guardrail scripts + artifact layout (outputs/<slug>/).
- `.claude/commands/saef/plan.md` – Shortcut export flow + MCP usage.
- `.claude/commands/saef/implement.md` – expects Shortcut story IDs per task.
- `.claude/skills/saef-ops/` – `init-feature.sh`, `check-context.sh`, `generate-screenshots.sh`.
- `docs/templates/tasks-template.md` – authoritative checklist structure for mapping to Shortcut stories.
- `.claude/skills/soracom-documentation-writer/references/website-developers-agent-guidelines.md` – canonical MCP command reference and SOP summary.
