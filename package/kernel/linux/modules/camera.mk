#
# Copyright (C) 2009 David Cooper <dave@kupesoft.com>
# Copyright (C) 2006-2010 OpenWrt.org
# Copyright (C) 2020-2021 HandsomeMod Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

VIDEO_MENU:=Camera Support

V4L2_DIR=v4l2-core
V4L2_USB_DIR=usb

#
# Video Capture
#

define KernelPackage/video-core
  SUBMENU:=$(VIDEO_MENU)
  TITLE=Video4Linux support
  DEPENDS:=@PCI_SUPPORT||USB_SUPPORT +PACKAGE_kmod-i2c-core:kmod-i2c-core
  KCONFIG:= \
	CONFIG_MEDIA_SUPPORT \
	CONFIG_MEDIA_CAMERA_SUPPORT=y \
	CONFIG_VIDEO_DEV \
	CONFIG_VIDEO_V4L1=y \
	CONFIG_VIDEO_ALLOW_V4L1=y \
	CONFIG_VIDEO_CAPTURE_DRIVERS=y \
	CONFIG_V4L_USB_DRIVERS=y \
	CONFIG_V4L_PCI_DRIVERS=y \
	CONFIG_V4L_PLATFORM_DRIVERS=y \
	CONFIG_V4L_ISA_PARPORT_DRIVERS=y
  FILES:= $(LINUX_DIR)/drivers/media/$(V4L2_DIR)/videodev.ko
  AUTOLOAD:=$(call AutoLoad,60, videodev)
endef

define KernelPackage/video-core/description
 Kernel modules for Video4Linux support
endef

$(eval $(call KernelPackage,video-core))


define AddDepends/video
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-video-core $(1)
endef

define AddDepends/camera
$(AddDepends/video)
  KCONFIG+=CONFIG_MEDIA_USB_SUPPORT=y \
	 CONFIG_MEDIA_CAMERA_SUPPORT=y
endef


define KernelPackage/video-videobuf2
  TITLE:=videobuf2 lib
  DEPENDS:=+kmod-dma-buf
  KCONFIG:= \
	CONFIG_VIDEOBUF2_CORE \
	CONFIG_VIDEOBUF2_MEMOPS \
	CONFIG_VIDEOBUF2_VMALLOC
  FILES:= \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-common.ko \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-v4l2.ko \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-memops.ko \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-vmalloc.ko
  AUTOLOAD:=$(call AutoLoad,65,videobuf2-core videobuf2-v4l2 videobuf2-memops videobuf2-vmalloc)
