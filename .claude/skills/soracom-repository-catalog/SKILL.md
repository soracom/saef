---
name: soracom-repository-catalog
description: Repository discovery and development commands for Soracom repos. Use when cloning repos, running builds/tests, or identifying which repos a feature affects.
---

# Soracom Repository Catalog

Repository catalog and development workflows for Soracom codebases.

## When to Use

- Identifying which repos are affected by a feature
- Cloning repositories
- Running build/test commands
- Understanding repo-specific workflows
- Reading CLAUDE.md for repo guidelines

## Repository Discovery

### Catalog Location
- **File**: `docs/repositories.yaml`
- **Contains**: Repository metadata, teams, AI docs, key patterns
- **Archived repos**: Marked with `archived: true` - must never be used for new work

### Archived Repository Check
**CRITICAL**: Before using any repository, verify it is not archived:

```bash
bash .claude/skills/saef-ops/scripts/check-archived.sh <repo-name>
# Exit 0 = archived (DO NOT USE)
# Exit 1 = active (safe to use)
```

Repositories marked `archived: true` in `docs/repositories.yaml`:
- **Cannot** be modified or used for new features
- **Cannot** receive new commits
- **Should not** be analyzed for pattern discovery
- **Must not** appear in implementation plans

If a feature requires an archived repo, ask the user about alternatives or migration strategy.

### Matching Features to Repos
1. Parse feature requirements
2. Check repository descriptions in catalog
3. **Verify repositories are not archived**
4. Match by team ownership (frontend, backend, infrastructure)
5. Consider dependencies between repos

## Common Repositories

### Frontend
- **user-console-monorepo**: Public user console (TypeScript/React)
- **soracom-internal-console-monorepo**: Internal console (TypeScript/React)

### Backend
- **soracom-api**: API definitions (OpenAPI 3.1+)
- **billing**: Billing service (Java/Spring Boot)
- **auth-manager**: Authentication (Java/Go)

### Infrastructure
- **soracom-api-gateway**: API gateway/routing (Go)

## Development Commands

### Frontend (npm/pnpm)
```bash
npm install           # Install dependencies
npm run dev           # Start dev server
npm test              # Unit tests
npm run e2e           # Playwright E2E
npm run lint          # ESLint
npm run build         # Production build
```

### Backend (Gradle)
```bash
./gradlew build       # Compile + tests
./gradlew test        # Unit tests only
./gradlew bootRun     # Run locally

## Detailed References

- **[local-dev-setup.md](references/local-dev-setup.md)**: Running services locally, DevServerMain, internal APIs, test accounts
./gradlew spotlessApply  # Format code
```

### API (Make)
```bash
make                  # Validate public APIs
make internal         # Validate all APIs
make serve            # Local Swagger UI
```

## Cloning & Setup

### Clone to Workspace
```bash
cd repos/
git clone https://github.com/soracom/<repo-name>
```

### Check AI Documentation
Look for:
- `CLAUDE.md` - Repository guidelines
- `AGENTS.md` - Agent instructions
- `docs/` - Architecture, standards

## Detailed Reference

- `docs/references/repository-catalog.md` – schema, trigger taxonomy, maintenance rules
- `.claude/skills/soracom-repository-catalog/references/local-dev-setup.md` – repo-specific dev environment steps
