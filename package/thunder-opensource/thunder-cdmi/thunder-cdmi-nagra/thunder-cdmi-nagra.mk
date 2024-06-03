################################################################################
#
# thunder-cdmi-nagra
#
################################################################################

THUNDER_CDMI_NAGRA_VERSION = R1
THUNDER_CDMI_NAGRA_SITE = $(call github,rdkcentral,OCDM-Nagra,$(THUNDER_CDMI_NAGRA_VERSION))
THUNDER_CDMI_NAGRA_INSTALL_STAGING = NO
THUNDER_CDMI_NAGRA_DEPENDENCIES = thunder

$(eval $(cmake-package))