ifneq ($(wildcard $(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dma-sg.ko),)
  FILES+=$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dma-sg.ko
  AUTOLOAD+=$(call AutoLoad,65,videobuf2-dma-sg)
endif
  $(call AddDepends/video)
endef

define KernelPackage/video-videobuf2/description
 Kernel modules that implements four basic types of media buffers.
endef

$(eval $(call KernelPackage,video-videobuf2))

define KernelPackage/video-videobuf2-dma-contig
  TITLE:=videobuf2 dma contig 
  DEPENDS:=+kmod-dma-buf +kmod-video-videobuf2
  KCONFIG:= CONFIG_VIDEOBUF2_DMA_CONTIG
  FILES:= $(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dma-contig.ko
  AUTOLOAD:=$(call AutoLoad,65,videobuf2-dma-contig)
  HIDDEN:=1
  $(call AddDepends/video)
endef

define KernelPackage/video-videobuf2-dma-contig/description
 Some stuff depends on this,but this cannot generate without those stuff.
endef

$(eval $(call KernelPackage,video-videobuf2-dma-contig))


define KernelPackage/video-cpia2
  TITLE:=CPIA2 video driver
  DEPENDS:=@USB_SUPPORT +kmod-usb-core
  KCONFIG:=CONFIG_VIDEO_CPIA2
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/cpia2/cpia2.ko
  AUTOLOAD:=$(call AutoProbe,cpia2)
  $(call AddDepends/camera)
endef

define KernelPackage/video-cpia2/description
 Kernel modules for supporting CPIA2 USB based cameras
endef

$(eval $(call KernelPackage,video-cpia2))


define KernelPackage/video-pwc
  TITLE:=Philips USB webcam support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2
  KCONFIG:= \
	CONFIG_USB_PWC \
	CONFIG_USB_PWC_DEBUG=n
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/pwc/pwc.ko
  AUTOLOAD:=$(call AutoProbe,pwc)
  $(call AddDepends/camera)
endef

define KernelPackage/video-pwc/description
 Kernel modules for supporting Philips USB based cameras
endef

$(eval $(call KernelPackage,video-pwc))


define KernelPackage/video-uvc
  TITLE:=USB Video Class (UVC) support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2 +kmod-input-core
  KCONFIG:= CONFIG_USB_VIDEO_CLASS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/uvc/uvcvideo.ko
  AUTOLOAD:=$(call AutoProbe,uvcvideo)
  $(call AddDepends/camera)
endef

define KernelPackage/video-uvc/description
 Kernel modules for supporting USB Video Class (UVC) devices
endef

$(eval $(call KernelPackage,video-uvc))


define KernelPackage/video-gspca-core
  MENU:=1
  TITLE:=GSPCA webcam core support framework
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-input-core +kmod-video-videobuf2
  KCONFIG:=CONFIG_USB_GSPCA
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_main.ko
  AUTOLOAD:=$(call AutoProbe,gspca_main)
  $(call AddDepends/camera)
endef

define KernelPackage/video-gspca-core/description
 Kernel modules for supporting GSPCA based webcam devices. Note this is just
 the core of the driver, please select a submodule that supports your webcam.
endef

$(eval $(call KernelPackage,video-gspca-core))


define AddDepends/camera-gspca
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-video-gspca-core $(1)
endef


define KernelPackage/video-gspca-conex
  TITLE:=conex webcam support
  KCONFIG:=CONFIG_USB_GSPCA_CONEX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_conex.ko
  AUTOLOAD:=$(call AutoProbe,gspca_conex)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-conex/description
 The Conexant Camera Driver (conex) kernel module
endef

$(eval $(call KernelPackage,video-gspca-conex))


define KernelPackage/video-gspca-etoms
  TITLE:=etoms webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ETOMS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_etoms.ko
  AUTOLOAD:=$(call AutoProbe,gspca_etoms)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-etoms/description
 The Etoms USB Camera Driver (etoms) kernel module
endef

$(eval $(call KernelPackage,video-gspca-etoms))


define KernelPackage/video-gspca-finepix
  TITLE:=finepix webcam support
  KCONFIG:=CONFIG_USB_GSPCA_FINEPIX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_finepix.ko
  AUTOLOAD:=$(call AutoProbe,gspca_finepix)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-finepix/description
 The Fujifilm FinePix USB V4L2 driver (finepix) kernel module
endef

$(eval $(call KernelPackage,video-gspca-finepix))


define KernelPackage/video-gspca-mars
  TITLE:=mars webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MARS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_mars.ko
  AUTOLOAD:=$(call AutoProbe,gspca_mars)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mars/description
 The Mars USB Camera Driver (mars) kernel module
endef

$(eval $(call KernelPackage,video-gspca-mars))


define KernelPackage/video-gspca-mr97310a
  TITLE:=mr97310a webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MR97310A
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_mr97310a.ko
  AUTOLOAD:=$(call AutoProbe,gspca_mr97310a)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mr97310a/description
 The Mars-Semi MR97310A USB Camera Driver (mr97310a) kernel module
endef

$(eval $(call KernelPackage,video-gspca-mr97310a))


define KernelPackage/video-gspca-ov519
  TITLE:=ov519 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV519
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov519.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov519)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov519/description
 The OV519 USB Camera Driver (ov519) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov519))


define KernelPackage/video-gspca-ov534
  TITLE:=ov534 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov534.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov534)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534/description
 The OV534 USB Camera Driver (ov534) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov534))


define KernelPackage/video-gspca-ov534-9
  TITLE:=ov534-9 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534_9
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_ov534_9.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov534_9)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534-9/description
 The OV534-9 USB Camera Driver (ov534_9) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov534-9))


define KernelPackage/video-gspca-pac207
  TITLE:=pac207 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC207
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac207.ko
  AUTOLOAD:=$(call AutoProbe,gspca_pac207)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac207/description
 The Pixart PAC207 USB Camera Driver (pac207) kernel module
