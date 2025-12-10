# Dev Platform Access Notes

This document replaces the legacy `.archive/.context/*` references for development-environment operations.

## Credentials & Passwords
- Store shared credentials (e.g., “Development Environment”) in 1Password under the Soracom vault.
- Coordinate with the Platform/DevOps team if access needs to be provisioned or rotated.

## Adding Stats Files on Dev
1. Generate the stats bundle using the tooling described in the repository’s `CLAUDE.md` (usually `make stats` or `npm run stats`).
2. Upload the file to the designated S3 bucket or dev server via SCP (see repo instructions).
3. Notify the owning team in Slack (`#platform-devops`) once the file is updated.

## Checkpoint Usage
1. Launch Checkpoint from the corporate VPN portal.
2. Select the **dev** profile, authenticate with MFA, and wait for the tunnel to establish.
3. Verify access by hitting the dev endpoint (`curl https://<service>-dev.soracom.io/health`).

## Rundeck Access
1. Navigate to the internal Rundeck URL (listed in the Platform runbook).
2. Log in with your corporate SSO credentials.
3. Choose the project matching your service (billing, auth-manager, etc.) and execute the predefined jobs.

If any of these steps change, update this document and notify the Platform/DevOps team so the canonical instructions remain outside `.archive/`.


