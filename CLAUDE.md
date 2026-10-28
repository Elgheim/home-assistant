# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a Home Assistant configuration repository containing custom cards, components, automations, and configuration files.

## Directory Structure

- `custom_cards/` - Custom Lovelace cards (TypeScript/JavaScript)
- `custom_components/` - Custom Home Assistant integrations (Python)
- `configuration/` - Self-contained repository-managed Home Assistant payload
- `configuration/packages/` - Feature-oriented packages
- `configuration/automations/` - Repository-managed automation definitions
- `configuration/scripts/` - Repository-managed script definitions
- `configuration/scenes/` - Repository-managed scene definitions
- `configuration/themes/` - Repository-managed UI themes
- `docs/` - Documentation and development notes

## Development Commands

### Custom Cards Development
```bash
# Navigate to a card directory
cd custom_cards/[card-name]

# Install dependencies (if package.json exists)
npm install

# Build card (typical commands)
npm run build
npm run dev
npm run watch

# Lint TypeScript/JavaScript
npm run lint
```

### Custom Components Development
```bash
# Install Home Assistant development dependencies
pip install homeassistant
pip install pytest
pip install pytest-homeassistant-custom-component

# Run tests for a component
cd custom_components/[component-name]
python -m pytest tests/

# Lint Python code
flake8 .
black .
mypy .
```

### Configuration Validation
```bash
# Run the same checks as CI
make test

# Build and verify the deployable artifact
make build
./tools/verify-artifact dist
```

## Architecture Notes

### Custom Cards
- Built as ES6 modules that extend LitElement
- Must define `customElements.define()` for registration
- Follow Home Assistant frontend card conventions
- Include `card-config.js` for Lovelace UI editor support

### Custom Components
- Follow Home Assistant integration structure with `__init__.py`, `manifest.json`
- Implement config flow for UI-based setup when appropriate
- Use Home Assistant's entity platforms (sensor, switch, etc.)
- Include proper error handling and logging

### Configuration Structure
- Keep `configuration/configuration.yaml` as a small composition root.
- Use packages for feature-oriented YAML such as Aquarea monitoring.
- Keep UI/API-managed files separate from repository-managed directories.
- Never edit or deploy `.storage`.

## File Naming Conventions
- Custom cards: `[card-name].js` or `[card-name].ts`
- Custom components: snake_case directory and file names
- Configuration: kebab-case for file names
- Automations: descriptive names with area/purpose prefix
