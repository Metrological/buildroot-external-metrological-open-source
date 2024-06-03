################################################################################
#
# thunder-cdmi-clearkey
#
################################################################################
THUNDER_CDMI_CLEARKEY_VERSION = 502bf7b26de5b0b5bb65d8c7012c26bcfaa37714
THUNDER_CDMI_CLEARKEY_SITE = $(call github,rdkcentral,OCDM-Clearkey,$(THUNDER_CDMI_CLEARKEY_VERSION))
THUNDER_CDMI_CLEARKEY_INSTALL_STAGING = YES
THUNDER_CDMI_CLEARKEY_DEPENDENCIES = thunder-clientlibraries libopenssl

$(eval $(cmake-package))
