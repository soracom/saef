# Soracom Backend Engineering Standards

This document replaces the legacy `.archive/.context/Quality Guideline for Backend Engineers` reference. Use it whenever `/saef:spec`, `/saef:implement`, or code reviews need clarity on backend behaviors and human-in-the-loop checkpoints.

## 1. Design / 設計

- Remove ambiguity before implementation. Document open questions inside `prd.md` or `pattern-analysis.md`, not in chat.
- Break work into Shortcut stories with estimates, reviewers, and risk labels.
- Share early drafts with stakeholders so `/saef:spec` has a validated scope before tests are written.

## 2. Implementation / 実装

- Keep new code consistent with established patterns (error handling, auth, logging). Cite the repo analysis when deviating.
- Cover edge cases with JUnit 5 (backend) or Playwright (UI). Tests must pass before requesting review.
- Ask a subject-matter expert early—do not wait for review when you are unsure.

## 3. Review (Code Review) / レビュー

### Reviewee
- Ensure unit tests passed locally and CI is green.
- Explain the intent, background, and risk areas in the PR description.
- Split huge diffs; reviewers should never see unrelated refactors.

### Reviewer
- Check consistency with adjacent code, not just logic correctness.
- Point out concrete improvements (naming, missing tests, doc updates).
- Confirm quality gates (Spotless, lint, localization) before approval.

## 4. E2E Validation / E2E テスト

- Run end-to-end verification in dev/staging using real user scenarios.
- Confirm both Root and SAM users behave correctly—this is a recurring gap.
- After deployment, verify the change actually landed and no regressions exist.

## 5. HITL Touchpoints

- **Design HITL:** Product/SAT leads sign off before `/saef:spec` finishes.
- **Implementation HITL:** Senior backend owners approve before `/saef:implement` closes.
- **QA HITL:** Cross-team observers validate manual/automated checks ahead of `/saef:release`.

Keep this document updated whenever backend teams evolve their review practices so SAEF never has to read `.archive/.context/` again.

