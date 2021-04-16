![HandsomeMod logo](include/logo.png)

# HandsomeMod Attila (21.03)
## IOT Freedom For End-user!

### HandsomeMod is Not A router-only GNU/Linux distribution.
### Right Now Router is not Our Mainly Support Target.

This is the buildsystem for the HandsomeMod GNU/Linux distribution.

To build your own firmware you need a Linux, BSD or MacOSX system (case
sensitive filesystem required). Cygwin is unsupported.

You need gcc, binutils, bzip2, flex, python, perl, make, find, grep, diff,
unzip, gawk, getopt, subversion, libz-dev and libc headers installed.

1. Run "./scripts/feeds update -a" to obtain all the latest package definitions
defined in feeds.conf / feeds.conf.default

2. Run "./scripts/feeds install -a" to install symlinks for all obtained
packages into package/feeds/ 

3. Run "make menuconfig" to select your preferred configuration for the
toolchain, target system & firmware packages.

4. Run "make" to build your firmware. This will download all sources, build
the cross-compile toolchain and then cross-compile the Linux kernel & all
chosen applications for your target system.

## Thanks

The orginal code comes form openwrt 21.02.

https://github.com/openwrt/openwrt

## Project Goal

- Create a ready-to-use lightweight linux distribution for single-board computer and IOT devices.

- Bring package-manager to devices that has lower memory.

- Maybe the first mainline-based IOT Solution?

- A Simple distribution for IOT devices with screen.


#  The Main Target Support By HandsomeMod

- Rapsberry pies (BCM27xx)

- Allwinner Socs （Sunxi）

- Freescale I.MX6ULL Family

- MSM8916 (Planing)

- Samsung Exynos 4412 On samsung i9300(planing)


## License

HandsomeMod is licensed under GPL-2.0

