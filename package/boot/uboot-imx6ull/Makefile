#
# Copyright (C) 2020-2021 HandsomeMod Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_VERSION:=2019.04
PKG_RELEASE:=1

PKG_HASH:=76b7772d156b3ddd7644c8a1736081e55b78828537ff714065d21dbade229bef

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=imx6ull
  UBOOT_IMAGE:=u-boot-dtb.imx
  UENV:=default
  HIDDEN:=1
endef

define U-Boot/imx6ull_alientek_mini_emmc
  NAME:=AlienTek I.MX6ULL Mini With Emmc
  BUILD_DEVICES:=alientek_mini_emmc
  UENV:=default
endef

UBOOT_TARGETS := \
  imx6ull_alientek_mini_emmc

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/$(UBOOT_IMAGE) $(STAGING_DIR_IMAGE)/$(BUILD_DEVICES)-u-boot-imx.bin
	# do not need a script for now :p
	#mkimage -C none -A arm -T script -d boot-$(UENV).txt \
	#	$(STAGING_DIR_IMAGE)/$(BUILD_DEVICES)-boot.scr
endef

$(eval $(call BuildPackage/U-Boot))
