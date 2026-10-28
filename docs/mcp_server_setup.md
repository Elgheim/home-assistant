# Home Assistant MCP Server Setup

This project uses `ha-mcp` with OpenCode. `ha-mcp` talks to the Home Assistant REST/WebSocket APIs using a long-lived access token and does not depend on the Home Assistant built-in MCP endpoint version.

```text
<home-assistant-url>
```

The integration is configured from the Home Assistant UI. Do not add MCP credentials or long-lived access tokens to this repository.

## 1. Home Assistant Setup

1. Go to **Settings > Devices & services**.
2. Add **Model Context Protocol Server** if it is not already added.
3. Open the integration options.
4. Enable **Control Home Assistant** only if you want clients to control exposed entities.
5. Go to **Settings > Voice assistants > Expose**.
6. Expose only the entities the MCP client should see or control.

Keep exposure narrow. For example, expose test lights and read-only sensors first, then expand once behavior is verified.

## 2. Create A Token

1. In Home Assistant, open your user profile.
2. Go to **Security**.
3. Create a long-lived access token named `mcp-local-client`.
4. Store the token only in your local MCP client config or password manager.
5. Store the token in `.env`; do not commit it.

## 3. Install uv

```bash
brew install uv
```

## 4. OpenCode Project Setup

This repository has a project-local `opencode.json` that enables the Home Assistant MCP server only when OpenCode is started from this project.

Create `.env` from the example:

```bash
cp .env.example .env
```

Then edit `.env`:

```bash
HOMEASSISTANT_URL=http://<your-home-assistant-local-host>:8123
HOMEASSISTANT_TOKEN=<your-long-lived-access-token>
```

Do not wrap these values in quotes unless your shell requires it. The token should be on one line.

Start OpenCode from the repo root:

```bash
opencode .
```

Check that OpenCode sees the server:

```bash
opencode mcp list
```

The `home-assistant` MCP server should appear when the command is run from this repository root.

## Client Configuration

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "home-assistant": {
      "type": "local",
      "command": [
        "sh",
        "-lc",
        "set -a; [ -f .env ] && . ./.env; set +a; exec uvx ha-mcp@latest"
      ],
      "enabled": true
    }
  }
}
```

## Verification Prompt

After connecting, start read-only:

```text
List the Home Assistant entities you can see. Do not control anything.
```

Then test a low-risk exposed entity:

```text
Turn on the test light, then turn it off again.
```

## Troubleshooting

- `Missing required environment variables`: confirm `.env` has `HOMEASSISTANT_URL` and `HOMEASSISTANT_TOKEN`.
- `401 Unauthorized`: the long-lived access token is missing, expired, or copied incorrectly.
- No entities visible: check **Settings > Voice assistants > Expose** and expose the relevant entities.
- OpenCode cannot find the server: run OpenCode from the repository root so it loads this project's `opencode.json`.
