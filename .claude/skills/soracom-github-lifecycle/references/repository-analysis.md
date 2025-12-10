# Repository Analysis

Discover, clone, and analyze Soracom repositories to determine what code exists vs what needs creation.

## Workflow

### Step 1: Read Repository Catalog

```bash
# Load catalog
cat docs/repositories.yaml

# Expected structure:
# repositories:
#   - name: soracom-internal-console-api
#     clone_url: git@github.com:soracom/soracom-internal-console-api.git
#     triggers: [internal console, CRE backend]
#     common_paths: [src/main/java/.../controller/]
```

### Step 2: Match Requirements to Repositories

**Input:** Feature requirements (from `business-statement.md` or PRD)

**Process:**
1. Extract keywords from requirements
2. Match against repository triggers in catalog
3. Check discovery_rules for feature type patterns
4. Rank repositories by relevance
5. **Note team ownership** for each matched repository
6. **Check for AI documentation** (CLAUDE.md, AGENTS.md) availability
7. **Extract key patterns** from repository metadata

**Example:**
```
Requirement: "Display PUK on subscriber page in internal console"
Keywords: [internal console, subscriber, display]

Matches:
- soracom-internal-console-monorepo (triggers: "internal console")
  Team: CRE (@cre-team)
  AI Docs: CLAUDE.md, AGENTS.md, .github/copilot-instructions.md
  Tech: TypeScript, Angular, Material Design

- soracom-internal-console-api (triggers: "internal console API", "subscriber")
  Team: CRE (@cre-team)
  Tech: Java, AWS Lambda, Gradle

Discovery rule: internal_ui
- soracom-internal-console-monorepo
- soracom-internal-console-api
```

### Step 3: Clone Missing Repositories

**For each matched repository:**

```bash
# Check if exists
if ! test -d "./repos/${repo_name}"; then
    # Clone from catalog
    clone_url=$(grep -A 5 "name: ${repo_name}" docs/repositories.yaml | grep clone_url | cut -d' ' -f4)
    git clone "${clone_url}" "./repos/${repo_name}"

    # Log result
    if [ $? -eq 0 ]; then
        echo "✅ Cloned: ${repo_name}"

        # Check for AI documentation
        if [ -f "./repos/${repo_name}/CLAUDE.md" ]; then
            echo "   📄 Found: CLAUDE.md"
        fi
        if [ -f "./repos/${repo_name}/AGENTS.md" ]; then
            echo "   📄 Found: AGENTS.md"
        fi
        if [ -d "./repos/${repo_name}/docs" ]; then
            echo "   📁 Found: docs/ folder"
        fi
    else
        echo "❌ Clone failed: ${repo_name}"
    fi
fi
```

**Skip conditions:**
- `clone_by_default: false` in catalog (e.g., auth-lib)
- Repository already exists
- User specified `--no-clone` flag
- Repository has no `clone_url` (API host only, e.g., session-manager)

**Clone location:** `./repos/<repo-name>/`

**Post-Clone Actions:**
1. Read CLAUDE.md if present (repository guidelines)
2. Read AGENTS.md if present (agent-specific instructions)
3. Check docs/ folder structure (architecture, procedures, coding-guidelines)
4. Note key_patterns from catalog metadata
5. Check for validation commands (make, gradle, npm)

### Step 4: Analyze Backend Repositories

**Search for:**

#### Controllers/Endpoints
```bash
# Use common_paths from catalog
grep -r "Controller\|@GetMapping\|@PostMapping" ./repos/${repo}/src/main/java/.../controller/

# Look for similar endpoints
grep -r "getPuk\|getSubscriber\|registration_secret" ./repos/${repo}/
```

#### Authentication/Authorization
```bash
# Check imports for auth libraries
grep -r "import.*auth-lib\|import.*heimdall" ./repos/${repo}/

# Find RBAC patterns
grep -r "@PreAuthorize\|hasRole\|hasAnyRole" ./repos/${repo}/

# Look for existing role checks
grep -r "CRE\|Support\|Operations" ./repos/${repo}/src/
```

#### Audit Logging
```bash
# Find audit services
find ./repos/${repo}/ -name "*Audit*Service.java"

# Check for logging patterns
grep -r "auditLog\|logAccess\|accessEvent" ./repos/${repo}/
```

#### Database Access
```bash
# Find repositories/DAOs
find ./repos/${repo}/ -name "*Repository.java" -o -name "*Dao.java"

# Check for ORM patterns
grep -r "@Entity\|@Table\|registration_secret" ./repos/${repo}/
```

