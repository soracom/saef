---
title: "Improved SIM session history export"
labels: Improvements
japanOnly: false
publishOn: 2025-02-03T11:00:00+09:00
isDraft: true
---

# Summary
We refreshed the SIM session history export so global operators can pull 90-day datasets with consistent columns and timezone handling. Troubleshooting teams now have faster access to per-session latency data without opening support tickets.

## Details
- Added CSV download to the User Console subscriber page (`SIM Details → Session History`), using the same filters shown on-screen.
- Expanded the API to support UTC offsets and operator scoping; see `outputs/<slug>/docs/docs-en.md` for the new `timezone_offset` parameter.
- Root and SAM users see only the operators they manage, matching Shortcut ticket SRE-2189.

## Availability / Timeline
- Available globally on February 3, 2025.
- Applies to all Air SIM plans (plan01s, planX3, planP1) and virtual SIMs (Arc).

## How to Use / Next Steps
1. Navigate to **SIM Management → SIMs → (Select SIM) → Session History**.
2. Adjust filters (date range, operator, connection type).
3. Click **Download CSV** to export; the file includes session start/end, APN, country, and latency fields.
4. API users can call `GET /subscribers/{imsi}/sessions/export` with the same query parameters.
5. Reference the updated docs: `outputs/<slug>/docs/docs-en.md` (developer) and `docs-ja.md` (user guide).

## Closing
Please contact [Soracom Support](https://support.soracom.io/hc/en-us/requests/new) if you have any questions.

