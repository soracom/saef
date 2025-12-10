# Local Development Setup

Guide for running and testing SORACOM backend components locally.

## Overview

Local development allows you to:
- Run API servers on your machine (e.g., billing, auth-manager)
- Test against dev environment without deploying
- Debug with breakpoints
- Iterate quickly without CI/CD delays

**Prefer writing tests first**, but use local servers when you need to:
- Test with curl or Postman
- Try different parameters interactively
- Validate integration with other services

## Running API Server Locally

### Step 1: Start DevServerMain

Most backend components have a `DevServerMain` class for local development:

**Examples:**
- `auth-manager`: `auth-manager-local/src/main/java/vconnec/auth/DevServerMain.java`
- `billing`: `billing-local/src/main/java/vconnec/billing/DevServerMain.java`

**Run from IDE or command line:**

```bash
# Set coverage type (jp or g)
export SORACOM_COVERAGE=jp

# Run DevServerMain
./gradlew :billing-local:run
# or from IDE: Run DevServerMain.java

# Note the port number from startup logs:
# Example: Server started on port 8777
```

### Step 2: Authenticate Against Dev Environment

Get API credentials from dev console:

**Dev console URLs:**
- JP: https://dev.console.soracom.io
- Global: https://g-dev.console.soracom.io

```bash
# Authenticate and get credentials
curl -X POST "https://jp-dev-active.api.soracom.io/v1/auth" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "your-email@example.com",
    "password": "your-password"
  }'

# Response includes:
# - apiKey: Use as X-Soracom-API-Key header
# - token: Use as X-Soracom-Token header
# - operatorId: Your operator ID
```

### Step 3: Call Local API

```bash
# Example: Call local billing API
curl "http://localhost:8777/v1/bills?operator_id=OP0059150966" \
  -H "X-Soracom-API-Key: your-api-key" \
  -H "X-Soracom-Token: your-token"
```

**Important notes:**
- User doesn't exist locally by default - add data to DynamoDB if needed
- Local server connects to dev environment resources (DynamoDB, S3, etc.)

## Testing Against Internal APIs

When testing components locally that need to call other services:

### Internal API Endpoints

**JP Coverage:**
- auth-manager: `http://auth-manager-staging.soracom.io`
- billing: `http://billing-staging.dyn.soracom.io`
- session-manager: `http://session-manager-staging.dyn.soracom.com`
- device-manager: `http://device-manager-staging.dyn.soracom.io`

**Global Coverage:**
- auth-manager: `http://auth-manager-g-staging.dyn.soracom.io`
- billing: `http://billing-g-staging.dyn.soracom.io`
- session-manager: `http://session-manager-g-staging.dyn.soracom.com`
- device-manager: `http://device-manager-g-staging.dyn.soracom.com`

### Example: Calling Session Manager Internally

```bash
# Query subscriber
curl "http://session-manager-staging.dyn.soracom.com/v1/subscribers/419499987654323"

# Query SIM with operator
curl "http://session-manager-staging.dyn.soracom.com/v1/sims/8942309499987654323?operator_id=OP0059150966"

# Query sessions
curl "http://session-manager-staging.dyn.soracom.com/v1/sims/8942309499987654323/events/sessions?operator_id=OP0059150966"
```

**Note:** Internal APIs require `@InternalAPI` annotation and may need VPC access (Checkpoint/Rundeck).

## Working with Local DynamoDB

View and edit local DynamoDB data during development.

### Install DynamoDB Admin

```bash
npm install -g dynamodb-admin
```

### Start DynamoDB Admin

```bash
#!/bin/bash
export DYNAMO_ENDPOINT=http://localhost:8000
node node_modules/dynamodb-admin/bin/dynamodb-admin.js
```

Access at: http://localhost:8001

**Features:**
- Browse tables
- Add/edit/delete items
- Run queries
- View table structure

## Test Accounts

Use these pre-configured test accounts in dev environment:

| Purpose | Email | OPID | Notes |
|---------|-------|------|-------|
| Large dataset | katayama+staging18@soracom.jp | OP0004104157 | 110k SIMs |
| Various bill items | kaz+sim@soracom.jp | OP0001877272 | Multiple billing scenarios |
| JP + Credit card | kaz+jp-stripe@soracom.jp | OP0005955171 | Standard JP user |
| US + Credit card | kaz+us-stripe@soracom.jp | OP0008787240 | Standard US user |
| JP + Bank transfer | kaz+jp-banktransfer@soracom.jp | OP0029987451 | Bank payment method |
| JP + Invoice | kaz+invoice@soracom.jp | OP0063938824 | Invoice payment method |
| JP + Trial | kaz+jp-trial@soracom.jp | OP0047513116 | Trial account |

**Password:** Retrieve from the Soracom 1Password vault (see `docs/references/dev-platform-access.md`).

**Creating additional accounts:**
- Use email+tags: `yourname+dev@soracom.jp`
- Test cards: Use [Stripe test cards](https://stripe.com/docs/testing#cards)
- VAT ID: `GB340867687` (Soracom-UK)

## Dev vs Prod Differences

Be aware of these key differences when testing locally:

### 1. Permissions
- **Dev**: More permissive (can delete roles, etc.)
- **Prod**: Restricted to prevent accidents
- **Impact**: Some operations work in dev but fail in prod

### 2. Cross-Account Access
- **Dev**: Single account (soracom-dev), cross-region only
- **Prod**: JP (tamasui) and Global (sng) separate accounts, cross-account + cross-region
- **Impact**: Dev code might miss cross-account auth issues

### 3. Stats Generation
- **Dev**: Cannot generate stats from real SIMs (no physical devices)
- **Prod**: Stats generated from actual network traffic
- **Workaround**: Manually add stats files to S3 for testing

See: `docs/references/dev-platform-access.md#adding-stats-files-on-dev`

## VPC Access (Advanced)

Some resources require VPC access:

**Access methods:**
1. **Rundeck server**: Run batch jobs, access VPC resources
2. **Checkpoint server**: SSH bastion for VPC access

**When needed:**
- Running batch processes (billing締め処理)
- Accessing internal databases directly
- Testing VPC-internal integrations

See: `docs/references/dev-platform-access.md#vpc-access-advanced` for Checkpoint/Rundeck usage

## Troubleshooting

**Problem**: "User not found" error
- **Solution**: Add operator/user data to local DynamoDB tables

**Problem**: "Connection refused" to internal API
- **Solution**: Use VPC access (Checkpoint/Rundeck) or test from dev environment

**Problem**: Stats data missing
- **Solution**: Manually add stats files to S3 (dev can't generate from SIMs)

**Problem**: DynamoDB table not found
- **Solution**: Ensure `SORACOM_COVERAGE` env var is set (jp or g)

**Problem**: Different behavior dev vs prod
- **Solution**: Check cross-account access patterns, permissions differences

## Best Practices

1. **Write tests first**: Only run locally when interactive testing is truly needed
2. **Use dev snapshots**: Publish `devSnapshot` for dependencies during development
3. **Clean up data**: Remove test data from DynamoDB after testing
4. **Check coverage**: Ensure `SORACOM_COVERAGE` matches your test scenario
5. **Test both users**: Validate Root and SAM user scenarios
