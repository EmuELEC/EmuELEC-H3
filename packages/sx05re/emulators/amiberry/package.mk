# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Frank Hartung (supervisedthinking (@) gmail.com)

PKG_NAME="amiberry"
PKG_VERSION="b957c4754d03de286d90150a3bb05b36dfe6da3e"
PKG_ARCH="arm"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/midwan/amiberry"
PKG_URL="https://github.com/midwan/amiberry.git"
PKG_DEPENDS_TARGET="toolchain linux glibc bzip2 zlib SDL2-git SDL2_image SDL2_ttf capsimg freetype libxml2 flac libogg mpg123-compat libpng libmpeg2"
PKG_LONGDESC="Amiberry is an optimized Amiga emulator for ARM-based boards."
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="make"
PKG_GIT_CLONE_BRANCH="master"

PKG_MAKE_OPTS_TARGET="all"

pre_configure_target() {
  cd ${PKG_BUILD}
  export SYSROOT_PREFIX=${SYSROOT_PREFIX}

  case ${PROJECT} in
    Amlogic)
        AMIBERRY_PLATFORM="AMLGX"
      ;;
    Amlogic-ng)
        AMIBERRY_PLATFORM="AMLG12B"
      ;;
    H3)
        AMIBERRY_PLATFORM="orangepi-pc"

      ;;
  esac

  PKG_MAKE_OPTS_TARGET+=" PLATFORM=${AMIBERRY_PLATFORM}"
}

makeinstall_target() {
  # Create directories
  mkdir -p ${INSTALL}/usr/bin
  mkdir -p ${INSTALL}/usr/lib
  mkdir -p ${INSTALL}/usr/config/amiberry
  # mkdir -p ${INSTALL}/usr/config/amiberry/controller

  # Copy ressources
  cp -a ${PKG_DIR}/config/*           ${INSTALL}/usr/config/amiberry/
  cp -a data                          ${INSTALL}/usr/config/amiberry/
  cp -a savestates                    ${INSTALL}/usr/config/amiberry/
  cp -a screenshots                   ${INSTALL}/usr/config/amiberry/
  cp -a whdboot                       ${INSTALL}/usr/config/amiberry/
  ln -s /storage/roms/bios/Kickstarts ${INSTALL}/usr/config/amiberry/kickstarts

  # Create links to Retroarch controller files
  # ln -s /usr/share/retroarch/autoconfig/udev/8Bitdo_Pro_SF30_BT_B.cfg "${INSTALL}/usr/config/amiberry/controller/8Bitdo SF30 Pro.cfg"
  ln -s "/tmp/joypads" "${INSTALL}/usr/config/amiberry/controller"

  # Copy binary, scripts & link libcapsimg
  cp -a amiberry* ${INSTALL}/usr/bin/amiberry
  cp -a ${PKG_DIR}/scripts/*          ${INSTALL}/usr/bin
  ln -sf /usr/lib/libcapsimage.so.5.1 ${INSTALL}/usr/config/amiberry/capsimg.so
}
