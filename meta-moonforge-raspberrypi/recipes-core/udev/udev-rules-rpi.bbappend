FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://framebuf.rules \
"

do_install:append() {
	install -m 0644 ${WORKDIR}/framebuf.rules ${D}${sysconfdir}/udev/rules.d/
}
