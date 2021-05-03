#
# Copyright (C) 2020-2021 HandsomeMod Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

ifeq ($(SUBTARGET),msm8916)

define Device/msm8916
  SOC := msm8916
  $(Device/Qcom)
endef

# RedMi 2
define Device/XiaoMi_wingtech-wt88047-modem
  $(Device/msm8916)
  DEVICE_VENDOR := XiaoMi
  DEVICE_MODEL := Redmi 2
  QCOM_CMDLINE := "earlycon console=tty0 console=ttyMSM0,115200 root=/dev/mmcblk0p30 rw"
  QCOM_BOOTIMG_FLASH_OFFSET_BASE := 0x80000000
  QCOM_BOOTIMG_FLASH_OFFSET_KERNEL:= 0x00080000
  QCOM_BOOTIMG_FLASH_OFFSET_SECOND:= 0x00f00000
  QCOM_BOOTIMG_FLASH_OFFSET_TAGS:= 0x01e00000
  QCOM_BOOTIMG_FLASH_OFFSET_PAGESIZE:= 2048
endef
TARGET_DEVICES += XiaoMi_wingtech-wt88047-modem

endif
