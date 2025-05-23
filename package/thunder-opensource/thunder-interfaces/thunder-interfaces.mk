################################################################################
#
# thunder-interfaces
#
################################################################################
THUNDER_INTERFACES_VERSION = R5.2.0
THUNDER_INTERFACES_SITE = $(call github,rdkcentral,ThunderInterfaces,$(THUNDER_INTERFACES_VERSION))
THUNDER_INTERFACES_INSTALL_STAGING = YES
THUNDER_INTERFACES_DEPENDENCIES = thunder

THUNDER_INTERFACES_OPKG_NAME = "thunder-interfaces"
THUNDER_INTERFACES_OPKG_VERSION = "1.0.0"
THUNDER_INTERFACES_OPKG_ARCHITECTURE = "${BR2_ARCH}"
THUNDER_INTERFACES_OPKG_MAINTAINER = "Metrological"
THUNDER_INTERFACES_OPKG_DESCRIPTION = "Thunder interfaces"

THUNDER_INTERFACES_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_INTERFACES_VERSION}

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
THUNDER_INTERFACES_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_THUNDER_CLIENTLIBRARY_CDM),y)
THUNDER_INTERFACES_CONF_OPTS += -DCDMI=ON
endif

$(eval $(cmake-package))
