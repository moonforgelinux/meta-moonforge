#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2025 Igalia S.L.
#

SUMMARY = "Simple WPE-based web launcher"
DESCRIPTION = "On-device WPEWebKit launcher that opens a URL and exposes a FIFO control channel through the wpe-ctl helper."
HOMEPAGE = "https://github.com/psaavedra/wpe-simple-launcher"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=dd93f6e0496294f589c3d561f96ffee4"

inherit meson pkgconfig systemd

DEPENDS += "glib-2.0 wpewebkit"

SRC_URI = "git://github.com/psaavedra/wpe-simple-launcher.git;protocol=https;branch=main \
           file://wpe-ctl \
           file://wpe-exported-wayland \
           file://wpe-simple-launcher.service.in \
          "
SRCREV = "522488025d1e68d039667bd897b3e8f4ee820061"

S = "${WORKDIR}/git"

SYSTEMD_PACKAGES = "wpe-simple-launcher"
SYSTEMD_SERVICE:${PN} = "wpe-simple-launcher.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

WPE_SIMPLE_LAUNCHER_URL ?= "https://www.moonforgelinux.org"

do_compile:append () {
    sed -e "s|@wpe-simple-launcher-url@|${WPE_SIMPLE_LAUNCHER_URL}|g" ${WORKDIR}/wpe-simple-launcher.service.in > ${WORKDIR}/wpe-simple-launcher.service
}

do_install:append () {
    install -d ${D}/${bindir}/
    install -m 755 ${B}/wpe-simple-launcher ${D}/${bindir}/wpe-simple-launcher
    install -m 755 ${WORKDIR}/wpe-ctl ${D}/${bindir}/wpe-ctl
    install -m 755 ${WORKDIR}/wpe-exported-wayland ${D}/${bindir}/wpe-exported-wayland
    install -Dm644 ${WORKDIR}/wpe-simple-launcher.service ${D}${systemd_unitdir}/system/wpe-simple-launcher.service
}
