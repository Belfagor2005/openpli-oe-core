SUMMARY = "dual partitions files"
SECTION = "base"
PRIORITY = "required"
LICENSE = "CLOSED"
require conf/license/license-gplv2.inc
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit deploy

SRCDATE = "20220915"

S = "${WORKDIR}"

SRC_URI = "http://downloads.openpli.org/archive/qviart/dags-partitions-${MACHINE}_${SRCDATE}.tar.gz \
        file://flash-updater"

inherit update-rc.d

INITSCRIPT_NAME = "flash-updater"
INITSCRIPT_PARAMS = "start 90 S ."

#ALLOW_EMPTY:${PN} = "1"
do_configure[nostamp] = "1"

do_compile() {
}

do_install() {
    install -d ${D}/usr/share
    install -m 0644 ${S}/apploader.bin ${D}/usr/share/apploader.bin
    install -m 0644 ${S}/fastboot.bin ${D}/usr/share/fastboot.bin
    install -m 0644 ${S}/bootargs.bin ${D}/usr/share/bootargs.bin
    install -m 0755 -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/flash-updater ${D}${sysconfdir}/init.d/flash-updater
    install -m 0755 ${S}/apploader.bin ${DEPLOY_DIR_IMAGE}/apploader.bin
}

do_deploy() {
}

do_package_qa() {
}

SRC_URI[md5sum] = "076cda40a60b602c28daaa08dbbbcfcf"
SRC_URI[sha256sum] = "71cd0306028a64ab37ab80737355a2d88d1cf13b87e02e8184fa2eb3e49e41b5"

FILES:${PN} = "/usr/share ${sysconfdir}"

INSANE_SKIP:${PN} += "already-stripped"

pkg_postinst:${PN}() {
    if [ "x$D" == "x" ]; then
        if [ -f /usr/share/apploader.bin -a -b /dev/block/by-name/loader ] ; then
            dd if=/usr/share/apploader.bin of=/dev/block/by-name/loader
        fi
        if [ -f /usr/share/fastboot.bin -a -b /dev/block/by-name/fastboot ] ; then
            dd if=/usr/share/fastboot.bin of=/dev/block/by-name/fastboot
        fi
        if [ -f /usr/share/bootargs.bin -a -b /dev/block/by-name/bootargs ] ; then
            dd if=/usr/share/bootargs.bin of=/dev/block/by-name/bootargs
        fi
    fi
    true
}
