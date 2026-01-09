# meta-moonforge-wpe

This layer adds WPE Webkit to display a given URL in a kiosk-like setting.

## What it does

* Extends the minimal base image with the WPE related recipes.
* Provides a custom recipe to launch the Cog browser and display a given URL in a fullscreen window.

## How to use it

To use this layer, include the following kas file:

```yml
header:
  version: 16
  includes:
    - kas/include/layer/meta-moonforge-wpe.yml

local_conf_header:
  30_meta-moonforge-wpe: |
    WAYLAND_COG_LAUNCH_URL = "https://www.igalia.com"
```

Note that a different URL can be provided by overriding the `WAYLAND_COG_LAUNCH_URL` variable.

See [meta-moonforge-wpe](../kas/include/layer/meta-moonforge-wpe.yml).

## Examples

* See [moonforge-image-alt-qemux86-64.yml](../kas/examples/moonforge-image-alt-qemux86-64.yml).
* See [moonforge-image-alt-raspberrypi4-64.yml](../kas/examples/moonforge-image-alt-raspberrypi4-64.yml).
* See [moonforge-image-alt-raspberrypi5.yml](../kas/examples/moonforge-image-alt-raspberrypi5.yml).

