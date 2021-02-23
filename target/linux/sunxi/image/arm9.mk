# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2013-2016 OpenWrt.org
# Copyright (C) 2018 Fengling
# Copyright (C) 2020-2021 HandsomeMod Project

ifeq ($(SUBTARGET),arm9)

define Device/sipeed_licheepi-nano
  DEVICE_VENDOR := Sipeed
  DEVICE_MODEL := Lichee Pi Nano
  SOC := suniv-f1c100s
  KERNEL_COMPRESS := Y
endef

TARGET_DEVICES += sipeed_licheepi-nano

define Device/widora_widora-tiny200-v2
  DEVICE_VENDOR := Widora
  DEVICE_MODEL := Tiny200 V2
  SOC := suniv
  KERNEL_COMPRESS := Y
endef

TARGET_DEVICES += widora_widora-tiny200-v2

define Device/widora_widora-tiny200-v3
  DEVICE_VENDOR := Widora
  DEVICE_MODEL := Tiny200 V3
  SOC := suniv
  KERNEL_COMPRESS := Y
endef

TARGET_DEVICES += widora_widora-tiny200-v3

endif
