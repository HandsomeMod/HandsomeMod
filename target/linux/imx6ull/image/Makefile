#
# Copyright (C) 2020-2021 HandsomeMod Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

FAT32_BLOCK_SIZE=1024
SD_BOOT_PARTSIZE=40
FAT32_BLOCKS=$(shell echo $$(($(SD_BOOT_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

KERNEL_LOADADDR:=0x85000000

define Build/imx-sdcard
	rm -f $@.boot
	mkfs.fat $@.boot -C $(FAT32_BLOCKS)
	
	#mcopy -i $@.boot $(STAGING_DIR_IMAGE)/$(DEVICE_NAME)-boot.scr ::boot.scr
	mcopy -i $@.boot $(DTS_DIR)/$(DEVICE_DTS).dtb ::dtb
	mcopy -i $@.boot $(IMAGE_KERNEL) ::zImage
	./gen_imx_sdcard_img.sh $@ \
		$@.boot \
		$(IMAGE_ROOTFS) \
		$(SD_BOOT_PARTSIZE) \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) \
		$(STAGING_DIR_IMAGE)/$(DEVICE_NAME)-u-boot-imx.bin
	rm -f $@.boot
endef

# why \x00\x00\x00\x00 for zImage-initramfs
define Device/Default
  PROFILES := Generic
  FILESYSTEMS := squashfs ext4
  KERNEL_INSTALL := 1
  KERNEL_SUFFIX := -uImage
  KERNEL_NAME := zImage
  KERNEL_PREFIX := $$(IMAGE_PREFIX)
endef


define Device/alientek_mini_emmc
  DEVICE_VENDOR := AlienTek
  DEVICE_MODEL := I.MX6ULL Mini With Emmc
  DEVICE_DTS := imx6ull-alientek-mini-emmc
  KERNEL := kernel-bin | uImage none
  IMAGES := sdcard.img.gz
  IMAGE/sdcard.img.gz := imx-sdcard | append-metadata | gzip
endef
TARGET_DEVICES += alientek_mini_emmc

$(eval $(call BuildImage))
