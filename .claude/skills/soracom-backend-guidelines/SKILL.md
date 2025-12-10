---
name: soracom-backend-guidelines
description: Backend and API standards for Soracom services. Use when authoring OpenAPI specs, implementing Java/Kotlin services, or preparing releases.
---

# Soracom Backend Guidelines

Unified backend + API standards for defining OpenAPI specs, implementing Java/Kotlin services, and managing releases.

## 1. API Definition Standards

### Naming & Structure
- Paths: `snake_case` (e.g., `/sims/{sim_id}/delete_session`)
- Tags: `PascalCase`
- operationIds: `camelCase` and globally unique
- Path params: `snake_case` within `{ }`
- Error codes: `AAA0000` pattern (`COM0001`, `AGW0008`)

### Repository Layout (`soracom-api`)
- `apidef/prod/base/`: structure only (paths, schemas, params). **No descriptions.**
- `apidef/prod/i18n/{ja,en}/`: descriptions and summaries only.

### Two-Stage PR Flow
1. **Functional Definition**
   - Update base files, add `x-soracom-hidden: true` if private.
   - Validate with `make && make internal`.
   - Reviewers: stakeholders + ogu.
2. **Bilingual Text**
   - Update i18n files.
   - Reviewers: makoto (JP), felix (EN).

### Status Codes & Data Types
- Document `200/201/204/400/401/403/404`; never document 5xx.
- Timestamps are Unix epoch integers (no ISO strings).
- Validate base + internal builds before every push.

## 2. Backend Implementation Standards

### Libraries & Frameworks
- JSON: Jackson (not Gson)
- HTTP: WebClient/HttpClient (not RestTemplate)
- AWS SDK: v2 (v1 only for DynamoDB legacy code)
- Testing: JUnit 5, Playwright for UI
- Formatting: Spotless + Google Java Style (`./gradlew spotlessApply`)

### Dependencies
- Use `backend-bom` for all service repos—no individual version pins.
- Renovate PRs: prefer quarterly BOM updates.

### Security & Auth
- Java services use `auth-lib`.
- Go/Lambda services use `heimdall-v2` and tag Lambdas with `soracom:api-provider`.
- Enforce role-based access (Root vs SAM) in both code and tests.

### Testing Requirements
- Minimum 80% coverage for new code.
- Map FR/NFR to Unit, Contract, Integration, E2E tests.
- Ensure scenarios cover both Root and SAM users.

### Code Quality
- Lombok allowed; DTOs require `@NoArgsConstructor`.
- Run `./gradlew spotlessApply` + unit tests before committing.

## 3. Release & Deployment

- Releases go through Nebula scripts (see references).
- Deployment announcements via Slack `#dev-backend-github`.
- API routing updates live in `soracom-api-gateway/src/etc/routes.*.yaml`.
- Always document rollout/rollback steps in PR description and `/saef:release`.

## References

- [references/backend-engineering-standards.md](references/backend-engineering-standards.md)
- [references/java-code-style.md](references/java-code-style.md)
- `docs/references/backend-bom.md` (general, stays in docs)
- [references/openapi-development.md](references/openapi-development.md)
- `docs/references/api-error-codes.md` (general, stays in docs)
- `docs/references/backend-cd-system.md` (general, stays in docs)
