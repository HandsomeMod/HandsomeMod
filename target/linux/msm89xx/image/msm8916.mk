# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2020-2022 HandsomeMod Project
#

ifeq ($(SUBTARGET),msm8916)

define Device/msm8916
  $(Device/Qcom)
  SOC := msm8916
  QCOM_CMDLINE := "earlycon console=tty0 console=ttyMSM0,115200 root=/dev/mmcblk0p14 rw rootwait"
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
  DEVICE_PACKAGES := kmod-qcom-drm kmod-qcom-msm8916-panel kmod-sound-qcom-msm8916 kmod-qcom-modem qcom-msm8916-wt8x047-wcnss-firmware qcom-msm8916-wcnss-wt88047-nv qcom-msm8916-modem-wt88047-firmware 
endef

TARGET_DEVICES += XiaoMi_wingtech-wt88047-modem

define Device/Handsome_handsome-openstick-ufi001b
  $(Device/msm8916)
  DEVICE_VENDOR := Handsome
  DEVICE_MODEL := OpenStick UFI001B
  DEVICE_PACKAGES := openstick-tweaks wpad-basic-wolfssl kmod-qcom-modem qcom-msm8916-modem-openstick-ufi001b-firmware qcom-msm8916-openstick-ufi001b-wcnss-firmware qcom-msm8916-wcnss-openstick-ufi001b-nv
endef

TARGET_DEVICES += Handsome_handsome-openstick-ufi001b

define Device/Handsome_handsome-openstick-ufi001c
  $(Device/msm8916)
  DEVICE_VENDOR := Handsome
  DEVICE_MODEL := OpenStick UFI001C
  DEVICE_PACKAGES := openstick-tweaks wpad-basic-wolfssl kmod-qcom-modem qcom-msm8916-modem-openstick-ufi001c-firmware qcom-msm8916-openstick-ufi001c-wcnss-firmware qcom-msm8916-wcnss-openstick-ufi001c-nv
endef

TARGET_DEVICES += Handsome_handsome-openstick-ufi001c

define Device/Handsome_handsome-openstick-sp970
  $(Device/msm8916)
  DEVICE_VENDOR := Handsome
  DEVICE_MODEL := OpenStick SP970
  DEVICE_PACKAGES := openstick-tweaks wpad-basic-wolfssl kmod-qcom-modem qcom-msm8916-modem-openstick-sp970-firmware qcom-msm8916-openstick-sp970-wcnss-firmware qcom-msm8916-wcnss-openstick-sp970-nv
endef

TARGET_DEVICES += Handsome_handsome-openstick-sp970

define Device/Handsome_handsome-openstick-uz801
  $(Device/msm8916)
  DEVICE_VENDOR := Handsome
  DEVICE_MODEL := OpenStick UZ801
  DEVICE_PACKAGES := openstick-tweaks wpad-basic-wolfssl kmod-qcom-modem qcom-msm8916-modem-openstick-uz801-firmware qcom-msm8916-openstick-uz801-wcnss-firmware qcom-msm8916-wcnss-openstick-uz801-nv
endef

TARGET_DEVICES += Handsome_handsome-openstick-uz801

endif
