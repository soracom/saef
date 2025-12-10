# Example PRD: Managed Service & Enterprise Support Billing

| Field | Value |
| :---- | :---- |
| **Feature Name** | Managed Service & Enterprise Support Billing |
| **Phase / Status** | PRD Review |
| **Product Manager** | Kana Morita |
| **Business Owner / TPM** | Richard Lee |
| **Program Manager** | Services Enablement |
| **Related Team** | Customer Reliability Engineering (CRE) |
| **ProductBoard URL** | https://productboard.soracom.example/ideas/msa-billing |
| **Shortcut Epic** | https://shortcut.example.com/epic/SAEF-458 |
| **Target Launch Date** | 2025-03-31 |
| **Last Updated** | 2025-01-15 |

## 1. Introduction

Customers in the English-speaking market expect Soracom to operate their connectivity stack and provide enterprise-grade support with defined SLAs. Current billing flows only handle one-off professional services or self-service subscriptions. This project delivers subscription management for staff-provisioned Managed Service (MS) and Enterprise Support Plan (ESP) contracts, covering both monthly and annual offerings.

## 2. Target Customers & Use Cases

| Segment | Requirement |
|---------|-------------|
| Integrators bundling Soracom connectivity | Custom recurring fee configured per project, invoiced monthly by Soracom. |
| Enterprises requiring named 24/7 support | Annual pre-pay invoices with regional tax compliance. |
| Channel partners using third-party billing | 0 USD listing to show Soracom involvement while the partner invoices the customer directly. |

## 3. Goals

- Launch MS/ESP billing for at least 12 MS customers and 8 ESP customers by FY25 end.
- Reduce custom-support contracting cycle from 6 weeks to 2 weeks.
- Generate monthly recognized-revenue exports for every annual pre-pay account.
- Ensure internal staff can configure, suspend, and terminate subscriptions without engineering tickets.

## 4. Target Countries

| Region | Priority | Notes |
|--------|----------|-------|
| United States | High | Avalara integration for tax calculation. |
| Canada | High | PST/GST combination per province. |
| Mexico | Medium | USD invoicing with MXN memo lines. |
| Brazil | Medium | Portuguese invoice description required. |
| EU + UK | Medium | Reverse charge vs domestic VAT rules. |
| Japan | Low | Architecture must remain extensible for domestic parity. |

## 5. GTM Strategy

- Customers do not self-activate MS/ESP. Account teams submit a request; CRE configures pricing through the internal console.
- Marketing publishes a landing page explaining value; CTA routes to a sales form.
- Enablement package includes an onboarding checklist, billing FAQ, and internal runbook for CRE and Finance.

## 6. System Requirements

### 6.1 Pricing Model

| Priority | Requirement | Rationale |
|----------|-------------|-----------|
| High | Custom fixed recurring price per contract. | Reflects unique staffing needs and agreed scope. |
| Medium | 0 USD line item while still displaying service name. | Partners may bill customers separately but need invoice visibility. |
| Out of scope | Percentage-based billing. | Difficult to audit and reconcile. |

### 6.2 Billing Item Type

- MS/ESP charges appear on Service invoices alongside usage.
- Each entry references contract ID and description for audit trails.
- GL mapping: 7005 (Managed Service) and 7010 (Enterprise Support).

### 6.3 Payment Cycle

| Cycle | Behavior |
|-------|----------|
| Monthly | Charge appears every billing month until terminated. |
| Annual pre-pay | Charge appears in renewal month only; other months show $0. |
| One-time setup (optional) | Manual add-on triggered during activation. |

No prorated refunds; contracts describe the non-refundable policy.

### 6.4 Currency

- USD (primary).
- EUR (secondary) with ECB conversion snapshot at invoice creation.
- Architecture allows future JPY addition without schema updates.

### 6.5 Tax

| Scenario | Treatment |
|----------|-----------|
| US customer served by Soracom US | Avalara handles state-specific tax rates. |
| UK entity serving EU corporate | 0% VAT, reverse charge note. |
| UK entity serving UK corporate | 20% VAT. |
| Service provided to Japanese customers | Consumption tax TBD; add rule once finalized. |

### 6.6 Accounting & Reporting

- Annual pre-pay accounts produce a CSV with monthly recognized revenue.
- Export delivered to Finance S3 bucket on the first business day of each month.
- Audit log records activation, termination, and export generation events.

### 6.7 Termination / Suspension

- Staff can terminate immediately or schedule a future termination month.
- Monthly plans stop billing after the current cycle; annual plans stop at the next renewal.
- Optional "suspend" state pauses invoicing without deleting configuration (phase 3 target).

## 7. Operational Requirements

- Internal console fields: contract ID, custom price, currency, cycle, start date, optional end date, billing contact.
- Access limited to CRE and Finance roles; every change generates an audit event.
- Until UI launches, backend provides a CLI with identical validation.
- Monitoring: alert if a configured contract fails to appear on invoices or accounting exports.

## 8. Use Cases

### UC01: Start Monthly Plan
1. CRE specialist enters custom price, selects monthly cycle, activates plan.
2. Tax rules run based on customer address.
3. Monthly invoice lists the Managed Service line item with contract ID reference.

### UC02: Terminate Monthly Plan
1. Specialist selects contract and terminates it.
2. System flags the current month as the final billable period.
3. Next invoice omits the line item and records a termination log entry.

### UC03: Start Annual Plan
1. Specialist sets annual cycle and activation month.
2. Renewal-month invoice includes the annual fee; other months show $0.
3. Accounting export records monthly revenue recognition entries.

### UC04: Terminate Annual Plan
1. Specialist terminates contract; system marks the next renewal as non-billable.
2. Accounting export stops creating revenue rows after that renewal.
3. Ops receives confirmation email.

### UC05: Scheduled Termination
1. During activation, specialist selects a future termination month.
2. Scheduler executes termination automatically and sends notification to CRE and Finance.

### UC06: 0 USD Listing
1. Specialist sets price to 0 USD and activates plan.
2. Invoice displays the service name with a $0 charge for visibility.

## 9. Project Phases & Scope

| Phase | Scope | Exit Criteria |
|-------|-------|---------------|
| Phase 1 | UC01 + UC02, internal console configuration, invoice integration. | First MS customer billed monthly without manual adjustments. |
| Phase 2 | UC03 + UC04, accounting export, VAT logic. | Annual ESP customer billed with automated revenue recognition. |
| Phase 3 | UC05 + UC06, suspend state (time permitting). | Ops can schedule end dates and list zero-dollar services. |

## 10. Appendix

- SLA summary: MS response < 4 hours, ESP response < 1 hour.
- Diagram: `outputs/<slug>/diagrams/ms-billing.mmd`.
- Runbook: `outputs/<slug>/docs/runbook-ms-billing.md`.
- KPI dashboard: `outputs/<slug>/docs/kpi-ms-billing.csv`.
