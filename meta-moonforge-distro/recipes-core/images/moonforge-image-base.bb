#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "A single rootfs image composed of one or more moonforge layers"
LICENSE = "MIT"

inherit moonforge-image

# Set common recipes
CORE_IMAGE_EXTRA_INSTALL += " \
    packagegroup-core-boot \
"
