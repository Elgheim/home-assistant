# IKEA Remote Scene Setup Guide

## Overview
This setup allows you to cycle between "Day Light" and "Evening Light" scenes using your IKEA Trådfri remote.

## What You Need to Configure

### 1. Find Your Entity IDs
First, you need to identify the actual entity IDs of your lights in Home Assistant:

1. Go to **Settings > Devices & Services**
2. Find your IKEA lights and note their entity IDs (e.g., `light.tradfri_bulb_e27_ws_opal_980lm`)
3. Find your extra light entity ID

### 2. Update the Scenes File
Edit `configuration/scenes.yaml` and replace the placeholder entity IDs:
- Replace `light.tradfri_bulb_1`, `light.tradfri_bulb_2`, etc. with your actual IKEA light entity IDs
- Replace `light.extra_light` with your actual extra light entity ID

### 3. Find Your Remote Device ID
1. Go to **Settings > Devices & Services**
2. Find your IKEA remote device
3. Click on it and copy the device ID from the URL or device info
4. Add it to your `secrets.yaml` file:
   ```yaml
   ikea_remote_device_id: "your_device_id_here"
   ```

### 4. Configure Remote Button Action
The automation is set up for a **double-press of the power button**. You may need to adjust this based on your remote model:

**Common IKEA Remote Button Events:**
- `remote_button_short_press` + `turn_on` - Single press power button
- `remote_button_double_press` + `turn_on` - Double press power button  
- `remote_button_long_press` + `turn_on` - Long press power button
- `remote_button_short_press` + `dim_up` - Single press brightness up
- `remote_button_short_press` + `dim_down` - Single press brightness down

## Scene Settings Explained

### Day Light Scene
- **Brightness**: 255 (100%) for IKEA lights, 200 (78%) for extra light
- **Color Temperature**: 250 (cool white, ~6500K)
- **Purpose**: Bright, energizing light for daytime activities

### Evening Light Scene  
- **Brightness**: 100 (39%) for IKEA lights, 50 (20%) for extra light
- **Color Temperature**: 454 (warm white, ~2700K)
- **Purpose**: Dim, relaxing light for evening/night

## Testing the Setup

1. **Restart Home Assistant** after adding the configuration
2. Check that scenes appear in **Settings > Automations & Scenes > Scenes**
3. Test scenes manually first:
   - Go to **Developer Tools > Services**
   - Call `scene.turn_on` with `entity_id: scene.day_light`
   - Call `scene.turn_on` with `entity_id: scene.evening_light`
4. Test the remote automation by double-pressing the power button

## Troubleshooting

### Remote Not Working
- Check if your remote device ID is correct
- Try different button events (single press, long press)
- Check **Settings > System > Logs** for errors

### Scenes Not Working
- Verify all entity IDs exist and are spelled correctly
- Check that lights are available (not offline)
- Ensure color temperature values are supported by your lights

### Alternative Button Options
If double-press doesn't work, try these alternatives in the automation:
```yaml
# Single press power button
type: remote_button_short_press
subtype: turn_on

# Long press power button  
type: remote_button_long_press
subtype: turn_on

# Use a different button like brightness up
type: remote_button_short_press
subtype: dim_up
```

## Customizing Brightness Levels

You can adjust brightness in the scenes file:
- **0-255 scale**: 0 = off, 128 = 50%, 255 = 100%
- **Color temperature**: 153-500 range (153 = cool, 500 = very warm)

Example brightness adjustments:
```yaml
# Very dim evening
brightness: 25  # ~10%

# Medium day lighting  
brightness: 180  # ~70%
```