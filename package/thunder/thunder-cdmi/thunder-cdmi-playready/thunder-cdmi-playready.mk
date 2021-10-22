################################################################################
#
# thunder-cdmi-playready
#
################################################################################

ifeq ($(BR2_PACKAGE_PLAYREADY4),y)
THUNDER_CDMI_PLAYREADY_VERSION = a89185d52243c59070fc834aa734a973d2a7b933
else
THUNDER_CDMI_PLAYREADY_VERSION = 59b3deba0710b9f372fd333fcc7aca2ebed483a6
endif

THUNDER_CDMI_PLAYREADY_SITE_METHOD = git
THUNDER_CDMI_PLAYREADY_SITE = git@github.com:rdkcentral/OCDM-Playready.git
THUNDER_CDMI_PLAYREADY_INSTALL_STAGING = YES
THUNDER_CDMI_PLAYREADY_DEPENDENCIES = thunder-clientlibraries
THUNDER_CDMI_PLAYREADY_CONF_OPTS = -DPERSISTENT_PATH=${BR2_PACKAGE_THUNDER_PERSISTENT_PATH}

ifeq ($(BR2_PACKAGE_PLAYREADY4),y)
THUNDER_CDMI_PLAYREADY_DEPENDENCIES += playready4
THUNDER_CDMI_PLAYREADY_CONF_OPTS += -DNETFLIX_EXTENSION=OFF
else
THUNDER_CDMI_PLAYREADY_DEPENDENCIES += playready
THUNDER_CDMI_PLAYREADY_CONF_OPTS += -DNETFLIX_EXTENSION=ON
endif

$(eval $(cmake-package))
