# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2020-2022 HandsomeMod Project
#
# THANKS TO:
# Postmarket OS Project
# msm8916-mainline Project

include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=msm89xx
BOARDNAME:=Qualcomm Msm89xx Soc
FEATURES:=fpu usb ext4 display rtc usbgadget gpio
SUBTARGETS:=msm8916
MAINTAINER:=HandsomeYingyan <handsomeyingyan@gmail.com>

KERNEL_PATCHVER:=5.10
KERNEL_TESTING_PATCHVER:=5.10
KERNELNAME:=Image.gz dtbs

define Target/Description
	Build firmware images for Qualcomm Msm89xx Soc based SmartPhones Tablets and Boards.
endef

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += partx-utils mkf2fs e2fsprogs
DEFAULT_PACKAGES += kmod-wcn36xx kmod-qcom-remoteproc kmod-qcom-wcnss kmod-qcom-bluetooth

$(eval $(call BuildTarget))
