---
name: soracom-changelog-writer
description: Writes bilingual changelog entries for changelog.soracom.io following Soracom content guidelines. Use when creating release announcements, feature updates, or service changes that need JP/EN customer-facing copy.
---

# Soracom Changelog Writer Skill

Use this skill whenever `/saef:release` or `/saef:docs --type changelog` needs to produce copy for https://changelog.soracom.io/. The requirements below are mirrored inside [references/changelog-guidelines.md](references/changelog-guidelines.md), extracted from the Soracom content writer prompts.

## 1. Front Matter Schema

```yaml
---
title: <Concise headline (EN or JP)>
labels: Improvements | New | Fixes | Notice (comma-separated if multiple)
japanOnly: <true|false>
publishOn: YYYY-MM-DDThh:mm:ss+09:00  # JST
isDraft: <true|false>
---
```

- `source` must be omitted (per guidelines).
- No trailing spaces anywhere in the Markdown (GFM only).
- Files should live in `outputs/<slug>/release/changelog-ja.md` and `changelog-en.md` so they can be copied into the website repos.

| Field | What to enter |
|-------|---------------|
| `title` | Customer-facing headline in the target language. |
| `labels` | Changelog taxonomy (comma-separated) such as `Feature, Announcement`. |
| `japanOnly` | `true` if the change only affects JP customers; otherwise `false` and produce both EN/JA entries. |
| `publishOn` | Target publish timestamp in JST (`YYYY-MM-DDThh:mm:ss+09:00`). |
| `isDraft` | Keep `true` until copy is finalized and synchronized with the changelog repo. |

## 2. Tone & Messaging

Reference: [references/changelog-guidelines.md](references/changelog-guidelines.md).

| Language | Audience | Requirements |
|----------|----------|--------------|
| Japanese (`changelog-ja`) | Existing Soracom customers reading https://changelog.soracom.io/ja/ | Include brand-friendly, positive messaging. Ensure the reader learns something new. End with closing remarks that invite contact via `[SORACOM サポート](https://support.soracom.io/hc/ja/requests/new)`. |
| English (`changelog-en`) | Global customers | Same as above (new insight, positive framing, clear use cases) and closing remarks such as “Please contact [Soracom Support](https://support.soracom.io/hc/en-us/requests/new) if you have any questions.” |

## 3. Structure

Suggested baseline (expand as needed for table-heavy updates):

```markdown
# Summary
<2–3 sentences describing what changed and why it matters.>

## Details
- Key change 1 (with metrics, SKUs, carrier names, etc.)
- Key change 2

## Availability / Timeline
- Effective date/time
- Regions or services affected

## How to Use / Next Steps
1. Step-by-step if action is required, or link to docs (`[詳細はこちら](https://users.soracom.io/...)`).
2. Mention prerequisite plans / subscriptions.

## Closing
<Positive wrap-up + Soracom Support link per language requirements.>
```

When tables clarify coverage changes (see `messages_content-writer_plan01s_ldv_close_docomo`), use standard GFM tables with headers translated for the target language.

## 4. Inputs to Read

- SAEF artifacts: `outputs/<slug>/prd.md`, `api-spec.yaml`, `tasks.md`, `quality-checklist.md`
- Implementation summary from `/saef:implement` (repositories touched, release tags)
- Documentation links: `outputs/<slug>/docs/docs-ja.md`, `docs-en.md`
- Product metrics (coverage changes, carrier codes, etc.) from PRD or implementation notes

## 5. Workflow

1. Validate release gate:
   ```bash
   .claude/skills/saef-ops/scripts/check-context.sh --stage docs --slug <slug>
   ```
   Ensure `quality-checklist.md` doc + release sections are complete.
2. Determine if the update is Japan-only (`japanOnly: true`) or global.
3. Draft JP entry first (if Japan-only) so translations stay aligned with `website-users` tone.
4. Draft EN entry referencing developer wording from `website-developers`.
5. Store drafts under `outputs/<slug>/release/` and list them in the final summary so humans know where to copy them into the changelog repo.

## 6. Checklist

- [ ] Front matter filled without `source` field; timestamps in JST.
- [ ] Summary states what changed + why it matters.
- [ ] Details include concrete data (plans, carrier IDs, API names, screenshots where relevant).
- [ ] Closing paragraph contains Soracom Support link and positive tone (per extracted guidelines).
- [ ] No trailing spaces; valid GFM.
- [ ] Files saved to `outputs/<slug>/release/changelog-ja.md` / `changelog-en.md`.

