require conf/machine/include/gigablue-arm.inc

MACHINE_KERNEL_PR = "${@bb.utils.contains('MACHINE', 'gbquad4kpro', 'r9' , 'r7', d)}"

MACHINE_EXTRA_RRECOMMENDS = " \
    gst-plugin-dvbmediasink \
    ntfs-3g \
"

PREFERRED_VERSION_linux-gigablue = "4.1.20"
PREFERRED_PROVIDER_virtual/kernel = "linux-gigablue"
PREFERRED_PROVIDER_virtual/kodi = "stb-kodi-gb7252"

PACKAGECONFIG_GL:pn-qtbase = " gles2 eglfs linuxfb"

# xbmc/kodi support
DEPENDS:append:pn-kodi = " gigablue-kodi-${MACHINE}"

IMGDEPLOYDIR ?= "${DEPLOY_DIR_IMAGE}"

IMAGE_CMD:tar:prepend = "\
    rm -Rf ${IMAGE_ROOTFS}/tmp/*; \
    mkdir -p ${IMGDEPLOYDIR}/${IMAGEDIR}; \
    cp ${DEPLOY_DIR_IMAGE}/${MACHINE}_boot.bin ${IMGDEPLOYDIR}/${IMAGEDIR}/boot.bin; \
    cp ${DEPLOY_DIR_IMAGE}/${MACHINE}_gpt.bin ${IMGDEPLOYDIR}/${IMAGEDIR}/gpt.bin; \
    cp ${DEPLOY_DIR_IMAGE}/${MACHINE}_rescue.bin ${IMGDEPLOYDIR}/${IMAGEDIR}/rescue.bin; \
    cp ${DEPLOY_DIR_IMAGE}/${MACHINE}_bolt_${SRCDATE_BOLT}.bin ${IMGDEPLOYDIR}/${IMAGEDIR}/bolt_${SRCDATE_BOLT}.bin; \
    cp ${DEPLOY_DIR_IMAGE}/zImage ${IMGDEPLOYDIR}/${IMAGEDIR}/kernel.bin; \
    echo ${DISTRO_NAME}-${DISTRO_VERSION}.${BUILD_VERSION} > ${IMGDEPLOYDIR}/${IMAGEDIR}/imageversion; \
    cd ${IMAGE_ROOTFS}; \
    tar -cvf ${IMGDEPLOYDIR}/rootfs.tar -C ${IMAGE_ROOTFS} .; \
    mv ${IMGDEPLOYDIR}/rootfs.tar ${IMGDEPLOYDIR}/${IMAGEDIR}/rootfs.tar; \
    bzip2 ${IMGDEPLOYDIR}/${IMAGEDIR}/rootfs.tar; \
    cd ${IMGDEPLOYDIR}; \
    zip ${IMAGE_NAME}_usb.zip ${IMAGEDIR}/*; \
    rm -Rf gigablue; \
"

MACHINE_ESSENTIAL_EXTRA_RDEPENDS += " \
    gigablue-platform-util-${MACHINE_DRIVER} \
    gigablue-ddbootup \
    gigablue-swapcreate \
"

MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += " \
    gb-v3ddriver-${MACHINE_DRIVER} \
    gb-qteglfs-platform \
    ${@bb.utils.contains('MACHINE', 'gbquad4kpro', 'gigablue-firmware-aic8800d80 gigablue-aic8800-driver gigablue-bluetooth-keymaps' , '', d)} \
    kernel-module-88xxau \
    kernel-module-88x2bu \
    "

EXTRA_IMAGEDEPENDS = "\
    gigablue-initrd-cfe-${MACHINE} \
    "

OPTIONAL_BSP_PACKAGES += "\
    gigablue-bootloader-${MACHINE} \
    "

OPTIONAL_BSP_ENIGMA2_PACKAGES = "\
    enigma2-plugin-extensions-hbbtv-gb \
    enigma2-plugin-extensions-chromium \
    "
