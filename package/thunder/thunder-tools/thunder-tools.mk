################################################################################
#
# thunder-tools
#
################################################################################
THUNDER_TOOLS_VERSION = a4b363a49cf81084d2a10e27eeff46d519e37a6d
HOST_THUNDER_TOOLS_SITE = $(call github,rdkcentral,Thunder,$(THUNDER_TOOLS_VERSION))
HOST_THUNDER_TOOLS_INSTALL_STAGING = YES
HOST_THUNDER_TOOLS_INSTALL_TARGET = NO
HOST_THUNDER_TOOLS_DEPENDENCIES = host-cmake host-python3 host-python3-jsonref
HOST_THUNDER_TOOLS_SUBDIR = Tools

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
HOST_THUNDER_TOOLS_CONF_OPTS += \
	-DGENERIC_CMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

$(eval $(host-cmake-package))
