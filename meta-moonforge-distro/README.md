# meta-moonforge-distro

This layer covers *everything* that should be common to all the OS images built out of this distro layer.

## What is does

* Builds a new distribution on top of a LTS openembedded-core release.
* Provides a composable image with features enabled (e.g., read-only-rootfs, overlayfs-etc, etc).
* Provides recipes bbappend overrides to ensure these settings and features work properly together (e.g., creates an empty `/data` mount point for the persistent partition).
* Provides an additional recipe to make CVE reports easy for people to read.

## How to use it

To use this layer, include the following kas file:

```yml
header:
  version: 16
  includes:
    - kas/include/layer/meta-moonforge-distro.yml

local_conf_header:
  20_meta-moonforge-distro: |
    OVERLAYFS_ETC_DEVICE = "/dev/sda3"
```

Note that, because it's the base Yocto layer, it *must* be used whenever building a new OS image.

See [meta-moonforge-distro](../kas/include/layer/meta-moonforge-distro.yml).

## Examples

* See [moonforge-image-base-qemux86-64](../kas/examples/moonforge-image-base-qemux86-64.yml).

