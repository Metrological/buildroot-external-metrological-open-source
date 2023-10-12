################################################################################
#
# wpeframework-tools
#
################################################################################
HOST_WPEFRAMEWORK_TOOLS_VERSION = d96d8a637e276718fb2ca7e5d3afe133a6adad04
HOST_WPEFRAMEWORK_TOOLS_SITE = $(call github,rdkcentral,ThunderTools,$(HOST_WPEFRAMEWORK_TOOLS_VERSION))
HOST_WPEFRAMEWORK_TOOLS_INSTALL_STAGING = YES
HOST_WPEFRAMEWORK_TOOLS_INSTALL_TARGET = NO
HOST_WPEFRAMEWORK_TOOLS_DEPENDENCIES = host-cmake host-python3 host-python3-jsonref

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
HOST_WPEFRAMEWORK_TOOLS_CONF_OPTS += \
	-DGENERIC_CMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

$(eval $(host-cmake-package))
