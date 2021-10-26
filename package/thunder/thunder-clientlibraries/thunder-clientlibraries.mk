################################################################################
#
# thunder-clientlibraries
#
################################################################################
THUNDER_CLIENTLIBRARIES_VERSION = 8da285476b346c7fbd0b506abedd75197fe0409c
THUNDER_CLIENTLIBRARIES_SITE = $(call github,rdkcentral,ThunderClientLibraries,$(THUNDER_CLIENTLIBRARIES_VERSION))
THUNDER_CLIENTLIBRARIES_INSTALL_STAGING = YES
THUNDER_CLIENTLIBRARIES_DEPENDENCIES = thunder thunder-interfaces

THUNDER_CLIENTLIBRARIES_OPKG_NAME = "thunder-clientlibraries"
THUNDER_CLIENTLIBRARIES_OPKG_VERSION = "1.0.0"
THUNDER_CLIENTLIBRARIES_OPKG_ARCHITECTURE = "${BR2_ARCH}"
THUNDER_CLIENTLIBRARIES_OPKG_MAINTAINER = "Metrological"
THUNDER_CLIENTLIBRARIES_OPKG_DESCRIPTION = "WPEFramework clientlibraries"

THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_CLIENTLIBRARIES_VERSION}

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_DEBUG),y)
        THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DBUILD_TYPE=Debug
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_DEBUG_OPTIMIZED),y)
        THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DBUILD_TYPE=DebugOptimized
else ifeq ($( BR2_PACKAGE_THUNDER_BUILD_TYPE_RELEASE_WITH_SYMBOLS),y)
        THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DBUILD_TYPE=ReleaseSymbols
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_RELEASE),y)
        THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DBUILD_TYPE=Release
else ifeq ($(BR2_PACKAGE_THUNDER_BUILD_TYPE_PRODUCTION),y)
        THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DBUILD_TYPE=Production
endif

ifeq ($(BR2_PACKAGE_THUNDER_COMPOSITORCLIENT),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCOMPOSITORCLIENT=ON
THUNDER_CLIENTLIBRARIES_DEPENDENCIES += libegl
ifeq ($(BR2_PACKAGE_WESTEROS),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=Wayland
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_SUB_IMPLEMENTATION=Westeros
THUNDER_CLIENTLIBRARIES_DEPENDENCIES += westeros
else ifeq ($(BR2_PACKAGE_WESTON),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=Wayland
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_SUB_IMPLEMENTATION=Weston
THUNDER_CLIENTLIBRARIES_DEPENDENCIES += weston
else ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=Nexus
else ifeq ($(BR2_PACKAGE_LIBDRM),y) 
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=linux
THUNDER_CLIENTLIBRARIES_DEPENDENCIES += libdrm
ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
THUNDER_CLIENTLIBRARIES_DEPENDENCIES += bcm-refsw
endif
else ifeq ($(BR2_PACKAGE_RPI_FIRMWARE),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=RPI
ifeq ($(BR2_PACKAGE_LIBDRM),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DVC6=ON
THUNDER_CLIENTLIBRARIES_DEPENDENCIES += libdrm mesa3d
endif
else
$(error Missing a compositor implemtation, please provide one or disable PLUGIN_COMPOSITOR)
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_COMPOSITOR),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCOMPOSITORSERVERPLUGIN=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_DEVICEINFO),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DDEVICEINFO=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_DISPLAYINFO),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DDISPLAYINFO=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_PLAYERINFO),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DPLAYERINFO=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_PROVISIONPROXY),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DPROVISIONPROXY=ON
THUNDER_CLIENTLIBRARIES_DEPENDENCIES += libprovision
endif

ifeq ($(BR2_PACKAGE_THUNDER_SECURITYAGENT_ACCESSOR),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DSECURITYAGENT=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_VIRTUALINPUT),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DVIRTUALINPUT=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_CDM),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCDMI=ON
ifeq ($(BR2_PACKAGE_HAS_NEXUS_SAGE),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCDMI_BCM_NEXUS_SVP=ON
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCDMI_ADAPTER_IMPLEMENTATION="broadcom-svp"
THUNDER_CLIENTLIBRARIES_DEPENDENCIES += gst1-bcm
else
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCDMI_ADAPTER_IMPLEMENTATION="gstreamer"
THUNDER_CLIENTLIBRARIES_DEPENDENCIES += gstreamer1
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_CRYPTOGRAPHY),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCRYPTOGRAPHY=ON
ifeq ($(BR2_PACKAGE_THUNDER_CRYPTOGRAPHY_BACKEND_NEXUS),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCRYPTOGRAPHY_IMPLEMENTATION=Nexus
else ifeq ($(BR2_PACKAGE_THUNDER_CRYPTOGRAPHY_BACKEND_OPENSSL),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCRYPTOGRAPHY_IMPLEMENTATION=OpenSSL
else ifeq ($(BR2_PACKAGE_THUNDER_CRYPTOGRAPHY_BACKEND_THUNDER),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DCRYPTOGRAPHY_IMPLEMENTATION=Thunder
else
$(error Missing a cryptography implementation)
endif
ifeq ($(BR2_PACKAGE_LIBPROVISION),y)
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DUSE_PROVISIONING=ON
else 
THUNDER_CLIENTLIBRARIES_CONF_OPTS += -DUSE_PROVISIONING=OFF
endif
endif

$(eval $(cmake-package))
