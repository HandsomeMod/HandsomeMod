# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2017 Hauke Mehrtens
# Copyright (C) 2020-2021 HandsomeMod Project

include $(TOPDIR)/rules.mk

BOARDNAME:=Allwinner F1Cx00s
CPU_TYPE:=arm926ej-s
FEATURES:= usb ext4 display rtc squashfs usbgadget gpio
