# API Spec Quality Checklist

Use this checklist to self-evaluate API specification quality before finalizing.

## OpenAPI Structure Check

- [ ] All endpoints use `snake_case` paths (e.g., `/sims/{sim_id}/delete_session`)?
- [ ] Tags use `PascalCase`?
- [ ] operationIds use `camelCase` and are globally unique?
- [ ] Path parameters use `snake_case` within `{ }`?
- [ ] Error codes follow `AAA0000` pattern (e.g., `COM0001`, `AGW0008`)?

## Soracom API Standards

- [ ] Base file (`apidef/prod/base/`) contains structure only (paths, schemas, params) - NO descriptions?
- [ ] i18n files (`apidef/prod/i18n/{ja,en}/`) contain summaries and descriptions only?
- [ ] Timestamps are Unix epoch integers (not ISO8601 strings)?
- [ ] Only documented status codes: `200/201/204/400/401/403/404` (never 5xx)?

## Test Plan Coverage

- [ ] Test plan targets 15-25 tests (not 77)?
- [ ] Test count informed by pattern-analysis.md if available?
- [ ] Tests categorized: Unit, Contract, Integration, E2E?
- [ ] Role-based scenarios included (Root user AND SAM user)?
- [ ] Edge cases covered (empty states, invalid input, boundary values)?

## Quality Signals

| Signal | Criteria | Action |
|--------|----------|--------|
| ✅ **Green** | All checks pass | Ready for /saef:implement |
| ⚠️ **Yellow** | 1-2 minor gaps | Note in Open Questions, proceed with caution |
| ❌ **Red** | 3+ gaps or security concerns | Stop and resolve before proceeding |

## Common Issues to Avoid

1. **Over-testing**: Don't generate 77 tests when 15-25 is appropriate
2. **Wrong error codes**: Use `AAA0000` format, not generic `ERROR_001`
3. **ISO timestamps**: Use Unix epoch integers instead
4. **Missing role tests**: Always include both Root and SAM user scenarios
5. **Vague test names**: Use `<action>_<condition>_<expectedResult>` pattern

## Validation Commands

Before finalizing:
```bash
# Validate base + internal builds
make && make internal

# Check for common issues
grep -r "ERROR_" outputs/<slug>/api-spec.yaml  # Should not find generic errors
```

## References

- [pattern-discovery.md](pattern-discovery.md) - For test count guidance from similar features
- `docs/references/api-error-codes.md` - Standard error code prefixes
- `.claude/skills/soracom-backend-guidelines/references/openapi-development.md` - Full API standards
