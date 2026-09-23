FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RDEPENDS:${PN} += "e2fsprogs-mke2fs grub-editenv"
