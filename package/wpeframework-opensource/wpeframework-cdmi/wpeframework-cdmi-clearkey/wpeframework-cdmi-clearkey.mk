################################################################################
#
# wpeframework-cdmi-clearkey
#
################################################################################
WPEFRAMEWORK_CDMI_CLEARKEY_VERSION = 39e6690feb0021c0ace930b82d65a9f23263f1f1
WPEFRAMEWORK_CDMI_CLEARKEY_SITE = $(call github,rdkcentral,OCDM-Clearkey,$(WPEFRAMEWORK_CDMI_CLEARKEY_VERSION))
WPEFRAMEWORK_CDMI_CLEARKEY_INSTALL_STAGING = YES
WPEFRAMEWORK_CDMI_CLEARKEY_DEPENDENCIES = wpeframework-clientlibraries libopenssl

$(eval $(cmake-package))
