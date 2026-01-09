FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://storage.conf \
    file://container-host-config.conf \
"

do_install:append() {
	install ${WORKDIR}/storage.conf ${D}/${sysconfdir}/containers/storage.conf
	install -Dm644 ${WORKDIR}/container-host-config.conf ${D}${nonarch_libdir}/tmpfiles.d/container-host-config.conf
}

FILES:${PN} += " \
    ${sysconfdir}/containers/storage.conf \
    ${nonarch_libdir}/tmpfiles.d/container-host-config.conf \
"
