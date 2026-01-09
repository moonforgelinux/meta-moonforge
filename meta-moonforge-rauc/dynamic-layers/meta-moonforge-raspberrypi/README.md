# meta-moonforge-rauc-raspberrypi

This dynamic layer extends RAUC support to Raspberry Pi boards.

## What it does

* Extends meta-rauc-raspberrypi layer with recipes bbappend overrides to ensure it's properly integrated.
* Extends the base image with distro and local configurations to build images.

## How to use it

To use this layer, include the following kas file:

```yml
header:
  version: 16
  includes:
    - kas/include/layer/meta-moonforge-rauc-raspberrypi.yml
```

See [meta-moonforge-rauc-raspberrypi](../../../kas/examples/include/layer/meta-moonforge-rauc-raspberrypi.yml).

## Examples

* See [moonforge-image-full-raspberrypi5](../../../kas/examples/moonforge-image-full-raspberrypi5.yml).

