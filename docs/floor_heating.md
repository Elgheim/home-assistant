# Floor Heating

Documentation of the hydronic floor heating system: heat source, manifold, room thermostats and supplementary heaters. This is reference material, not active configuration.

Last updated: 2026-11-21

## Overview

| Part | Details |
|---|---|
| Heat source | Panasonic Aquarea heat pump, monitored via HeishaMon (`sensor.panasonic_heat_pump_*`) |
| Room control | Salus thermostats and Salus wiring centre with thermal actuators (`climate.termostat_*`) |
| Supplementary heat | Adax panel heaters in the living room and kitchen (not yet integrated in HA) |
| Electricity price | Norgespris |

The floor heating is the primary heat source. Panel heaters are buffers for cold periods only.

## Heat Pump Settings

| Setting | Value | Notes |
|---|---|---|
| Heating curve zone 1, cold point | 45 °C flow at −5 °C outdoor | Kept as is for winter 2026/27 |
| Heating curve zone 1, warm point | 35 °C flow at +15 °C outdoor | |
| Pump duty | 80 % | Increase to ~90 % being considered (target flow 15–15.5 L/min) |
| System flow | ~14 L/min | |
| Supply/return ΔT | ~5–6 K in cold weather | Target 4–6 K |

The curve is set on the Aquarea controller. HeishaMon is read-only in HA today; changing pump duty from HA would require an MQTT entity for `SetMaxPumpDuty`.

Cold-snap reference (17–20 Nov 2026, −2 to −5 °C outdoor): compressor running near continuously, 39–55 kWh electricity per day, daily COP 2.4–2.7.

## Manifold (Salus cabinet)

Six outlets. Each flow meter is also the balancing valve for its loop (remove the red locking ring and turn the meter to adjust). Read flow with all loops on the manifold open.

| Outlet | Room | Loop length | Flow | Notes |
|---|---|---|---|---|
| 1–3 | Yttergang (outer hallway) and spare | | | Yttergang loop connected in Nov 2026; return bar labelled "GANG" |
| 4 | Penstue | 110–120 m | ~2.8 L/min (3 L/min when spisestue is closed) | Fully open |
| 5 | Spisestue, loop 1 of 2 | 110–120 m | ~2.6 L/min | Air bubbles seen in flow meter |
| 6 | Kitchen | Shorter | ~2.4 L/min (~2.7 when outlets 4–5 are closed) | |

Targets: 2.5–3 L/min on the long loops. TV-stue, penstue and spisestue have the longest loops in the house.

Air vents sit top left on the supply and return bars. Fill and drain valves are below them; ball valves (blue handles) are on the right.

## Room Thermostats

All thermostats except the bathroom run **Permanent Hold** with no night setback (since 2026-10-25).

| Room | Entity | Setpoint | Notes |
|---|---|---|---|
| Penstue + spisestue | `climate.termostat_spisestue` | 22 °C | One open room; one thermostat controls both loops |
| Kitchen | `climate.termostat_kokken` | 22 °C | Weakest room, see below |
| TV-stue | `climate.termostat_tv_stue` | 22 °C | |
| Bibliotek / playroom | `climate.termostat_legerum` | 22 °C | |
| Kontor | `climate.termostat_kontor` | 22 °C | Sensor reads high in sun |
| WC | `climate.termostat_wc` | 22–23 °C | |
| Yttergang | `climate.termostat_yttergang` | 21 °C | Salus open-window detection may pause heating when the front door is open |
| Barnerom | `climate.termostat_barnerom` | 21 °C | |
| Soverom | `climate.termostat_soverom` | 20 °C | |
| Bad | `climate.termostat_bad` | 23 °C day | Follow Schedule, night setback 17 °C |

`climate.termostat_gang` (mellomgang) is unavailable; the mellomgang does not have floor heating yet.

Thermostat placement matters: the penstue sensor originally sat in a window sill and swung between 21 and 24 °C. Moving it to an inside wall fixed the readings.

## Supplementary Panel Heaters (Adax)

| Location | Setpoint | Installed | Purpose |
|---|---|---|---|
| Penstue/spisestue, under window | 18 °C | Existing | Buffer for very cold days. Senses cold downdraft from the window, so it runs even when the room holds 22 °C if set higher. Used 86 kWh in October 2026 at 21 °C. |
| Kitchen | 20 °C day, 16 °C night | 2026-11-21 | Covers cold zones in the kitchen. The previous owner laid no pipes under the kitchen benches, so the kitchen loop cannot keep up in cold weather. |

Set each panel heater a couple of degrees below the room's floor heating setpoint so the heat pump does most of the work and the heater only covers the gap.

Neither heater is in HA yet (only `update.adax_heaters_update` exists). Plan: add them with the official Adax integration (cloud, which provides energy sensors). Heater energy use is a useful check when lowering the heating curve: if the heaters start running more, the curve is too low.

## Known Issues and Decisions

- **Kitchen:** Ran 18–21 °C against 22 °C during the November cold snap with the thermostat calling for heat continuously. Cause is the loop layout, not the curve. Decision: add a panel heater rather than raise the curve for the whole house.
- **Curve:** In cold weather the living room has little margin at 45 °C / −5 °C. Do not lower the curve while it is below freezing; revisit in milder weather.
- **Salus reliability:** The spisestue thermostat went offline from 2026-11-20 19:46 to 2026-11-21 09:21 and the loop stayed closed, so the living room cooled down. Check batteries and signal if it happens again.

## Change Log

- 2026-10-25: Manifold flow documented and rebalanced (penstue 1.7 → 2.8, spisestue 1.9 → 2.6, kitchen 2.2 → 2.4 L/min). Thermostats switched to Permanent Hold without night setback.
- 2026-10-27: Penstue thermostat moved from window sill to inside wall.
- 2026-10-28: Living room Adax heater lowered to 18 °C.
- 2026-11: Yttergang floor poured (MegaPlan, ~40 mm) and floor heating loop connected.
- 2026-11-21: Adax heater installed in the kitchen as supplementary heat (20 °C day, 16 °C night).
