# Quality Checklist / 品質チェックリスト

Use this file per feature to ensure SDS, bilingual, API, and repo standards are satisfied before `/saef:implement` completes.

## 1. Documentation & Artifacts
- [ ] Business statement, PRD, UX Evidence, Pattern Analysis up to date
- [ ] Test plan reflects Root + SAM scenarios
- [ ] Tasks.md matches PRD scope

## 2. SDS & UX
- [ ] SDS components confirmed (link to code refs)
- [ ] JP/EN copy reviewed by bilingual owner (makoto/felix)
- [ ] Accessibility notes captured (keyboard, screen reader)

## 3. API & Backend Standards
- [ ] OpenAPI spec validated (`make && make internal`)
- [ ] Error codes follow AAA0000 format
- [ ] Auth handled via auth-lib / heimdall-v2
- [ ] Spotless / formatting applied

## 4. Frontend & Testing
- [ ] Playwright tests cover Root + SAM flows
- [ ] Localization toggles verified in UI
- [ ] Feature flag / rollout strategy defined

## 5. Repository & Ops
- [ ] `docs/repositories.yaml` entry confirmed for each repo
- [ ] Routing / gateway config updated (if applicable)
- [ ] Monitoring / alerting plan updated

## 6. HITL Sign-off
- [ ] Product / SAT review complete
- [ ] QA evidence attached (screenshots, logs)
- [ ] Release checklist ready for `/saef:docs` phase

