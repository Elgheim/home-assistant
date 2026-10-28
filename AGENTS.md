# Repository Instructions

## Safety boundaries

- Treat `configuration/` as the complete repository-managed deployment payload.
- Never add, edit, copy, or delete Home Assistant `.storage` files.
- Preserve entity IDs unless the task explicitly requires a rename and every consumer has been audited.
- Keep UI/API-managed `automations.yaml`, `scripts.yaml`, `scenes.yaml`, `secrets.yaml`, databases, logs, and HACS files outside the deployment payload.
- Do not run a production deployment unless the user explicitly requests it.
- Preserve unrelated and pre-existing worktree changes.

## Placement

- Put feature-oriented YAML in `configuration/packages/`.
- Put repository-managed automations, scripts, and scenes in their corresponding directories under `configuration/`.
- Keep `configuration/configuration.yaml` as a small composition root.
- Put operational explanations in `README.md` or `docs/`, not in this file.

## Definition of done

Before declaring a configuration or workflow change complete, run from the repository root:

```bash
make lint
make check
make test-deploy
make build
./tools/verify-artifact dist
```

If Docker is unavailable, report that `make check` could not run. Never claim Home Assistant validation passed based on YAML linting alone.
