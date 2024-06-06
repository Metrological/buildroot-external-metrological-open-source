################################################################################
#
# thunder-cdmi-clearkey
#
################################################################################
THUNDER_CDMI_CLEARKEY_VERSION = 1b3f7e956f4b540242f39ee50f980f10d77ec187
THUNDER_CDMI_CLEARKEY_SITE = $(call github,rdkcentral,OCDM-Clearkey,$(THUNDER_CDMI_CLEARKEY_VERSION))
THUNDER_CDMI_CLEARKEY_INSTALL_STAGING = YES
THUNDER_CDMI_CLEARKEY_DEPENDENCIES = thunder-clientlibraries libopenssl

$(eval $(cmake-package))
