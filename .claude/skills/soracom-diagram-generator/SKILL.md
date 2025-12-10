---
name: soracom-diagram-generator
description: Creates Mermaid/PlantUML diagrams (architecture, sequence, flow) from SAEF artifacts. Use when visualizing system design or documenting workflows.
---

# Soracom Diagram Generator Skill

Use this skill whenever a feature needs visual artifacts (architecture overviews, data flows, sequence diagrams, state machines) for documentation, reviews, or release notes.

## Responsibilities

1. **Gather context**
   - Read `outputs/<slug>/prd.md`, `api-spec.yaml`, `test-plan.md`, and `repo-analysis.md`.
   - Identify entities (services, APIs, users), interactions, and noteworthy constraints.
2. **Select diagram type**
   - **Architecture / component view** – show services, queues, data stores.
   - **Sequence / swimlane** – show user ↔ API ↔ backend flows.
   - **State / lifecycle** – show SIM/device status transitions or approval flows.
   - **Data flow** – show information moving between systems (billing, auth, console).
3. **Generate diagram source**
   - Prefer **Mermaid** fenced blocks (` ```mermaid ... ````) so GitHub previews render automatically.
   - Fall back to **PlantUML** when advanced notation is needed (e.g., state machines) and note that `plantuml` CLI must convert to PNG/SVG before publishing.
4. **Explain embedding**
   - For Markdown docs: embed Mermaid directly.
- For repos that require static assets: run `mmdc`/`plantuml` locally, store PNG/SVG under `outputs/<slug>/diagrams/`, and reference with relative paths.

## Workflow

1. **Classify the request**
   ```text
   - Diagram purpose?
   - Target audience? (SAT engineers, docs readers, exec)
   - Output format? (Mermaid markdown, PNG, SVG)
   - Where will it live? (feature folder, Confluence, wiki)
   ```
2. **Extract key objects**
   - Actors (Root user, SAM user, backend service, external system)
   - Data stores / queues (SIM DB, Billing, Auth)
   - Triggers / events (webhook, cron, manual action)
3. **Draft Mermaid skeleton**
   ```mermaid
   sequenceDiagram
     participant User
     participant Console
     participant API
     participant Service
   ```
4. **Annotate with constraints**
   - Add notes (`Note right of ...`) for permission checks, retries, SLAs.
   - Include error branches when documented in PRD/spec.
5. **Review against quality checklist** (below).
6. **Publish**
- Save diagram source to `outputs/<slug>/diagrams/<name>.mmd`.
   - If PNG/SVG required: run `npx @mermaid-js/mermaid-cli -i ... -o ...`.
- Update feature documentation (e.g., `outputs/<slug>/docs/docs-en.md`) with embeds and brief descriptions.

## Diagram Quality Checklist

- [ ] Actors and systems match names used in PRD/spec (pay attention to case).
- [ ] Sequence flows include success + error / retry states where relevant.
- [ ] Sensitive identifiers (SIM ICCID, auth secrets) are masked.
- [ ] Legend or labels included when using shorthand icons.
- [ ] Diagram stored alongside feature (`outputs/<slug>/diagrams/`) with version suffix if multiple iterations (`-v1`, `-v2`).

## Tips

- Use **class diagrams** (Mermaid `classDiagram`) when clarifying domain models extracted from PRD data requirements.
- Use **state diagrams** for SIM/device lifecycle stories.
- For infra topologies, consider PlantUML + AWS icons but always export to SVG/PNG for final docs.
- Keep Mermaid blocks under 120 lines; break complex systems into multiple diagrams instead of crowding.

## Integration with `/saef:docs`

- `/saef:docs` can invoke this skill after screenshots are captured to add architecture/sequence visuals to `outputs/<slug>/docs/docs-ja.md` / `docs-en.md`.
- `/saef:spec` may also call the skill when API reviewers request a flow diagram—store interim diagrams under `outputs/<slug>/diagrams/` and reference them in PRD/spec.
