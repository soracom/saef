# SAEF End-to-End Workflow (Feature & Product)

This document replaces the legacy `.archive/.context/notes.md` information. Use it whenever you need to explain the human-in-the-loop (HITL) checkpoints, MCP integrations, or sub-agent orchestration that SAEF assumes.

## 1. Feature Workflow
1. **Preparation**
   - Clarify the customer problem, business value, and urgency.
   - Check for duplicate requests in ProductBoard and existing Shortcut stories.
   - Use HITL/MCP prompts to gather missing context directly from stakeholders when needed.
2. **Research & Planning**
   - Audit relevant repos and past stories.
   - Produce `business-statement.md` and `prd.md` using the standard template (executive summary, personas, outcomes, lean canvas).
   - Define sub-agents (RL/HITL/MCP/SAge) if specialized expertise is needed.
3. **Implementation**
   - Draft the technical spec and associated tests.
   - Assign language/domain-specific sub-agents for code, while HITL reviewers verify quality gates.
   - Ensure tests map directly to PRD requirements.
4. **UAT & QA**
   - Deploy to staging/local.
   - Confirm SDS + localization for frontend, API standards for backend.
   - Verify endpoints and integrations are reachable; log multi-modal evidence (screenshots, recordings).
5. **Integrations**
   - MCP services: Shortcut (`get_stories`), Notion (read/create), Slack (notifications), GitHub (PRs), ProductBoard (insights).
   - Use these consistently so SAEF commands can audit progress automatically.

## 2. Product Workflow (MRD-level)
1. **Preparation**
   - Define MRD, rationale, timelines, and business metrics.
   - Research ProductBoard insights and existing repos relevant to the product scope.
2. **Research & Planning**
   - Q&A loop with stakeholders.
   - Compile PRD-like artifacts at the product level (front matter, context, goals).
3. **Implementation**
   - Create technical design, tests, and tasks, leveraging Falcon or other templates when available.
   - Assign specialized sub-agents per discipline.
4. **UAT & QA**
   - Stage/local validation across the entire product surface.
   - Confirm backend/frontend standards as above.
5. **Human-in-the-Loop Verification**
   - Generate manual verification test cases before launch.
   - Require sign-off from product/SAT leads and QA observers.
6. **Integrations**
   - Same MCP stack as the feature workflow (Shortcut, Notion, Slack, GitHub, ProductBoard).

Keep this document synchronized with any future SAEF process changes so commands and skills never need to reference `.archive/.context/notes.md` again.