**Document findings:**
- ✅ Feature exists - note location
- ⚠️ Partial implementation - note what's missing
- ❌ Not found - needs creation
- 🔍 Uncertain - needs manual verification

### Step 5: Analyze Frontend Repositories

**Search for:**

#### Similar Components
```bash
# Use common_paths from catalog
find ./repos/${repo}/apps/*/src/app/ -name "*subscriber*.component.ts"

# Look for masked field patterns
grep -r "masked\|reveal\|••••" ./repos/${repo}/apps/
```

#### API Service Clients
```bash
# Find service files
find ./repos/${repo}/ -name "*subscriber*.service.ts"

# Check existing API calls
grep -r "getPuk\|getSubscriber" ./repos/${repo}/
```

#### Role-Based Visibility
```bash
# Find role check patterns
grep -r "hasRole\|canView\|isAuthorized" ./repos/${repo}/

# Look for *ngIf role checks
grep -r "\*ngIf.*role\|\*ngIf.*can" ./repos/${repo}/
```

#### SDS Component Usage
```bash
# Find Material/SDS components
grep -r "mat-stroked-button\|mat-icon\|content_copy" ./repos/${repo}/

# Look for similar UI patterns
grep -r "click-to-reveal\|copyToClipboard" ./repos/${repo}/
```

### Step 6: Analyze API Definitions

**Search for:**

```bash
# Find OpenAPI specs for domain
find ./repos/soracom-api/apidef/ -name "*subscriber*.yaml"

# Check existing endpoints
grep -r "paths:.*subscriber\|/subscribers" ./repos/soracom-api/apidef/

# Look for similar operations
grep -r "operationId:.*getPuk\|getSubscriber" ./repos/soracom-api/
```

### Step 7: Generate Analysis Report

**Output file:** `outputs/<date>-<slug>/repo-analysis.md`

**Use template:** `docs/templates/repo-analysis-checklist.md`

**Fill sections:**
1. **Repository Discovery** - Trigger matches, suggested repos
2. **Clone Activity** - What was cloned, failures, location
3. **Backend Analysis** - Controllers, auth, logging, DB access
4. **Frontend Analysis** - Components, services, role checks, SDS
5. **API Definition Analysis** - Existing specs, patterns
6. **Confidence Level** - High/Medium/Low based on findings
7. **Recommendations** - What to reuse, what to create, verification needed

---

## Analysis Patterns

### Pattern 1: Feature Already Exists
```
Backend: ✅ SubscriberController.getPuk() found
Frontend: ✅ PukDisplayComponent found
API: ✅ GET /subscribers/{imsi}/puk in spec

Recommendation: Feature may already be implemented.
Verify deployment status and test in staging.
```

### Pattern 2: Partial Implementation
```
Backend: ✅ SubscriberController exists
         ❌ getPuk() method NOT found
Auth: ✅ auth-lib integrated
      ⚠️ CRE role check pattern found but not applied to subscriber endpoints
Audit: ✅ AuditService.java exists
       ❌ PUK access events NOT logged

Recommendation: Extend existing controller, integrate with auth-lib and AuditService.
Estimate: 3 points (reuse > create)
```

### Pattern 3: Net-New Implementation
```
Backend: ❌ No subscriber-related endpoints found
Auth: ❌ auth-lib NOT integrated
Audit: ❌ No audit service found

Recommendation: Implement from scratch following existing patterns in billing repo.
Estimate: 8 points (no reusable code)
```

---

## Error Handling

### Clone Failures

**Permission denied:**
```
❌ Clone failed: soracom-internal-console-api (Permission denied)

Recommendation:
1. Verify SSH key: ssh -T git@github.com
2. Try HTTPS: https://github.com/soracom/soracom-internal-console-api.git
3. Or manually clone to ./repos/

Confidence: LOW - Cannot analyze without repo access
```

**Network issues:**
```
❌ Clone failed: soracom-api (Network timeout)

Recommendation: Retry clone or use existing repo if available elsewhere
Confidence: MEDIUM - Can proceed with partial analysis
```

### Search Failures

**No results found:**
```
🔍 Searched: grep -r "getPuk" ./repos/soracom-internal-console-api/
Result: No matches

Note: This doesn't confirm feature doesn't exist
Recommendation:
- Try broader search patterns
- Check method naming variations (fetchPuk, retrievePuk)
- Manually inspect controller files
```

