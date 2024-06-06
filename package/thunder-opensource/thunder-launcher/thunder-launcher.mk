THUNDER_LAUNCHER_VERSION = 5aa8feaf9b44016e363b9a936914cf86e3bf0ac9
THUNDER_LAUNCHER_SITE = $(call github,WebPlatformForEmbedded,WPEPluginLauncher,$(THUNDER_LAUNCHER_VERSION))
THUNDER_LAUNCHER_INSTALL_STAGING = YES
THUNDER_LAUNCHER_DEPENDENCIES = thunder thunder-interfaces

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
THUNDER_LAUNCHER_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

THUNDER_LAUNCHER_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_LAUNCHER_VERSION}

$(eval $(cmake-package))

