# SHAC C-Bus REST API Package

This package creates a small REST-style API for a Clipsal SHAC / NAC controller using Lua user libraries and lightweight `.lp` endpoint files.

It supports:

- Setting a C-Bus lighting group level
- Turning lights on/off
- Toggling lights
- Reading light level/state/tag
- Setting trigger groups / action selectors
- Reading trigger values
- Pulsing trigger values and resetting them
- A single router endpoint
- Individual simple endpoints
- Token authentication stored in the `api_common` user library

---

## Files

```text
libraries/api_common.lua
libraries/api_light.lua
libraries/api_trigger.lua
libraries/api_router.lua
scripts/create_endpoints.lua
README.md
```

---

## Install

### 1. Create SHAC User Libraries

In the SHAC web interface, create these user libraries exactly:

```text
api_common
api_light
api_trigger
api_router
```

Copy the matching code from the `libraries/` folder into each library:

```text
api_common   <- libraries/api_common.lua
api_light    <- libraries/api_light.lua
api_trigger  <- libraries/api_trigger.lua
api_router   <- libraries/api_router.lua
```

### 2. Change the API token

Open the `api_common` library and change:

```lua
M.API_TOKEN = 'changeme'
```

to something private, for example:

```lua
M.API_TOKEN = 'my-secret-token-123'
```

### 3. Run endpoint creation script

Create a normal SHAC script, paste in:

```text
scripts/create_endpoints.lua
```

Run it once.

It creates these endpoint files:

```text
/www/user/cbus_api.lp
/www/user/api_info.lp
/www/user/light_set.lp
/www/user/light_get.lp
/www/user/light_on.lp
/www/user/light_off.lp
/www/user/light_toggle.lp
/www/user/group_tag.lp
/www/user/trigger_set.lp
/www/user/trigger_get.lp
/www/user/trigger_pulse.lp
```

The script disables itself after running.

---

## Defaults

Default C-Bus values are set in `api_common`:

```lua
M.DEFAULT_NET = 0
M.DEFAULT_APP = 56
```

You can override these in any request using:

```text
net=<network>&app=<application>
```

Lighting levels are `0` to `255`.

- `0` = off
- `255` = full on
- `128` = about 50%

---

## Authentication

Every request requires:

```text
token=<your-token>
```

Example:

```text
http://<SHAC-IP>/user/api_info.lp?token=my-secret-token-123
```

---

# Router Endpoint

The main router endpoint is:

```text
/user/cbus_api.lp
```

It uses an `action` parameter.

