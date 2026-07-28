DESCRIPTION = "Simple WPE-based web launcher"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=dd93f6e0496294f589c3d561f96ffee4"

inherit meson pkgconfig systemd

DEPENDS = "glib-2.0-native wpewebkit"

SRCREV = "4f0e576194b5c4f632e988d31ff990bdcb5060cc"
SRC_URI = "git://git@github.com/psaavedra/wpe-simple-launcher.git;protocol=ssh;branch=main \
           file://wpe-ctl \
           file://wpe-exported-wayland \
           file://wpe-simple-launcher.service.in \
           file://0001-add-glib-unix-include.patch \
          "

EXTRA_OECMAKE = ""

SYSTEMD_PACKAGES = "wpe-simple-launcher"
SYSTEMD_SERVICE:${PN} = "wpe-simple-launcher.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

WPE_SIMPLE_LAUNCHER_URL ?= "https://www.moonforgelinux.org"

do_compile:append () {
	sed -e "s|@wpe-simple-launcher-url@|${WPE_SIMPLE_LAUNCHER_URL}|g" ${UNPACKDIR}/wpe-simple-launcher.service.in > ${UNPACKDIR}/wpe-simple-launcher.service
}

do_install:append () {
    install -d ${D}/${bindir}/
    install -m 755 ${B}/wpe-simple-launcher ${D}/${bindir}/wpe-simple-launcher
    install -m 755 ${UNPACKDIR}/wpe-ctl ${D}/${bindir}/wpe-ctl
    install -m 755 ${UNPACKDIR}/wpe-exported-wayland ${D}/${bindir}/wpe-exported-wayland
    install -Dm644 ${UNPACKDIR}/wpe-simple-launcher.service ${D}${systemd_unitdir}/system/wpe-simple-launcher.service
}

RDEPENDS:${PN} += "bash"
