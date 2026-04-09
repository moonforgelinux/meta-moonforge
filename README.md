# meta-moonforge

[Moonforge](https://moonforgelinux.org/) is an open-source collection of [various Yocto layers](https://moonforgelinux.org/docs/) and build tooling maintained by [Igalia](https://www.igalia.com/). It gives system integrators and product teams a production-ready starting point for building custom, immutable embedded Linux operating systems, without duplicating the integration work that every project ends up doing from scratch.

## Setup

In order to prepare the host build machine, the following system tools are required:

* [docker](https://www.docker.com/) or [podman](https://podman.io/)
* python3-pip

See the official documentation for common Linux distributions like [Fedora](https://docs.docker.com/engine/install/fedora/) or [Ubuntu](https://docs.docker.com/engine/install/ubuntu/).

Images are built using [kas](https://kas.readthedocs.io/en/latest/), therefore the following step is also required:

```sh
$ pip install --user kas==5.0
$ kas-container --help
```

It's recommended to create a workspace directory to hold both this repository and a persistent cache and:

```sh
$ mkdir workspace && cd workspace
$ mkdir cache
$ git clone https://github.com/moonforgelinux/meta-moonforge.git
```

## Build

Before building, it's important to set up the cache directory to speed up subsequent builds:

```sh
$ cd meta-moonforge
$ export KAS_CONTAINER_ENGINE=docker
$ export DL_DIR=$PWD/../cache/downloads/
$ export SSTATE_DIR=$PWD/../cache/sstate-cache/
```

To ensure truly reproducible builds, Moonforge uses a containerized build environment provided by *kas-container*:

```sh
$ cd meta-moonforge
$ kas-container build kas/examples/moonforge-image-base-raspberrypi5.yml:kas/common/debug.yml
```

This repository contains [example kas files](./kas/examples) for building different images for the boards we currently support.

Additionally, it contains [auxiliary kas fragments](./kas/common) useful for common tasks while developing locally or in continuous integration environments. For example:

* *kas/common/debug.yml* disables the root password to facilitate testing.
* *kas/common/cve.yml* enables the generation of the [Common Vulnerabilities and Exposures](https://www.cve.org/) (CVE) report.
* *kas/common/sbom.yml* enables the generation of the [Software Bill of Materials](https://www.cisa.gov/sbom) (SBOM) report.
* *kas/common/throttle.yml* limits the amount of system resources used by bitbake and the build environment, useful when building demanding recipes.

Multiple kas fragments can be used at once, as shown in the example above.

## Test

On real hardware, it's recommended to use tools such as [bmaptool](https://docs.yoctoproject.org/dev-manual/bmaptool.html) to flash the SD card:

```sh
$ sudo bmaptool copy ./build/tmp/deploy/images/raspberrypi5/moonforge-image-base-raspberrypi5.rootfs.wic.bz2 /dev/sdX
```

Check the BSP-related layers for instructions on how to test images for specific hardware targets.

## Derive

This repository can be used as any other regular Yocto layer to build derivative products based on Moonforge. The recommended method is using kas as exemplified in in our [meta-derivative](https://github.com/moonforgelinux/meta-derivative) reference repository.

## Contribute

Please send your patches as Pull Requests or fill an issue report to the [meta-moonforge](https://github.com/moonforgelinux/meta-moonforge) repository.

Maintainer: The Moonforge Linux team info@moonforgelinux.org

See the [structure documentation](./STRUCTURE.md) for better understanding of this repository.

## Legal

MIT License

Copyright (c) 2026 Igalia, S.L.

