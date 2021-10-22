################################################################################
#
# thunder-cdmi-nagra
#
################################################################################

THUNDER_CDMI_NAGRA_VERSION = R1
THUNDER_CDMI_NAGRA_SITE_METHOD = git
THUNDER_CDMI_NAGRA_SITE = git@github.com:rdkcentral/OCDM-Nagra.git
THUNDER_CDMI_NAGRA_INSTALL_STAGING = NO
THUNDER_CDMI_NAGRA_DEPENDENCIES = thunder

$(eval $(cmake-package))
