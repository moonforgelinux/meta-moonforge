# meta-moonforge-qemu

This layer provides auxiliary assets for QEMU builds.

## What is does

* Extends the base image with recipes, distro and local configurations to build images for qemux86-64.

## How to use it

To use this layer, include the following kas file:

```yml
header:
  version: 16
  includes:
    - kas/include/layer/meta-moonforge-qemu.yml

local_conf_header:
  20_meta-moonforge-qemu: |
    WKS_FILE = "moonforge-image-base-qemux86-64.wks.in"

machine: qemux86-64
```

See [meta-moonforge-qemu](../kas/include/layer/meta-moonforge-qemu.yml).

## Examples

* See [moonforge-image-base-qemux86-64](../kas/examples/moonforge-image-base-qemux86-64.yml).

## Testing

To use `runqemu`:

```sh
$ cd meta-moonforge
$ kas-container --runtime-args "--device=/dev/kvm" shell kas/moonforge-image-base-qemux86-64.yml:kas/common/debug.yml
$ bitbake -c build moonforge-image-base ovmf
$ bzip2 -df tmp/deploy/images/qemux86-64/moonforge-image-base-qemux86-64.rootfs.wic.bz2
$ runqemu snapshot kvm nographic slirp ovmf qemux86-64 tmp/deploy/images/qemux86-64/moonforge-image-base-qemux86-64.rootfs.wic
```

