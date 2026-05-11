# IKEA Remote Scene Setup

This document keeps the IKEA remote setup as an example until you replace the light entity IDs and ZHA event data with real values. Do not paste placeholder entities into active config.

## Recommended Pattern

Use one automation that tracks the current scene with `input_select.lighting_scene`. Avoid checking scene state directly, because scene entities only expose transient activation state.

For ZHA remotes, use an event trigger with `device_ieee` instead of `device_id`. The IEEE address survives device re-adds; `device_id` does not.

## Find ZHA Event Data

1. Open Home Assistant.
2. Go to **Developer Tools > Events**.
3. Subscribe to `zha_event`.
4. Press the remote button you want to use.
5. Copy `device_ieee` and `command` from the event payload.
6. Add the IEEE address to `configuration/secrets.yaml` as `ikea_remote_device_ieee`.

## Active Helper

`configuration/input_select.yaml` already defines the scene tracker:

```yaml
lighting_scene:
  name: "Current Lighting Scene"
  options:
    - "Day Light"
    - "Evening Light"
  initial: "Day Light"
  icon: mdi:lightbulb-group
```

## Scene Example

Copy this into `configuration/scenes.yaml` only after replacing every entity ID with real lights.

```yaml
- id: day_light
  name: "Day Light"
  entities:
    light.living_room_ceiling:
      state: "on"
      brightness: 255
      color_temp_kelvin: 5000
    light.living_room_lamp:
      state: "on"
      brightness: 200
      color_temp_kelvin: 5000

- id: evening_light
  name: "Evening Light"
  entities:
    light.living_room_ceiling:
      state: "on"
      brightness: 100
      color_temp_kelvin: 2700
    light.living_room_lamp:
      state: "on"
      brightness: 50
      color_temp_kelvin: 2700
```

## Automation Example

Copy this into `automations/ikea_remote_scene_cycling.yaml` after updating the `command` value to match the event emitted by your remote.

```yaml
- id: ikea_remote_cycle_lighting_scenes
  alias: "IKEA Remote - Cycle Lighting Scenes"
  description: "Cycle between configured lighting scenes from an IKEA ZHA remote."
  mode: single
  triggers:
    - trigger: event
      event_type: zha_event
      event_data:
        device_ieee: !secret ikea_remote_device_ieee
        command: "toggle"
  conditions: []
  actions:
    - action: input_select.select_next
      target:
        entity_id: input_select.lighting_scene
    - variables:
        scene_entity: >
          scene.{{ states('input_select.lighting_scene') | lower | replace(' ', '_') }}
    - action: scene.turn_on
      target:
        entity_id: "{{ scene_entity }}"
    - action: notify.persistent_notification
      data:
        title: "Scene Changed"
        message: "Activated {{ states('input_select.lighting_scene') }}."
```

## Validation

After applying real values, run:

```bash
hass --script check_config --config configuration/
```

If `hass` is not installed locally, run the configuration check from Home Assistant itself before restarting.
