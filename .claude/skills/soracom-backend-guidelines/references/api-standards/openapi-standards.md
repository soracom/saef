# Soracom OpenAPI Standards - Detailed Reference

## Naming Conventions (CRITICAL)

### API Paths
- **Format**: `snake_case`
- **Examples**:
  - ✅ `/sims/{sim_id}/delete_session`
  - ✅ `/operators/{operator_id}/subscribers`
  - ❌ `/sims/{simId}/deleteSession` (camelCase - WRONG)

### Tags (Service Names)
- **Format**: `PascalCase`
- **Purpose**: Permissions, grouping
- **Examples**:
  - ✅ `CellLocation`
  - ✅ `EventHandler`
  - ❌ `cell_location` (snake_case - WRONG)

### Operation IDs
- **Format**: `camelCase`
- **Must be**: Unique across ALL APIs
- **Examples**:
  - ✅ `getCellLocation`
  - ✅ `listSubscribers`
  - ❌ `get_cell_location` (snake_case - WRONG)

### Path Variables
- **Format**: `snake_case` with braces
- **Examples**:
  - ✅ `{sim_id}`
  - ✅ `{operator_id}`
  - ❌ `{simId}` (camelCase - WRONG)

## Error Code Format

### AAA0000 Pattern
- **Format**: 3 uppercase letters + 4 digits
- **Examples**: `COM0001`, `AGW0008`, `AUM0042`

### Error Response Schema
```yaml
ErrorResponse:
  type: object
  required:
    - code
    - message
  properties:
    code:
      type: string
      example: "COM0001"
    message:
      type: string
      example: "Invalid parameter: simId"
```

### Security Rule
- **NEVER** include user input in error messages
- **Why**: Prevents injection vulnerabilities
- **Do**: Log full details, return sanitized messages

### Component Prefixes
- `AGW` - api-gateway
- `AUM` - auth-manager
- `BIL` - billing
- `COM` - common errors
- `SIM` - SIM-specific
- `SUB` - Subscriber-specific

See `context/SORACOM API Error Code Prefixes.md` for full list.

## HTTP Status Codes

### Document These
- `200` - Request succeeded with response body
- `201` - Request succeeded, new resource created
- `204` - Request succeeded without response body
- `400` - Bad request (validation failed)
- `401` - Unauthorized (missing/invalid auth)
- `403` - Forbidden (no permission)
- `404` - Not found OR not willing to disclose

### NEVER Document
- `5xx` - Internal server errors
- **Why**: These indicate bugs, not API behavior

