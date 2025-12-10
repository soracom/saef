# Backend BOM & Third-Party Library Management

This reference supersedes `.archive/.context/Third-party library management`. It explains how backend teams manage dependencies across services.

## 1. Principles
- All Java services reference `soracom/backend-bom`.
- Individual projects **do not** pin third-party versions; add new dependencies to the BOM instead.
- Renovate monitors the BOM and raises PRs for updates.

## 2. Handling Renovate PRs
1. **Check for vulnerability fixes.** Urgent CVEs may require patch releases outside the quarterly cycle.
2. **Check for breaking changes.** Tag PRs with `breaking` when frameworks upgrade (e.g., Spring Boot 2 → 3).
3. **Coordinate with other teams.** If a change impacts a shared component, add `help wanted` and notify the owner.
4. **Approve & merge** into the `renovatebot` branch after labeling. This branch is merged into `dev`/`main` every quarter.

## 3. Quarterly Release Flow
- Merge `renovatebot` → `dev`/`main` in backend-bom.
- Update downstream services (billing, auth-manager, etc.) to consume the new BOM before releasing.
- Maintain a changelog of dependency bumps so `/saef:release` can cite them.

## 4. Diagnosing Dependency Conflicts
- Use `./gradlew :<module>:dependencies --configuration runtimeClasspath`.
- Remember that Gradle resolves to the highest version unless the BOM overrides it.
- If BOM forces an older version that breaks your code, either bump the BOM or align your project to the BOM version—never pin ad hoc versions.

## 5. Tooling
- Pre-commit hook example (Spotless via Gradle) is documented in `docs/references/java-code-style.md`.
- Use Renovate filters (e.g., `label:breaking` + milestone) to review change scope quickly.

Keep this file updated whenever the backend platform team adjusts the BOM cadence or Renovate workflow.

