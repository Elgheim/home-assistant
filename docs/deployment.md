# Deployment and Recovery

Production deployment promotes an immutable artifact created by a successful `Home Assistant` workflow run on `main`. It never builds from the deploy workflow's current branch.

## Required production secrets

- `HA_SSH_HOST`
- `HA_SSH_PORT`
- `HA_SSH_USER`
- `HA_SSH_PRIVATE_KEY`
- `HA_SSH_KNOWN_HOSTS` - Pinned known-hosts entry for the Home Assistant host
- `HA_CONFIG_PATH` - Absolute Home Assistant config path, normally `/config`
- `HA_URL` - Base URL used for post-restart health checks
- `HA_TOKEN` - Long-lived token used only by the health check

Use a restricted deploy user where possible. The key needs access only to the managed configuration paths and the `ha core check` and `ha core restart` commands.

## Deploy

1. Merge the configuration change into `main`.
2. Wait for the `Home Assistant` workflow to pass.
3. Copy that workflow run's numeric run ID.
4. Run `Deploy Home Assistant` manually and enter the run ID.
5. Review and approve the protected `production` environment.
6. Choose whether Home Assistant should restart after deployment.

The workflow verifies the run came from `main`, downloads the commit-addressed artifact, verifies its checksums, previews changes, and uploads it to a revision-specific staging directory.

Each commit can create only one rollback archive. A repeated deployment of the same commit is refused rather than overwriting the recovery point; retain or relocate the existing archive before an intentional retry.

Before changing live files, the remote installer creates:

```text
<HA_CONFIG_PATH>/.repo-backups/<commit-sha>/managed.tar.gz
```

Only explicitly managed files are installed. Directory deletion is scoped to repository-owned `packages/`, `automations/`, `scripts/`, `scenes/`, and `themes/` directories. Root-level `rsync --delete` is forbidden.

After installation, `ha core check` runs before any restart. A failed check restores the backup automatically. If the optional restart does not pass the authenticated API health check, the workflow restores the backup and restarts again.

## Manual rollback

The workflow performs automatic rollback for validation and health-check failures. For an operator-requested rollback, rerun the remote helper from a trusted checkout using the failed deployment's revision:

```bash
ssh -p "$HA_SSH_PORT" "$HA_SSH_USER@$HA_SSH_HOST" \
  "sh -s -- rollback '$HA_CONFIG_PATH' '<commit-sha>'" \
  < tools/remote-deploy-config
```

Then restart Home Assistant only after the helper's `ha core check` succeeds.

## Artifact contents

`make build` produces:

```text
dist/
├── config/
├── manifest.sha256
└── REVISION
```

The artifact contains no production secrets or UI/runtime-managed files. `make check` creates a separate local validation overlay with harmless CI secrets and empty UI-file fixtures; that overlay is never uploaded or deployed.
