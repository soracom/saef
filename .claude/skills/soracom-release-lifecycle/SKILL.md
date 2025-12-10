---
name: soracom-release-lifecycle
description: Soracom’s release workflow covering Nebula-based versioning, dev→main promotion, deployment validation, and announcement steps. Use when preparing backend releases, promoting builds, or coordinating release notes.
---

# Soracom Release Lifecycle

Follow this skill whenever a backend component or API must be released to production.

## 1. Preconditions
- Feature branch merged into `dev`.
- `outputs/<slug>/quality-checklist.md` complete (tests, docs, rollout plan).
- Changelog drafts (`outputs/<slug>/release/`) ready if public announcement required.

## 2. Create Release PR (dev → main)
```bash
./backend-shared/release-scripts/create_release_pr.sh
```
- Pull latest `dev`, run script to open PR from `dev` to `main`.
- Review aggregated commits, ensure CI passes.
- Request review from backend leads (`#dev-backend-github` notification).

## 3. Run Release Script
Choose appropriate version bump:
```bash
# Minor (default)
./backend-shared/release-scripts/release.sh

# Patch
./backend-shared/release-scripts/release_patch.sh

# Major
./backend-shared/release-scripts/release_major.sh
```
What it does:
1. Checks out `main`, pulls latest.
2. Uses Nebula plugin to bump version/tag.
3. Publishes artifacts to GitHub Packages/S3.
4. Creates GitHub release notes.
5. Merges `main` back into `dev`.

## 4. Deployment Notifications
- Slack `#dev-backend-github` posts deploy button/status.
- Include rollout plan + monitoring instructions.
- Update API gateway routing (`soracom-api-gateway/src/etc/routes.*.yaml`) if needed.
- Cross-check expectations in `docs/references/saef-principles.md` (release discipline, rollback readiness, documentation links).

## 5. Post-Release
- Verify metrics/alarms.
- Ensure `/saef:release` changelog announcement matches final release timestamp (JST).
- Archive evidence (logs, metrics) in the feature folder if required.

## References
- `.claude/skills/soracom-backend-guidelines/references/release-process.md`
- `.claude/skills/soracom-backend-guidelines/references/backend-standards.md`

