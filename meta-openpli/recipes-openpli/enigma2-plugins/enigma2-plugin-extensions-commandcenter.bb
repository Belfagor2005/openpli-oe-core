SUMMARY = "CommandCenter by Lululla"
MAINTAINER = "Lululla"
SECTION = "base"
PRIORITY = "required"
LICENSE = "CLOSED"

inherit gitpkgv allarch

SRCREV = "${AUTOREV}"
PV = "1.0+git${SRCPV}"
PKGV = "1.0+git${GITPKGV}"
VER ="1.0"
PR = "r0"

SRC_URI = "git://github.com/OwnerPlugins/CommandCenter.git;protocol=https;branch=main"

S = "${WORKDIR}/git"

FILES:${PN} = "/usr/*"

do_install() {
    if [ -d ${S}/usr ]; then
        cp -rp ${S}/usr/* ${D}/usr/
    fi
    if [ -d ${S}/etc ]; then
        cp -rp ${S}/etc/* ${D}/etc/
    fi
}