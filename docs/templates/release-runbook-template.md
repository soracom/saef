# Release Runbook Template

## Scope
- Feature: `<feature name>`
- Slug: `outputs/<slug>/`
- Components: `<repos / services>`

## Pre-flight Checklist
- [ ] `outputs/<slug>/quality-checklist.md` signed
- [ ] Docs published / PR links recorded
- [ ] Monitoring dashboards prepared
- [ ] Rollback strategy documented below

## Deployment Steps
1. **Create release PR**
   ```bash
   ./backend-shared/release-scripts/create_release_pr.sh
   ```
2. **Run Nebula release**
   ```bash
   ./backend-shared/release-scripts/release.sh        # minor
   ./backend-shared/release-scripts/release_patch.sh  # patch
   ```
3. **Update API gateway / configs (if needed)**
   - `soracom-api-gateway/src/etc/routes.*.yaml`
4. **Notify #dev-backend-github** with changelog link.

## Verification
- Smoke tests / health checks
- CloudWatch metrics (error rate, latency)
- Logs (keyword searches)
- Feature flag toggles (if used)

## Rollback Plan
- Command / script to roll back (`release_patch.sh` with previous tag).
- Steps to revert configs / feature flags.
- Criteria for initiating rollback.

## Communication
- Slack channels / email lists
- Customer-facing message (if any)
- On-call owner + backup

## Post-release Tasks
- Update Shortcut story
- Archive metrics / evidence in `outputs/<slug>/release/status.md`
- Schedule retrospective if issues found

