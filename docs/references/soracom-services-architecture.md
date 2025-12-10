# Soracom Services Architecture

This summary replaces the legacy `.archive/.context/SORACOM services architecture.md` reference. Use it when you need to explain how Soracom’s connectivity and application services route traffic through the core network components.

## 1. Core Connectivity (Air / VPG / Arc)
- **Session Manager (Orion team)** – Manages SIM sessions, VPG routing, GTP-C/U control, and exposes subscriber/group APIs. Hosts include `session-manager-api-soracom.dyn.soracom.com`.
- **Auth Manager (Backend Core)** – Performs SIM/auth token validation for both cellular (Diameter/SIGTRAN) and internet entry points.
- **Tier1 / Tier2 (nwepc)** – LTE/3G packet core landing zones. Traffic flows UE → Tier1 (GTP) → Tier2 (nwepc) → Soracom services or customer networks.
- **VPG (Virtual Private Gateways)** – Provides customer-specific routing (Canal/Direct/Door/Gate). Controlled via Session Manager APIs.
- **Arc** – WireGuard-based virtual SIM service that enters the same Tier1/Tier2 pipeline via ArcTier1/Tier2 components.

## 2. Device & Metadata Services
- **Device Manager (Orion)** – Device registry, bootstrap (LwM2M), and LWM2M server integration.
- **Key Manager (Orion)** – Key agreement / credential distribution (used by Krypton).
- **Data Manager (Artemis)** – Stores sensor data (Harvest/Data APIs). Hosted at `data-manager-soracom.dyn.soracom.com`.
- **File Manager / Datafiles Manager (Artemis)** – Handles Harvest Files uploads and S3 persistence.
- **Inventory** – Combines Device Manager + LwM2M bootstrap/read/write to orchestrate lifecycle management.

## 3. Application & Integration Services
- **Beam / Funnel / Funk** – Tier2 (beam-proxy) forwards traffic to customer endpoints (HTTP, MQTT, Lambda) or Soracom-hosted functions.
- **Endorse / Krypton** – Build on Tier2 + Key Manager to mint credentials securely over cellular or public internet.
- **Harvest Data / Harvest Files** – Tier2 + Data Manager/Datafiles Manager + DynamoDB/S3 for storage and visualization.
- **Lagoon / Mosaic** – Visual layers on top of Harvest data with Grafana components.
- **Napter** – Remote access (port forwarding) using Tier1+VPG+MAEB proxy pipeline.
- **Peek** – Traffic mirroring service that funnels packets via Tier1 / VPG into collectors stored on S3.

## 4. Analytics & Data Platform
- **Searchlight (Data Platform team)** – Fronts Elasticsearch/Snowflake queries from apps like Query Intelligence; runs behind `jp.api.searchlight.soracom.io` via ogu-proxy.
- **Who-can-do / internal data console** – Slack/BI tooling that sits on top of the same data platform services.
- **Snowflake Ownership** – Managed by the Data Platform team (Shogo, Christian, Koki). Any feature touching Snowflake, Searchlight, or Query Intelligence should involve them.

## 5. Cloud Camera (SoraCam)
- **sora-cam-devices-api** – Go/Lambda service with CDK deployments (`jp-prod.sora-cam-devices-api.soracom.com`).
- **Atom/Kepler components** – Support cloud camera streaming and device provisioning; deployments handled by Cloud Camera Services team.

## 6. Diagnostic & Support Tooling
- **Diagnostic Manager (CRE)** – Lambda-based troubleshooting API invoked by internal tools.
- **Internal Console** – Angular front-end + `soracom-internal-console-api` backend for CRE/support workflows.

## 7. Host ↔ Team Mapping
Use `src/etc/routes.jp-production.yaml` in `soracom-api-gateway` to confirm ownership:
- `billing-soracom.soracom.io` → Backend Core
- `session-manager-api-soracom.dyn.soracom.com` → Orion
- `data-manager-soracom.dyn.soracom.com` → Artemis
- `jp.api.searchlight.soracom.io` → Data Platform
- `files-manager-soracom.dyn.soracom.com` → Artemis
- `jp-prod.sora-cam-devices-api.soracom.com` → Cloud Camera Services

Keep this document updated whenever new services (or ownership changes) are introduced so SAEF has a single place to reference the system landscape.

