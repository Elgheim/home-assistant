# Home Assistant Setup

This repository contains the Git-managed portion of a Home Assistant configuration, validation tooling, and an artifact-based deployment workflow.

Active configuration should contain only real entity IDs and values that can pass a Home Assistant configuration check. Placeholder automations, scene examples, and setup notes belong in `docs/` until they are configured for the live installation.

## Structure

- `configuration/` - Self-contained repository-managed Home Assistant payload
- `configuration/packages/` - Feature-oriented packages such as Aquarea monitoring
- `configuration/automations/`, `scripts/`, `scenes/`, `themes/` - Repository-managed entries
- `ci/` - Non-sensitive fixtures used only for validation
- `tools/` - Shared local, CI, artifact, deployment, and rollback commands
- `custom_cards/` - Optional custom Lovelace card source
- `custom_components/` - Optional custom integration source
- `docs/` - Setup notes and examples that are not active config

## Current Baseline

- `configuration/configuration.yaml` composes UI/API-managed files and repository-managed directories.
- `configuration/packages/aquarea.yaml` defines the Panasonic Aquarea/HeishaMon monitoring entities.
- `configuration/scenes/ikea_remote.yaml` is intentionally empty until real light entities are added.
- `configuration/automations/ikea_remote_scene_cycling.yaml` is intentionally empty until real ZHA remote event data is added.
- `configuration/input_select.yaml` defines `input_select.lighting_scene`, which is used by the documented IKEA remote scene-cycling example.

See `docs/source-of-truth.md` for the boundary between Git-managed and Home Assistant-managed state.

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

Run the same checks used by CI:

```bash
make test
```

Build and verify the deployable artifact:

```bash
make build
./tools/verify-artifact dist
```

`make check` uses the Home Assistant release and image digest pinned in `.ha-version` and `.ha-image`. It validates the staged payload with non-sensitive CI fixtures and requires Docker. YAML linting uses an installed `yamllint`, `uvx`, or `pipx`.

## Publishing

The repository is configured with a GitHub workflow in `.github/workflows/home-assistant.yml`.

- Relevant pull requests and pushes run YAML linting and Home Assistant config validation.
- Documentation-only pull requests retain a lightweight required gate.
- Successful configuration runs publish an immutable artifact named for the commit SHA.

## Deployment

Manual deploys promote a validated artifact from a successful `main` workflow run. The workflow backs up only Git-managed paths, performs scoped synchronization, runs `ha core check`, and can optionally restart and health-check Home Assistant.

Configure these GitHub Actions secrets before running the deploy workflow:

- `HA_SSH_HOST` - Home Assistant host name or IP address
- `HA_SSH_PORT` - SSH port, usually `22`
- `HA_SSH_USER` - SSH user with write access to the config path
- `HA_SSH_PRIVATE_KEY` - Private key for the SSH user
- `HA_SSH_KNOWN_HOSTS` - Pinned SSH host-key entry
- `HA_CONFIG_PATH` - Remote config directory, for example `/config`
- `HA_URL` - Home Assistant base URL used for health checks
- `HA_TOKEN` - Long-lived token used only for authenticated health checks

Use a protected `production` environment in GitHub if deploys should require approval.
See `docs/deployment.md` for deployment and recovery instructions.

## MCP Server

Home Assistant MCP Server setup notes are in `docs/mcp_server_setup.md`. Keep MCP tokens and client secrets out of this repository.

This repo includes a project-local `opencode.json` for OpenCode. Copy `.env.example` to `.env`, fill in `HOMEASSISTANT_URL` and `HOMEASSISTANT_TOKEN`, then run `opencode .` from the repo root.

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

See [AGENTS.md](AGENTS.md) for repository safety rules and the definition of done. `CLAUDE.md` contains additional development context.
