#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2021 Enrico Jorns <ejo@pengutronix.de>
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "Grub configuration file to use with RAUC"
DESCRIPTION = "Installs and deploys the GRUB configuration and environment used \
to boot the RAUC A/B slots on the QEMU machine."
HOMEPAGE = "https://github.com/moonforgelinux/meta-moonforge"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# EFI_FILES_PATH comes from openembedded-core, which is outside the
# meta-moonforge-* files the linter is pointed at, so it cannot resolve this.
# nooelint: oelint.file.requirenotfound
require conf/image-uefi.conf

SRC_URI += "\
    file://grub.cfg \
    file://grubenv \
    "

S = "${WORKDIR}"

FILES:${PN} += "${EFI_FILES_PATH}"

RPROVIDES:${PN} += "virtual-grub-bootconf"

inherit deploy

do_install() {
        install -d ${D}${EFI_FILES_PATH}
        install -m 644 ${WORKDIR}/grub.cfg ${D}${EFI_FILES_PATH}/grub.cfg
}

do_deploy() {
    install -m 644 ${WORKDIR}/grub.cfg ${DEPLOYDIR}
    install -m 644 ${WORKDIR}/grubenv ${DEPLOYDIR}
}

addtask deploy after do_install before do_build
