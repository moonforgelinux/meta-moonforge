#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "Provides a configuration file with moonforge settings"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

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
