################################################################################
#
# thunder-packagemanager
#
################################################################################
THUNDER_PACKAGEMANAGER_VERSION = R5.2.0
THUNDER_PACKAGEMANAGER_SITE_METHOD = git
THUNDER_PACKAGEMANAGER_SITE = git@github.com:rdkcentral/PackageManager.git


THUNDER_PACKAGEMANAGER_DEPENDENCIES = thunder thunder-interfaces

THUNDER_PACKAGEMANAGER_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_PACKAGEMANAGER_VERSION}

THUNDER_PACKAGEMANAGER_CONF_OPTS += -DLEGACY_CONFIG_GENERATOR=OFF

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
THUNDER_PACKAGEMANAGER_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_THUNDER_PACKAGEMANAGER_AUTOSTART),y)
THUNDER_PACKAGEMANAGER_CONF_OPTS += -DPLUGIN_PACKAGEMANAGER_AUTOSTART=true
endif

$(eval $(cmake-package))
