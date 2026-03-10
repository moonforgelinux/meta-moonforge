# Repository structure

This document describes the repository structure, its goals and the integration experience it provides.

## Design goals

Moonforge is a Linux distribution built on the [Yocto](https://www.yoctoproject.org/) and [OpenEmbedded](https://www.openembedded.org/wiki/Main_Page) projects. As such, it's a collection of Yocto layers and auxiliary [kas](https://github.com/siemens/kas) configuration files, arranged so that the following goals can be achieved:

* Good balance between having turn-key solutions and the flexibility to extend beyond these solutions, to support a wide range of products.
* Clear separation between upstream and downstream components, to support the creation of derivative products with predictable processes and releases.
* Best practices in place, to provide a simplified yet powerful integration experience.

## Balance

Building a Linux distribution often comes down to selecting a base distribution, an integration tool and adjusting system components to an overall system design. Experience shows that these tasks result in a lot of duplicated effort that can be inconsequential for the actual product.

Moonforge's proposition is to free the system integrator from that burden by making core design decisions and providing common components tailored to these decisions. Thus, reducing that duplicated effort and enabling the integrator to focus on their own products.

At the same time, experience also shows that there isn't a one-size-fits-all system design and, therefore, balance is required.

Moonforge's approach to balance is to leverage OpenEmbedded's build system best capabilities with a mix of conventions and sensible defaults powered by kas and the practices it enables. More concretely:

* High-level components are provided as separate Yocto layers that can be combined in different ways. For example, the [meta-moonforge-distro](../meta-moonforge-distro) layer provides the recipe for the base image, while the additional [meta-moonforge-graphics](../meta-moonforge-graphics) layer provides recipes that extends the same base image to run a graphical environment.
* Kas fragments are provided for each layer, so these can be combined and customized in a declarative fashion to build different products. These fragments handle the inclusion of external repositories, the activation of the required layers, and provide sensible defaults that can be overridden.

See the following example:

```yml
header:
  version: 16
  includes:
    - kas/include/layer/meta-moonforge-distro.yml
    - kas/include/layer/meta-moonforge-raspberrypi.yml
    - kas/include/layer/meta-moonforge-wpe.yml

local_conf_header:
  30_meta-moonforge-wpe: |
    WAYLAND_COG_LAUNCH_URL = "https://www.moonforgelinux.org"
  30_meta-moonforge-raspberrypi: |
    # Specifies description file for partitioning the image
    WKS_FILE = "moonforge-image-base-raspberrypi.wks.in"
  20_meta-moonforge-distro: |
    # Sets up persistent data partition
    OVERLAYFS_ETC_DEVICE = "/dev/mmcblk0p3"

machine: raspberrypi5
```

The above example demonstrates how a kiosk-like product can be built by combining these layers and, more importantly, provides a single integration source that can be versioned and developed as any other piece of modern software. Check the [kas](../kas/examples/) directory for other examples.

As Moonforge development continues, additional layers with distinct components will be added while existing layers will be refined.

## Separation

These existing layers can cover many common needs, but can't cover every need. Here is where the [layers](https://docs.yoctoproject.org/5.0.14/dev-manual/layers.html) capabilities of the OpenEmbedded build system provide an appropriate solution for:

* Having flexibility when existing layers aren't enough.
* Having a clear separation between components.
* Building new products by extending Moonforge and allowing vendor-specific components.

To illustrate what comprises a layer in this repository, see the following graph showing the files related to the *meta-moonforge-wpe* layer:

```tree
meta-moonforge
├── kas
│   └── include
│       ├── layer
│       │   └── meta-moonforge-wpe.yml
│       └── repo
│           ├── meta-openembedded.yml
│           └── meta-webkit.yml
└── meta-moonforge-wpe
    ├── conf
    │   └── layer.conf
    ├── README.md
    ├── recipes-core
    │   ├── images
    │   │   └── moonforge-image-base.bbappend
    │   └── volatile-binds
    │       └── volatile-binds.bbappend
    └── recipes-graphics
        └── wayland-cog-launch
            ├── files
            │   ├── wayland-cog-launch.in
            │   └── wayland-cog-launch.service
            └── wayland-cog-launch_1.0.bb
```

The **meta-meta-moonforge-wpe** directory is a regular Yocto layer. Following the example, this layer provides custom recipes for launching the *Cog browser* and extending the base image with that recipe and other required recipes.

The **kas/include/layer/meta-moonforge-wpe.yml** YAML file is the kas fragment for that layer. See its contents below:

```yml
header:
  version: 16
  includes:
    - kas/include/repo/meta-openembedded.yml
    - kas/include/repo/meta-webkit.yml
    - kas/include/layer/meta-moonforge-graphics.yml

local_conf_header:
  20_meta-moonforge-wpe: |
    PREFERRED_PROVIDER_virtual/wpebackend = "wpebackend-fdo"

repos:
  meta-moonforge:
    layers:
      meta-moonforge-wpe:
  meta-openembedded:
    layers:
      meta-oe:
      meta-python:
      meta-multimedia:
```

The key responsibilities of these layer kas fragments are:

* Inclusion of the external repositories that are required by this layer (e.g., *meta-openembedded*).
* Activation of the specific layers, within an external repository, that are required by this layer (e.g., *meta-oe*).
* Inclusion of other layers required by this layer (e.g., *meta-moonforge-graphics*).
* Activation of the WPE layer itself (e.g., *meta-moonforge-wpe*).
* Definition of sensible defaults for configurations that belong to the *local.conf* file (e.g., *PREFERRED_PROVIDER_virtual*).

The **kas/include/repo/meta-openembedded.yml** YAML file is the kas fragment for that external repository. See its contents below:

```yml
header:
  version: 16

repos:
  meta-openembedded:
    url: http://git.openembedded.org/meta-openembedded
    commit: 15e18246dd0c0585cd1515a0be8ee5e2016d1329
    branch: scarthgap
```

The key responsibilities of these repository kas fragments are:

* Single point of definition for these external resources.
* Availability for inclusion from the different layers.
* Enforcement of fixed versions, which is critical for reproducible builds.
* Inclusion of downstream patches for the layer itself.

## Integration

Just like the Moonforge's layers are built on top of different Yocto layers, other layers can do the same with the *meta-moonforge* layer. The following is a simplified kas configuration file that builds Moonforge's base image for the Raspberry Pi 5 for a potential vendor:

```yml
header:
  version: 16
  includes:
    - repo: meta-moonforge
      file: kas/include/layer/meta-moonforge-distro.yml
    - repo: meta-moonforge
      file: kas/include/layer/meta-moonforge-raspberrypi.yml

local_conf_header:
  30_meta-moonforge-raspberrypi: |
    # Specifies description file for partitioning the image
    WKS_FILE = "moonforge-image-base-raspberrypi.wks.in"
  20_meta-moonforge-distro: |
    # Sets up persistent data partition
    OVERLAYFS_ETC_DEVICE = "/dev/mmcblk0p3"

repos:
  meta-moonforge:
    url: https://github.com/moonforgelinux/meta-moonforge.git
    commit: bf84d3b2623f0268c9644e56e3e7885d53b37906
    branch: main

machine: raspberrypi5
```

The above kas configuration file is almost identical to the first example shown in this document. Kas ability to import remote fragments allows reusing the existing layer and repository fragments, and combining these fragments to build different vendor products.

Additionally, vendors can integrate their own custom layers to extend Moonforge's base image. Check the [meta-derivative](https://github.com/moonforgelinux/meta-derivative) example repository for a quick tutorial on how to build derivative products.

