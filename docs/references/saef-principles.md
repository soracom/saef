# SAEF Principles & Guardrails

These are the standing rules every `/saef:*` command and skill should follow. Keep them in mind instead of rewriting per feature.

## 1. Quality & Consistency
- Every artifact lives under `outputs/<slug>/`; no stray files elsewhere.
- Apply `docs/templates/*` as scaffolds and keep them bilingual by default.
- Reference existing patterns before inventing new ones (`pattern-analysis.md`, `repo-analysis.md`, SDS evidence).

## 2. Documentation & Localization
- All user-facing docs (PRD, docs, changelog) are JP/EN pairs unless explicitly waived.
- Use SDS/UI rules (see `docs/references/website-users-doc-guidelines.md` and `.../website-developers-agent-guidelines.md`).
- Capture screenshots/diagrams per feature; annotate and store in the slug’s `docs/` tree.

## 3. Testing & Verification
- Map every requirement to tests (unit, contract, integration, Root/SAM E2E) in `test-plan.md`.
- Keep `quality-checklist.md` current; `release` gate will block if unchecked items remain.
- For releases, always produce `release/changelog-ja.md`, `changelog-en.md`, and `runbook.md`.

## 4. Operational Discipline
- Guardrail scripts (`init-feature.sh`, `check-context.sh`) are mandatory; don’t bypass them.
- Shortcut tickets must link to the slug artifacts and reflect the current stage.
- Nebula releases and deployment runbooks are documented, reversible, and announced via the prescribed channels.

> Update this file whenever the organization adds or changes a policy so all commands inherit it passively.

