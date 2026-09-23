#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "RAUC bundle wrapping the base Moonforge image"
DESCRIPTION = "Packs moonforge-image-base into a verity-format RAUC bundle that \
the A/B update flow installs into the rootfs slot."
HOMEPAGE = "https://github.com/moonforgelinux/meta-moonforge"
LICENSE = "MIT"

inherit bundle

RAUC_BUNDLE_COMPATIBLE = "${MACHINE}"
RAUC_BUNDLE_VERSION = "${IMAGE_VERSION}"
RAUC_BUNDLE_DESCRIPTION = "${IMAGE_ID}"

RAUC_BUNDLE_FORMAT = "verity"

RAUC_BUNDLE_SLOTS = "rootfs"

RAUC_SLOT_rootfs = "moonforge-image-base"
RAUC_SLOT_rootfs[fstype] = "ext4"
