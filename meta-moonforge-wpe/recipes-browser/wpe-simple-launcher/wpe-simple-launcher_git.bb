DESCRIPTION = "Simple WPE-based web launcher"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=dd93f6e0496294f589c3d561f96ffee4"

inherit meson pkgconfig

DEPENDS = "glib-2.0-native wpewebkit"

SRCREV = "4f0e576194b5c4f632e988d31ff990bdcb5060cc"
SRC_URI = "git://git@github.com/psaavedra/wpe-simple-launcher.git;protocol=ssh;branch=main \
           file://wpe-ctl \
           file://wpe-exported-wayland \
           file://0001-add-glib-unix-include.patch \
          "

EXTRA_OECMAKE = ""

do_install:append () {
    install -d ${D}/${bindir}/
    install -m 755 ${B}/wpe-simple-launcher ${D}/${bindir}/wpe-simple-launcher
    install -m 755 ${UNPACKDIR}/wpe-ctl ${D}/${bindir}/wpe-ctl
    install -m 755 ${UNPACKDIR}/wpe-exported-wayland ${D}/${bindir}/wpe-exported-wayland
}

RDEPENDS:${PN} += "bash"
