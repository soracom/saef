# Backend Continuous Deployment System

This document replaces the legacy `.archive/.context/Backend Team Continuous Deployment System` reference. Use it when planning or executing backend releases.

## Environments & Flow
1. **dev** – feature branches merge here; automated tests must pass.
2. **release PR (dev → main)** – created via `./backend-shared/release-scripts/create_release_pr.sh`.
3. **Nebula release** – run one of:
   ```bash
   ./backend-shared/release-scripts/release.sh          # Minor (default)
   ./backend-shared/release-scripts/release_patch.sh   # Patch
   ./backend-shared/release-scripts/release_major.sh   # Major
   ```
4. **Deployment** – GitHub Actions posts status in `#dev-backend-github`; monitor until healthy.

## Responsibilities
- Confirm `outputs/<slug>/quality-checklist.md` is complete before promoting.
- Ensure API gateway routes (`soracom-api-gateway/src/etc/routes.*.yaml`) are updated when endpoints move.
- Keep release notes (`outputs/<slug>/release/`) in sync with actual go-live time (JST).

## Monitoring & Rollback
- Watch service dashboards/alerts immediately after cutover.
- If issues arise, roll back via Nebula (`release_patch.sh` with prior tag) or redeploy previous container image.
- Document outcome in Shortcut + changelog if customer-visible.

## Related Skills/Docs
- `soracom-release-lifecycle` – operational checklist for release scripts and notifications.
- `soracom-backend-guidelines` – coding/testing standards required before release.
- `.claude/commands/saef/references/deployment-workflow.md` – detailed deployment runbook.

