# Deployment Workflow

SORACOM's continuous deployment (CD) system for backend services.

## Overview

Backend services use an automated CD pipeline triggered by GitHub commits, with Slack-based deployment controls.

**Current target applications:**
- auth-manager
- a2p-server
- (More being added)

## Architecture

```
GitHub push → CodeBuild → ECR → Slack notification →
Deploy button → CodeDeploy → Test env → Cutover → Production
                    ↓
                Rollback (at any stage)
```

### Key Components

**Repositories:**
- [backend-ci](https://github.com/soracom/backend-ci): Lambda functions to run CodeDeploy
- [backend-deploy](https://github.com/soracom/backend-deploy): Web API for Slack integration
- [backend-deploy-hooks](https://github.com/soracom/backend-deploy-hooks): CodeDeploy lifecycle hooks

**Slack channel:** [#dev-backend-github](https://soracom.slack.com/archives/C016KMG2BCH)

## Deployment Policy

**Backend team conventions:**
- **Dev branch → Dev environment** (for testing)
- **Master branch → Prod environment** (for production)
- **Branch to prod** (emergency only - test in dev first if possible)

## Deployment Flow

### 1. Build Notification

After pushing to GitHub, CodeBuild runs and Slack shows:

```
✅ Build completed: auth-manager (branch: dev)
Commit: abc1234 - "Add new feature"

[Deploy to Dev] [Deploy to Prod]
```

**Actions:**
- Review the commit and build status
- Decide which environment to deploy to
- Click appropriate button

### 2. Deploy Confirmation

After clicking a deploy button:

```
🚀 Deploy auth-manager to Dev?
Branch: dev
Commit: abc1234

This will deploy to ECS test environment first.

[Confirm Deploy] [Cancel]
```

**Actions:**
- Verify branch and commit are correct
- Click "Confirm Deploy"

### 3. Deployment Started

```
⏳ Deploying auth-manager to Dev...
Status: Starting CodeDeploy deployment

[Rollback] (available at any time)
```

**What happens:**
- CodeDeploy starts
- New ECS tasks created
- Health checks running

**Rollback option:**
- Available immediately
- Restores previous ECS task definition
- No downtime

### 4. Test Environment Ready

```
✅ Deployed to Test Environment
Status: Ready for validation

Test endpoint: https://auth-manager-test-staging.dyn.soracom.io

Next: Test the deployment, then cutover to production

[Cutover] [Rollback]
```

**Actions:**
1. **Test the deployment** using test endpoint
   - Validate functionality works
   - Check logs for errors
   - Verify integrations
2. **Wait for confirmation** from team if needed
3. **Click Cutover** when ready

**Traffic routing:**
- Test traffic → New deployment (ECS test tasks)
- Production traffic → Old deployment (unchanged)

### 5. Cutover Confirmation

```
⚠️ Final cutover to production?

This will route production traffic to the new deployment.
The previous deployment will be terminated.

[Confirm Cutover] [Rollback] [Cancel]
```

**CRITICAL DECISION:**
- This affects production users
- Previous deployment will be stopped
- Ensure testing is complete

**Actions:**
- Final verification
- Click "Confirm Cutover"

### 6. Deployment Complete

```
🎉 Deployment completed successfully!

auth-manager is now live in Dev environment.
Previous deployment has been terminated.

ECS task info: Stored in deploy-data table (soracom-dev, tokyo)
```

**Done!** The new version is now serving production traffic.

## Rollback Process

Available at any stage before final cutover.

### When to Rollback

- Tests fail in test environment
- Unexpected errors in logs
- Performance degradation
- Need to abort deployment

### How to Rollback

1. **Click [Rollback] button** (appears at every stage)
2. **Confirm rollback:**
   ```
   ⚠️ Rollback deployment?

   This will restore the previous version.

   [Confirm Rollback] [Cancel]
   ```
3. **Wait for completion:**
   ```
   ↩️ Rollback completed

   Previous version restored successfully.
   ```

**What rollback does:**
- Stops new ECS tasks
- Restores previous task definition
- Routes traffic back to old version
- No data loss

## ECS Task Information

Deployment data stored in DynamoDB:

**Table:** `deploy-data`
**Location:** soracom-dev account, Tokyo region

**Contains:**
- Task definition ARNs
- Deployment timestamps
- Rollback information
- Health check status

## Testing in Test Environment

When deployment reaches test environment:

### Access Test Endpoints

**Pattern:** `https://{service}-test-staging.dyn.soracom.io`

Examples:
- auth-manager: `https://auth-manager-test-staging.dyn.soracom.io`
- a2p-server: `https://a2p-server-test-staging.dyn.soracom.io`

### Test Checklist

- [ ] API responds (health check endpoint)
- [ ] Core functionality works
- [ ] No errors in CloudWatch logs
- [ ] Response times acceptable
- [ ] Integrations with other services work
- [ ] Database queries succeed

### Test Tools

```bash
# Health check
curl https://auth-manager-test-staging.dyn.soracom.io/health

# Example API call
curl "https://auth-manager-test-staging.dyn.soracom.io/v1/admin/operators/OP0059150966" \
  -H "X-Soracom-API-Key: your-key" \
  -H "X-Soracom-Token: your-token"
```

## Monitoring After Deployment

After cutover, monitor for 1 week:

**Metrics to watch:**
- Error rates (CloudWatch)
- Response times (CloudWatch)
- Request volume (CloudWatch)
- ECS task health (ECS console)

**Where to check:**
- CloudWatch Logs: `/aws/ecs/{service-name}`
- CloudWatch Metrics: ECS service metrics
- Slack alerts: Error notifications in relevant channels

**If issues arise:**
- Can still rollback manually via ECS console
- Create hotfix branch if needed
- Coordinate with team in Slack

## Troubleshooting

**Problem**: Deploy button doesn't appear
- **Solution**: Check CodeBuild completed successfully, refresh Slack

**Problem**: Deployment stuck at "Starting"
- **Solution**: Check CodeDeploy console, verify ECS task launching

**Problem**: Test endpoint returns 502/503
- **Solution**: Wait for ECS tasks to fully start (health checks), check logs

**Problem**: Can't access test endpoint
- **Solution**: Ensure VPC access (Checkpoint) or use internal endpoint

**Problem**: Cutover button greyed out
- **Solution**: Wait for test environment health checks to pass

## Best Practices

1. **Always test in dev first**: Even for hotfixes when possible
2. **Review commit carefully**: Before clicking deploy
3. **Test thoroughly**: Don't rush to cutover
4. **Monitor after cutover**: Watch for errors in production
5. **Coordinate with team**: For high-risk deployments
6. **Have rollback plan**: Know how to revert if needed
7. **Use feature flags**: For gradual rollout of risky features

## Related Documentation

- Backend CD System: `docs/references/backend-cd-system.md`
- Release Process: `.claude/skills/soracom-backend-guidelines/references/release-process.md`
- Local Testing: `.claude/skills/soracom-repository-catalog/references/local-dev-setup.md`
