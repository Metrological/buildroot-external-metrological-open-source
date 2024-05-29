################################################################################
#
# wpeframework-clientlibraries
#
################################################################################
WPEFRAMEWORK_CLIENTLIBRARIES_VERSION = 363f840ebb69c8a7ef84201e9acab7613496ffad
WPEFRAMEWORK_CLIENTLIBRARIES_SITE = $(call github,rdkcentral,ThunderClientLibraries,$(WPEFRAMEWORK_CLIENTLIBRARIES_VERSION))
WPEFRAMEWORK_CLIENTLIBRARIES_INSTALL_STAGING = YES
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES = wpeframework wpeframework-interfaces

WPEFRAMEWORK_CLIENTLIBRARIES_OPKG_NAME = "wpeframework-clientlibraries"
WPEFRAMEWORK_CLIENTLIBRARIES_OPKG_VERSION = "1.0.0"
WPEFRAMEWORK_CLIENTLIBRARIES_OPKG_ARCHITECTURE = "${BR2_ARCH}"
WPEFRAMEWORK_CLIENTLIBRARIES_OPKG_MAINTAINER = "Metrological"
WPEFRAMEWORK_CLIENTLIBRARIES_OPKG_DESCRIPTION = "WPEFramework clientlibraries"

WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DBUILD_REFERENCE=${WPEFRAMEWORK_CLIENTLIBRARIES_VERSION}

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_COMPOSITORCLIENT),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCOMPOSITORCLIENT=ON
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += libegl
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_EXPERIMENTAL),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=Mesa
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += libdrm mesa3d wpeframework-libraries
else ifeq ($(BR2_PACKAGE_WESTEROS),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=Wayland
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_SUB_IMPLEMENTATION=Westeros
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += westeros
else ifeq ($(BR2_PACKAGE_WESTON),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=Wayland
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_SUB_IMPLEMENTATION=Weston
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += weston
else ifeq ($(BR2_PACKAGE_HAS_NEXUS),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=Nexus
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCOMPOSITORCLIENT_IMPLEMENTATION_REPOSITORY=git@github.com:WebPlatformForEmbedded/CompositorClient-brcm.git
ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += bcm-refsw
endif
else ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DPLUGIN_COMPOSITOR_IMPLEMENTATION=RPI
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += rpi-userland
# ifeq ($(BR2_PACKAGE_LIBDRM),y)
# WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DVC6=ON
# WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += libdrm mesa3d
# endif
else
$(error Missing a compositor implemtation, please provide one or disable BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_COMPOSITORCLIENT)
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCOMPOSITORSERVERPLUGIN=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_BLUETOOTHAUDIOSINK),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DBLUETOOTHAUDIOSINK=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_BLUETOOTHAUDIOSINK_EXAMPLEPLAYER),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DBLUETOOTHAUDIOSINK_EXAMPLEPLAYER=ON
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_BLUETOOTHAUDIOSOURCE),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DBLUETOOTHAUDIOSOURCE=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_BLUETOOTHAUDIOSOURCE_EXAMPLERECORDER),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DBLUETOOTHAUDIOSOURCE_EXAMPLERECORDER=ON
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_DEVICEINFO),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DDEVICEINFO=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_DISPLAYINFO),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DDISPLAYINFO=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_PLAYERINFO),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DPLAYERINFO=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROVISIONPROXY),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DPROVISIONPROXY=ON
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += libprovision
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_SECURITYAGENT_ACCESSOR),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DSECURITYAGENT=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_VIRTUALINPUT),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DVIRTUALINPUT=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_BUFFER),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCOMPOSITORBUFFER=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_CDM),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCDMI=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI_SOFTWARE_OVERRIDE),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCDMI_ADAPTER_IMPLEMENTATION="gstreamer"
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += gstreamer1
else
ifeq ($(BR2_PACKAGE_HAS_NEXUS_SAGE),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCDMI_BCM_NEXUS_SVP=ON
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCDMI_ADAPTER_IMPLEMENTATION="broadcom-svp"
WPEFRAMEWORK_CLIENTLIBRARIES_DEPENDENCIES += gst1-bcm
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DOCDM_IMPLEMENTATION_REPOSITORY=git@github.com:WebPlatformForEmbedded/OCDMAdapter-brcm.git
endif
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_CRYPTOGRAPHY),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCRYPTOGRAPHY=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_CRYPTOGRAPHY_IMPLEMENTATION_NEXUS),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCRYPTOGRAPHY_IMPLEMENTATION=Nexus -DOPENSSL_PLATFORM_VAULT=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_CRYPTOGRAPHY_IMPLEMENTATION_NEXUS_COMMAND_BASED),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DUSE_BROADCOM_SAGE_DRM_API=OFF
else
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DUSE_BROADCOM_SAGE_DRM_API=ON
endif
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_CRYPTOGRAPHY_IMPLEMENTATION_OPENSSL),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCRYPTOGRAPHY_IMPLEMENTATION=OpenSSL
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_PROVISIONPROXY),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DUSE_PROVISIONING=ON
endif
else ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CLIENTLIBRARY_CRYPTOGRAPHY_IMPLEMENTATION_THUNDER),y)
WPEFRAMEWORK_CLIENTLIBRARIES_CONF_OPTS += -DCRYPTOGRAPHY_IMPLEMENTATION=Thunder
else
$(error Missing a cryptography implementation)
endif
endif

$(eval $(cmake-package))
