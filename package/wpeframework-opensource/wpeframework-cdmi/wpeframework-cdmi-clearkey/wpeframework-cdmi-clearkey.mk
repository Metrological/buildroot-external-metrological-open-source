################################################################################
#
# wpeframework-cdmi-clearkey
#
################################################################################
WPEFRAMEWORK_CDMI_CLEARKEY_VERSION = 502bf7b26de5b0b5bb65d8c7012c26bcfaa37714
WPEFRAMEWORK_CDMI_CLEARKEY_SITE = $(call github,rdkcentral,OCDM-Clearkey,$(WPEFRAMEWORK_CDMI_CLEARKEY_VERSION))
WPEFRAMEWORK_CDMI_CLEARKEY_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_CLEARKEY_DEPENDENCIES = wpeframework-clientlibraries libopenssl

$(eval $(cmake-package))
