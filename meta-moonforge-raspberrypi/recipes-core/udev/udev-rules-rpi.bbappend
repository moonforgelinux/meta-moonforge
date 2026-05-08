FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://framebuf.rules \
"

do_install:append() {
	install -m 0644 ${UNPACKDIR}/framebuf.rules ${D}${sysconfdir}/udev/rules.d/
}
