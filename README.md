# Home Assistant Setup

This repository contains a YAML-based Home Assistant configuration baseline plus documentation for local automations and scenes.

Active configuration should contain only real entity IDs and values that can pass a Home Assistant configuration check. Placeholder automations, scene examples, and setup notes belong in `docs/` until they are configured for the live installation.

## Structure

- `configuration/` - Main Home Assistant YAML configuration and included helper files
- `automations/` - Active automation YAML files included with `!include_dir_merge_list`
- `scripts/` - Active scripts included with `!include_dir_merge_named`
- `themes/` - Active frontend themes included with `!include_dir_merge_named`
- `custom_cards/` - Optional custom Lovelace card source
- `custom_components/` - Optional custom integration source
- `docs/` - Setup notes and examples that are not active config

## Current Baseline

- `configuration/configuration.yaml` includes automations, scripts, scenes, input selects, and themes.
- `configuration/scenes.yaml` is intentionally empty until real light entities are added.
- `automations/ikea_remote_scene_cycling.yaml` is intentionally empty until real ZHA remote event data is added.
- `configuration/input_select.yaml` defines `input_select.lighting_scene`, which is used by the documented IKEA remote scene-cycling example.

## Secrets

Copy `configuration/secrets.yaml.example` to `configuration/secrets.yaml` and fill in real values before running Home Assistant.

Required baseline secrets:

- `home_latitude`
- `home_longitude`
- `home_elevation`
- `time_zone`

Optional for the IKEA remote example:

- `ikea_remote_device_ieee`

## Validation

Run a Home Assistant config check after any YAML change:

```bash
hass --script check_config --config configuration/
```

Run YAML linting if available:

```bash
yamllint configuration automations scripts themes
```

## Conventions

- Use stable `entity_id` references where possible.
- For ZHA remotes, prefer `zha_event` with `device_ieee` over `device_id` triggers.
- Use modern automation keys: `triggers`, `conditions`, `actions`, `trigger`, and `action`.
- Use `target:` for service/action targets.
- Use `color_temp_kelvin` instead of legacy `color_temp`.
- Keep examples out of active YAML unless all referenced entities exist.

## Development

See [CLAUDE.md](CLAUDE.md) for development guidance when working with this repository.
