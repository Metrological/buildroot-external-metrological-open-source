################################################################################
#
# thunder-cdmi-clearkey
#
################################################################################
THUNDER_CDMI_CLEARKEY_VERSION = R5.0.0
THUNDER_CDMI_CLEARKEY_SITE = $(call github,rdkcentral,OCDM-Clearkey,$(THUNDER_CDMI_CLEARKEY_VERSION))
THUNDER_CDMI_CLEARKEY_INSTALL_STAGING = YES
THUNDER_CDMI_CLEARKEY_DEPENDENCIES = thunder-clientlibraries libopenssl

$(eval $(cmake-package))
