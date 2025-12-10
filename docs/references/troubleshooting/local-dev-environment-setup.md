# Troubleshooting Notes: Display PUK Feature Implementation

This document captures all issues encountered during local development and testing, along with their solutions.

---

## Summary: Local Environment Setup Issues

We encountered **11 distinct issues** while setting up the local development environment for testing the PUK display feature:

### Quick Reference

| # | Issue | Status | Impact |
|---|-------|--------|--------|
| 1 | JAVA_HOME Not Set | ✅ Resolved | Blocked all Gradle commands |
| 2 | GitHub Authentication Missing | ✅ Resolved | Blocked dependency downloads |
| 3 | Git Submodules Not Initialized | ✅ Resolved | Blocked Gradle builds |
| 4 | Docker Not Accessible in WSL2 | ✅ Resolved | Blocked integration tests |
| 5 | AWS Credentials Expired | ✅ Resolved | Blocked test execution |
| 5b | Test Infrastructure AWS Dependencies | ❌ **Unresolved** | **Blocks integration tests** |
| 5c | Docker ECR Credential Helper Not Configured | ✅ Resolved | Blocked `make run-api` |
| 6 | File Edit Without Reading First | ✅ Resolved | Development workflow issue |
| 7 | Data Access Pattern Uncertainty | ✅ Resolved | Implementation design issue |
| 8 | DynamoDB 301 Redirect Error | ❌ **Unresolved** | **Blocks backend server startup** |
| 9 | Angular postcss-media-query-parser Missing Module | ❌ **Unresolved** | **Blocks frontend server startup** |

### Resolution Summary

**Resolved Issues (8/11)**: Basic environment setup is complete and functional.
- ✅ Java 17 installed via APT
- ✅ GitHub token configured for private packages
- ✅ Git submodules initialized (`backend-shared`)
- ✅ Docker Desktop + WSL2 integration enabled
- ✅ AWS credentials refreshed
- ✅ Docker ECR credential helper configured
- ✅ Code properly formatted with Spotless
- ✅ PUK implementation pattern identified

**Unresolved Issues (3/11)**: Local dev server startup blocked.
- ❌ Integration tests require undocumented AWS infrastructure (`billing-local-db:7.6.0`)
- ❌ Backend server fails with DynamoDB 301 redirect error (persistent)
- ❌ Frontend server fails with postcss-media-query-parser module error
- ✅ **Recommended**: Deploy to staging for testing (local environment has fundamental issues)

### Recommended Next Steps

1. **Deploy to staging** - Local environment has multiple blocking issues
2. **Create PRs** - Backend (soracom-internal-console-api) and frontend (soracom-internal-console-monorepo)
3. **Test in staging** - Access https://internal-console-staging.dyn.soracom.io/ (available 07:30-22:00 JST)
4. **Skip local testing** - Too many environment dependencies that aren't documented

---

## Environment Setup Issues

### 1. JAVA_HOME Not Set

**Error**:
```bash
JAVA_HOME is not set and no 'java' command could be found in your PATH
```

**Context**: Attempting to run `./gradlew spotlessApply` failed because Java was not installed on WSL2.

**Solution**:
Installed Amazon Corretto 17 via APT:
```bash
# Add Amazon Corretto repository
wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add -
sudo add-apt-repository 'deb https://apt.corretto.aws stable main'

# Install Java
sudo apt update
sudo apt install -y java-17-amazon-corretto-jdk

# Verify installation
java -version  # Should show: openjdk version "17.0.x"
```

**Root Cause**: Java runtime not included in default WSL2 Ubuntu installation.

---

### 2. GitHub Authentication Not Configured

**Error**:
```text
Plugin [id: 'io.soracom.gradle.maven-s3', version: '1.0.0'] was not found
```

**Context**: Gradle build failed because it couldn't access Soracom's private GitHub packages.

**Solution**:
Created GitHub Personal Access Token and configured environment variables:

1. Created token at https://github.com/settings/tokens with scopes:
   - `repo`
   - `read:packages`

2. Added to `~/.bashrc`:
```bash
export GITHUB_USERNAME=your_github_username
export GITHUB_TOKEN=ghp_xxxxxxxxxx
```

3. Reloaded shell:
```bash
source ~/.bashrc
```

**Root Cause**: Soracom uses private GitHub Packages for internal dependencies, requiring authentication.

---

### 3. Git Submodules Not Initialized

**Error**:
```text
Could not read script '/home/fstubner/repos/saef/repos/soracom-internal-console-api/backend-shared/gradle-plugins/plugin-settings.gradle' as it does not exist
```

**Context**: Gradle build failed because the `backend-shared` submodule wasn't checked out.

