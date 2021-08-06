#
# Copyright (C) 2020-2021 HandsomeMod project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=simg-tools
PKG_SOURCE_URL=https://github.com/HandsomeMod/simg-tools.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_DATE:=2021-05-02
PKG_SOURCE_VERSION:=59e39f096eeb453cee78e14bfabfeb088f00b20b
PKG_MIRROR_HASH:=2cfcc280ea06570cd1ab3cff1aab6ab6628b25f0560f5bb7e27e982f281a99c1

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/cmake.mk

define Host/Install
	$(call Host/Install/Default)
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/bin/img2simg $(STAGING_DIR_HOST)/bin
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/bin/simg2img $(STAGING_DIR_HOST)/bin
endef

$(eval $(call HostBuild))
