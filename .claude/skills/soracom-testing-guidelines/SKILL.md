---
name: soracom-testing-guidelines
description: Soracom testing standards (unit/contract/E2E, Root vs SAM users, 80% coverage). Use when writing tests or creating test plans.
---

# Soracom Testing Guidelines

Testing standards for ensuring quality across unit, contract, integration, and E2E testing.

## Test Coverage

### Requirements
- **Minimum**: 80% for new code
- **Tool**: SonarQube gates
- **Scope**: Unit + integration tests

### What to Test
- Business logic
- Validation rules
- Edge cases
- Error handling

## Test Types

### Unit Tests
- **Focus**: Individual functions/methods
- **Framework**: JUnit 5 (Java), Jest/Vitest (TypeScript)
- **Pattern**: AAA (Arrange, Act, Assert)

### Contract Tests
- **Focus**: API request/response schemas
- **Purpose**: Catch breaking changes

### E2E Tests
- **Frontend**: Playwright
- **Coverage**: User flows, both Root and SAM users

## Role-Based Testing

### Root User
- Full permissions
- All features accessible

### SAM User
- Limited permissions
- Test authorization checks
- Verify proper error messages

## UAT Checklists

### Purpose
- Validate in staging before production
- Confirm functional requirements
- Check SDS compliance
- Test accessibility

### Coverage
- Functional flows (happy path)
- Edge cases (empty states, boundaries)
- Error states
- Role-based scenarios

## Detailed Reference

For comprehensive test templates, UAT checklist formats, and testing patterns, see:
- [references/test-planning.md](references/test-planning.md)
- [references/uat-guidelines.md](references/uat-guidelines.md)
- `docs/references/saef-principles.md` for the overarching quality, localization, and release guardrails every feature must satisfy.
