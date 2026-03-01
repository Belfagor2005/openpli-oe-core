DESCRIPTION = "Linux kernel for ${MACHINE}"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

KERNEL_RELEASE = "4.4.176"
SRCDATE = "20221203"

inherit kernel machine_kernel_pr

MACHINE_KERNEL_PR:append = ".8"

SRC_URI[mv300.md5sum] = "9c400b45c9bc7949c97ddb5bf6714b1e"
SRC_URI[mv300.sha256sum] = "e5604bb3576ead02b23861b0dde082a2b219fe7a622d973f7a52aaafbc56f7bb"

SRC_URI += "http://downloads.openpli.org/archive/uclan/uclan-linux-${PV}-${SRCDATE}.tar.gz;name=mv300 \
    file://defconfig \
    file://initramfs-subdirboot.cpio.gz;unpack=0 \
    file://findkerneldevice.sh \
    file://fix-multiple-defs-yyloc.patch \
    file://fix-build-with-binutils-2.41.patch \
"

COMPATIBLE_MACHINE = "ustym4ks2ottx"

S = "${WORKDIR}/linux-${PV}"
B = "${WORKDIR}/build"

export OS = "Linux"
KERNEL_OBJECT_SUFFIX = "ko"
KERNEL_IMAGEDEST = "tmp"
KERNEL_IMAGETYPE = "uImage"
KERNEL_OUTPUT = "arch/${ARCH}/boot/${KERNEL_IMAGETYPE}"

KERNEL_EXTRA_ARGS = "EXTRA_CFLAGS=-Wno-attribute-alias"

FILES:${KERNEL_PACKAGE_NAME}-image = "${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE} /${KERNEL_IMAGEDEST}/findkerneldevice.sh"

kernel_do_configure:prepend() {
	install -d ${B}/usr
	install -m 0644 ${WORKDIR}/initramfs-subdirboot.cpio.gz ${B}/
}

kernel_do_install:append() {
	install -d ${D}/${KERNEL_IMAGEDEST}
	install -m 0755 ${KERNEL_OUTPUT} ${D}/${KERNEL_IMAGEDEST}
	install -m 0755 ${WORKDIR}/findkerneldevice.sh ${D}${KERNEL_IMAGEDEST}
}

pkg_postinst:kernel-image () {
    if [ "x$D" == "x" ]; then
        if [ -f /${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE} ] ; then
            /${KERNEL_IMAGEDEST}/./findkerneldevice.sh
            dd if=/${KERNEL_IMAGEDEST}/${KERNEL_IMAGETYPE} of=/dev/kernel
        fi
    fi
    true
}

do_rm_work() {
}
