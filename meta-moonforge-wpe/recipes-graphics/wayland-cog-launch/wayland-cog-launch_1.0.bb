#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "Launches cog on startup"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://wayland-cog-launch.in \
    file://wayland-cog-launch.service \
"

S = "${WORKDIR}"

inherit systemd

SYSTEMD_PACKAGES = "wayland-cog-launch"
SYSTEMD_SERVICE:${PN} = "wayland-cog-launch.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

RDEPENDS:${PN} = " \
    weston-init \
    cog \
"

WAYLAND_COG_LAUNCH_URL ?= "https://www.moonforgelinux.org"

do_compile () {
	sed -e "s|@wayland-cog-launch-url@|${WAYLAND_COG_LAUNCH_URL}|g" wayland-cog-launch.in > wayland-cog-launch
}

do_install () {
	install -Dm755 ${WORKDIR}/wayland-cog-launch ${D}${bindir}/wayland-cog-launch
	install -Dm644 ${WORKDIR}/wayland-cog-launch.service ${D}${systemd_unitdir}/system/wayland-cog-launch.service
}

FILES:${PN} = " \
    ${bindir}/wayland-cog-launch \
    ${systemd_unitdir}/system/wayland-cog-launch.service \
"
