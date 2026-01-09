#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "Updates the system using RAUC"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
        file://rauc-update \
        file://rauc-update.service.in \
        file://rauc-update.timer \
"

S = "${WORKDIR}"

inherit systemd

SYSTEMD_PACKAGES = "rauc-update"
SYSTEMD_SERVICE:${PN} = "rauc-update.timer"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

RDEPENDS:${PN} += " \
        rauc \
        systemd \
"

RAUC_BUNDLE_URL ?= "https://localhost/ota/${IMAGE_ID}/LATEST.raucb"
RAUC_FORCE_REBOOT_ON_UPDATE ?= "1"

do_compile () {
        RAUC_FLAGS=$([ "${RAUC_FORCE_REBOOT_ON_UPDATE}" = "1" ] && echo "-r" || echo "")
        sed -e "s|@RAUC_BUNDLE_URL@|${RAUC_BUNDLE_URL}|g" rauc-update.service.in > rauc-update.service
        sed -i "s|@RAUC_FLAGS@|${RAUC_FLAGS}|g" rauc-update.service
}

do_install () {
        install -Dm 0755 ${WORKDIR}/rauc-update ${D}${bindir}/rauc-update
        install -Dm 0644 ${WORKDIR}/rauc-update.service ${D}${systemd_unitdir}/system/rauc-update.service
        install -Dm 0644 ${WORKDIR}/rauc-update.timer ${D}${systemd_unitdir}/system/rauc-update.timer
}

FILES:${PN} = " \
        ${bindir}/rauc-update \
        ${systemd_unitdir}/system/rauc-update.service \
        ${systemd_unitdir}/system/rauc-update.timer \
"