Example:

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=light_on&group=1
```

Supported actions:

```text
info
light_set
light_on
light_off
light_toggle
light_get
group_tag
trigger_set
trigger_get
trigger_pulse
```

---

# Endpoint Examples

Replace:

```text
<SHAC-IP>
```

with your controller IP address.

Replace:

```text
changeme
```

with your API token.

---

## Info

### Individual endpoint

```text
http://<SHAC-IP>/user/api_info.lp?token=changeme
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=info
```

Returns API version, defaults, actions, and endpoint list.

---

## Set Light Level

Sets a C-Bus lighting group to a specific level.

### Individual endpoint

```text
http://<SHAC-IP>/user/light_set.lp?token=changeme&group=1&level=128&ramp=4
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=light_set&group=1&level=128&ramp=4
```

Parameters:

```text
group    required
level    required, 0-255
ramp     optional, default 0
net      optional, default 0
app      optional, default 56
```

---

## Light On

Turns a group on. Default level is `255`.

### Individual endpoint

```text
http://<SHAC-IP>/user/light_on.lp?token=changeme&group=1
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=light_on&group=1
```

With custom level and ramp:

```text
http://<SHAC-IP>/user/light_on.lp?token=changeme&group=1&level=200&ramp=4
```

Parameters:

```text
group    required
level    optional, default 255, range 1-255
ramp     optional, default 0
net      optional, default 0
app      optional, default 56
```

---

## Light Off

Turns a group off.

### Individual endpoint

```text
http://<SHAC-IP>/user/light_off.lp?token=changeme&group=1
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=light_off&group=1
```

With ramp:

```text
http://<SHAC-IP>/user/light_off.lp?token=changeme&group=1&ramp=4
```

Parameters:

```text
group    required
ramp     optional, default 0
net      optional, default 0
app      optional, default 56
```

---

## Light Toggle

If the current level is off/zero, turns the group on. Otherwise turns it off.

### Individual endpoint

```text
http://<SHAC-IP>/user/light_toggle.lp?token=changeme&group=1
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=light_toggle&group=1
```

With custom on level:

```text
http://<SHAC-IP>/user/light_toggle.lp?token=changeme&group=1&onlevel=180&ramp=4
```

Parameters:

```text
group      required
onlevel    optional, default 255, range 1-255
ramp       optional, default 0
net        optional, default 0
app        optional, default 56
```

---

## Light Get

Reads a light group level, calculated percent, state, and C-Bus group tag.

### Individual endpoint

```text
http://<SHAC-IP>/user/light_get.lp?token=changeme&group=1
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=light_get&group=1
```

Parameters:

```text
group    required
net      optional, default 0
app      optional, default 56
```

Example response:

```json
{
  "ok": true,
  "message": "light value read",
  "net": 0,
  "app": 56,
  "group": 1,
  "level": 128,
  "percent": 50,
  "state": true,
  "tag": "Kitchen"
}
```

---

## Group Tag

Reads the configured C-Bus group tag.

### Individual endpoint

```text
http://<SHAC-IP>/user/group_tag.lp?token=changeme&group=1
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=group_tag&group=1
```

Parameters:

```text
group    required
net      optional, default 0
app      optional, default 56
```

---

# Trigger Endpoints

Trigger values are useful for scenes/action selectors.

Values are clamped between `0` and `255`.

---

## Trigger Set

Sets a trigger group to an action selector value.

### Individual endpoint

```text
http://<SHAC-IP>/user/trigger_set.lp?token=changeme&group=9&trigger_action=255
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=trigger_set&group=9&trigger_action=255
```

Accepted aliases for the action value:

```text
trigger_action
action_selector
level
value
```

Examples:

```text
http://<SHAC-IP>/user/trigger_set.lp?token=changeme&group=9&action_selector=10
```

```text
http://<SHAC-IP>/user/trigger_set.lp?token=changeme&group=9&value=255
```

---

## Trigger Get

Reads the current trigger group value.

### Individual endpoint

```text
http://<SHAC-IP>/user/trigger_get.lp?token=changeme&group=9
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=trigger_get&group=9
```

---

## Trigger Pulse

Sets a trigger group to an action selector, waits, then resets it.

### Individual endpoint

```text
http://<SHAC-IP>/user/trigger_pulse.lp?token=changeme&group=9&trigger_action=255&reset=0&delay=1
```

### Router endpoint

```text
http://<SHAC-IP>/user/cbus_api.lp?token=changeme&action=trigger_pulse&group=9&trigger_action=255&reset=0&delay=1
```

Parameters:

```text
group             required
trigger_action    required
reset             optional, default 0
delay             optional, default 1 second
```

Accepted aliases for the action value:

```text
trigger_action
action_selector
level
value
```

---

# Testing

Start with the info endpoint:

```text
http://<SHAC-IP>/user/api_info.lp?token=changeme
```

Then test a read-only call:

```text
http://<SHAC-IP>/user/light_get.lp?token=changeme&group=1
```

Then test a low-impact set command:

```text
http://<SHAC-IP>/user/light_set.lp?token=changeme&group=1&level=128&ramp=4
```

---

# Notes

- Keep the SHAC API on a trusted network only.
- Change the default token before use.
- The token is passed in the URL, so it can appear in browser history and web logs.
- This package uses GET-style requests because that is the simplest pattern for SHAC `.lp` endpoint files.
- For Home Assistant, use REST commands pointed at the endpoints above.

