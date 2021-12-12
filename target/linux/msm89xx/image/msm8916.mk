# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2020-2021 HandsomeMod Project
#

ifeq ($(SUBTARGET),msm8916)

define Device/msm8916
  $(Device/Qcom)
  SOC := msm8916
  QCOM_CMDLINE := "earlycon console=ttyMSM0,115200 root=PARTUUID=a7ab80e8-e9d1-e8cd-f157-93f69b1d141e rw"
  QCOM_BOOTIMG_FLASH_OFFSET_BASE := 0x80000000
  QCOM_BOOTIMG_FLASH_OFFSET_KERNEL := 0x00080000
  QCOM_BOOTIMG_FLASH_OFFSET_RAMDISK := 0x02000000
  QCOM_BOOTIMG_FLASH_OFFSET_SECOND := 0x00f00000
  QCOM_BOOTIMG_FLASH_OFFSET_TAGS := 0x01e00000
  QCOM_BOOTIMG_FLASH_OFFSET_PAGESIZE := 2048
endef

define Device/XiaoMi_wingtech-wt88047-modem
  $(Device/msm8916)
  DEVICE_VENDOR := XiaoMi
  DEVICE_MODEL := Redmi 2
endef

TARGET_DEVICES += XiaoMi_wingtech-wt88047-modem

endif
