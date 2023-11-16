################################################################################
#
# WPEBackend
#
################################################################################

ifeq ($(BR2_PACKAGE_WPEWEBKIT_ML2_22),y)
WPEBACKEND_VERSION = 4be4c7df5734d125148367a90da477c8d40d9eaf
WPEBACKEND_SITE = $(call github,WebPlatformForEmbedded,WPEBackend,$(WPEBACKEND_VERSION))
else
WPEBACKEND_VERSION = $(call qstrip,$(BR2_PACKAGE_WPEBACKEND_LIBWPE_VERSION))
WPEBACKEND_SITE = https://wpewebkit.org/releases
WPEBACKEND_SOURCE = libwpe-$(WPEBACKEND_VERSION).tar.xz
endif
WPEBACKEND_INSTALL_STAGING = YES
WPEBACKEND_LICENSE = BSD-2-Clause
WPEBACKEND_LICENSE_FILES = COPYING
WPEBACKEND_DEPENDENCIES = libegl libxkbcommon

# Workaround for https://github.com/raspberrypi/userland/issues/316
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
WPEBACKEND_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -D_GNU_SOURCE"
endif

$(eval $(cmake-package))
