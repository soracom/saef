# Repository Analysis: <Feature Name>

## Repository Availability

**Analysis Completeness**: [Complete | Partial | Unable to Analyze]

| Repository | Available | Analyzed | Notes |
| :--------- | :-------- | :------- | :---- |
| user-console-monorepo | ✓/✗ | Yes/No | [Reason if not analyzed] |
| soracom-api | ✓/✗ | Yes/No | [Reason if not analyzed] |
| billing | ✓/✗ | Yes/No | [Reason if not analyzed] |
| [other repos] | ✓/✗ | Yes/No | [Reason if not analyzed] |

**Missing Repositories Impact**:
> If any critical repos are unavailable, explain impact on analysis accuracy. For example:
> "user-console-monorepo not available - UI patterns and SDS component usage could not be analyzed. Recommendations are based on documentation only."

**To clone missing repositories**:
```bash
git clone git@github.com:soracom/<repo>.git repos/<repo>
```

---

## Repository: <Repo Name>

### 1. Documentation Review
- [ ] Read `docs/` folder
- [ ] Read `README.md` / `CLAUDE.md`
- [ ] Checked for architecture diagrams

### 2. Existing Patterns
- [ ] Authentication/Authorization patterns
- [ ] Database access patterns
- [ ] Similar API endpoints
- [ ] Error handling conventions

### 3. Implementation Plan
- [ ] **Exists:** [List features that already exist]
- [ ] **To Create:** [List features needing implementation]
- [ ] **To Extend:** [List features to be modified]

### 4. Constraints & Risks
- [ ] Technical debt
- [ ] Performance concerns
- [ ] Security considerations
