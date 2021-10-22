################################################################################
#
# thunder-cdmi-widevine-nexus-svp
#
################################################################################

THUNDER_CDMI_WIDEVINE_NEXUS_SVP_VERSION = 88ee2c16e82c6b826e492aa918e25f68e8a61bfb
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_SITE_METHOD = git
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_SITE = https://code.rdkcentral.com/r/soc/broadcom/components/rdkcentral/OCDM-Widevine-Nexus-SVP
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_INSTALL_STAGING = NO
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_DEPENDENCIES = thunder-clientlibraries

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_DEPENDENCIES += bcm-refsw
endif

ifeq ($(BR2_PACKAGE_THUNDER_CDMI_WIDEVINE_NEW_CENC_INTERFACE),y)
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_CONF_OPTS = -DCENC_VERSION=14
endif
ifeq ($(BR2_PACKAGE_BCM_REFSW_SAGE_WIDEVINE_VERSION_16),y)
THUNDER_CDMI_WIDEVINE_NEXUS_SVP_CONF_OPTS += -DCENC_VERSION=16
endif

$(eval $(cmake-package))
