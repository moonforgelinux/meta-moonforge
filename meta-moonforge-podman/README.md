# meta-moonforge-podman

This layer adds and configures Podman to be able to run containers.

## What it does

* Provides recipes bbappend overrides to configure Podman storage (e.g., to store images on the persistent partition).
* Extends the minimal base image with Podman recipes and its dependencies (e.g., ca-certificates to be able to pull images from public registries).

## How to use it

To use this layer, include the following kas file:

```yml
header:
  version: 16
  includes:
    - kas/include/layer/meta-moonforge-podman.yml
```

See [meta-moonforge-podman](../kas/include/layer/meta-moonforge-podman.yml).

## Examples

* See [moonforge-image-alt-qemux86-64](../kas/examples/moonforge-image-alt-qemux86-64.yml).
* See [moonforge-image-alt-raspberrypi4-64](../kas/examples/moonforge-image-alt-raspberrypi4-64.yml).
* See [moonforge-image-alt-raspberrypi5](../kas/examples/moonforge-image-alt-raspberrypi5.yml).