endef

$(eval $(call KernelPackage,video-gspca-pac207))


define KernelPackage/video-gspca-pac7311
  TITLE:=pac7311 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC7311
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_pac7311.ko
  AUTOLOAD:=$(call AutoProbe,gspca_pac7311)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac7311/description
 The Pixart PAC7311 USB Camera Driver (pac7311) kernel module
endef

$(eval $(call KernelPackage,video-gspca-pac7311))


define KernelPackage/video-gspca-se401
  TITLE:=se401 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SE401
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_se401.ko
  AUTOLOAD:=$(call AutoProbe,gspca_se401)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-se401/description
 The SE401 USB Camera Driver kernel module
endef

$(eval $(call KernelPackage,video-gspca-se401))


define KernelPackage/video-gspca-sn9c20x
  TITLE:=sn9c20x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SN9C20X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sn9c20x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sn9c20x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sn9c20x/description
 The SN9C20X USB Camera Driver (sn9c20x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sn9c20x))


define KernelPackage/video-gspca-sonixb
  TITLE:=sonixb webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXB
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sonixb.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sonixb)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixb/description
 The SONIX Bayer USB Camera Driver (sonixb) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sonixb))


define KernelPackage/video-gspca-sonixj
  TITLE:=sonixj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXJ
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sonixj.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sonixj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixj/description
 The SONIX JPEG USB Camera Driver (sonixj) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sonixj))


define KernelPackage/video-gspca-spca500
  TITLE:=spca500 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA500
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca500.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca500)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca500/description
 The SPCA500 USB Camera Driver (spca500) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca500))


define KernelPackage/video-gspca-spca501
  TITLE:=spca501 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA501
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca501.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca501)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca501/description
 The SPCA501 USB Camera Driver (spca501) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca501))


define KernelPackage/video-gspca-spca505
  TITLE:=spca505 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA505
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca505.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca505)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca505/description
 The SPCA505 USB Camera Driver (spca505) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca505))


define KernelPackage/video-gspca-spca506
  TITLE:=spca506 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA506
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca506.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca506)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca506/description
 The SPCA506 USB Camera Driver (spca506) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca506))


define KernelPackage/video-gspca-spca508
  TITLE:=spca508 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA508
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca508.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca508)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca508/description
 The SPCA508 USB Camera Driver (spca508) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca508))


define KernelPackage/video-gspca-spca561
  TITLE:=spca561 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA561
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_spca561.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca561)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca561/description
 The SPCA561 USB Camera Driver (spca561) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca561))


define KernelPackage/video-gspca-sq905
  TITLE:=sq905 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq905.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq905)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905/description
 The SQ Technologies SQ905 based USB Camera Driver (sq905) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq905))


define KernelPackage/video-gspca-sq905c
  TITLE:=sq905c webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905C
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sq905c.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq905c)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905c/description
 The SQ Technologies SQ905C based USB Camera Driver (sq905c) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq905c))


define KernelPackage/video-gspca-stk014
  TITLE:=stk014 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_STK014
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_stk014.ko
  AUTOLOAD:=$(call AutoProbe,gspca_stk014)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stk014/description
 The Syntek DV4000 (STK014) USB Camera Driver (stk014) kernel module
endef

$(eval $(call KernelPackage,video-gspca-stk014))


define KernelPackage/video-gspca-sunplus
  TITLE:=sunplus webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SUNPLUS
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_sunplus.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sunplus)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sunplus/description
 The SUNPLUS USB Camera Driver (sunplus) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sunplus))


define KernelPackage/video-gspca-t613
  TITLE:=t613 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_T613
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_t613.ko
  AUTOLOAD:=$(call AutoProbe,gspca_t613)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-t613/description
 The T613 (JPEG Compliance) USB Camera Driver (t613) kernel module
endef

$(eval $(call KernelPackage,video-gspca-t613))


define KernelPackage/video-gspca-tv8532
  TITLE:=tv8532 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_TV8532
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_tv8532.ko
  AUTOLOAD:=$(call AutoProbe,gspca_tv8532)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-tv8532/description
 The TV8532 USB Camera Driver (tv8532) kernel module
endef

$(eval $(call KernelPackage,video-gspca-tv8532))


