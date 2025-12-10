# Copilot Instructions for SAEF

- **What this repo is**: Soracom AI Engineering Framework (SAEF) that drives features from idea to release via slash commands, producing numbered artifacts in `outputs/<YYYY-MM-DD>-<slug>/`.
- **Core lifecycle commands** (run via chat/IDE): `/saef:1-refine` → `/saef:2-prd` → `/saef:3-spec` → `/saef:4-plan` → `/saef:5-implement` → `/saef:6-docs` → `/saef:7-release`; `6-7` are experimental. ` /saef:debug:review-session` summarizes friction.
- **Where commands live**: `.claude/commands/saef/` holds the stage prompts; `.claude/skills/` adds domain rules (backend/frontend/testing, changelog writer, repository catalog, etc.). Use these files as source of truth when uncertain.
- **Artifacts by stage**: `1-business-statement.md`, `2-prd.md`, `2-pattern-analysis.md`, `3-api-spec.yaml`, `3-test-plan.md`, `3-repo-analysis.md`, `4-tasks.md`, `4-stories/`, `5-quality-checklist.md`, `5-pr-descriptions/`, `6-docs/`, `7-release/`. Keep filenames and numbering intact.
- **Selecting the feature**: If multiple folders exist under `outputs/`, pass `--slug <YYYY-MM-DD-slug>` to commands. Scripts in `.claude/skills/saef-ops/scripts/list-features.sh --verbose` help enumerate.
- **Language switch**: Commands accept `--lang en|ja|ja-en` (default `en`). Use bilingual (`ja-en`) for customer-facing docs/changelogs.
- **Validation hooks**: `check_context_guardrail.sh` enforces required artifacts before each stage; `markdown_formatter.py` normalizes fenced code blocks. Let these run instead of manual formatting.
- **Repository work**: Product code lives in `repos/<repo>/`; CODEOWNERS in each repo sets reviewers. `/saef:5-implement` writes code/tests and keeps work local—never push branches or open PRs automatically.
- **Pattern discovery**: `/saef:2-prd` looks at recent PRs before asking questions. When implementing, prefer matching patterns from `docs/templates/` and examples in `docs/examples/`.
- **Repository catalog**: `docs/repositories.yaml` lists product repos and triggers; use it to locate the right service when cloning or analyzing.
- **Domain guidance**: Skills in `.claude/skills/` codify standards (backend OpenAPI, frontend SDS/i18n, testing expectations, release flow, GitHub lifecycle). Consult the relevant `SKILL.md` when applying conventions.
- **Asking vs assuming**: Follow the AGENTS rule set (`AGENTS.md`): ask clarifying questions, search for patterns before designing, stay local, escalate if blocked >15 minutes.
- **Session reviews**: After complex work, run `/saef:debug:review-session` to capture improvement notes under `outputs/session_reviews/`.
- **Common setup**: `.claude/settings.json` auto-loads hooks/permissions; no extra bootstrap is needed once the repo is open in the IDE.
- **Do**: Keep artifacts in their numbered slots; cite key files/dirs when writing docs; reuse lifecycle outputs rather than rewriting context.
- **Don’t**: Skip required inputs for later stages; invent structure diverging from templates; push code or create PRs from this agent.
