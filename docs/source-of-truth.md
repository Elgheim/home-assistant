# Configuration Source of Truth

This repository intentionally manages only part of the Home Assistant installation. Deployment must preserve everything owned by Home Assistant or its UI/API.

## Repository-managed

These paths are built from `configuration/` and may be changed by deployment:

- `configuration.yaml`
- `input_select.yaml`
- `packages/`
- `automations/`
- `scripts/`
- `scenes/`
- `themes/`

The directories are exclusively repository-managed. Deletion is allowed only inside these directories so removed Git files do not remain active in Home Assistant.

## Home Assistant-managed

These paths live on the Home Assistant host and must never be included in an artifact or overwritten by deployment:

- `.storage/`
- `automations.yaml`
- `scripts.yaml`
- `scenes.yaml`
- `secrets.yaml`
- `home-assistant_v2.db*`
- Logs, backups, generated dependencies, and caches
- HACS-managed files such as `www/community/`

The labeled `automation ui`, `script ui`, and `scene ui` entries in `configuration.yaml` load the conventional UI-managed files alongside the repository-managed directories.

## API and config-entry state

Integrations, entity registry entries, devices, areas, helpers, and storage-mode dashboards normally live in Home Assistant's internal storage. Manage them through the Home Assistant UI or supported REST/WebSocket APIs. Do not copy or patch `.storage` files.

The inventory in `docs/home-assistant-inventory.md` is a point-in-time operational record, not a deployable export.

## Unmanaged repository content

Documentation, MCP/OpenCode configuration, CI fixtures, tooling, custom-card placeholders, custom-component placeholders, and `home/` artifacts are not part of the Home Assistant deployment payload.
