# Website Developers Agent Guidelines (Extracted)

This consolidated reference replaces the scattered `.claude` and `.agents` SOPs so SAEF no longer depends on the original repository.

## 1. Repository Overview

- **Stack**: Grav CMS 1.6.x + Blackhole static generator, Node.js 20.x, PHP 8.3, AWS S3 hosting, Algolia search.
- **Key paths**:
  - Content: `source/pages/` (URLs reflect directory names, e.g., `02.docs/01.air/` → `/docs/air/`).
  - Theme: `source/themes/soracom/`.
  - Grav install: `grav/` with `grav/user -> ../source` symlink.
- **Common commands**:
  - `npm ci`
  - `npx gulp dev` (local server)
  - `npx gulp build_batch`, `deploy_staging_batch`, `deploy_production_batch`
  - `npx gulp data` (API + carrier updates), `npx gulp index` (search)

## 2. Front Matter Requirements (`docs.en.md`)

```yaml
---
title: "Setting a Custom DNS"
menu: "Custom DNS"
description: "Short SEO blurb"
taxonomy:
  category: connectivity
  tag:
    - beta
icon: soracom-beam
sitemap:
  ignore: false
order: 100
simple-responsive-tables:
  active: true
---
```

Landing or hub pages may define `categories`, `button`, or redirect metadata (`external_url`, `to`).

## 3. Writing Style & Structure

- Headings use Title Case and progress sequentially (H2 → H3 → H4). No parentheticals inside headings.
- Overview section first, then prerequisites/before you begin, then tasks (Guides) or reference (API).
- Tone: professional, precise, primarily active voice. Address the reader directly (`you`) only in procedural sections.
- Avoid redundant blank lines; exactly one blank line before/after major blocks. No double line breaks.
- Inline code for file names/CLI flags; fenced code blocks with language tags (` ```bash`, ` ```json`).
- Use `[block=note|tip|warning|api|cli]...[/block]` for callouts; inline callouts can use `! Text`.
- Use tables for structured reference information; lists for flows/hierarchies.
- Provide alt text for every screenshot and describe what the user should notice.

## 4. Content Management SOPs (from `.agents/content-management/`)

1. **Adding New Category**
   - Duplicate the canonical directory structure `source/pages/02.docs/NN.service/`.
   - Update `doc.en.md` front matter with `categories` definitions so the landing page lists child guides.
   - Register nav weight via numeric directory prefixes.
2. **Cross-linking**
   - Always use relative links (`/docs/air/...`) for internal references.
   - When linking between guides, include a short description instead of “click here”.
3. **Creating Guides**
   - Base file name on purpose (`guide.en.md`, `topics.en.md`).
   - Include “Overview”, “Before you begin”, “Procedure”, “Troubleshooting”, “Related resources”.
   - Add `[block=api]` or `[block=cli]` when referencing programmatic steps.

## 5. Tool Usage SOPs

### GitHub MCP (`.agents/tool-usage-rules/github-mcp.md`)

- Use `mcp__github__list-repos`, `get-file`, `create-branch`, `create-pull-request`.
- Branch naming convention aligns with Shortcut: `sc-<story-id>-<slug>`.
- Always include PR checklist (tests run, docs updated) in the MCP call payload.

### Shortcut MCP (`tool-usage-rules/shortcut-mcp.md`)

| Task | Command | Notes |
|------|---------|-------|
| Identify user | `mcp__mcp-shortcut__get-current-user` | Returns ID + name |
| Search stories | `mcp__mcp-shortcut__search-stories` | Filter by `name`, `owner`, `state` |
| Fetch details | `mcp__mcp-shortcut__get-story` | Provide `storyPublicId` |
| Branch name | `mcp__mcp-shortcut__get-story-branch-name` | Returns `sc-1234-slug` |
| Update status | `mcp__mcp-shortcut__update-story` | Workflow IDs: Started `500000006`, Ready for Review `500000007`, Approved `500000008`, Completed `500000009` |
| Assign/unassign | `mcp__mcp-shortcut__assign-current-user-as-owner` / `unassign-…` | Use before and after work |
| Comment | `mcp__mcp-shortcut__create-story-comment` | Include SAEF artifact links |
| Add external link | `mcp__mcp-shortcut__add-external-link-to-story` | Attach PR URLs |

### Playwright MCP (`tool-usage-rules/playwright-mcp.md`)

- Use staging environment URLs; prompt human for MFA/credentials, then continue automated flows.
- Capture screenshots at ≥1200px width, PNG format.
- Store raw captures under `.playwright-mcp/screenshots/original`; annotated versions live in SAEF `outputs/<slug>/docs/images/`.

## 6. Development & Deployment SOPs

- **Branch creation** (`.agents/development/branch-creation.md`):
  ```bash
  git checkout dev
  git pull origin dev
  git checkout -b sc-<story-id>-<slug>
  ```
- **PR process** (`.agents/development/PR-process.md`):
  - Run `npx gulp dev` locally and confirm no lint/build errors.
  - Include testing evidence plus screenshots in PR body.
  - Request review from Documentation + Platform teams.
- **Status tracking** (`.agents/project-management/status-tracking.md`):
  - Update Shortcut states as work moves across refine → planning → implementation → docs → done.
  - Attach doc paths (`source/pages/.../docs.en.md`) and release artifacts to the story before completion.

## 7. Data Update Workflows

- **API Reference**: `npx gulp api` fetches YAML from `soracom-api`; ensure PAT in `~/.npmrc`. Generated artifacts saved to `source/assets/{yaml,json}/`.
- **Carrier Coverage**: `npx gulp carriers` downloads CSVs, applies overrides from `source/data/coverage/overrides.yaml`.
- **Search Index**: `npx gulp index` regenerates Algolia indexes (`stg_developers_search`, `prod_developers_search`). Keep API keys in env vars.

## 8. QA Checklist

- [ ] Local dev server (`npx gulp dev`) renders page and navigation correctly.
- [ ] Static build (`npx gulp build_batch`) completes with no warnings.
- [ ] Screenshots/styling validated in both light/dark themes.
- [ ] Link checker (`tools/check-404.sh`) passes for modified paths.
- [ ] Accessibility: heading hierarchy, alt text, tab order, color contrast.
- [ ] Release plan documented in Shortcut comment + `outputs/<slug>/quality-checklist.md`.

## 9. Directory Map for SOPs

Use this table to locate additional guidance without browsing the external repo:

| Category | Key Files | Purpose |
|----------|-----------|---------|
| `content-management/` | `adding-new-category.md`, `cross-linking.md`, `creating-guides.md` | Structure content, add nav entries, link correctly |
| `data-updates/` | `api-reference.md`, `coverage-data.md` | Refresh machine-generated assets |
| `development/` | `branch-creation.md`, `PR-process.md` | Git + review workflow |
| `project-management/` | `status-tracking.md`, `ticket-triage.md` | Shortcut workflow + triage |
| `tool-usage-rules/` | `github-mcp.md`, `playwright-mcp.md`, `shortcut-mcp.md` | MCP command catalogs |
| `dev-ops-rules/`, `theme-development-rules/`, `integration-rules/` | Build/deploy troubleshooting, AWS/Algolia integration, Blackhole debugging |

Keep this file updated whenever the upstream SOPs change so SAEF remains authoritative.

