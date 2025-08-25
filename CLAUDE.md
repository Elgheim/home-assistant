# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a Home Assistant configuration repository containing custom cards, components, automations, and configuration files.

## Directory Structure

- `custom_cards/` - Custom Lovelace cards (TypeScript/JavaScript)
- `custom_components/` - Custom Home Assistant integrations (Python)
- `configuration/` - Home Assistant YAML configuration files
- `automations/` - Automation definitions
- `scripts/` - Home Assistant script definitions
- `themes/` - Custom UI themes
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
# Check Home Assistant configuration syntax
hass --script check_config --config configuration/

# Validate specific YAML files
yamllint configuration/configuration.yaml
yamllint automations/
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
- Main config in `configuration/configuration.yaml`
- Split configurations using `!include` directives
- Automations and scripts in separate directories for organization
- Use packages for grouping related functionality

## File Naming Conventions
- Custom cards: `[card-name].js` or `[card-name].ts`
- Custom components: snake_case directory and file names
- Configuration: kebab-case for file names
- Automations: descriptive names with area/purpose prefix