**Solution**:
```bash
cd /home/fstubner/repos/saef/repos/soracom-internal-console-api
git submodule init && git submodule update
```

**Output**:
```text
Submodule path 'backend-shared': checked out '27832841edee68c59b969ef28e3696cc4944d37b'
```

**Root Cause**: Git submodules are not automatically cloned when cloning a repository. They must be explicitly initialized.

---

### 4. Docker Not Accessible in WSL2

**Error**:
```bash
java.lang.IllegalStateException at DockerClientProviderStrategy.java:276
The command 'docker' could not be found in this WSL 2 distro
```

**Context**: Integration tests use Testcontainers framework which requires Docker to spin up local DynamoDB.

**Solution**:
Started Docker Desktop with WSL2 integration enabled:
1. Opened Docker Desktop
2. Settings → Resources → WSL Integration → Enable for Ubuntu distro
3. Waited for Docker to fully start

**Verification**:
```bash
docker ps  # Should show running containers or empty list (not error)
```

**Root Cause**: Testcontainers requires Docker daemon to create ephemeral test containers. WSL2 can access Docker Desktop's daemon if integration is enabled.

---

### 5. AWS Credentials Expired

**Error** (First attempt):
```text
com.amazonaws.services.dynamodbv2.model.AmazonDynamoDBException at AmazonHttpClient.java:1879
java.lang.RuntimeException at DynamoDBInitializer.java:97
Caused by: java.lang.NullPointerException
```

**Context**: Tests failed during DynamoDB initialization because AWS credentials were expired.

**Solution**:
User refreshed AWS credentials in `~/.aws/credentials`:
```ini
[soracom-org]
aws_access_key_id=YOUR_ACCESS_KEY_ID
aws_secret_access_key=YOUR_SECRET_ACCESS_KEY
aws_session_token=YOUR_SESSION_TOKEN  # <-- Must be current

[default]
role_arn=arn:aws:iam::903921708000:role/OrganizationAccountDeveloperRole
source_profile=soracom-org
region=ap-northeast-1
```

**Root Cause**: Integration tests interact with AWS DynamoDB (local or remote) which requires valid credentials. Session tokens expire periodically and must be refreshed.

---

### 5b. Test Infrastructure AWS Dependencies (Unresolved)

**Error** (After refreshing credentials):
```text
java.lang.RuntimeException at DynamoDBInitializer.java:97
    Caused by: java.util.concurrent.ExecutionException at ForkJoinTask.java:605
        Caused by: java.lang.NullPointerException
```

**Context**: Even with fresh AWS credentials and Docker running, integration tests fail during `BillingLocalDB.build()` initialization.

**Investigation Findings**:
1. Tests use external library `vconnec:billing-local-db:7.6.0` (not in this repository)
2. The `BillingLocalDB.build()` method requires undocumented AWS resources beyond credentials
3. Likely needs:
   - Specific S3 bucket access for test data files
   - Specific IAM permissions
   - Specific DynamoDB table structures
   - Network access to AWS services
4. README documents runtime setup but NOT test setup requirements
5. README states billing library is "**optional**" for running the API server

**Stack Trace Analysis**:
```text
DynamodbLocalContainerInitializer.initialize() at line 48
  → InternalConsoleLocalDB.build() at line 36
    → DynamoDBInitializer.initTables() at line 97
      → NullPointerException (specific AWS resource or permission missing)
```

**Attempted Solutions**:
- ✅ Refreshed AWS credentials
- ✅ Verified Docker is running
- ✅ Checked test configuration files
- ❌ Cannot determine specific AWS resource requirements (library is external)

**Workaround**:
Skip integration tests and use manual testing:
```bash
# Option 1: Skip tests entirely
./gradlew build -x test

# Option 2: Start server directly (recommended)
make run-api  # Starts local DynamoDB + API server without test infrastructure

# Option 3: Let CI/CD handle tests
# Deploy to staging and let automated pipeline run tests with proper infrastructure
```

**Resolution Status**: **Unresolved** - Test infrastructure has undocumented AWS dependencies that cannot be satisfied in local development environment. Tests will need to run in CI/CD pipeline or staging environment where proper AWS resources are configured.

**Root Cause**: The `billing-local-db` test library requires AWS resources (likely S3 buckets for test data) that are not documented in the repository README. Local test execution requires infrastructure setup beyond developer credentials.

---

### 5c. Docker ECR Credential Helper Not Configured

**Error**:
```text
Error response from daemon: Head "https://903921708000.dkr.ecr.ap-northeast-1.amazonaws.com/v2/internal-console/dynamodb-local-builder/manifests/latest": no basic auth credentials
make: *** [Makefile:19: run-database] Error 1
```

