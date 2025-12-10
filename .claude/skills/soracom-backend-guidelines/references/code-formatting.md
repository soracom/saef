# Code Formatting Standards

SORACOM backend projects use Google Java Style Guide with automated formatting via Spotless.

## Quick Start

```bash
# Format all code before commit
./gradlew spotlessApply

# Check formatting without modifying files
./gradlew spotlessCheck
```

## IDE Setup

Apply Google Style Guide to your IDE for consistent formatting while coding.

### Eclipse

```bash
# Apply to specific project
./gradlew cleanEclipse eclipse
```

This creates Eclipse-specific formatter configuration from the project's style guide.

**Manual setup:**
1. Download formatter: `gradle/org.eclipse.jdt.core.prefs`
2. Eclipse → Preferences → Java → Code Style → Formatter
3. Import the formatter file
4. Set as active profile

**Resources:**
- [Eclipse code formatting rule](https://scrapbox.soracom.io/general/eclipse_code_formatting_rule)

### IntelliJ IDEA

**Manual setup:**
1. Settings → Editor → Code Style → Java
2. Click gear icon → Import Scheme → Eclipse XML Profile
3. Select `gradle/org.eclipse.jdt.core.prefs`
4. Apply and OK

**Resources:**
- [IntelliJ code formatting rule](https://scrapbox.soracom.io/general/IntelliJ_code_formatting_rule)

### VS Code

**Manual setup:**
1. Install "Language Support for Java" extension
2. Create `.vscode/settings.json`:
   ```json
   {
     "java.format.settings.url": "gradle/org.eclipse.jdt.core.prefs"
   }
   ```

**Resources:**
- [VS Code formatting rule](https://scrapbox.soracom.io/general/VS_code_formatting_rule)

## Spotless Gradle Plugin

Spotless automates code formatting in the build process.

### Setup

Add to `build.gradle`:

```groovy
plugins {
    id "com.diffplug.gradle.spotless" version "3.30.0"
}

spotless {
    java {
        eclipse().configFile "${rootDir}/gradle/org.eclipse.jdt.core.prefs"
        importOrder 'java', 'javax', 'org', 'com', 'lombok', 'vconnec', 'io.soracom'
        removeUnusedImports()
        target '**/*.java'
    }
}

// Auto-format on every build (optional)
build.dependsOn spotlessApply
```

### Commands

```bash
# Check code formatting (CI/CD)
./gradlew spotlessCheck

# Apply formatting to all files
./gradlew spotlessApply

# Format specific module
./gradlew :module-name:spotlessApply
```

### Import Order

Spotless enforces consistent import ordering:

1. `java.*`
2. `javax.*`
3. `org.*`
4. `com.*`
5. `lombok.*`
6. `vconnec.*`
7. `io.soracom.*`

Unused imports are automatically removed.

## Git Pre-Commit Hook

Automatically run Spotless before every commit to catch formatting issues early.

### Setup

1. **Install pre-commit** (one-time):
   ```bash
   brew install pre-commit
   ```

2. **Create `.pre-commit-config.yaml`** at project root:
   ```yaml
   repos:
     - repo: https://github.com/jguttman94/pre-commit-gradle
       rev: v0.3.0
       hooks:
         - id: gradle-spotless
           args:
             - "--wrapper"
   ```

3. **Install hook scripts**:
   ```bash
   pre-commit install
   # Output: pre-commit installed at .git/hooks/pre-commit
   ```

4. **Test (optional)**:
   ```bash
   pre-commit run --all-files
   ```

### How It Works

When you run `git commit`:
1. Pre-commit hook runs `./gradlew spotlessCheck`
2. If formatting issues exist, commit is blocked
3. Fix with `./gradlew spotlessApply`
4. Retry commit

## Google Java Style Highlights

Key formatting rules applied:

- **Indentation**: 2 spaces (not tabs)
- **Line length**: 100 characters
- **Braces**: Required for all control structures
- **Imports**: Organized by category, unused removed
- **Whitespace**: Consistent spacing around operators
- **Naming**: camelCase for methods/variables, PascalCase for classes

## Font Management

Google Style Guide recommends specific fonts:

- **Headings**: Poppins (fallback: Arial)
- **Body text**: Lora (fallback: Georgia)

Fonts should be pre-installed in your environment. If unavailable, fallback fonts are used automatically.

## CI/CD Integration

Add to CI pipeline:

```yaml
# GitHub Actions example
- name: Check code formatting
  run: ./gradlew spotlessCheck
```

This prevents unformatted code from being merged.

## Common Issues

**Problem**: Spotless fails with "File has changes"
- **Solution**: Run `./gradlew spotlessApply` before commit

**Problem**: IDE formatting conflicts with Spotless
- **Solution**: Ensure IDE uses the same `org.eclipse.jdt.core.prefs` file

**Problem**: Pre-commit hook not running
- **Solution**: Reinstall: `pre-commit uninstall && pre-commit install`

**Problem**: Different formatting between local and CI
- **Solution**: Ensure same Spotless plugin version in build.gradle

## Best Practices

1. **Format before commit**: Always run `spotlessApply` before pushing
2. **Use pre-commit hooks**: Automate formatting checks
3. **IDE integration**: Configure IDE to use same rules
4. **Consistent version**: Pin Spotless version in build.gradle
5. **Whole team**: Ensure all developers use same configuration