define KernelPackage/video-gspca-vc032x
  TITLE:=vc032x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_VC032X
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_vc032x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_vc032x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-vc032x/description
 The VC032X USB Camera Driver (vc032x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-vc032x))


define KernelPackage/video-gspca-zc3xx
  TITLE:=zc3xx webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ZC3XX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_zc3xx.ko
  AUTOLOAD:=$(call AutoProbe,gspca_zc3xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-zc3xx/description
 The ZC3XX USB Camera Driver (zc3xx) kernel module
endef

$(eval $(call KernelPackage,video-gspca-zc3xx))


define KernelPackage/video-gspca-m5602
  TITLE:=m5602 webcam support
  KCONFIG:=CONFIG_USB_M5602
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/m5602/gspca_m5602.ko
  AUTOLOAD:=$(call AutoProbe,gspca_m5602)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-m5602/description
 The ALi USB m5602 Camera Driver (m5602) kernel module
endef

$(eval $(call KernelPackage,video-gspca-m5602))


define KernelPackage/video-gspca-stv06xx
  TITLE:=stv06xx webcam support
  KCONFIG:=CONFIG_USB_STV06XX
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/stv06xx/gspca_stv06xx.ko
  AUTOLOAD:=$(call AutoProbe,gspca_stv06xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stv06xx/description
 The STV06XX USB Camera Driver (stv06xx) kernel module
endef

$(eval $(call KernelPackage,video-gspca-stv06xx))


define KernelPackage/video-gspca-gl860
  TITLE:=gl860 webcam support
  KCONFIG:=CONFIG_USB_GL860
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gl860/gspca_gl860.ko
  AUTOLOAD:=$(call AutoProbe,gspca_gl860)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-gl860/description
 The GL860 USB Camera Driver (gl860) kernel module
endef

$(eval $(call KernelPackage,video-gspca-gl860))


define KernelPackage/video-gspca-jeilinj
  TITLE:=jeilinj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_JEILINJ
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_jeilinj.ko
  AUTOLOAD:=$(call AutoProbe,gspca_jeilinj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-jeilinj/description
 The JEILINJ USB Camera Driver (jeilinj) kernel module
endef

$(eval $(call KernelPackage,video-gspca-jeilinj))


define KernelPackage/video-gspca-konica
  TITLE:=konica webcam support
  KCONFIG:=CONFIG_USB_GSPCA_KONICA
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_USB_DIR)/gspca/gspca_konica.ko
  AUTOLOAD:=$(call AutoProbe,gspca_konica)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-konica/description
 The Konica USB Camera Driver (konica) kernel module
endef

$(eval $(call KernelPackage,video-gspca-konica))

#
# Csi Cameras
#

define KernelPackage/video-csi-core
  MENU:=1
  TITLE:=MIPI/CSI Based Camera core support framework
  DEPENDS:=+kmod-video-core +kmod-video-gspca-core +kmod-i2c-algo-bit
  KCONFIG:= \
	CONFIG_VIDEO_V4L2=y \
  	CONFIG_VIDEO_V4L2_SUBDEV_API=y \
  	CONFIG_MEDIA_CONTROLLER=y \
  	CONFIG_MEDIA_CONTROLLER_REQUEST_API=y \
  	CONFIG_VIDEO_V4L2_I2C=y \
  	CONFIG_VIDEO_TDA1997X=n \
  	CONFIG_VIDEO_ADV748X=n \
  	CONFIG_VIDEO_ADV7604=n \
  	CONFIG_VIDEO_VIDEO_ADV7604=n \
  	CONFIG_VIDEO_MUX=n \
  	CONFIG_VIDEO_ADV7842=n \
  	CONFIG_VIDEO_XILINX=n \
  	CONFIG_VIDEO_TC358743=n \
  	CONFIG_VIDEO_ADV7511=n \
  	CONFIG_VIDEO_AD9389B=n \
  	CONFIG_VIDEO_AD5820=n \
  	CONFIG_VIDEO_AK7375=n \
  	CONFIG_VIDEO_DW9714=n \
  	CONFIG_VIDEO_DW9807_VCM=n \
  	CONFIG_VIDEO_ADP1653=n \
  	CONFIG_VIDEO_LM3560=n \
  	CONFIG_VIDEO_LM3646=n \
  	CONFIG_VIDEO_ST_MIPID02=n \
  	CONFIG_VIDEO_GS1662=n \
  	CONFIG_V4L2_FWNODE 	
  FILES:=$(LINUX_DIR)/drivers/media/$(V4L2_DIR)/v4l2-fwnode.ko
  AUTOLOAD:=$(call AutoProbe,v4l2-fwnode)
  $(call AddDepends/camera)
endef

define KernelPackage/video-csi-core/description
 Kernel modules for supporting MIPI/CSI Based Camera. Note this is just
 the core of the driver, please select a submodule that supports your Camera.
endef

$(eval $(call KernelPackage,video-csi-core))


define AddDepends/camera-csi
  SUBMENU:=$(VIDEO_MENU)
  DEPENDS+=kmod-video-csi-core $(1)
endef

define KernelPackage/video-csi-ov2640
  TITLE:=OmniVision OV2640 sensor support
  KCONFIG:=CONFIG_VIDEO_OV2640
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov2640.ko
  AUTOLOAD:=$(call AutoProbe,ov2640)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov2640/description
 OmniVision OV2640 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov2640))

