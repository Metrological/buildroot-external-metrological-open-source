################################################################################
#
# thunder-cdmi-widevine
#
################################################################################
THUNDER_CDMI_WIDEVINE_VERSION = R5.3.0
THUNDER_CDMI_WIDEVINE_SITE = $(call github,rdkcentral,OCDM-Widevine,$(THUNDER_CDMI_WIDEVINE_VERSION))
THUNDER_CDMI_WIDEVINE_INSTALL_STAGING = NO
THUNDER_CDMI_WIDEVINE_DEPENDENCIES = thunder-clientlibraries widevine

ifeq ($(BR2_CMAKE_HOST_DEPENDENCY),)
THUNDER_CDMI_WIDEVINE_CONF_OPTS += \
       -DCMAKE_MODULE_PATH=$(HOST_DIR)/share/cmake/Modules
endif

ifeq ($(BR2_PACKAGE_WIDEVINE_VERSION_14),y)
THUNDER_CDMI_WIDEVINE_CONF_OPTS += -DCENC_VERSION=14
endif
ifeq ($(BR2_PACKAGE_WIDEVINE_VERSION_15),y)
THUNDER_CDMI_WIDEVINE_CONF_OPTS += -DCENC_VERSION=15
endif
ifeq ($(BR2_PACKAGE_WIDEVINE_VERSION_16),y)
THUNDER_CDMI_WIDEVINE_CONF_OPTS += -DCENC_VERSION=16
endif



$(eval $(cmake-package))
