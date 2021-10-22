################################################################################
#
# thunder-cdmi-clearkey
#
################################################################################
THUNDER_CDMI_CLEARKEY_VERSION = 709a3bec04fb722712a3395c9033eb1c9e757e0e
THUNDER_CDMI_CLEARKEY_SITE_METHOD = git
THUNDER_CDMI_CLEARKEY_SITE = git@github.com:rdkcentral/OCDM-Clearkey.git
THUNDER_CDMI_CLEARKEY_INSTALL_STAGING = YES
THUNDER_CDMI_CLEARKEY_DEPENDENCIES = thunder-clientlibraries libopenssl

$(eval $(cmake-package))
