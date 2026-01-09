# meta-moonforge-rauc-qemu

This dynamic layer extends RAUC support to qemux86-64 VMs.

## What it does

* Provides a custom recipe and extensions to allow GRUB handle A/B rootfs partitions.
* Extends the base image with distro and local configurations to build images.

## How to use it

To use this layer, include the following kas file:

```yml
header:
  version: 16
  includes:
    - kas/include/layer/meta-moonforge-rauc-qemu.yml
```

See [meta-moonforge-rauc-qemu](../../../kas/examples/include/layer/meta-moonforge-rauc-qemu.yml).

## Examples

* See [moonforge-image-full-qemux86-64](../../../kas/examples/moonforge-image-full-qemux86-64.yml).

