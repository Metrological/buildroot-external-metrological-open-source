################################################################################
#
# thunder-cdmi-widevine-nexus-svp
#
################################################################################

THUNDER_CDMI_WIDEVINE_NEXUS_SVP_VERSION = R4.2 
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_SITE_METHOD = git
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_SITE = git@github.com:WebPlatformForEmbedded/OCDM-Widevine-Nexus-SVP.git
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_INSTALL_STAGING = NO
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_DEPENDENCIES = thunder-clientlibraries

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_DEPENDENCIES += bcm-refsw
endif

ifeq ($(BR2_PACKAGE_WIDEVINE_VERSION_14),y)
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_CONF_OPTS += -DCENC_VERSION=14
endif
ifeq ($(BR2_PACKAGE_WIDEVINE_VERSION_15),y)
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_CONF_OPTS += -DCENC_VERSION=15
endif
ifeq ($(BR2_PACKAGE_WIDEVINE_VERSION_16),y)
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_CONF_OPTS += -DCENC_VERSION=16
endif

$(eval $(cmake-package))
