#
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2026 Igalia S.L.
#

FILESEXTRAPATHS:prepend := "${THISDIR}/systemd:"

TIME_SYNC_TIMEOUT ?= "60"
TIME_SYNC_ACTION = "${@'disable' if d.getVar('TIME_SYNC_TIMEOUT') == '0' else 'enable'}"

SRC_URI += "\
    file://80-moonforge.preset.in \
    file://wait-any.conf \
    file://wait-sync-timeout.conf.in \
"

do_compile:append() {
    sed -e "s|@TIME_SYNC_ACTION@|${TIME_SYNC_ACTION}|g" \
        ${WORKDIR}/80-moonforge.preset.in > ${WORKDIR}/80-moonforge.preset

    sed -e "s|@TIME_SYNC_TIMEOUT@|${TIME_SYNC_TIMEOUT}|g" \
        ${WORKDIR}/wait-sync-timeout.conf.in > ${WORKDIR}/wait-sync-timeout.conf
}

do_install:append() {
    # Configure time-wait-sync preset
    install -Dm 0644 ${WORKDIR}/80-moonforge.preset \
        ${D}${systemd_unitdir}/system-preset/80-moonforge.preset

    # Consider the network online once ANY link is up
    install -Dm 0644 ${WORKDIR}/wait-any.conf \
        ${D}${systemd_system_unitdir}/systemd-networkd-wait-online.service.d/wait-any.conf

    # Timeout override (dormant if preset is disabled)
    install -Dm 0644 ${WORKDIR}/wait-sync-timeout.conf \
        ${D}${systemd_system_unitdir}/systemd-time-wait-sync.service.d/wait-sync-timeout.conf
}

FILES:${PN} += "\
    ${systemd_unitdir}/system-preset/80-moonforge.preset \
    ${systemd_system_unitdir}/systemd-networkd-wait-online.service.d/wait-any.conf \
    ${systemd_system_unitdir}/systemd-time-wait-sync.service.d/wait-sync-timeout.conf \
"
