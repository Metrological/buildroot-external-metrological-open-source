################################################################################
#
# thunder-tools
#
################################################################################
HOST_THUNDER_TOOLS_VERSION = ad2f6280c32716a7b7f7c6b82a7209e279405f19
HOST_THUNDER_TOOLS_SITE = $(call github,rdkcentral,ThunderTools,$(HOST_THUNDER_TOOLS_VERSION))
HOST_THUNDER_TOOLS_INSTALL_STAGING = YES
HOST_THUNDER_TOOLS_INSTALL_TARGET = NO
HOST_THUNDER_TOOLS_DEPENDENCIES = host-cmake host-python3 host-python-jsonref

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
HOST_THUNDER_TOOLS_CONF_OPTS += \
	-DGENERIC_CMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_THUNDER_TOOLS_PROXYSTUB_SECURITY),y)
	HOST_THUNDER_TOOLS_CONF_OPTS += -DPROXYSTUB_GENERATOR_ENABLE_SECURITY=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_TOOLS_PROXYSTUB_COHERENCY),y)
	HOST_THUNDER_TOOLS_CONF_OPTS += -DPROXYSTUB_GENERATOR_ENABLE_COHERENCY=ON
endif

$(eval $(host-cmake-package))