**Repo structure changed:**
```
⚠️ Common paths from catalog not found:
Expected: src/main/java/vconnec/internal/console/controller/
Actual: src/controller/ (repo restructured)

Recommendation: Update docs/repositories.yaml common_paths
Falling back to full repository search...
```

---

## Output Quality Checklist

Before finalizing analysis report, verify:

- [ ] All matched repositories analyzed (or clone failures documented)
- [ ] Backend: Checked for controllers, auth, logging, DB access
- [ ] Frontend: Checked for components, services, role visibility
- [ ] API: Checked for existing endpoint definitions
- [ ] Clone activity fully documented
- [ ] Confidence level assigned (High/Medium/Low)
- [ ] Specific file paths provided for existing code
- [ ] Clear distinction between EXISTS, PARTIAL, and NEEDS CREATION
- [ ] Recommendations actionable (not vague)
- [ ] Limitations clearly flagged

---

## Integration with SAEF Commands

### Used by `/saef:prd`
```markdown
6. **Discover and clone affected repositories:**
   Use @repo-analyzer skill:
   - Read business statement requirements
   - Match against catalog
   - Clone missing repos
   - Search for similar features
   - Document findings in PRD
```

### Used by `/saef:spec`
```markdown
2. **Verify and clone repositories:**
   Use @repo-analyzer skill:
   - Read repo list from PRD
   - Clone any missing repos
   - Generate repo-analysis.md
```

### Used by `/saef:plan`
```markdown
2. **Analyze Existing Codebase:**
   Use @repo-analyzer skill:
   - Read PRD repo list
   - Verify all repos analyzed
   - Use findings to create accurate stories
```

---

## Examples

### Example 1: Internal Console Feature

**Input:**
```
Feature: Display PUK on subscriber page in internal console
Requirements:
- Show PUK field on subscriber detail page
- Mask by default, click to reveal
- Only CRE/Support/Operations roles
- Log access events
```

**Analysis:**
```bash
# Step 1: Match repos
Triggers matched:
- "internal console" → soracom-internal-console-monorepo
- "subscriber" → soracom-internal-console-api

# Step 2: Clone
✅ Cloned: soracom-internal-console-api
✅ Already exists: soracom-internal-console-monorepo

# Step 3: Search backend
$ grep -r "SubscriberController" ./repos/soracom-internal-console-api/src/
✅ Found: SubscriberController.java

$ grep -r "getPuk\|registration_secret" ./repos/soracom-internal-console-api/
❌ No getPuk method found

$ grep -r "auth-lib" ./repos/soracom-internal-console-api/src/
✅ Found: import io.soracom.auth.lib.annotations.RequiresRole

$ find ./repos/soracom-internal-console-api/ -name "*Audit*"
✅ Found: AuditService.java

# Step 4: Search frontend
$ find ./repos/soracom-internal-console-monorepo/apps/ -name "*subscriber*"
✅ Found: subscriber-detail.component.ts

$ grep -r "masked\|reveal" ./repos/soracom-internal-console-monorepo/apps/
⚠️ Found in api-keys component (reusable pattern)

# Step 5: Generate report
Output: docs/2025-11-17-display-puk/repo-analysis.md

Findings:
✅ SubscriberController exists - extend with getPuk()
✅ auth-lib integrated - reuse @RequiresRole
✅ AuditService exists - add PUK access event
✅ Subscriber component exists - add PUK field
⚠️ Masked field pattern - copy from api-keys component

Confidence: HIGH
Estimate: 3 points (70% reuse)
```

---

## Skill Metadata

**When to invoke:**
- Before writing PRD (discover repos)
- Before writing API spec (verify existing code)
- Before creating project plan (avoid duplicate stories)

**Inputs:**
- Feature requirements (text)
- Repository catalog (docs/repositories.yaml)
- Workspace state (./repos/ directory)

**Outputs:**
- Repository analysis report (markdown)
- Clone activity log
- Confidence assessment
- Actionable recommendations

**Dependencies:**
- Git (for cloning)
- grep/find (for searching)
- docs/repositories.yaml (catalog)

**Time estimate:** 2-5 minutes per repository

---

## References

- **Repository Catalog:** `docs/repositories.yaml`
- **Output Template:** `docs/templates/repo-analysis-checklist.md`
- **Usage Guide:** `docs/repository-catalog-guide.md`
- **Standards:** @api-spec-generator, @ux-pattern-miner
