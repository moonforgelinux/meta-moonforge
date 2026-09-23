#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "A single rootfs image composed of one or more moonforge layers"
DESCRIPTION = "Base Moonforge rootfs image: a read-only root filesystem with an \
overlayfs-backed /etc and a persistent /data partition, as set up by the \
moonforge-image class."
HOMEPAGE = "https://github.com/moonforgelinux/meta-moonforge"
LICENSE = "MIT"

inherit moonforge-image
