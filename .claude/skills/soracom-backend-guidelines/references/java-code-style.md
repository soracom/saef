# Java Code Style & Formatting

Migrated from `.archive/.context/Java code formatting`. Apply these rules across backend repositories (billing, auth-manager, soracom-api, etc.).

## 1. Google Java Style
- Base formatter: [google/styleguide](https://github.com/google/styleguide).
- Apply via IDE-specific configs (`.prefs` files) or project-level Gradle tasks.
- When multiple developers touch the same repo, run the formatter before committing to avoid noisy diffs.

## 2. Spotless Configuration
Add the plugin once per Gradle root (`build.gradle`):
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
```
Optional: `build.dependsOn spotlessApply` forces formatting before every build.

## 3. Commands
- `./gradlew spotlessCheck` – verify sources.
- `./gradlew spotlessApply` – format in place.
- Pre-commit hook example:
```yaml
repos:
  - repo: https://github.com/jguttman94/pre-commit-gradle
    rev: v0.3.0
    hooks:
      - id: gradle-spotless
        args: ["--wrapper"]
```

## 4. IDE Links
- Eclipse: `https://scrapbox.soracom.io/general/eclipse_code_formatting_rule`
- IntelliJ: `https://scrapbox.soracom.io/general/IntelliJ_code_formatting_rule`
- VS Code: `https://scrapbox.soracom.io/general/VS_code_formatting_rule`

Keep this doc updated whenever the backend team changes formatter versions so SAEF never references `.archive/.context/` again.

