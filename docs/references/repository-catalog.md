# Soracom Repository Catalog Reference

This document explains how `docs/repositories.yaml` is structured and how SAEF commands should use it. Keep it synchronized with the catalog whenever repositories change ownership, tooling, or build instructions.

## 1. Schema (`docs/repositories.yaml`)

```yaml
schema_version: 1
metadata:
  updated: 2025-11-27
  owner: AI Engineering
repositories:
  - name: user-console-monorepo                 # short label (slug-friendly)
    full_name: soracom/user-console-monorepo    # GitHub org/repo
    clone_url: git@github.com:soracom/user-console-monorepo.git
    description: Customer-facing Soracom console (web UI)
    product_area: Customer Console              # optional domain tag
    team: Frontend                              # canonical team name
    slack_group: "@frontend-team"
    tech_stack: [TypeScript, React, SDS, Playwright]
    package_manager: pnpm
    build_tool: pnpm
    api_host: null                               # optional (mainly backend services)
    triggers: [customer-ui, sim-management, billing-ui]
    common_paths:
      - apps/user-console/src/app/
    ai_docs:
      - CLAUDE.md
    metadata_status: verified                    # or needs-verification
    notes: |
      Any caveats (e.g., requires VPN, long build times).
```

### Required Keys per Repository
| Key | Description |
| --- | --- |
| `name` | Short identifier used in prompts and `--repo` flags. |
| `full_name` | GitHub org/name (for linking). |
| `clone_url` | SSH URL (so commands can clone deterministically). |
| `description` | One-line summary for humans. |
| `product_area` | Optional domain tag (Customer Console, Internal Tools, Backend Platform, etc.). |
| `team` | Canonical team owner (Frontend, CRE, Backend Core, Ogu, Orion, Artemis, Cloud Camera, Flux, Platform/CRE). |
| `slack_group` | Primary escalation channel. |
| `tech_stack` | Primary technologies (languages, frameworks, infra). |
| `package_manager` / `build_tool` | How to install/build. Use `null` if not applicable. |
| `api_host` | Only for backend services exposed via HTTP. |
| `triggers` | Stable keywords SAEF commands match against. |
| `common_paths` | Directories to inspect first during analysis. |
| `ai_docs` | Repo-local reference files (CLAUDE.md, AGENTS.md, etc.). |
| `metadata_status` | `verified` or `needs-verification`. Use the latter if ownership/tooling is uncertain. |
| `notes` | Free-form caveats (VPN, long builds, manual steps). |

### Trigger Taxonomy (canonical values)
- `customer-ui`, `internal-ui`, `docs-site`
- `sim-management`, `group-config`, `billing-ui`, `operator-admin`
- `api-definition`, `api-routing`, `backend-core`, `diagnostics`
- `session-management`, `data-pipeline`, `file-management`
- `campaigns`, `ota`, `snowflake`, `auth`, `billing`, `notifications`

Use kebab-case, and prefer fewer, more general triggers to reduce noise.

## 2. Usage Guidelines

### `/saef:prd`
1. Read `docs/repositories.yaml`.
2. Match feature requirements against `triggers`.
3. Pull 2–4 candidate repos per product area.
4. Record findings under “Affected Repositories” in `prd.md`.

### `/saef:spec`
1. Verify selected repos are cloned (`clone_url` tells you how).
2. Use `common_paths`/`ai_docs` to focus semantic search.
3. Update `repo-analysis.md` with `metadata_status` if gaps remain.

### `/saef:plan`
1. Map tasks/story templates per repo.
2. Reference `build_tool` / `package_manager` for setup steps.

### `/saef:implement`
1. Follow `notes` (VPN, long builds).
2. Make sure code references `ai_docs` instead of rephrasing tribal knowledge.

## 3. Maintenance Rules

- Whenever ownership or tooling changes, update the YAML **and** this reference (if schema changes).
- If information is missing, set `metadata_status: needs-verification` and add TODO notes so the catalog doesn’t lie.
- Never reference `.archive/` from the catalog; extract needed snippets into `docs/references/` first.

## 4. Related Documents
- `docs/references/local-dev-setup.md` (per-repo environment steps)
- `.claude/skills/soracom-repository-catalog/references/local-dev-setup.md`
- `docs/references/backend-engineering-standards.md`
- `docs/references/soracom-services-architecture.md`

