FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://weston.ini \
    file://background.png \
"

do_install:append() {
	install -Dm644 ${WORKDIR}/background.png ${D}${datadir}/background.png
}

FILES:${PN} += " \
    ${datadir}/background.png \
"
