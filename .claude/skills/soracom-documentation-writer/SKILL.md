---
name: soracom-documentation-writer
description: Generates Soracom documentation (JP user guide for website-users Hugo site + EN developer guide for website-developers Grav site). Use when creating user guides, API reference, FAQ content, or any customer-facing documentation.
---

# Soracom Documentation Writer Skill

Use this skill whenever `/saef:docs` or `/saef:release` needs to create production-ready documentation. All instructions come from the real repos:

- [references/website-users-doc-guidelines.md](references/website-users-doc-guidelines.md)
- [references/website-developers-agent-guidelines.md](references/website-developers-agent-guidelines.md)
- `.claude/commands/saef/docs.md` (SAEF guardrail)

## Target Repositories

| Repo | Stack | What we deliver |
|------|-------|-----------------|
| `website-users` | Hugo (ja-jp primary) | Drafts under `content/ja-jp/.../index.md` that obey textlint, PRH dictionaries, and SDS UI notation. |
| `website-developers` | Grav + Blackhole | Drafts under `source/pages/<section>/<page>/docs.en.md` with Grav front matter, callouts, and shortcode usage. |

During Phase 0 planning:
1. `git -C repos/website-users pull` and `git -C repos/website-developers pull` (optional if you need live repo context).
2. Read the local references under `references/website-users-doc-guidelines.md` and `references/website-developers-agent-guidelines.md`.
3. Identify existing pages to update vs. new directories/weights that must be created.

## Website-Users (JP Hugo) Rules

*Source: `references/website-users-doc-guidelines.md`*

- **Front matter template**
  ```yaml
  ---
  title: "30文字以内の具体的なタイトル"
  description: "120文字以内の説明"
  og_description: "SNS共有用 (任意)"
  weight: 100
  ---
  ```
- **Structure**
  ```markdown
  このページでは、<機能>の<操作>について説明します。
  {{<prerequisites>}}
  - 必要なアカウント・権限
  - 事前設定
  {{</prerequisites>}}

  ## 手順
  1. {{<menu "..." >}} をクリックします。
  2. ...

  ## よくある質問
  ## トラブルシューティング
  ## 関連情報
  ```
- Tone: 丁寧語 (“です・ます”) and reader-first. Avoid 推測, keep facts aligned with official documents.
- `{{<menu>}}` shortcode: use for UI labels inside body; use `[ラベル]` in callout headings. Use 全角 `＋` for buttons that start with “+”.
- Steps: Each numbered step ends with 「〜します」; break apart action vs result sentences; remove redundant prose.
- Lists/Tables: follow rules (no single-item bullets, tables require pipe formatting + optional `simple-responsive-tables: active: true`).
- Callouts: Use `!` / `[block=warning]` etc. Never prefix with "**Note:**".
- Textlint & PRH: note that maintainers will run `npm run lint` but highlight any terms that might violate dictionaries.

## Website-Developers (EN Grav) Rules

*Source: `references/website-developers-agent-guidelines.md`*

- **Front matter** (`docs.en.md`)
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
  ---
  ```
- Use Title Case headings, no parentheticals inside headers, Overview first → Prerequisites → Guided steps → Programmatic usage.
- Grav shortcodes: `[block=note]...[/block]`, `[block=api]`, `[ui-tabs]`, `[plan=01s/]`. Inline callouts use `! Text`.
- Formatting rules: single blank lines between sections, inline code for parameters, fenced code blocks with language tags.
- Tone: professional, concise, mostly active voice; limited “you/we” except in tutorials.
- Directory/URL mapping: `source/pages/02.docs/01.air/...` → `/docs/air/...`. Keep numeric prefixes aligned with nav ordering.
- Build workflow for authors: `npm ci`, `npx gulp dev`, ensure `grav/user` symlink to `source/`.

## Required Inputs

- `outputs/<slug>/prd.md`, `api-spec.yaml`, `test-plan.md`
- `outputs/<slug>/tasks.md`, `quality-checklist.md`
- Screenshot assets under `outputs/<slug>/docs/images/{original,annotated}`
- Diagrams in `outputs/<slug>/diagrams/`
- Outline/todos: `outputs/<slug>/docs/planning/*`

## Workflow

1. **Planning**
   - Run `.claude/skills/saef-ops/scripts/check-context.sh --stage docs --slug <slug>`
   - Review outline, todos, existing website pages, and decide on update vs net-new.
   - Re-read `docs/references/saef-principles.md` (in docs folder, not skill refs) so tone, quality expectations, and release obligations stay consistent.
2. **Assets**
   - Organize screenshots via `.claude/skills/saef-ops/scripts/generate-screenshots.sh --slug <slug> --backup`
   - Annotate with `.claude/skills/saef-ops/scripts/annotate_screenshot.py`
   - Generate diagrams (Mermaid/PlantUML) as needed and export PNG/SVG for repo ingestion.
3. **Drafting**
   - Create `outputs/<slug>/docs/docs-ja.md`, `docs-en.md` (plus optional `api-reference.md`, `faq.md`) mirroring the repo-specific structures above.
   - Embed images with relative paths (`![説明](./images/annotated/01.png)`), cite diagrams, and cross-link to PRD/API/test artifacts.
   - Capture repo insertion paths (e.g., `website-users/content/ja-jp/docs/gate/device-to-device/index.md`, `website-developers/source/pages/02.docs/01.air/.../docs.en.md`).
4. **Handoff Notes**
   - Document branch naming and commands authors must run: `npm run serve`, `npm run build`, `npx gulp build`, `npm run lint`.
   - Mention reviewers (JP TW team vs Dev Docs team) and any textlint exceptions to watch for.
5. **Quality Gates**
   - Update `outputs/<slug>/quality-checklist.md` (Documentation section) once tone, assets, and bilingual coverage are validated.

## Checklist

- [ ] Website-users rules applied (`{{<menu>}}`, 丁寧語, front matter, textlint considerations)
- [ ] Website-developers rules applied (Grav front matter, shortcodes, single-blank-line policy)
- [ ] Screenshots/diagrams embedded with consistent numbering
- [ ] Output files stored under `outputs/<slug>/docs/` and mapped to target repo paths
- [ ] Handoff instructions include commands + reviewer expectations
- [ ] `quality-checklist.md` documentation gate updated

