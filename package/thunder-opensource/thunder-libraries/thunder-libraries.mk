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

ifeq ($(BR2_PACKAGE_THUNDER_LIBRARIES_BROADCAST),y)
THUNDER_LIBRARIES_CONF_OPTS += -DBROADCAST=ON
ifeq ($(BR2_PACKAGE_THUNDER_BROADCAST_SI_PARSING),y)
THUNDER_LIBRARIES_CONF_OPTS += -DBROADCAST_SI_PARSING=ON
endif
endif

ifeq ($(BR2_PACKAGE_THUNDER_LIBRARY_BLUETOOTH),y)
THUNDER_LIBRARIES_CONF_OPTS += -DBLUETOOTH=ON
THUNDER_LIBRARIES_DEPENDENCIES += bluez5_utils-headers

ifeq ($(BR2_PACKAGE_BRCMFMAC_SDIO_FIRMWARE_RPI_BT)$(BR2_PACKAGE_THUNDER_BLUETOOTH_CHIP_CONTROL_USERSPACE),yy)
THUNDER_LIBRARIES_CONF_OPTS += -DBCM43XX=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_LIBRARY_BLUETOOTH_GATT),y)
THUNDER_LIBRARIES_CONF_OPTS += -DBLUETOOTH_GATT_SUPPORT=ON
endif

ifeq ($(BR2_PACKAGE_THUNDER_LIBRARY_BLUETOOTH_AUDIO),y)
THUNDER_LIBRARIES_CONF_OPTS += -DBLUETOOTH_AUDIO_SUPPORT=ON
THUNDER_LIBRARIES_DEPENDENCIES += sbc
endif
endif

$(eval $(cmake-package))