define KernelPackage/video-csi-ov5640
  TITLE:=OmniVision OV5640 sensor support
  KCONFIG:=CONFIG_VIDEO_OV5640
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov5640.ko
  AUTOLOAD:=$(call AutoProbe,ov5640)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov5640/description
 OmniVision OV5640 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov5640))

define KernelPackage/video-csi-ov2680
  TITLE:=OmniVision OV2680 sensor support
  KCONFIG:=CONFIG_VIDEO_OV2680
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov2680.ko
  AUTOLOAD:=$(call AutoProbe,ov2680)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov2680/description
 OmniVision ov2680 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov2680))

define KernelPackage/video-csi-ov2685
  TITLE:=OmniVision ov2685 sensor support
  KCONFIG:=CONFIG_VIDEO_OV2685
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov2685.ko
  AUTOLOAD:=$(call AutoProbe,ov2685)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov2685/description
 OmniVision ov2685 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov2685))

define KernelPackage/video-csi-ov5645
  TITLE:=OmniVision ov5645 sensor support
  KCONFIG:=CONFIG_VIDEO_OV5645
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov5645.ko
  AUTOLOAD:=$(call AutoProbe,ov5645)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov5645/description
 OmniVision ov5645 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov5645))

define KernelPackage/video-csi-ov5647
  TITLE:=OmniVision ov5647 sensor support
  KCONFIG:=CONFIG_VIDEO_OV5647
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov5647.ko
  AUTOLOAD:=$(call AutoProbe,ov5647)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov5647/description
 OmniVision ov5647 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov5647))

define KernelPackage/video-csi-ov5670
  TITLE:=OmniVision ov5670 sensor support
  KCONFIG:=CONFIG_VIDEO_OV5670
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov5670.ko
  AUTOLOAD:=$(call AutoProbe,ov5670)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov5670/description
 OmniVision ov5670 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov5670))

define KernelPackage/video-csi-ov5675
  TITLE:=OmniVision ov5675 sensor support
  KCONFIG:=CONFIG_VIDEO_OV5675
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov5675.ko
  AUTOLOAD:=$(call AutoProbe,ov5675)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov5675/description
 OmniVision ov5675 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov5675))

define KernelPackage/video-csi-ov7251
  TITLE:=OmniVision ov7251 sensor support
  KCONFIG:=CONFIG_VIDEO_OV7251
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov7251.ko
  AUTOLOAD:=$(call AutoProbe,ov7251)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov7251/description
 OmniVision ov7251 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov7251))

define KernelPackage/video-csi-ov8856
  TITLE:=OmniVision ov8856 sensor support
  KCONFIG:=CONFIG_VIDEO_OV8856
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov8856.ko
  AUTOLOAD:=$(call AutoProbe,ov8856)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov8856/description
 OmniVision ov8856 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov8856))

define KernelPackage/video-csi-ov9650
  TITLE:=OmniVision ov9650 sensor support
  KCONFIG:=CONFIG_VIDEO_OV9650
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov9650.ko
  AUTOLOAD:=$(call AutoProbe,ov9650)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov9650/description
 OmniVision ov9650 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov9650))

