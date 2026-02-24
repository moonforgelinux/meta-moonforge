#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "Provides a configuration file with moonforge settings"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://daemon.json \
"

do_install() {
	install -Dm644 ${WORKDIR}/daemon.json ${D}${sysconfdir}/docker/daemon.json
}

FILES:${PN} = " \
    ${sysconfdir}/docker/daemon.json \
"
