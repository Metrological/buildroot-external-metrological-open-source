################################################################################
#
# thunder-cdmi-playready-nexus-svp
#
################################################################################

THUNDER_CDMI_PLAYREADY_NEXUS_SVP_VERSION = d1a32e179acb07993d235d66316190b1ea8b5ebf
THUNDER_CDMI_PLAYREADY_NEXUS_SVP_SITE_METHOD = git
THUNDER_CDMI_PLAYREADY_NEXUS_SVP_SITE = https://code.rdkcentral.com/r/soc/broadcom/components/rdkcentral/OCDM-Playready-Nexus-SVP
THUNDER_CDMI_PLAYREADY_NEXUS_SVP_INSTALL_STAGING = YES
THUNDER_CDMI_PLAYREADY_NEXUS_SVP_DEPENDENCIES = thunder-clientlibraries

ifeq ($(BR2_PACKAGE_BCM_REFSW),y)
THUNDER_CDMI_PLAYREADY_NEXUS_SVP_DEPENDENCIES += bcm-refsw
endif

ifeq ($(BR2_PACKAGE_THUNDER_CDMI_PLAYREADY_NEXUS_SVP_ENABLE),y)
THUNDER_CDMI_PLAYREADY_NEXUS_SVP_CONF_OPTS += -DNEXUS_PLAYREADY_SVP_ENABLE=ON
endif

$(eval $(cmake-package))
