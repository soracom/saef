# Website Users Documentation Guidelines (Extracted)

This file centralizes the website-users documentation rules so SAEF can operate without consulting other repositories.

## 1. Front Matter Template

```yaml
---
title: "30文字以内の具体的なタイトル"
description: "120文字以内のページ内容説明"
og_description: "SNS共有用の説明文（省略可）"
weight: 100  # セクション内の順序
---
```

For service landing pages add optional `category`, `icon`, `tags`, and `sections` fields following the same structure.

## 2. Recommended Page Skeleton

```markdown
このページでは、<機能>の<操作>について説明します。

{{<prerequisites>}}
- 必要なアカウント・権限
- 事前準備
{{</prerequisites>}}

## 手順
1. {{<menu "..." >}} をクリックします。
2. …

## よくある質問
## トラブルシューティング
## 関連情報
```

Guidance:
- Lead paragraph states purpose, benefit, and prerequisites (2–3 sentences).
- Use 丁寧語 (“です・ます”) throughout.
- Avoid推測; confirm product numbers and specifications.

## 3. UI Notation & Shortcodes

- Use `{{<menu "ボタン" "サブメニュー">}}` for UI labels inside body text.
- Warning/info block titles should use `[ボタン名]` instead of shortcodes.
- Buttons that start with “+” must use the full-width `＋` with no trailing space (例: `＋Webhook`).
- Use `{{<required>}}` for required input marks; `[tag=beta]`, `[block=warning]`, etc., remain available.

## 4. Step-Writing Rules

- Numbered steps end with 「〜します」 or 「〜してください」, never dictionary form.
- Separate actions from outcomes (operation vs “〜が表示されます”).
- Merge trivial steps; split a step if it contains more than two sentences.
- Remove redundant prose such as 「することも可能です」 → 「できます」.

## 5. Lists, Tables, and Callouts

- Do not create bullet lists with a single item.
- Bullet items must end with 「。」 even if short.
- Tables should include leading/trailing `|` and optional `simple-responsive-tables: active: true` in front matter for wide data.
- Use `[block=warning]`, `[block=note]`, or `!` callouts without prepending “**Note:**”; critical info belongs in body text, not callouts.

## 6. Structure & Headings

- Avoid redundant headings (e.g., do not repeat the page title as `## ...`).
- Headings describe intent (動詞形 for procedures, 名詞 for concepts).
- Maintain logical H2 → H3 → H4 hierarchy; no jumps.
- For glossary-style pages you may bold terms instead of using headings, but keep this exception scoped to glossaries.

## 7. Content Organization Patterns

- Separate technical specifications from sales/distribution details.
- Group complex comparisons into tables or categorized subsections.
- Use dedicated overview pages (e.g., `overview-plans`) for repeated detail; link out rather than duplicating content.
- Provide explicit checkpoints for prerequisites, environment configuration, and readiness before user stories.

## 8. Language & Tone

- Explain target audience and trade-offs explicitly (“対象者”, “指示”, “ただし…” pattern).
- Break down long conditional sentences; prefer multiple short sentences.
- Replace passive constructions with direct statements; use active voice describing user actions.

## 9. Examples of Required Formatting

**Hand-off Template for Steps:**
```markdown
1. {{<menu "保存">}} をクリックします。

    {{<alert "オプションが表示されない場合">}}
    Lagoon 3 の Alert rule では {{<menu "Soracom Query">}} をデフォルトで無効にしています。
    {{</alert>}}
```

**Table Template:**
```markdown
| 項目 | 説明 | 注釈 |
|------|------|------|
| 設定項目 | 詳細説明 | (*1) |
| 次の項目 | 別の説明 | (*2) |
```

## 10. Checklist Before Publishing

- [ ] Front matter filled with title/description/weight (plus optional taxonomy).
- [ ] 丁寧語, no slang or sentence-long parentheses.
- [ ] Steps follow numbering + 「〜します」 endings; result sentences separated.
- [ ] `{{<menu>}}`, callouts, tables, and tags follow the rules above.
- [ ] Screenshots placed under `static/images/...` with descriptive alt text.
- [ ] `npm run lint` (textlint + PRH) passes or known exceptions are documented.

