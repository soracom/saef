# Soracom Changelog Guidelines (Extracted)

This file captures the Soracom changelog prompts so SAEF can generate release notes without consulting other repositories.

## 1. Front Matter Schema

```yaml
---
title: <Concise headline (language-specific)>
labels: Improvements | New | Fixes | Notice  # comma-separated if multiple
japanOnly: <true|false>
publishOn: YYYY-MM-DDThh:mm:ss+09:00  # JST
isDraft: <true|false>
---
```

- Remove any `source` field.
- No trailing spaces anywhere in the file (GFM requirement).
- Store drafts inside `outputs/<slug>/release/changelog-ja.md` and `changelog-en.md`.

## 2. Messaging Requirements

| Language | Audience | Tone Requirements | Closing |
|----------|----------|-------------------|---------|
| Japanese (`changelog-ja`) | Existing Soracom customers reading <https://changelog.soracom.io/ja/> | Highlight new learnings, keep messaging positive, describe practical use cases. | Always end with guidance such as `ご不明な点がございましたら、[SORACOM サポート](https://support.soracom.io/hc/ja/requests/new) までお問い合わせください。` |
| English (`changelog-en`) | Global customers | Same as above; focus on actionable description of the change plus how to adopt it. | Close with `Please contact [Soracom Support](https://support.soracom.io/hc/en-us/requests/new) if you have any questions.` |

## 3. Article Structure

Use the baseline below and adapt as needed (tables, images, etc.):

```markdown
# Summary
<2–3 sentences describing what changed and why it matters.>

## Details
- Bullet points covering each change, including metrics, carrier IDs, feature flags, etc.

## Availability / Timeline
- Effective date/time
- Regions, plans, or SKUs affected

## How to Use / Next Steps
1. Outline any required configuration changes.
2. Provide links to relevant documentation or prerequisite plans.

## Closing
<Positive wrap-up + support guidance as noted above.>
```

When the update revolves around coverage/plan changes, add a markdown table (`| 国 | キャリア | 状態 |`) with the before/after matrix.

## 4. Required Inputs

- PRD + implementation summary (`outputs/<slug>/prd.md`, repositories touched, test evidence).
- Documentation outputs: `outputs/<slug>/docs/docs-ja.md`, `docs-en.md`.
- Release checklist results from `outputs/<slug>/quality-checklist.md`.
- KPI deltas, carrier codes, API names, screenshots, or diagrams referenced in the change.

## 5. Workflow Checklist

- [ ] Validate release gate via `.claude/skills/saef-ops/scripts/check-context.sh --stage docs --slug <slug>`.
- [ ] Determine `japanOnly` flag (true if update is JP-exclusive).
- [ ] Draft JP entry first when `japanOnly: true`, otherwise create both JP and EN in parallel.
- [ ] Include direct links to supporting docs (users site, developers site, FAQ).
- [ ] Add support contact line in both languages.
- [ ] Save outputs under `outputs/<slug>/release/` and mention them in `/saef:release` summary.

