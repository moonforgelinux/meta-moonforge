FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RDEPENDS:${PN} += "grub-editenv e2fsprogs-mke2fs"