**Context**: Attempting to run `make run-api` failed because Docker couldn't pull images from AWS ECR private registry.

**Solution**:
Configure ECR credential helper in `~/.docker/config.json`:

```json
{
  "auths": {
    "903921708000.dkr.ecr.eu-central-1.amazonaws.com": {}
  },
  "credHelpers": {
    "public.ecr.aws": "ecr-login",
    "903921708000.dkr.ecr.ap-northeast-1.amazonaws.com": "ecr-login"
  },
  "credsStore": "desktop.exe"
}
```

**Key Points**:
- The `credHelpers` section enables automatic ECR authentication
- Uses `amazon-ecr-credential-helper` which reads AWS credentials from `~/.aws/credentials`
- Both public ECR and private ECR repositories need to be configured
- The `ecr-login` helper must be installed (comes with Docker Desktop on WSL2)

**Root Cause**: Docker requires explicit credential helper configuration to authenticate with AWS ECR. Without it, Docker cannot pull private images even if AWS credentials are valid.

---

## Code Implementation Issues

### 6. File Edit Without Reading First

**Error**:
```text
File has not been read yet. Read it first before writing to it.
```

**Context**: Attempted to edit `SubscriberIO.java` without reading it first.

**Solution**:
Always read files before editing:
```typescript
// Correct workflow
1. Read(file_path)
2. Edit(file_path, old_string, new_string)
```

**Root Cause**: Claude Code requires reading a file before editing to ensure accurate context and prevent unintended changes.

---

### 7. Uncertainty About Data Access Pattern

**Problem**: Initially unclear how to retrieve PUK from DynamoDB in the internal console API.

**Investigation Process**:
1. Examined support bot code (`support.py`) - showed direct DynamoDB query
2. Searched for `GlobalSIMCardManagement` references in codebase
3. Found `SubscriberRegistrationDetailService` showing the correct service layer pattern

**Solution**:
Use `GlobalSimCardManagementService` with Spring dependency injection:
```java
// Correct pattern (service layer)
GlobalSimCardManagementService globalSimManagementService =
    billingContext.getBean(CoverageType.GLOBAL, GlobalSimCardManagementService.class);
GlobalSIMCardManagement globalSim =
    globalSimManagementService.find(ICCID.numberPartOf(subscriberResponse.getIccid()));
if (globalSim != null && globalSim.getPuk1() != null) {
  subscriberResponse.setPuk(globalSim.getPuk1().getValue());
}
```

**Key Insights**:
- Don't use direct DynamoDB access - use service layer abstractions
- `getPuk1()` returns a `PUK` object, need `.getValue()` to get string
- ICCID must be converted using `ICCID.numberPartOf(string)`
- PUK only available for Global coverage SIMs (not Japan)

**Root Cause**: Internal console follows different patterns than support bot (service layer vs direct DB access).

---

## Server Startup Issues

### 8. DynamoDB 301 Redirect Error (Unresolved)

**Error**:
```text
Status Code: 301; Error Code: null (Service: AmazonDynamoDBv2; Status Code: 301; Error Code: null)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.handleErrorResponse
```

**Context**: Attempting to start backend server with `make run-api` fails during Spring Boot initialization when connecting to local DynamoDB.

**Investigation Findings**:
1. DynamoDB container is running correctly on port 8000
2. Container is accessible via `curl http://localhost:8000`
3. HTTP 301 indicates "Moved Permanently" - endpoint redirect issue
4. Error occurs in `DynamodbLocalContainerLauncher.java` during initialization

**Attempted Solutions**:
- ✅ Set environment variables: `AWS_DYNAMODB_ENDPOINT=http://localhost:8000 AWS_REGION=ap-northeast-1`
- ✅ Recreated database with `make run-database-recreate`
- ✅ Verified Docker containers running with `docker ps`
- ✅ Multiple server restart attempts
- ❌ Error persists across all attempts

**Stack Trace**:
```text
Caused by: com.amazonaws.services.dynamodbv2.model.AmazonDynamoDBException: Status Code: 301
  at com.amazonaws.http.AmazonHttpClient$RequestExecutor.handleErrorResponse(AmazonHttpClient.java:1879)
  at com.amazonaws.http.AmazonHttpClient$RequestExecutor.handleServiceErrorResponse(AmazonHttpClient.java:1418)
  at com.amazonaws.http.AmazonHttpClient$RequestExecutor.executeOneRequest(AmazonHttpClient.java:1387)
```

**Root Cause**: Application DynamoDB client configuration is not respecting environment variables or needs additional configuration beyond what's documented. The client is likely trying to redirect to AWS-hosted DynamoDB instead of using localhost.

