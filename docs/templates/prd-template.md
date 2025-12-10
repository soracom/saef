# Product Requirements Document: <Feature Name>

| Field | Value |
|-------|-------|
| **Requester** | `<Name, Role, Team>` ← from business-statement.md |
| **Owner** | `<Name>` (assigned during PRD) |
| **Team** | `<Frontend / Backend / CRE>` ← from repo analysis |
| **Target Launch** | `<YYYY-MM-DD or Q3 2025>` |
| **Context Links** | ProductBoard: `<url>` <br> Shortcut: `<url>` <br> Slack: `<url>` ← from business-statement.md |

---

## 1. Context & Problem

### Current Situation
[Describe the current state - what exists today, what customers/users experience]

### Problem Statement
[Clear statement of the problem this feature solves - be specific with evidence]

### Why Now?
[Explain urgency: customer commitment, compliance deadline, competitive pressure, or efficiency driver]

---

## 2. Goals & Success Metrics

### Business Goals
[What business outcomes does this achieve?]

### Success Metrics
| Metric | Baseline | Target | Owner | How to Measure |
|--------|----------|--------|-------|----------------|
| `<Primary metric>` | `<Current state>` | `<Goal>` | `<Team>` | `<Measurement method>` |
| `<Secondary metric>` | `<Current>` | `<Goal>` | `<Team>` | `<Method>` |

---

## 3. Target Users & Scope

### Target Users
| User Type | Use Case | Frequency | Current Pain |
|-----------|----------|-----------|--------------|
| `<Persona>` | `<What they need>` | `<How often>` | `<Current problem>` |

### Scope & Priority

| Priority | Description | Rationale |
|----------|-------------|-----------|
| **P1 (Must-have)** | `<Critical features>` | `<Why required for launch>` |
| **P2 (Should-have)** | `<Important but not blocking>` | `<Value vs effort>` |
| **P3 (Nice-to-have)** | `<Future enhancements>` | `<Why defer>` |

### Out of Scope
- `<Item explicitly excluded>`
- `<Why it's not included>`

### Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| `<What could go wrong>` | `<High/Med/Low>` | `<How to prevent/handle>` |

---

## 4. Requirements

*Include relevant subsections based on feature type. Delete sections that don't apply.*

---

### 4A. Operational Requirements
*Include this section for billing, pricing, GTM, or operational features.*

#### GTM Strategy
- Acquisition path (self-serve, staff-provisioned, invite-only)
- Launch communications (customer-facing, internal enablement)
- Required approvals (pricing, legal, compliance)

#### Pricing & Billing
- Pricing model (fixed, usage-based, tiered)
- Payment cycle (monthly, annual, one-time)
- Currency support
- Tax/accounting requirements

#### Regional & Regulatory
- Target countries/regions
- Regulatory requirements (GDPR, tax, data residency)
- Localization needs

#### Staff Configuration Needs
[What can internal teams configure? Who controls it (backend script vs Ops UI)?]

| Configuration Item | Priority | Owner | Interface |
|--------------------|----------|-------|-----------|
| `<What to configure>` | High/Med/Low | `<Team>` | `<Internal Console / Script / API>` |

#### Use Cases (Operational Flows)
##### UC01: `<Primary happy path>`
1. `<Actor>` does `<action>`
2. `<System>` responds with `<result>`
3. `<Output/notification>`

##### UC02: `<Alternate path or termination>`
1. ...

---

### 4B. Product Requirements
*Include this section for UX, console, or customer-facing features.*

#### Hypothesis
[What do we believe will happen if we build this?]

#### User Journey
[Step-by-step flow from user perspective]

1. User arrives at `<page/state>`
2. User sees/does `<action>`
3. System responds with `<feedback>`
4. User completes `<goal>`

#### Design Patterns
[Reference design mocks, wireframes, or describe key UI patterns]

- Pattern 1: `<When this happens>`
  - Display: `<What user sees>`
  - Interactions: `<Available actions>`

- Pattern 2: `<Alternate state>`
  - Display: `<Different UI>`
  - Interactions: `<Actions>`

#### Measurement & Analytics
- Event tracking: `<What to track>`
- Dashboard/monitoring: `<What to observe>`
- A/B test plan (if applicable)

#### Content Requirements
[Bilingual content needs, help text, error messages]

---

### 4C. Technical Requirements
*Include this section for API, backend, or integration features.*

#### API Endpoints (if applicable)
| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| `POST` | `/api/v1/<resource>` | `<What it does>` | `<Required role>` |
| `GET` | `/api/v1/<resource>` | `<What it does>` | `<Required role>` |

#### Data Model
| Entity | Key Attributes | Relationships | Retention |
|--------|----------------|---------------|-----------|
| `<EntityName>` | `<Fields>` | `<Links to other entities>` | `<How long to keep>` |

#### Integration Points
- Internal: `<Which services/APIs this depends on>`
- External: `<Third-party integrations>`
- Events/Messaging: `<Queue/webhook needs>`

#### Performance Requirements
- Latency: `<Response time targets>`
- Throughput: `<Requests per second>`
- Scalability: `<Expected load>`

#### Security & Permissions
- Authentication: `<How users authenticate>`
- Authorization: `<Role-based access control>`
- Audit logging: `<What to log>`

#### Migration & Compatibility
- Backward compatibility needs
- Data migration plan (if applicable)
- Rollback strategy

---

## 5. Implementation

### Effort Estimate
- Story points: `<Total>`
- Rationale: `<Why this estimate>`

### Phases & Rollout
| Phase | Scope | Exit Criteria |
|-------|-------|---------------|
| Phase 1 | `<MVP slice>` | `<What "done" looks like>` |
| Phase 2 (optional) | `<Next increment>` | `<Criteria>` |

### Dependencies
- Blocking: `<Must have before starting>`
- Related: `<Parallel work or follow-up>`

### Quality Checklist
Reference: `./quality-checklist.md`

Key requirements:
- [ ] Unit tests written
- [ ] Integration tests written
- [ ] E2E tests (Root + SAM users)
- [ ] Bilingual i18n keys (if UI feature)
- [ ] API documentation updated
- [ ] Error codes documented

---

## 6. Open Questions & Links

### Open Questions
1. `<Question blocking spec/implementation>`
2. `<Decision needed>`

### Supporting References
- Business Statement: `./business-statement.md`
- Pattern Analysis: `./pattern-analysis.md`
- UX Evidence: `./ux-evidence.md`
- Repository Analysis: `./repo-analysis.md`
- Technical Spec: `./api-spec.yaml` (to be created)
- Test Plan: `./test-plan.md` (to be created)

### External Links
- ProductBoard: `<url>`
- Shortcut: `<url>`
- Slack discussions: `<url>`
- Design mocks: `<url>`