### 404 Special Case
- Means "not found OR not willing to disclose existence"
- **Don't assume** resource doesn't exist
- **Used for**: Security (hide existence of resources user can't access)

## Data Types

### Timestamps
- **Format**: Unix epoch integer
- **Unit**: Milliseconds or seconds (check API context)
- **NOT**: ISO 8601 strings
- **Example**:
  ```yaml
  createdAt:
    type: integer
    format: int64
    example: 1637164800000
  ```

### Booleans
- **Convention**: (Pending team discussion)
- **Current**: Mixed usage across APIs

## Authentication Headers

### Required from Client
- `X-Soracom-Api-Key`: Session-unique identifier
- `X-Soracom-Token`: JWT with authorization

### Injected by Gateway (when `validatePermission: true`)
- `X-Soracom-OperatorId`: Always present
- `X-Soracom-SAM-UserName`: Present for SAM users only

## Repository Structure

### Base Definitions (Language-Independent)
- **Path**: `apidef/prod/base/` or `apidef/internal/base/`
- **Contains**: Paths, methods, parameters, schemas
- **Does NOT contain**: Descriptions, summaries (save for i18n)

### Bilingual Text
- **Path**: `apidef/prod/i18n/en/` and `apidef/prod/i18n/ja/`
- **Contains**: Descriptions, summaries ONLY
- **Must have**: Both JP and EN for every API

### File Organization
- **Fragment** by API group (NOT monolithic)
- **Examples**: `sim.yaml`, `subscriber.yaml`, `event-handler.yaml`

### Hiding Unreleased APIs
- **Flag**: `x-soracom-hidden: true`
- **Where**: Add to operation or path
- **Purpose**: Exclude from public docs until ready

## Validation Commands

### Public Build
```bash
make
```
- Excludes APIs with `x-soracom-hidden: true`
- Generates public API reference

### Internal Build
```bash
make internal
```
- Includes ALL APIs
- Used for internal docs/testing

### Pre-push Checklist
- [ ] Run `make` - no errors
- [ ] Run `make internal` - no errors
- [ ] Check naming conventions
- [ ] Verify error codes use AAA0000 format

## Two-Stage PR Process

### Stage 1: Functional Definition
**Goal**: Agree on API structure

**Steps**:
1. Create branch in `soracom-api`
2. Update `apidef/prod/base/<api-group>.yaml`
   - Add paths, methods, parameters, schemas
   - **Skip** descriptions/summaries (add in Stage 2)
3. Add `x-soracom-hidden: true` (if not ready for public)
4. Validate: `make && make internal`
5. Create Draft PR
   - Reviewers: **stakeholders + ogu**
   - Purpose: Agree on API design
6. Iterate based on feedback
7. Merge after approval

**Reviewers**:
- Stakeholders (frontend devs, product team)
- ogu (repository maintainer)

### Stage 2: Bilingual Text
**Goal**: Add human-readable descriptions

**Steps**:
1. Same branch or new branch
2. Update `apidef/prod/i18n/ja/<api-group>.yaml`
   - Add Japanese descriptions/summaries
3. Update `apidef/prod/i18n/en/<api-group>.yaml`
   - Add English descriptions/summaries
4. Create PR
   - Reviewers: **makoto (JP) + felix (EN)**
   - Purpose: Approve bilingual text
5. Merge after approval

**Avoid**:
- Generic "OK." responses
- Mixed languages in single file
- Descriptions in base files

## Common Documentation Issues

### Missing Parameter Details
❌ Bad:
```yaml
parameters:
  - name: simId
    in: path
    required: true
```

✅ Good:
```yaml
parameters:
  - name: sim_id
    in: path
    required: true
    description: "SIM ID (e.g., 89012345678901234567)"
    schema:
      type: string
      pattern: '^[0-9]{19,20}$'
    example: "89012345678901234567"
```

### Incomplete Response Schemas
❌ Bad:
```yaml
responses:
  '200':
    description: OK
```

✅ Good:
```yaml
responses:
  '200':
    description: Successfully retrieved SIM information
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/Sim'
        example:
          simId: "89012345678901234567"
          status: "active"
```

### Generic Descriptions
❌ Bad: "OK."  
✅ Good: "Successfully updated SIM speed class"

### Mixed Languages
❌ Bad: Mixing JP and EN in same file  
✅ Good: Separate `ja/` and `en/` files

### Descriptions in Base Files
❌ Bad: Adding descriptions to `base/*.yaml`  
✅ Good: Structure in base, descriptions in `i18n/ja/` and `i18n/en/`

## When to Remove `x-soracom-hidden`

Remove the flag when:
- [ ] API implementation complete
- [ ] E2E testing passed
- [ ] Ready for public API reference
- [ ] Ready for CLI generation

## Release Process

### 1. Merge API Definition
- Merge `soracom-api` PR first
- Triggers builds and validations

### 2. Update CLI (optional, ask ogu)
```bash
# In soracom-cli repo
cp build/soracom-api.{ja,en}.yaml generators/assets/
VERSION=x.y.z ./scripts/build.sh
# Test with SORACOM_AUTHKEY_ID_FOR_TEST and SORACOM_AUTHKEY_FOR_TEST
```

### 3. Deploy Gateway
- Merge `soracom-api-gateway` PR
- Update ECS task definition

## Gateway Routing Configuration

### Config File
- **Path**: `soracom-api-gateway/src/etc/routes.*.yaml`
- **Format**: YAML mapping routes to backend services

### Example Route
```yaml
/v1/sims/{sim_id}/delete_session:
  validatePermission: true  # Enable JWT validation
  service: sim-management
  path: /sims/{sim_id}/delete_session
```

### Dynamic Routes (Dev/Staging Only)
- **Header**: `X-Soracom-DynamicRoutes`
- **Purpose**: Test new routes without gateway restart
- **Production**: NOT enabled

### Reviewers
- Stakeholders
- ogu
- kaz

## Testing Across Repos

### Same Branch Name Pattern
1. Create branch `feature/new-api` in `soracom-api`
2. Create branch `feature/new-api` in `soracom-api-gateway`
3. Deploy both to staging
4. Test with dynamic routes enabled

## References

### Documentation
- `context/SORACOM API development guideline.md`
- `context/SORACOM API Development Workflow.md`
- `context/SORACOM API Error Code Prefixes.md`
- `context/API Specification Template.md`

### Repositories
- **API Definitions**: https://github.com/soracom/soracom-api
- **Gateway**: https://github.com/soracom/soracom-api-gateway (ogu-proxy)
- **CLI**: https://github.com/soracom/soracom-cli
- **Local Sandbox**: dipper-local
