FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SPLASH_IMAGES:rpi = "file://logo-moonforge.png;outsuffix=raspberrypi"

do_install:append() {
	# Restore psplash binary
	install -m 0755 ${B}/psplash ${D}${bindir}/psplash
}
