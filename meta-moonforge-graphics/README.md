# meta-moonforge-graphics

This layer adds and runs a graphical environment for a kiosk-like setting.

## What it does

* Extends the base image with Weston and other required recipes (e.g., adds gsettings-dekstop-schemas).
* Provides recipes bbappend overrides and base configurations for the Weston compositor, to make it useful for kiosk-like settings (e.g., removes the top panel with default demos).

## How to use it

To use this layer, include the following kas file:

```yml
header:
  version: 16
  includes:
    - kas/include/layer/meta-moonforge-graphics.yml
```

See [meta-moonforge-graphics](../kas/include/layer/meta-moonforge-graphics.yml).

## Examples

* See [moonforge-image-alt-qemux86-64.yml](../kas/examples/moonforge-image-alt-qemux86-64.yml).
* See [moonforge-image-alt-raspberrypi4-64.yml](../kas/examples/moonforge-image-alt-raspberrypi4-64.yml).
* See [moonforge-image-alt-raspberrypi5.yml](../kas/examples/moonforge-image-alt-raspberrypi5.yml).

