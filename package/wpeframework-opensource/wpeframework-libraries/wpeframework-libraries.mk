################################################################################
#
# wpeframework-libraries
#
################################################################################
WPEFRAMEWORK_LIBRARIES_VERSION = 4554574d26b1b87b3fac71af22e79d6acae25ec8
WPEFRAMEWORK_LIBRARIES_SITE_METHOD = git
WPEFRAMEWORK_LIBRARIES_SITE = git@github.com:WebPlatformForEmbedded/ThunderLibraries.git
WPEFRAMEWORK_LIBRARIES_INSTALL_STAGING = YES
WPEFRAMEWORK_LIBRARIES_DEPENDENCIES = wpeframework

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BROADCAST),y)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DBROADCAST=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BROADCAST_SI_PARSING),y)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DBROADCAST_SI_PARSING=ON
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BLUETOOTH),y)
WPEFRAMEWORK_LIBRARIES_CONF_OPTS += -DBLUETOOTH=ON
WPEFRAMEWORK_LIBRARIES_DEPENDENCIES += bluez5_utils
endif

$(eval $(cmake-package))
