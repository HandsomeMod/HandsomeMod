#
# Copyright (C) 2006-2011 OpenWrt.org
# Copyright (C) 2020-2021 HandsomeMod Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=mips64el
BOARD:=loongson64
BOARDNAME:=Loongson64 Based Socs
FEATURES:=squashfs ext4 targz fpu display usbgadget gpio
SUBTARGETS:=generic 
MAINTAINER:=HandsomeYingyan<handosmeyingyan@gmali.com>

KERNEL_PATCHVER:=5.10
KERNEL_TESTING_PATCHVER:=5.10
KERNELNAME:=vmlinuz
# vmlinuz is not in arch/mips/boot/
IMAGES_DIR:=../../..

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += partx-utils mkf2fs e2fsprogs

$(eval $(call BuildTarget))

$(eval $(call $(if $(CONFIG_TARGET_ROOTFS_ISO),RequireCommand,Ignore),mkisofs, \
   	Please install mkisofs. \
))
