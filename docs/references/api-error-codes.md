# Soracom API Error Code Prefixes

This table replaces the `.archive/.context/SORACOM API Error Code Prefixes` reference. Use it during `/saef:spec`, `/saef:plan`, and `/saef:implement` whenever you add new API errors or need to verify ownership.

| Prefix | Component | Owning Team / Slack | Repository |
| --- | --- | --- | --- |
| `AGW` | soracom-api-gateway (ogu proxy) | Ogu (`@ogu-team`) | `soracom/soracom-api-gateway` |
| `ANA` | analysis / query APIs | Data Platform | `soracom/query-api-go` |
| `AUM` | auth-manager | Backend Core (`@backend-core-team`) | `soracom/auth-manager` |
| `BIL` | billing (billing domain) | Backend Core | `soracom/billing` |
| `CEL` | cell-locations | Ogu | `soracom/cell-locations` |
| `COM` | dipper-common (shared errors) | Backend Core | `soracom/dipper-common` |
| `DEM` | device-manager | Orion | `soracom/device-manager` |
| `DIC` | dipper-play-common (library) | Backend Core | `soracom/dipper-play-common` |
| `DIG` | diagnostic-manager | CRE | `soracom/diagnostic-manager` |
| `DSB` | downstream-billing-api | Backend Core | `soracom/downstream-billing-api` |
| `EVS` | event-scheduler | Ogu | `soracom/event-scheduler` |
| `FAT` | flux-app-template-api | Flux | `soracom/flux-app-template-gallery` (api folder) |
| `FCA` | flux-credit-api | Flux | `soracom/flux-credit-api` |
| `FEM` | file-entries-manager / LPWA gadget manager | Artemis | `soracom/lpwa-gadget-manager` |
| `FLX` | flux-core | Flux | `soracom/flux-core` |
| `HFE` | harvest-files-event-poster | Ogu | `soracom/harvest-files-event-poster` |
| `HMD` | heimdall-v2 | Ogu | `soracom/heimdall-v2` |
| `KEM` | key-manager | Orion | `soracom/key-manager` |
| `LGI` | logistics-api | Backend Core | `soracom/logistics` |
| `MSB` | model-s-server | Backend Core | `soracom/model-s-server` |
| `NTA` | notification-service | Ogu | `soracom/notification-service` |
| `PAY` | billing (payments) | Backend Core | `soracom/billing` |
| `QIA` | query-intelligence-api | Data Platform | `soracom/chatdb-core` |
| `SAP` | a2p-server (SMS A2P) | Backend Core | `soracom/a2p-server` |
| `SBX` | API sandbox | Ogu | `soracom/dipper-local` |
| `SCA` | sora-cam-devices-api | Cloud Camera | `soracom/sora-cam-devices-api` |
| `SCH` | searchlight-api | Data Platform | `soracom/searchlight` |
| `SCN` | sora-cam-notification-api | Cloud Camera | `soracom/sora-cam-atom-events` |
| `SEM` | session-manager | Orion | `soracom/session-manager` |
| `SIC` | soracom-internal-console-api | CRE | `soracom/soracom-internal-console-api` |
| `SLM` | soralet-manager / orbit runtime | Ogu | `soracom/orbit-runtime` |

**Usage notes**
- Prefix format: `AAA0000` (`AAA` = component prefix above, `0000` = sequential digits you control).
- Document new prefixes in this file whenever you add a backend component so SAEF agents can route issues correctly.
- Avoid duplicating prefixes—coordinate with platform/SAT team if a new service needs an identifier.
- You can confirm prefixes by causing validation errors against the API reference endpoints (they return the component prefix in the `code` field).
- API Gateway routes (`soracom-api-gateway/src/etc/routes.*.yaml`) show the destination host/component for each path; use them when mapping traffic to teams.

