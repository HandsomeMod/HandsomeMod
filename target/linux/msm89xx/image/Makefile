# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2020-2022 HandsomeMod Project
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS := QCOM_DTS QCOM_DTS_DIR

define mkBootimg
mkbootimg --base $(1) \
	--kernel_offset $(2) \
	--ramdisk_offset $(3) \
	--tags_offset $(4) \
	--pagesize $(5) \
	--second_offset $(6) \
	--ramdisk $(7) \
	--cmdline $(8) \
	--kernel $(9) \
	-o $(10)
endef

# Step1 Build the Bootimg
# Fake Ramdisk For Now
define Build/qcom-bootimg
	rm -f $@.kernel-dtb
	rm -f $@.fake-ramdisk
	cp $(KDIR)/Image.gz $@.kernel
	cat $(KDIR)/Image.gz $(DTS_DIR)/$(QCOM_DTS).dtb > $@.kernel-dtb
	# Just Generate A Fake ramdisk
	touch $@.fake-ramdisk
	$(call mkBootimg, \
		$(QCOM_BOOTIMG_FLASH_OFFSET_BASE), \
		$(QCOM_BOOTIMG_FLASH_OFFSET_KERNEL), \
		$(QCOM_BOOTIMG_FLASH_OFFSET_RAMDISK), \
		$(QCOM_BOOTIMG_FLASH_OFFSET_TAGS), \
		$(QCOM_BOOTIMG_FLASH_OFFSET_PAGESIZE), \
		$(QCOM_BOOTIMG_FLASH_OFFSET_SECOND), \
		$@.fake-ramdisk, \
		$(QCOM_CMDLINE), \
		$@.kernel-dtb, \
		$@, \
		)
	rm -f $@.kernel-dtb
	rm -f $@.fake-ramdisk
endef

# Step2 Build the System.img ext4 -> simg
define Build/qcom-systemimg
	img2simg $(IMAGE_ROOTFS) $@
endef


define Device/Default
  PROFILES = Default
  KERNEL_NAME := Image.gz
  KERNEL := kernel-bin
  IMAGES := boot.img system.img
  IMAGE/boot.img := qcom-bootimg | append-metadata
  IMAGE/system.img := qcom-systemimg | append-metadata
  QCOM_CMDLINE := "earlycon console=ttyMSM0,115200 console=tty0 rw"
  QCOM_DTS_DIR := qcom/
  QCOM_DTS = $$(QCOM_DTS_DIR)$$(SOC)-$(lastword $(subst _, ,$(1)))
  QCOM_BOOTIMG_FLASH_OFFSET_BASE := 0x80000000
  QCOM_BOOTIMG_FLASH_OFFSET_KERNEL:= 0x00080000
  QCOM_BOOTIMG_FLASH_OFFSET_RAMDISK := 0x02000000
  QCOM_BOOTIMG_FLASH_OFFSET_SECOND:= 0x00f00000
  QCOM_BOOTIMG_FLASH_OFFSET_TAGS:= 0x01e00000
  QCOM_BOOTIMG_FLASH_OFFSET_PAGESIZE:= 2048
endef

# Qcom Default Dts
define Device/Qcom
  QCOM_DTS_DIR := qcom/
  KERNEL_NAME := Image.gz
  KERNEL := kernel-bin
endef


include msm8916.mk

$(eval $(call BuildImage))
