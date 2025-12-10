---
name: soracom-frontend-guidelines
description: Soracom frontend/UI guidelines covering SDS component usage, accessibility, localization, and website repo conventions (website-users / website-developers). Use when designing console flows, writing documentation UI snippets, or updating frontend repos.
---

# Soracom Frontend Guidelines

Apply these rules whenever you build or update Soracom UIs (console, internal tools, docs). They combine SDS requirements and repo-specific SOPs.

## 1. SDS Fundamentals
- **Components:** Use SDS primitives (Table, Card, DescriptionList, Drawer, Form, ValidationMessage, Tag, etc.)—no bespoke CSS grids.
- **Spacing:** 8px base grid (4px for dense layouts). Cards stack with 24px margins/padding.
- **Tables:** Full width, toolbar actions, pagination via `Pagination`/`FilterChips`.
- **Role-based UI:** Hide/disable Root-only actions for SAM users and surface tooltips/banners explaining restrictions.

### Accessibility & i18n
- All strings via i18n keys (JP/EN). Do not hardcode bilingual copy.
- Maintain focus order, semantic headings, and `aria-describedby` for inputs.
- Respect SDS color tokens for contrast; use `TextOverflow` utilities for truncation.

## 2. Documentation-Site Conventions
Refer to `.claude/skills/soracom-documentation-writer/references/website-users-doc-guidelines.md` (JP Hugo) and `.claude/skills/soracom-documentation-writer/references/website-developers-agent-guidelines.md` (EN Grav):
- Follow prescribed front matter templates (`title`, `description`, `weight`, taxonomy).
- Use Hugo/Grav shortcodes: `{{<menu>}}`, `[block=note]`, `[ui-tabs]`, etc.
- Maintain JP step style (`〜します`) and EN imperative headings.
- Store screenshots in the approved directories (`static/images/...`, `outputs/<slug>/docs/images/annotated`).

## 3. Component Selection Cheatsheet
| Use case | Recommended SDS combo | Notes |
| --- | --- | --- |
| Entity list + filters | `Table` + `FilterChips` + `Pagination` | Avoid custom filter sidebars. |
| Detail summary | `Card` + `DescriptionList` | Group fields by domain. |
| Inline edit | `Drawer` + `Form` + `ValidationMessage` | Confirm destructive actions via `ConfirmModal`. |
| Status indicator | `Tag (status-*)` | Use SDS tokens for colors. |
| Bulk actions | `Table` + `SelectionToolbar` + `InlineAlert` | Always provide confirmation step. |
| **Data Visualization** | **Recharts** (React) / **Chart.js** (Angular) | Use SDS color tokens for series. Do not roll custom D3 unless approved. |

## 4. Process
1. Read PRD + UX evidence to identify actors and flows.
2. Map each interaction to SDS components and validated patterns.
3. Cite examples from existing repos (user-console, internal console, docs).
4. Flag anti-patterns (inline styles, custom spacing, duplicated components).
5. Record TODOs if SDS lacks a needed component—log gaps for the design team.

## 5. Failure Handling
- Propose nearest SDS alternative before inventing new UI.
- Escalate bespoke visual requirements to design.
- Ensure bilingual copy reviewers (makoto/felix) sign off when strings change.

## References
- `.claude/skills/soracom-documentation-writer/references/website-users-doc-guidelines.md`
- `.claude/skills/soracom-documentation-writer/references/website-developers-agent-guidelines.md`
- SDS component catalog (`soracom/soracom-design-system`)
