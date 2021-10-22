################################################################################
#
# thunder-cdmi-playready-nexus
#
################################################################################

THUNDER_CDMI_PLAYREADY_NEXUS_VERSION = cdb2e784a03b2d01c03a12d008bf1d9e034f7b62
THUNDER_CDMI_PLAYREADY_NEXUS_SITE_METHOD = git
THUNDER_CDMI_PLAYREADY_NEXUS_SITE = https://code.rdkcentral.com/r/soc/broadcom/components/rdkcentral/OCDM-Playready-Nexus
THUNDER_CDMI_PLAYREADY_NEXUS_INSTALL_STAGING = YES
THUNDER_CDMI_PLAYREADY_NEXUS_DEPENDENCIES = thunder-clientlibraries

ifneq ($(BR2_PACKAGE_BCM_REFSW),)
THUNDER_CDMI_PLAYREADY_NEXUS_DEPENDENCIES += bcm-refsw
endif

$(eval $(cmake-package))
