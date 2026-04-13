FILESEXTRAPATHS:prepend := "${THISDIR}/systemd:"

SRC_URI += " \
    file://wait-any.conf \
"

do_install:append() {
	install -d ${D}${systemd_system_unitdir}/systemd-networkd-wait-online.service.d
	install -m 0644 ${WORKDIR}/wait-any.conf ${D}${systemd_system_unitdir}/systemd-networkd-wait-online.service.d/
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/systemd-networkd-wait-online.service.d/wait-any.conf \
"
