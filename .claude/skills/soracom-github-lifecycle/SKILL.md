---
name: soracom-github-lifecycle
description: Soracom’s GitHub workflow for feature branches, PR reviews, CI requirements, and MCP/GitHub CLI usage. Use when creating branches from Shortcut stories, preparing PRs, or coordinating reviews/merges.
---

# Soracom GitHub Lifecycle

Use this skill to manage code changes end-to-end in Soracom’s GitHub org (branching, PR workflow, review gates, merges).

## 1. Branching
- Branch names must reference Shortcut story IDs: `sc-<story-id>-<slug>` (e.g., `sc-18421-sim-history-api`).
- Always branch from `dev` (backend repos) or mainline branch (frontend).
- Include the Shortcut URL in PR descriptions so lifecycle tools auto-link.

```bash
git checkout dev
git pull origin dev
git checkout -b sc-<story-id>-<slug>
```

## 2. Commit & Test Expectations
- Run repository-specific test commands before pushing (`./gradlew test`, `npm test`, `make internal`, etc.).
- Format code (`./gradlew spotlessApply`, `npm run lint`, `eslint --fix`) prior to commit.
- Reference `docs/repositories.yaml` for build/lint commands per repo.

## 3. Pull Request Checklist
- Title: `[Shortcut #<story-id>] <Feature summary>`
- Description:
  - Problem statement & solution summary
  - Test evidence (commands + results)
  - Links to SAEF artifacts (`outputs/<slug>/...`)
  - Rollout/rollback considerations
- Reviewers:
  - Backend: stakeholders + ogu (API) or core backend reviewers
  - Docs: makoto (JP), felix (EN) for copy changes
- Labels: domain/team + release phase as needed.

## 4. Reviews & Merging
- Require CI green (GitHub Actions/Buildkite per repo).
- For backend repos, follow Nebula release checklist before merging to `main`.
- Merge strategy:
  - Backend: merge dev → main via release PR scripts.
  - Frontend/docs: squash or merge commit per repo rules.

## 5. MCP / GitHub CLI Helpers
- `mcp__github__list-repos`, `get-file`, `create-branch`, `create-pull-request`.
- Ensure GitHub MCP credentials/config are set per repo instructions.
- Use `gh pr view`/`gh pr merge` for scripted merges when permitted.

## References
- [references/repository-analysis.md](references/repository-analysis.md)
- `docs/repositories.yaml`
- Repo-specific `CLAUDE.md` / `AGENTS.md`

