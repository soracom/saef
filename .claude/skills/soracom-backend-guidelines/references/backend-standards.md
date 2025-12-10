# Soracom Backend Standards - Detailed Reference

## Library Preferences

### JSON Processing
- **Prefer**: Jackson (`com.fasterxml.jackson`)
- **Avoid**: Gson (legacy, don't use in new code)
- **Rationale**: Jackson is the standard across all services

### HTTP Client
- **Prefer**:
  - WebClient (Spring WebClient)
  - HttpClient (Java 11+ HttpClient)
- **Avoid**: RestTemplate (legacy, blocking)
- **Rationale**: Modern async/reactive patterns

### AWS SDK
- **Prefer**: v2
- **Allow v1 only for**: DynamoDB (complex migration in progress)
- **Why**: v2 has better async support, smaller footprint

### Lombok
- **Use**: Yes, heavily encouraged
- **Requirement**: `@NoArgsConstructor` for DTOs (Jackson needs no-arg constructor)
- **Common annotations**: `@Data`, `@Builder`, `@RequiredArgsConstructor`, `@Slf4j`

### Testing
- **Framework**: JUnit 5 (NOT JUnit 4)
- **Assertions**: JUnit, AssertJ, Hamcrest (all acceptable)
- **Mocking**: Mockito preferred

## Build & Dependency Management

### Backend BOM
- **Required**: Yes, all services must use `backend-bom`
- **Source**: GitHub Packages
- **Rule**: No ad-hoc version pins in service repos
- **Why**: Centralized dependency management, security updates, consistency

### Gradle Configuration
```gradle
dependencies {
    implementation platform('com.soracom:backend-bom:latest.release')
    implementation 'com.fasterxml.jackson.core:jackson-databind' // No version!
}
```

### Renovate
- **Enabled**: Yes
- **Strategy**: Consolidate upgrades quarterly
- **Auto-merge**: Patch versions only

## Code Quality

### Spotless
- **Required**: Yes
- **Style**: Google Java Format
- **Command**: `./gradlew spotlessApply`
- **CI**: Fails build if not formatted

### Pre-commit Hooks
- **Recommended**: Install locally
- **Checks**: Formatting, basic linting

## Testing Standards

### Coverage Target
- **Minimum**: 80% for new code
- **Enforcement**: SonarQube gates

### Required Test Types
1. **Unit tests**: Business logic, validation, edge cases
2. **Contract tests**: API request/response schemas
3. **E2E tests**: Full flows

### Role-based Testing
- **Root user**: Full permissions
- **SAM user**: Limited permissions
- **Test both**: Different code paths, authorization checks

### Test Structure (AAA Pattern)
```java
@Test
void shouldReturnSimWhenValidId() {
    // Arrange
    String simId = "sim-123";
    when(repository.findById(simId)).thenReturn(Optional.of(sim));
    
    // Act
    Sim result = service.getSim(simId);
    
    // Assert
    assertThat(result.getId()).isEqualTo(simId);
}
```

## Operational Standards

### Logging
- **Format**: Structured JSON logs
- **Context**: Request ID, operator ID, trace ID
- **Levels**: DEBUG (dev), INFO (prod), ERROR (always)

### Metrics
- **Required for new endpoints**: Success/failure/latency
- **Tool**: CloudWatch Metrics
- **Format**: EMF (Embedded Metric Format)

### Feature Flags
- **When**: Risky changes, gradual rollout
- **Tool**: LaunchDarkly or environment variables
- **Pattern**: Kill switches, percentage rollouts

## Deployment

### Method
- **Channel**: Slack #dev-backend-github
- **Flow**: Push to GitHub → bot posts deploy button → click to deploy
- **Tool**: AWS CodeDeploy

### Routing Configuration
- **File**: `soracom-api-gateway/src/etc/routes.*.yaml`
- **Format**: YAML mapping routes to services

### Dynamic Routes (Dev/Staging Only)
- **Header**: `X-Soracom-DynamicRoutes`
- **Purpose**: Test new routing without gateway restart
- **Production**: NOT enabled

## Auth Standards

### Java Services
- **Library**: `auth-lib`
- **Usage**: Spring Security integration

### Go/Lambda Services
- **Library**: `heimdall-v2`
- **Usage**: Middleware for JWT validation

### Lambda Tags
- **Required**: `soracom:api-provider`
- **Purpose**: Permission scoping, billing

## Common Patterns

### DTO Pattern
```java
@Data
@NoArgsConstructor  // Required for Jackson
@Builder
public class SimResponse {
    private String simId;
    private String status;
    private Long createdAt;  // Unix epoch millis
}
```

### Service Layer Pattern
```java
@Service
@RequiredArgsConstructor  // Lombok injects dependencies
@Slf4j
public class SimService {
    private final SimRepository repository;
    
    public SimResponse getSim(String simId) {
        log.info("Fetching SIM: {}", simId);
        return repository.findById(simId)
            .map(this::toResponse)
            .orElseThrow(() -> new SimNotFoundException(simId));
    }
}
```

### Error Handling
- **Error codes**: AAA0000 format (see API standards)
- **Don't**: Include user input in error messages (security risk)
- **Do**: Log full details, return sanitized messages
