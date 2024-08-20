################################################################################
#
# thunder-libraries
#
################################################################################
THUNDER_LIBRARIES_VERSION = R5.0.0
THUNDER_LIBRARIES_SITE = $(call github,WebPlatformForEmbedded,ThunderLibraries,$(THUNDER_LIBRARIES_VERSION))
THUNDER_LIBRARIES_INSTALL_STAGING = YES
THUNDER_LIBRARIES_DEPENDENCIES = thunder 

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
THUNDER_LIBRARIES_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

$(eval $(cmake-package))
