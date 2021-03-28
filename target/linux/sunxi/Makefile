# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2013-2016 OpenWrt.org
# Copyright (C) 2020-2021 HandsomeMod Project

include $(TOPDIR)/rules.mk

ARCH:=arm
BOARD:=sunxi
BOARDNAME:=Allwinner Socs
FEATURES:=fpu usb ext4 display rtc squashfs usbgadget gpio
SUBTARGETS:=cortexa8 cortexa7 cortexa53 arm9
MAINTAINER:=HandsomeYingyan<handosmeyingyan@gmali.com>

KERNEL_PATCHVER:=5.4
KERNEL_TESTING_PATCHVER:=5.4
KERNELNAME:=zImage dtbs

# A10: Cortex-A8
# A13: Cortex-A8
# V3s/S3: Cortex-A7
# A20: dual Cortex-A7
# A31: quad Cortex-A7
# A80: octa Cortex-A15/A7
# H3: quad Cortex-A7
# R40: quad Cortex-A7
# F1Cx00s: ARM 926EJS



include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += uboot-envtools
DEFAULT_PACKAGES += partx-utils mkf2fs e2fsprogs

$(eval $(call BuildTarget))
