# Test Plan Generation

Translate PRD requirements into actionable test strategies covering unit, contract, integration, and E2E scenarios with explicit role-based coverage (Root vs SAM users).

## Responsibilities

1. **Map FR/NFR to test types**:
   - **Unit tests**: Business logic, validation, edge cases.
   - **Contract tests**: API request/response schemas, error handling.
   - **Integration tests**: Service-to-service interactions (auth-manager, billing).
   - **E2E tests**: End-user flows through UI + backend.

2. **Role-based coverage**:
   - **Root users**: Full access, all operations.
   - **SAM users**: Restricted permissions, should see correct errors/hiding.

3. **State and data scenarios**:
   - Empty states, single item, many items, pagination.
   - Valid input, invalid input, boundary values.
   - Loading, error, timeout, retry logic.

4. **Non-functional requirements**:
   - Performance: Response time budgets, concurrent user load.
   - Security: Auth checks, input sanitization, SQL injection prevention.
   - Accessibility: Keyboard navigation, screen reader compatibility.
   - Internationalization: JP/EN strings, date/number formatting.

5. **Regression protection**:
   - Identify existing tests that may need updates.
   - Flag areas where new tests prevent future regressions.

## Test Plan Structure

```markdown
# Test Plan: <Feature Name>

**PRD**: `outputs/<date>-<slug>.md`
**API Spec**: `apidef/sketch/<slug>.yaml`
**Test Owner**: <Name/Team>

## Scope
- **In scope**: <Features/scenarios covered>
- **Out of scope**: <Deferred to future or not applicable>

## Test Strategy

### Unit Tests
| Requirement | Test Case | Expected Behavior | Location |
|-------------|-----------|-------------------|----------|
| FR-1: Create group | `createGroup_validInput_success` | Returns 201, group ID | `GroupServiceTest.java` |
| FR-1: Create group | `createGroup_duplicateName_error` | Returns 409, error code GRP0001 | `GroupServiceTest.java` |
| NFR-2: Validation | `createGroup_invalidName_error` | Returns 400, message explains format | `GroupValidatorTest.java` |

### Contract Tests
| API Endpoint | Test Case | Validates | Location |
|--------------|-----------|-----------|----------|
| `POST /groups` | `createGroup_schema` | Request/response match OpenAPI | `GroupApiContractTest.java` |
| `GET /groups/{id}` | `getGroup_404` | Correct error shape for missing ID | `GroupApiContractTest.java` |

### Integration Tests
| Integration Point | Test Case | Scenario | Location |
|-------------------|-----------|----------|----------|
| Auth-manager | `createGroup_as_SAM_denied` | SAM user gets 403 | `GroupAuthIntegrationTest.java` |
| Billing | `deleteGroup_triggers_billing_update` | Group deletion updates charges | `BillingIntegrationTest.java` |

### E2E Tests
| User Flow | Steps | Expected Outcome | Tools |
|-----------|-------|------------------|-------|
| Root creates group | 1. Login as Root<br>2. Navigate to Groups<br>3. Click Create<br>4. Fill form<br>5. Submit | Group appears in list, success toast shown | Playwright/Cypress |
| SAM attempts create | 1. Login as SAM<br>2. Navigate to Groups<br>3. Create button hidden or disabled | Cannot create, sees appropriate message | Playwright/Cypress |

### Non-Functional Tests
| Requirement | Test Case | Acceptance Criteria | Location |
|-------------|-----------|---------------------|----------|
| NFR-1: Performance | `listGroups_1000_items_response_time` | <200ms p95 | Performance test suite |
| NFR-2: Accessibility | `groupForm_keyboard_navigation` | Can submit via Enter, cancel via Escape | E2E accessibility tests |
| NFR-3: I18n | `groupErrors_shown_in_JP` | Error messages display in Japanese when locale=ja | E2E i18n tests |

## Test Data
- **Fixtures**: `test/fixtures/groups.json`
- **Mocks**: Auth-manager responses, billing service responses
- **Cleanup**: Automated teardown after E2E runs

## Dependencies
- **Services**: Auth-manager (local/staging), billing service (mocked)
- **Test accounts**: `root-test@soracom.io`, `sam-test@soracom.io`
- **Environments**: Local, staging

## Execution Plan
1. **Pre-merge**: Unit + contract tests via CI
2. **Post-merge to staging**: Integration + E2E tests
3. **Pre-release**: Full regression suite + performance validation

## Exit Criteria
- [ ] All unit tests passing (≥90% coverage for new code)
- [ ] All contract tests passing
- [ ] Integration tests passing for Root and SAM scenarios
- [ ] E2E smoke tests passing on staging
- [ ] No P0/P1 bugs open
- [ ] Performance benchmarks met
- [ ] Accessibility audit passed (WCAG AA)

## Risk Areas
- **High complexity**: <Area with intricate logic>
- **External dependencies**: <Third-party API reliability>
- **Data migration**: <Existing records need updates>

## Soracom Testing Standards

## Test Coverage Requirements
- **Target**: 80% unit test coverage
- **Required test types**: Unit, Contract, Integration, E2E
- **Role coverage**: Must test Root user and SAM user scenarios

## Backend Testing
- **Framework**: JUnit5
- **Assertions**: AssertJ, Hamcrest
- **Coverage**: New code, bug fixes, edge cases

# References
- API Spec: `apidef/sketch/<slug>.yaml`
- Backend standards: `.claude/skills/soracom-backend-guidelines/references/backend-engineering-standards.md` for numeric thresholds

```

## Process

1. **Parse PRD**:
   - Extract FR (functional requirements) and NFR (non-functional requirements).
   - Identify personas (Root, SAM, operator, etc.).

2. **Map to test types**:
   - For each FR, determine: unit, contract, integration, E2E coverage.
   - For each NFR, add performance, security, a11y, i18n tests.

3. **Generate test cases**:
   - Use table format for clarity.
   - Include expected behavior and file locations.

4. **Role scenarios**:
   - Ensure Root and SAM paths are explicitly tested.
   - Document permission checks and error messages.

5. **Save output**:
   - Write to `outputs/<slug>/test-plan.md`.
   - Link from PRD's "Technical Document" section.

## Failure Handling

- **Missing requirements**: Ask for clarification on FR/NFR before generating plan.
- **Ambiguous roles**: Request explicit permission rules for Root vs SAM.
- **No API spec**: Generate placeholder test cases and mark as TODO pending `/saef:spec`.

## Integration with SAEF Workflow

- **Triggered by**: `/saef:spec` command
- **Prerequisites**: PRD completed, API spec stub created
- **Next step**: Implementation phase, `/saef:guard` for validation

## Style Rules

- Use tables for test case organization.
- Keep test case names descriptive: `<action>_<condition>_<expectedResult>`.
- Reference actual file paths when known (e.g., `GroupServiceTest.java`).
- Cite policy documents when recommending test approaches.

## Example Triggers

- "Generate a test plan for the group configuration export feature"
- "What test coverage do we need for this API?"
- "/saef:spec includes generating the test plan"