define KernelPackage/video-csi-ov13858
  TITLE:=OmniVision ov13858 sensor support
  KCONFIG:=CONFIG_VIDEO_OV13858
  FILES:=$(LINUX_DIR)/drivers/media/i2c/ov13858.ko
  AUTOLOAD:=$(call AutoProbe,ov13858)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-ov13858/description
 OmniVision ov13858 sensor support
endef

$(eval $(call KernelPackage,video-csi-ov13858))

define KernelPackage/video-csi-mt9m001
  TITLE:=mt9m001 sensor support
  KCONFIG:=CONFIG_VIDEO_MT9M001
  FILES:=$(LINUX_DIR)/drivers/media/i2c/mt9m001.ko
  AUTOLOAD:=$(call AutoProbe,mt9m001)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-mt9m001/description
 mt9m001 sensor support
endef

$(eval $(call KernelPackage,video-csi-mt9m001))

define KernelPackage/video-csi-mt9m032
  TITLE:=mt9m032 sensor support
  KCONFIG:=CONFIG_VIDEO_MT9M032
  FILES:=$(LINUX_DIR)/drivers/media/i2c/mt9m032.ko
  AUTOLOAD:=$(call AutoProbe,mt9m032)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-mt9m032/description
 mt9m032 sensor support
endef

$(eval $(call KernelPackage,video-csi-mt9m032))

define KernelPackage/video-csi-mt9p031
  TITLE:=MT9P031 sensor support
  KCONFIG:=CONFIG_VIDEO_MT9M032
  FILES:=$(LINUX_DIR)/drivers/media/i2c/mt9p031.ko
  AUTOLOAD:=$(call AutoProbe,mt9p031)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-mt9p031/description
 mt9p031 sensor support
endef

$(eval $(call KernelPackage,video-csi-mt9p031))

define KernelPackage/video-csi-mt9t001
  TITLE:=MT9T001 sensor support
  KCONFIG:=CONFIG_VIDEO_MT9T001
  FILES:=$(LINUX_DIR)/drivers/media/i2c/mt9t001.ko
  AUTOLOAD:=$(call AutoProbe,mt9t001)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-mt9t001/description
 mt9t001 sensor support
endef

$(eval $(call KernelPackage,video-csi-mt9t001))

define KernelPackage/video-csi-imx214
  TITLE:=Sony imx214 sensor support
  KCONFIG:=CONFIG_VIDEO_IMX214
  FILES:=$(LINUX_DIR)/drivers/media/i2c/imx214.ko
  AUTOLOAD:=$(call AutoProbe,imx214)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-imx214/description
 Sony imx214 sensor support
endef

$(eval $(call KernelPackage,video-csi-imx214))

define KernelPackage/video-csi-imx258
  TITLE:=Sony imx258 sensor support
  KCONFIG:=CONFIG_VIDEO_IMX258
  FILES:=$(LINUX_DIR)/drivers/media/i2c/imx258.ko
  AUTOLOAD:=$(call AutoProbe,imx258)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-imx258/description
 Sony imx258 sensor support
endef

$(eval $(call KernelPackage,video-csi-imx258))

define KernelPackage/video-csi-imx274
  TITLE:=Sony imx274 sensor support
  KCONFIG:=CONFIG_VIDEO_IMX274
  FILES:=$(LINUX_DIR)/drivers/media/i2c/imx274.ko
  AUTOLOAD:=$(call AutoProbe,imx274)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-imx274/description
 Sony imx274 sensor support
endef

$(eval $(call KernelPackage,video-csi-imx274))

define KernelPackage/video-csi-imx319
  TITLE:=Sony imx319 sensor support
  KCONFIG:=CONFIG_VIDEO_IMX319
  FILES:=$(LINUX_DIR)/drivers/media/i2c/imx319.ko
  AUTOLOAD:=$(call AutoProbe,imx319)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-imx319/description
 Sony imx319 sensor support
endef

$(eval $(call KernelPackage,video-csi-imx319))

