# Business Statement / ビジネスステートメント: <Feature Name>

**Date**: <YYYY-MM-DD>
**Submitted by**: <Name, Role, Team>
**Slug**: <YYYY-MM-DD-feature-slug>

---

## 0. Executive Summary / エグゼクティブサマリー

[3-4 bullet points for quick review]

- **Situation / 背景:** <Current state and problem - be specific>
- **Proposal / 提案:** <What we're considering building>
- **Impact / 期待効果:** <Who benefits and how much? Use numbers: "50 users save 25 hrs/week">
- **Stakeholders / 関係者:** <Who needs to review and approve>

---

## 1. Business Statement / 課題定義

### The Customer Problem

[Describe the actual pain customers/users experience. Be specific - "CRE team members spend 2 hours per day switching between 4 tools" not "CRE needs better tools"]

**Affected Users**:
- **Who**: <Specific user types - "50-person CRE team", "200+ enterprise customers">
- **Frequency**: <How often they hit this pain - "daily", "during every escalation", "monthly">
- **Current Workaround**: <What they do today - "manual export to Excel", "Slack bot queries">

### Why This Matters

[Explain business impact - revenue, cost, customer satisfaction, compliance, competitive position]

### Why Now / 緊急性

[Explain urgency with specifics:]
- Customer commitment: "Customer X committed to renewal contingent on this by Q2 2025 (contract value $200K)"
- Compliance: "GDPR audit Q3 2025 requires audit trail"
- Competitive: "Lost 3 deals to Competitor X with this feature"
- Efficiency: "CRE team growth frozen until efficiency improves"
- OR: "No specific deadline but efficiency improvement"

### Strategic Alignment / 事業整合

[How this fits with Soracom's direction - customer self-service, operational efficiency, enterprise expansion]

---

## 2. Personas & Scenarios / ペルソナと利用シナリオ

| Persona | Job Role | Key Scenario | Frequency | Current Pain Point |
|---------|----------|--------------|-----------|-------------------|
| Yuki (CRE) | Customer Reliability Engineer | Investigate subscriber issue during escalation | Daily (5-10 times) | Switches between console, Slack bot, DynamoDB to find history |
| [Add 1-2 more personas] | | | | |

---

## 3. Key Features / 提供機能

[Prioritized list of capabilities in plain language]

| Priority | Feature | Description | User Value |
|----------|---------|-------------|------------|
| P0 (Must have) | Display subscriber update history | Show all changes to subscriber config in timeline table | Saves 30 min per investigation - no more DynamoDB console access |
| P1 (Should have) | Highlight changed fields | Yellow background for fields that changed | Instant visual identification of what changed |
| P2 (Could have) | Export history to CSV | Download button for full history | Enables offline analysis and reporting |

**Out of Scope for Initial Release**:
- [ ] Edit/rollback capability (read-only for now)
- [ ] Real-time notifications of changes (future enhancement)
- [ ] [Other items explicitly not included]

---

## 4. Business Outcomes / 成果指標

[Specific, measurable outcomes that engineers can verify post-launch]

| Outcome Metric | Baseline (Current) | Target (Post-Launch) | Owner | How to Measure |
|----------------|-------------------|---------------------|-------|----------------|
| Mean Time To Resolution (MTTR) for subscriber issues | 45 minutes | 20 minutes | CRE Team | CloudWatch logs, weekly aggregate |
| Tool switches per investigation | 4 tools (console + Slack + DynamoDB + docs) | 1 tool (console only) | CRE Team | User survey after 30 days |
| CRE team satisfaction with tooling | 3.2/5 (last survey) | 4.5/5 | CRE Manager | Survey 60 days post-launch |

**Success Criteria**:
- [ ] 80%+ of CRE team members use this feature within first month
- [ ] MTTR reduction validated by CloudWatch data after 60 days
- [ ] Zero escalations requiring DynamoDB console access after 90 days

---

## 5. Business Model Canvas Snapshot

### Customer Segments / 顧客セグメント
**Who pays for or uses this**:
- Internal: CRE team (50 engineers)
- Indirect benefit: Enterprise customers (faster support resolution)

### Value Proposition / 価値提案
**Core benefit in one sentence**:
- Reduce investigation time by 55% (45min → 20min) through consolidated tooling

### Channels & Relationships / チャネルと関係
**How users access this**:
- Internal console (soracom-internal-console-monorepo)
- Training: 30-minute demo session for CRE team

### Revenue & Cost Structure / 収益とコスト
**Financial implications**:
- Revenue impact: Indirect (better support → higher retention)
- Cost savings: 25 hours/week CRE capacity (50 engineers × 30min/day)
- Development cost: ~5-8 story points (2-3 weeks)

### Key Activities, Resources, Partners / 活動・リソース・パートナー
- Activities: Build internal console feature, test with Root/SAM users
- Resources: 1 backend engineer, 1 frontend engineer, CRE for UAT
- Partners: CRE team for requirements validation and testing

### Risk & Mitigation / リスクと緩和策
- **Risk**: Data volume too large for client-side pagination
  - **Mitigation**: Follow user-console pattern (works for <50 records), add server-side pagination if needed later
- **Risk**: SAM users see data they shouldn't access
  - **Mitigation**: Test SAM user permissions thoroughly, follow existing permission patterns
- **Risk**: Engineers rely on this instead of fixing root causes
  - **Mitigation**: Track investigation time - if not decreasing, investigate why

---

## 6. Open Questions / 未解決事項

- [ ] Should this be read-only or allow rollback capability? (Propose: read-only for initial release)
- [ ] Which subscriber fields to track? (Propose: all config changes - tags, group_id, speed_class, etc.)
- [ ] Data retention period? (Propose: follow existing audit log retention - 90 days)

---

## 7. References / 参考情報

**Source Links**:
- Customer escalation: [Slack thread URL]
- Similar feature request: [Shortcut ticket SC-1234]
- Competitive analysis: [Competitor X has similar feature]
- Related documentation: [Internal wiki, RFC, design doc]

---

**Next Step**: SAT team reviews this business statement and discusses prioritization. If approved, proceed to `/saef:prd` for technical specification.
