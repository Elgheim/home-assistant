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

GitHub Actions also validates every push and pull request. Pushes to `main` publish a downloadable `home-assistant-config` artifact with local-only files and secrets excluded.

## Publishing

The repository is configured with a GitHub workflow in `.github/workflows/home-assistant.yml`.

- Pull requests and pushes run YAML linting and Home Assistant config validation.
- Pushes to `main` publish a clean config artifact.

## Deployment

Manual deploys are configured in `.github/workflows/deploy.yml`. The workflow validates the config, syncs the repository to the Home Assistant host with `rsync`, and can optionally restart Home Assistant.

Configure these GitHub Actions secrets before running the deploy workflow:

- `HA_SSH_HOST` - Home Assistant host name or IP address
- `HA_SSH_PORT` - SSH port, usually `22`
- `HA_SSH_USER` - SSH user with write access to the config path
- `HA_SSH_PRIVATE_KEY` - Private key for the SSH user
- `HA_CONFIG_PATH` - Remote config directory, for example `/config`
- `HA_RESTART_COMMAND` - Restart command, for example `ha core restart`

Use a protected `production` environment in GitHub if deploys should require approval.

## Branch Protection

Protect `main` and require the `Validate configuration` status check from GitHub Actions before merging. This keeps invalid YAML or invalid Home Assistant config out of the default branch.

## Conventions

- Use stable `entity_id` references where possible.
- For ZHA remotes, prefer `zha_event` with `device_ieee` over `device_id` triggers.
- Use modern automation keys: `triggers`, `conditions`, `actions`, `trigger`, and `action`.
- Use `target:` for service/action targets.
- Use `color_temp_kelvin` instead of legacy `color_temp`.
- Keep examples out of active YAML unless all referenced entities exist.

## Development

See [CLAUDE.md](CLAUDE.md) for development guidance when working with this repository.
