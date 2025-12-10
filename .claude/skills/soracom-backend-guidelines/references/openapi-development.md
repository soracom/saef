# Soracom OpenAPI Development Playbook

This document supersedes the `.archive/.context/SORACOM API development guideline`. Use it when defining endpoints inside `soracom/soracom-api`, publishing API docs, or coordinating releases.

## 1. Repository Layout
- `apidef/prod/base/`: structure only (paths, schemas, params). **No descriptions.**
- `apidef/prod/i18n/{ja,en}/`: summaries/descriptions only.
- Generated bundles (`build/soracom-api.ja.yaml`, `.en.yaml`) feed the CLI, docs, and SDKs.

## 2. URI & Naming Rules
- Internal admin APIs: `/admin/{feature}/{resource}/{id}` (e.g., `/admin/orders/{order_id}`).
- Paths and path params are `snake_case`.
- Tags (service names) are `PascalCase`.
- `operationId` is `camelCase` and must be globally unique.
- Permission statements in SAM policies use the tag name and operationId (`CellLocation:getCellLocation`).

## 3. Data Types & Responses
- Timestamps are Unix epoch integers (seconds). Avoid ISO8601 strings.
- Success codes: `200` (body), `201` (created), `204` (no content).
- Do **not** document 5xx codes; unexpected errors must be handled centrally.
- Error payloads always include `code` (`AAA0000`) + `message` (user-readable with next action).

## 4. Definition Workflow
1. Draft structural changes under `apidef/prod/base/`.
2. Run `make && make internal` before committing; fix generator warnings immediately.
3. Add bilingual copy under `apidef/prod/i18n/{ja,en}/` once structure is approved.
4. Tag reviewers:
   - Structure: Ogu, component owners.
   - JP copy: `@makoto`.
   - EN copy: `@felix`.

## 5. Release Checklist
- Update API reference sites (JP via Makoto, EN via Felix).
- Update CLI: copy generated YAMLs into `soracom-cli` via `./scripts/copy-apidef-files.sh`.
- Run CLI tests with sandbox credentials (`SORACOM_AUTHKEY_ID_FOR_TEST`, `SORACOM_AUTHKEY_FOR_TEST`).
- Coordinate with ogu for releasing the new CLI build.

## 6. Routing & Deployment
- New servers require entries in `soracom-api-gateway/src/etc/routes.*.yaml` and sandbox configs (`soracom/dipper-local`).
- Document rollout steps and fallback plans inside `/saef:spec` and `/saef:release`.

## References
- `docs/references/api-error-codes.md` (general, stays in docs)
- `backend-engineering-standards.md` (same skill folder)
- `docs/references/backend-bom.md` (general, stays in docs)

