FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://rpi_arm64_defconfig_disable_delay.patch \
"
