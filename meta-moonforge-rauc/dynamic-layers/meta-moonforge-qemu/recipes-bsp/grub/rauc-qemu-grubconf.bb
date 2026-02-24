#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2021 Enrico Jorns <ejo@pengutronix.de>
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "Grub configuration file to use with RAUC"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

include conf/image-uefi.conf

RPROVIDES:${PN} += "virtual-grub-bootconf"

SRC_URI += " \
    file://grub.cfg \
    file://grubenv \
    "

S = "${WORKDIR}"

inherit deploy

do_install() {
        install -d ${D}${EFI_FILES_PATH}
        install -m 644 ${WORKDIR}/grub.cfg ${D}${EFI_FILES_PATH}/grub.cfg
}

FILES:${PN} += "${EFI_FILES_PATH}"

do_deploy() {
	install -m 644 ${WORKDIR}/grub.cfg ${DEPLOYDIR}
	install -m 644 ${WORKDIR}/grubenv ${DEPLOYDIR}
}

addtask deploy after do_install before do_build