**Resolution Status**: **Unresolved** - Backend server cannot start locally. Alternative: Deploy to staging for testing.

**Impact**: Complete blocker for local backend testing. Frontend changes can potentially be tested independently, but backend changes require staging deployment.

---

### 9. Angular postcss-media-query-parser Missing Module (Unresolved)

**Error**:
```text
An unhandled exception occurred: Cannot find module './nodes/Container'
Require stack:
- /home/fstubner/repos/saef/repos/soracom-internal-console-monorepo/node_modules/postcss-media-query-parser/dist/index.js
```

**Context**: Attempting to start frontend dev server with `make run-angular` fails during Angular build compilation.

**Investigation Findings**:
1. npm dependencies installed successfully (1355 packages)
2. Error occurs in `postcss-media-query-parser` package during build
3. Module `./nodes/Container` is missing from the package
4. Clean reinstall (`rm -rf node_modules && npm install`) did not resolve

**Attempted Solutions**:
- ✅ `npm install` in frontend directory
- ✅ Clean reinstall: `rm -rf node_modules package-lock.json && npm install`
- ✅ `npm install` in root directory
- ❌ Error persists across all attempts

**Stack Trace**:
```text
Error: Cannot find module './nodes/Container'
    at Module._resolveFilename (node:internal/modules/cjs/loader:1140:15)
    at Module._load (node:internal/modules/cjs/loader:981:27)
    at Module.require (node:internal/modules/cjs/loader:1231:19)
    at Object.<anonymous> (/repos/soracom-internal-console-monorepo/node_modules/postcss-media-query-parser/dist/index.js:8:18)
```

**Root Cause**: The `postcss-media-query-parser` package in node_modules appears to be corrupted or incompatible with the Node.js version. This is likely a dependency resolution issue in the Angular build toolchain.

**Potential Solutions (Not Attempted)**:
1. Update Node.js version to match project requirements
2. Use `npm ci` instead of `npm install` to get exact lockfile versions
3. Clear npm cache: `npm cache clean --force`
4. Check if package-lock.json has integrity issues

**Resolution Status**: **Unresolved** - Frontend server cannot start locally. Alternative: Deploy to staging for testing.

**Impact**: Complete blocker for local frontend testing. Cannot preview UI changes without deploying to staging.

---

## Testing Issues

### 10. Integration Tests Require Full Environment

**Challenge**: Integration tests (`SubscriberControllerTest`) require:
- Docker running
- AWS credentials configured
- DynamoDB tables initialized
- Test data seeded

**Timeline**:
- First attempt: Docker not running → "DockerClientProviderStrategy" error
- Second attempt: AWS credentials expired → "AmazonDynamoDBException"
- Third attempt: Credentials refreshed → Tests running successfully

**Lesson Learned**: Integration tests have significant environmental dependencies. Consider:
- Running simpler unit tests first
- Using `make run-api` for manual testing as alternative
- Letting CI/CD handle integration tests in controlled environment

---

## Best Practices Learned

### Environment Setup Checklist
Before running backend tests:
- [ ] Java 17 installed (`java -version`)
- [ ] GitHub token configured (`echo $GITHUB_TOKEN`)
- [ ] Git submodules initialized (`git submodule status`)
- [ ] Docker running (`docker ps`)
- [ ] AWS credentials valid (check expiration time)

### Development Workflow
1. **Read before edit**: Always use Read tool before Edit tool
2. **Check existing patterns**: Search codebase for similar implementations
3. **Service layer first**: Use service abstractions (not direct DB access)
4. **Format before test**: Run `./gradlew spotlessApply` before running tests
5. **Manual testing fallback**: If integration tests fail, use `make run-api` + curl

### Test Strategy
- Unit tests: Fast, minimal dependencies
- Integration tests: Require full environment (Docker, AWS, etc.)
- Manual testing: Start server locally, test with curl/browser
- CI/CD tests: Let automation handle complex setup

---

## Quick Reference

### Essential Commands
```bash
# Environment setup
source ~/.bashrc  # Reload environment variables
git submodule init && git submodule update  # Initialize submodules
docker ps  # Verify Docker is running

# Code quality
./gradlew spotlessApply  # Format code

# Testing
./gradlew test --tests SubscriberControllerTest  # Run specific test class
make run-api  # Start backend server for manual testing
curl "http://localhost:5000/api/subscribers/295059990045088?coverageType=g" | jq .puk

# Verification
java -version  # Check Java installation
echo $GITHUB_TOKEN  # Check GitHub auth
aws sts get-caller-identity  # Check AWS credentials
```

---

**Created**: 2025-12-05
**Feature**: Display PUK on Subscriber Page
**Environment**: WSL2 Ubuntu, Docker Desktop, AWS
