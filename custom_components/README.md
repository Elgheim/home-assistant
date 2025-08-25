# Custom Components

This directory contains custom Home Assistant integrations.

## Creating a New Component

1. Create a new directory: `mkdir my_component`
2. Add required files:
   - `manifest.json` - Component metadata
   - `__init__.py` - Integration entry point
   - Platform files (`sensor.py`, `switch.py`, etc.)

## Example Component Structure

```
my_component/
├── manifest.json       # Component metadata
├── __init__.py        # Integration setup
├── config_flow.py     # Configuration flow (optional)
├── sensor.py          # Sensor platform (if applicable)
├── const.py           # Constants and configuration
└── README.md          # Component documentation
```