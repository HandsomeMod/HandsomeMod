# 
# Copyright (C) 2020-2021 HandsomeMod Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# Our HandsomeMod Can Runs On Android Devices! 
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mkbootimg
PKG_VERSION:=2021-1-6
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/osm0sis/mkbootimg.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:= 8dd5b5b5c68bcf8ecdb5859aa7036df276efcc79
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

HOST_BUILD_PARALLEL:=1
HOST_BUILD_DEPENDS:=pkg-config/host

include $(INCLUDE_DIR)/host-build.mk

HOSTCC := $(HOSTCC_NOCACHE)
HOSTCXX := $(HOSTCXX_NOCACHE)

define Host/Compile
	$(MAKE) -C $(HOST_BUILD_DIR) mkbootimg
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/mkbootimg $(STAGING_DIR_HOST)/bin
endef

$(eval $(call HostBuild))
