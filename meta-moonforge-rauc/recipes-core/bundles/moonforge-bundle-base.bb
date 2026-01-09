#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

inherit bundle

RAUC_BUNDLE_COMPATIBLE = "${MACHINE}"
RAUC_BUNDLE_VERSION = "${IMAGE_VERSION}"
RAUC_BUNDLE_DESCRIPTION = "${IMAGE_ID}"

RAUC_BUNDLE_FORMAT = "verity"

RAUC_BUNDLE_SLOTS = "rootfs"

RAUC_SLOT_rootfs = "moonforge-image-base"
RAUC_SLOT_rootfs[fstype] = "ext4"