define KernelPackage/video-csi-imx355
  TITLE:=Sony imx355 sensor support
  KCONFIG:=CONFIG_VIDEO_IMX355
  FILES:=$(LINUX_DIR)/drivers/media/i2c/imx355.ko
  AUTOLOAD:=$(call AutoProbe,imx355)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-imx355/description
 Sony imx355 sensor support
endef

$(eval $(call KernelPackage,video-csi-imx355))

define KernelPackage/video-csi-m5mols
  TITLE:=Fujitsu M-5MOLS 8MP sensor support
  KCONFIG:=CONFIG_VIDEO_M5MOLS
  FILES:=$(LINUX_DIR)/drivers/media/i2c/m5mols.ko
  AUTOLOAD:=$(call AutoProbe,m5mols)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-m5mols/description
 Fujitsu M-5MOLS 8MP sensor support
endef

$(eval $(call KernelPackage,video-csi-m5mols))

define KernelPackage/video-csi-s5k6aa
  TITLE:=Samsung S5K6AAFX sensor support
  KCONFIG:=CONFIG_VIDEO_S5K6AA
  FILES:=$(LINUX_DIR)/drivers/media/i2c/s5k6aa.ko
  AUTOLOAD:=$(call AutoProbe,s5k6aa)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-s5k6aa/description
 Samsung S5K6AAFX sensor support
endef

$(eval $(call KernelPackage,video-csi-s5k6aa))

define KernelPackage/video-csi-s5k6a3
  TITLE:=Samsung S5K6A3 sensor support
  KCONFIG:=CONFIG_VIDEO_S5K6AA
  FILES:=$(LINUX_DIR)/drivers/media/i2c/s5k6a3.ko
  AUTOLOAD:=$(call AutoProbe,s5k6a3)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-s5k6a3/description
 Samsung S5K6A3 sensor support
endef

$(eval $(call KernelPackage,video-csi-s5k6a3))

define KernelPackage/video-csi-s5k4ecgx
  TITLE:=Samsung S5K4ECGX sensor support
  KCONFIG:=CONFIG_VIDEO_S5K4ECGX
  FILES:=$(LINUX_DIR)/drivers/media/i2c/s5k4ecgx.ko
  AUTOLOAD:=$(call AutoProbe,s5k4ecgx)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-s5k4ecgx/description
 Samsung S5K4ECGX sensor support
endef

$(eval $(call KernelPackage,video-csi-s5k4ecgx))


define KernelPackage/video-csi-s5k5baf
  TITLE:=Samsung S5K5BAF sensor support
  KCONFIG:=CONFIG_VIDEO_S5K5BAF
  FILES:=$(LINUX_DIR)/drivers/media/i2c/s5k5baf.ko
  AUTOLOAD:=$(call AutoProbe,s5k5baf)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-s5k5baf/description
 Samsung S5K5BAF sensor support
endef

$(eval $(call KernelPackage,video-csi-s5k5baf))

define KernelPackage/video-csi-simapp
  TITLE:=SMIA++/SMIA sensor support
  KCONFIG:=CONFIG_VIDEO_SMIAPP
  FILES:=$(LINUX_DIR)/drivers/media/i2c/simapp.ko
  AUTOLOAD:=$(call AutoProbe,simapp)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-simapp/description
 SMIA++/SMIA sensor support
endef

$(eval $(call KernelPackage,video-csi-simapp))

define KernelPackage/video-csi-et8ek8
  TITLE:=ET8EK8 camera sensor support
  KCONFIG:=CONFIG_VIDEO_ET8EK8
  FILES:=$(LINUX_DIR)/drivers/media/i2c/et8ek8.ko
  AUTOLOAD:=$(call AutoProbe,et8ek8)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-et8ek8/description
 ET8EK8 camera sensor support
endef

$(eval $(call KernelPackage,video-csi-et8ek8))

define KernelPackage/video-csi-s5c73m3
  TITLE:=Samsung S5C73M3 sensor support
  KCONFIG:=CONFIG_VIDEO_S5C73M3
  FILES:=$(LINUX_DIR)/drivers/media/i2c/s5c73m3.ko
  AUTOLOAD:=$(call AutoProbe,s5c73m3)
  $(call AddDepends/camera-csi)
endef

define KernelPackage/video-csi-s5c73m3/description
 Samsung S5C73M3 sensor support
endef

$(eval $(call KernelPackage,video-csi-s5c73m3))

