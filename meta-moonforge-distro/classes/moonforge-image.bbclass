#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

# Include IMAGE_VERSION in the image name
IMAGE_VERSION_SUFFIX = "-${IMAGE_VERSION}"
IMAGE_NAME = "${IMAGE_BASENAME}-${MACHINE}${IMAGE_VERSION_SUFFIX}"
IMAGE_FSTYPES:append = " ext4 wic.bz2"

# Set up persistent data partition
OVERLAYFS_ETC_MOUNT_POINT ?= "/data"
OVERLAYFS_ETC_FSTYPE ?= "ext4"

inherit core-image

# Set common features
IMAGE_FEATURES += " \
    splash \
    read-only-rootfs \
    overlayfs-etc \
"
