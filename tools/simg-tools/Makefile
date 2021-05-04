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

# TODO HASH
# PKG_MIRROR_HASH:=a9b74b7b95acc84a5a5c33d6acf493faad8f161caca3180734d9bd383c9d823f

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/cmake.mk

$(eval $(call HostBuild))
