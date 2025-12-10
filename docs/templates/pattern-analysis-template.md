# Pattern Analysis: <Feature Name>

Analyze existing patterns in the codebase to avoid reinventing the wheel.

**Status**: [Patterns Found | No Patterns Found | Incomplete - Repos Not Available]

---

## 1. Similar Features
Identify features with similar workflows, data models, or UI interactions.

| Feature | Repo | Path | Relevance |
| :--- | :--- | :--- | :--- |
| e.g. SIM Group Config | user-console-monorepo | apps/user-console/src/app/groups | High - reuses same modal pattern |

**If no similar features found:**
> No similar features identified in available repositories. This appears to be a novel feature requiring custom implementation. Recommend following standard Soracom patterns from docs/references/ guidelines.

---

## 2. Reusable Components
List UI components, backend services, or libraries that can be reused.

- **UI Components:**
  - `ds-table` (SDS)
  - `ds-modal` (SDS)
- **Backend Services:**
  - `AuditLogService` (soracom-api)

**If no reusable components identified:**
> No direct reusable components found. Implement using standard SDS components and backend libraries per Soracom guidelines.

---

## 3. Anti-Patterns to Avoid
What mistakes were made in similar features that we should not repeat?
- e.g. Hardcoded error messages (use i18n keys)
- e.g. N+1 queries in list view

**General recommendations when no patterns found:**
- Follow SDS component library for UI consistency
- Use backend-bom for dependency management
- Implement bilingual i18n from the start
- Add comprehensive test coverage (unit, contract, E2E)

---

## 4. Repository Availability
**Repositories searched:**
- [ ] user-console-monorepo
- [ ] soracom-internal-console-monorepo
- [ ] soracom-api
- [ ] billing
- [ ] Other: ___

**Repositories not available locally:**
> List any repos that couldn't be searched due to not being cloned. This may limit pattern discovery accuracy.
