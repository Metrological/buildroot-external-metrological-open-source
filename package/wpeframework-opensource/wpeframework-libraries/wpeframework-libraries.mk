################################################################################
#
# wpeframework-libraries
#
################################################################################
WPEFRAMEWORK_LIBRARIES_VERSION = R4.4.1
WPEFRAMEWORK_LIBRARIES_SITE = $(call github,WebPlatformForEmbedded,ThunderLibraries,$(WPEFRAMEWORK_LIBRARIES_VERSION))
WPEFRAMEWORK_LIBRARIES_INSTALL_STAGING = YES
WPEFRAMEWORK_LIBRARIES_DEPENDENCIES = wpeframework 

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_LIBRARIES_BROADCAST),y)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DBROADCAST=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BROADCAST_SI_PARSING),y)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DBROADCAST_SI_PARSING=ON
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BLUETOOTH),y)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DBLUETOOTH=ON
WPEFRAMEWORK_LIBRARIES_DEPENDENCIES += bluez5_utils-headers

ifneq (,$(filter y,$(BR2_PACKAGE_BRCMFMAC_SDIO_FIRMWARE_RPI_BT)$(BR2_PACKAGE_BRCMFMAC_SDIO_FIRMWARE_RPI_BT)))
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DBCM43XX=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_LIBRARY_BLUETOOTH_GATT),y)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DBLUETOOTH_GATT_SUPPORT=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_LIBRARY_BLUETOOTH_AUDIO),y)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DBLUETOOTH_AUDIO_SUPPORT=ON
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_LIBRARY_COMPOSITOR_BUFFER),y)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DCOMPOSITOR_BUFFER=ON
endif

$(eval $(cmake-package))
