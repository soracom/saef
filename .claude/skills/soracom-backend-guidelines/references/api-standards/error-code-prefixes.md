# SORACOM API Error Code Prefixes

Error codes in SORACOM APIs follow the format `XXX0000` where `XXX` is a three-letter prefix identifying the component and `0000` is a four-digit sequential number.

## Component Prefix Registry

| Prefix | Component | Owner | Repository |
|--------|-----------|-------|------------|
| `AGW` | soracom-api-gateway (ogu proxy) | ogu, kaz, harry | [soracom-api-gateway](https://github.com/soracom/soracom-api-gateway) |
| `ANA` | Analysis (query) | koki | [query-api-go](https://github.com/soracom/query-api-go) |
| `AUM` | auth-manager | backend team | [auth-manager](https://github.com/soracom/auth-manager) |
| `BIL` | billing (billing related) | backend team | [billing](https://github.com/soracom/billing) |
| `CEL` | cell-locations | ogu | [cell-locations](https://github.com/soracom/cell-locations) |
| `DEM` | device-manager | - | [device-manager](https://github.com/soracom/device-manager) |
| `DIC` | dipper play common (library) | - | [dipper-play-common](https://github.com/soracom/dipper-play-common) |
| `DIG` | diagnostic-manager | CRE, kaz | [diagnostic-manager](https://github.com/soracom/diagnostic-manager) |
| `DSB` | downstream billing | hiroki | [downstream-billing-api](https://github.com/soracom/downstream-billing-api) |
| `EVS` | event-scheduler | spears (ogu) | [event-scheduler](https://github.com/soracom/event-scheduler) |
| `FAT` | flux-app-template-api | flux team | [flux-app-template-gallery](https://github.com/soracom/flux-app-template-gallery/tree/main/api) |
| `FCA` | flux-credit-api | flux team | [flux-credit-api](https://github.com/soracom/flux-credit-api) |
| `FEM` | file-entries-manager | - | [lpwa-gadget-manager](https://github.com/soracom/lpwa-gadget-manager) |
| `FLX` | flux-core | flux team | [flux-core](https://github.com/soracom/flux-core) |
| `HFE` | harvest-files-event-poster | spears (ogu) | [harvest-files-event-poster](https://github.com/soracom/harvest-files-event-poster) |
| `HMD` | heimdall-v2 | ogu | [heimdall-v2](https://github.com/soracom/heimdall-v2) |
| `KEM` | key-manager | - | [key-manager](https://github.com/soracom/key-manager) |
| `LGI` | logistics-api | backend team | [logistics](https://github.com/soracom/logistics) |
| `MSB` | model-s-server (eSIM profile order) | backend team | [model-s-server](https://github.com/soracom/model-s-server) |
| `NTA` | notification-api | ogu | [notification-service](https://github.com/soracom/notification-service) |
| `PAY` | billing (payment related) | backend team | [billing](https://github.com/soracom/billing) |
| `QIA` | query-intelligence-api | koki | [chatdb-core](https://github.com/soracom/chatdb-core) |
| `SAP` | a2p-server (SMS A2P) | backend team | [a2p-server](https://github.com/soracom/a2p-server) |
| `SBX` | API sandbox | ogu | [dipper-local](https://github.com/soracom/dipper-local) |
| `SCA` | sora-cam-devices-api | sora-cam team (ogu) | [sora-cam-devices-api](https://github.com/soracom/sora-cam-devices-api) |
| `SCH` | searchlight-api | backend team | [searchlight](https://github.com/soracom/searchlight) |
| `SCN` | sora-cam-notification-api | sora-cam team (ogu) | [sora-cam-atom-events](https://github.com/soracom/sora-cam-atom-events) |
| `SEM` | session-manager | - | [session-manager](https://github.com/soracom/session-manager) |
| `SIC` | soracom-internal-console-api | backend team | [soracom-internal-console-api](https://github.com/soracom/soracom-internal-console-api) |
| `SLM` | soralet-manager | ogu | [orbit-runtime](https://github.com/soracom/orbit-runtime) |

## Usage Guidelines

When defining a new error code:

1. **Use your component's prefix** from the table above
2. **Choose a sequential number** (e.g., `BIL0023`, `AUM0045`)
3. **Define error codes directly in code** rather than generating them sequentially - this makes them easier to search for
4. **Include user action guidance** in error messages when possible

## Error Response Format

Error responses must include both `code` and `message`:

```json
{
  "code": "AUM0017",
  "message": "SAM user 'user1' doesn't have permission 'Role:listRoles' to perform this action. Please ask your administrator for SAM permission configurations/statements. After the correct permission has been applied, please sign in again and retry it."
}
```

**Security note:** Error messages should not include user input to prevent vulnerability attacks.

## Requesting New Prefixes

If you need to add a new component that's not listed above, coordinate with the backend team to:
1. Choose an available three-letter prefix
2. Update this registry
3. Document the component owner and repository
