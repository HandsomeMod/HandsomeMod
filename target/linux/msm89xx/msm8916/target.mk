#
# Copyright (C) 2020-2021 HandsomeMod Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

SUBTARGET:=msm8916
BOARDNAME:=Msm8916 Soc based Targets
CPU_TYPE:=cortex-a53
CPU_SUBTYPE:=neon
ARCH:=aarch64

define Target/Description
	Build firmware images for Qualcomm Msm8916 based Targets.
endef

