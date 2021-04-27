#
# Copyright (C) 2020-2021 HandsomeMod Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

BOARDNAME:=Generic
CPU_TYPE :=mips64
FEATURES += usb audio
DEFAULT_PACKAGES += 

define Target/Description
	Build firmware images for modern loongson64 based boards with CPUs
	supporting at least the mips64(little endian) instruction set with
	Loongson Pi2.
endef

