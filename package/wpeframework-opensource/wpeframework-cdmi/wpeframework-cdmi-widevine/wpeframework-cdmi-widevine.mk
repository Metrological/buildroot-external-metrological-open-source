################################################################################
#
# wpeframework-cdmi-widevine
#
################################################################################
WPEFRAMEWORK_CDMI_WIDEVINE_VERSION = 375d6242c328e44d6dc42f6f423bb601a15d8276
WPEFRAMEWORK_CDMI_WIDEVINE_SITE = $(call github,rdkcentral,OCDM-Widevine,$(WPEFRAMEWORK_CDMI_WIDEVINE_VERSION))
WPEFRAMEWORK_CDMI_WIDEVINE_INSTALL_STAGING = NO
WPEFRAMEWORK_CDMI_WIDEVINE_DEPENDENCIES = wpeframework-clientlibraries widevine


ifeq ($(BR2_PACKAGE_WIDEVINE_VERSION_14),y)
WPEFRAMEWORK_CDMI_WIDEVINE_CONF_OPTS += -DCENC_VERSION=14
endif
ifeq ($(BR2_PACKAGE_WIDEVINE_VERSION_15),y)
WPEFRAMEWORK_CDMI_WIDEVINE_CONF_OPTS += -DCENC_VERSION=15
endif
ifeq ($(BR2_PACKAGE_WIDEVINE_VERSION_16),y)
WPEFRAMEWORK_CDMI_WIDEVINE_CONF_OPTS += -DCENC_VERSION=16
endif



$(eval $(cmake-package))
