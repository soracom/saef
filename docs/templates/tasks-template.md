# Tasks: <Feature Name>

**Folder:** `outputs/<date>-<slug>/`
**Source Docs:** `business-statement.md`, `prd.md`, `api-spec.yaml`, `test-plan.md`

> Use checklist syntax so `/saef:implement` can mark progress automatically.
> Tag each task with `[BE]`, `[FE]`, `[DOC]`, etc., plus `[P]` if it is safe to run in parallel.

---

## Phase 0 – Foundation / 下準備
- [ ] [P][OPS] Create feature branch in affected repositories
- [ ] [P][OPS] Copy `tasks.md` into Shortcut / tracking tool
- [ ] [OPS] Confirm env vars, secrets, and feature flags

## Phase 1 – Backend / サーバーサイド
- [ ] [BE] Update OpenAPI spec (`api-spec.yaml`)
- [ ] [BE] Implement service logic / Lambda
- [ ] [BE] Add persistence changes (include migration path)
- [ ] [P][BE] Unit tests covering happy + edge flows
- [ ] [BE] Contract tests for Root + SAM users

## Phase 2 – Frontend / フロントエンド
- [ ] [FE] Implement SDS components (cite files)
- [ ] [FE] Wire API integration + error handling
- [ ] [P][FE] Localization (JP / EN copy)
- [ ] [FE] Playwright tests (Root + SAM)

## Phase 3 – Platform / 共通処理
- [ ] [OPS] Gateway / routing updates (if applicable)
- [ ] [SEC] Permission / auth updates
- [ ] [P][OPS] Monitoring & alerting adjustments

## Phase 4 – Documentation & Enablement / ドキュメント
- [ ] [DOC] Update `quality-checklist.md`
- [ ] [DOC] Confirm `outputs/<slug>/docs/planning/{outline.md,todos.md}` approved
- [ ] [P][DOC] Run `.claude/skills/saef-ops/scripts/generate-screenshots.sh --slug <slug>` and annotate screenshots
- [ ] [DOC] Generate diagrams (use `soracom-diagram-generator` skill) and save under `outputs/<slug>/diagrams/`
- [ ] [DOC] Author `outputs/<slug>/docs/docs-ja.md` (user guide + FAQ)
- [ ] [DOC] Author `outputs/<slug>/docs/docs-en.md` (developer guide)
- [ ] [DOC] Produce API reference / FAQ supplements when required
- [ ] [DOC] Update release notes or runbook references if needed

## Phase 5 – Validation / 検証
- [ ] [QA] Execute `test-plan.md` scenarios
- [ ] [QA] Record evidence links / screenshots
- [ ] [QA] Final HITL review and sign-off

---

### Dependencies / 依存関係
- Phase 1 must complete before Phase 2 starts unless flagged `[P]`.
- Document blockers inline: `Blocked by <task id>`.

### Hand-off Notes / 共有事項
- Mention required reviewers (e.g., ogu, makoto, felix)
- Include rollout or feature-flag instructions if applicable.

