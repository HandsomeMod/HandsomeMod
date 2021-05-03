#
# Copyright (C) 2020-2021 HandsomeMod Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS := QCOM_DTS QCOM_DTS_DIR

# TODO Ramdisk
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

define mkBootimg_noRamdisk
mkbootimg --base $(1) \
	--kernel_offset $(2) \
	--tags_offset $(3) \
	--pagesize $(4) \
	--second_offset $(5) \
	--cmdline $(6) \
	--kernel $(7) \
	-o $(8)
endef


# Step1 Build the Bootimg
# No Ramdisk For Now
define Build/qcom-bootimg
	rm -f $@.zImage-dtb
	cat $(KDIR)/zImage $(DTS_DIR)/$(QCOM_DTS).dtb > $@.zImage-dtb
	# TODO Ramdisk
	$(call mkBootimg_noRamdisk, \
		$(QCOM_BOOTIMG_FLASH_OFFSET_BASE), \
		$(QCOM_BOOTIMG_FLASH_OFFSET_KERNEL), \
		$(QCOM_BOOTIMG_FLASH_OFFSET_TAGS), \
		$(QCOM_BOOTIMG_FLASH_OFFSET_PAGESIZE), \
		$(QCOM_BOOTIMG_FLASH_OFFSET_SECOND), \
		$(QCOM_CMDLINE), \
		$@.zImage-dtb, \
		$@, \
		)
	rm -f $@.zImage-dtb
endef

# Step2 Build the System.img
define Build/qcom-systemimg
	simg2img $(IMAGE_ROOTFS) $@
endef


define Device/Default
  PROFILES = Default
  KERNEL_NAME := zImage
  KERNEL := kernel-bin | uImage none
  IMAGES := boot.img system.img
  IMAGE/boot.img := qcom-bootimg | append-metadata
  IMAGE/system.img := qcom-systemimg | append-metadata
  QCOM_CMDLINE := "earlycon console=ttyMSM0,115200 console=tty0 rw"
  QCOM_DTS_DIR := qcom/
  QCOM_DTS = $$(QCOM_DTS_DIR)$$(SOC)-$(lastword $(subst _, ,$(1)))
  QCOM_BOOTIMG_FLASH_OFFSET_BASE := 0x80000000
  QCOM_BOOTIMG_FLASH_OFFSET_KERNEL:= 0x00080000
  QCOM_BOOTIMG_FLASH_OFFSET_SECOND:= 0x00f00000
  QCOM_BOOTIMG_FLASH_OFFSET_TAGS:= 0x01e00000
  QCOM_BOOTIMG_FLASH_OFFSET_PAGESIZE:= 2048
endef

# Qcom Default Dts
define Device/Qcom
  QCOM_DTS_DIR := qcom/
  KERNEL_NAME := Image
  KERNEL := kernel-bin
endef


include $(SUBTARGETS).mk

$(eval $(call BuildImage))
