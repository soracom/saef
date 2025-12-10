# Backend Component Release Process

SORACOM backend components use a standardized release process with the Nebula release plugin and a dev/main branching strategy.

## Overview

- **Development**: Work in `dev` branch
- **Release**: Merge dev → main, tag with Nebula, publish to GitHub Packages
- **Versioning**: Semantic versioning with Nebula (no manual version in build.gradle)
- **Scripts**: Automated release scripts in `backend-shared/release-scripts/`

## Why Nebula?

[Nebula release plugin](https://github.com/nebula-plugins/nebula-release-plugin) provides:
- Automatic version bumping from git tags
- No manual version changes in build.gradle
- Prevents conflicts when releasing
- Checks for uncommitted files before release

## Branching Strategy

```
dev (development)  ──→  main (releases)
  ├─ feature branches        ├─ hotfix branches
  └─ epic branches           └─ patch releases
```

- **dev**: Active development, feature branches merge here
- **main**: Release-ready code only, tagged versions, production deployments

## Development Phase

### Creating Feature Branches

```bash
# Branch from dev
git checkout dev
git pull origin dev
git checkout -b sc-xxxx-feature-name  # Use Shortcut story ID
```

### Publishing Development Snapshots

During development, you can publish snapshot versions for testing:

```bash
# Unique dev snapshot (recommended)
./gradlew devSnapshot
# Creates: billing-1.6.0-dev.0+82efa96.jar

# Shared snapshot (overwrites previous)
./gradlew snapshot
# Creates: billing-1.6.0-SNAPSHOT.jar
# ⚠️ Must be published from dev branch
```

### Merging to Dev

```bash
# Create PR to dev branch
gh pr create --base dev --title "sc-xxxx: Feature description"

# After approval, merge via GitHub UI
```

## Release Phase

### Prerequisites

1. **Update dependencies** if needed (e.g., dipper-common version)
2. **Ensure you have SSH access** to GitHub (not HTTPS)
3. **Install gh CLI**: `brew install gh` (for automated PR creation)
4. **Authenticate**: `gh auth login` (first time only)

### Step 1: Create Release PR

This merges all changes from dev → main:

```bash
./backend-shared/release-scripts/create_release_pr.sh
```

If the shell doesn't exit, update the submodule:
```bash
git submodule update -i
```

**What it does:**
- Creates PR from `dev` to `main`
- Includes all features since last release
- Reviewers: @backend-engineers

**Actions:**
1. Review the generated PR
2. Request review from team
3. Merge after approval

### Step 2: Run Release Script

Choose the appropriate release type:

#### Minor Release (default)
For new features, non-breaking changes:
```bash
./backend-shared/release-scripts/release.sh
# Example: 1.5.0 → 1.6.0
```

#### Patch Release
For bugfixes only:
```bash
./backend-shared/release-scripts/release_patch.sh
# Example: 1.5.0 → 1.5.1
```

#### Major Release
For breaking changes:
```bash
./backend-shared/release-scripts/release_major.sh
# Example: 1.5.0 → 2.0.0
```

**What the script does:**
1. Switches to `main` branch
2. Pulls from `origin/main`
3. Finalizes version with Nebula
4. Publishes to GitHub Packages
5. Creates GitHub release with auto-generated notes
6. Merges `main` back to `dev`
7. Pushes changes

## Versioning Conventions

Follow semantic versioning:

- **Major** (X.0.0): Breaking changes
  - Coordinate with backend-bom releases
  - Java major version upgrades
  - API contract breaks

- **Minor** (1.X.0): New features, backwards compatible
  - New functionality
  - Feature additions
  - No breaking changes

- **Patch** (1.5.X): Bugfixes only
  - No new features
  - No breaking changes
  - Security fixes

## Manual Release (Fallback)

If release scripts fail, you can release manually:

### 1. Publish JAR

```bash
# Minor version
./gradlew clean final

# Patch version
./gradlew final -Prelease.scope=patch

# Major version
./gradlew final -Prelease.scope=major
```

Published to: `s3://soracom-repository/mvnrepos/vconnec/{component-name}/`

### 2. Create GitHub Release

1. Confirm you're on `main` branch
2. Go to GitHub: `https://github.com/soracom/{repo}/releases`
3. Click "Draft a new release"
4. Specify tag (version number, e.g., `1.6.0`)
5. Click "Auto-generate release notes"
6. Publish release

## CodeBuild Configuration

For Nebula to work correctly:

**Git clone depth must be `Full`** (not shallow clone)

Configure in CodeBuild:
1. Go to project → Edit → Source
2. Set "Git clone depth" to "Full"
3. Save

This allows Nebula to read git history and determine the latest version.

## Initial Repository Setup

For new repositories:

1. See [soracom/backend-shared](https://github.com/soracom/nebula-chain) for reference
2. Change default branch to `dev`
3. Protect both `main` and `dev` branches (require PR reviews)
4. Add Nebula plugin to build.gradle
5. Remove manual `version` field from build.gradle

## Troubleshooting

**Problem**: Release script fails with "uncommitted files"
- **Solution**: Commit or stash changes before releasing

**Problem**: "Permission denied" when pushing
- **Solution**: Ensure SSH access (not HTTPS): `git remote -v`

**Problem**: Version number doesn't increment
- **Solution**: Check CodeBuild git clone depth is "Full"

**Problem**: Can't find latest version
- **Solution**: Nebula reads git tags - ensure tags are fetched: `git fetch --tags`
