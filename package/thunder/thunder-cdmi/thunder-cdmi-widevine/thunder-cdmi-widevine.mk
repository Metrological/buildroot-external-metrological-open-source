################################################################################
#
# thunder-cdmi-widevine
#
################################################################################
THUNDER_CDMI_WIDEVINE_VERSION = 7736fc6ecf696089553258db74a8cb17c8970541
THUNDER_CDMI_WIDEVINE_SITE_METHOD = git
THUNDER_CDMI_WIDEVINE_SITE = git@github.com:rdkcentral/OCDM-Widevine.git
THUNDER_CDMI_WIDEVINE_INSTALL_STAGING = NO
THUNDER_CDMI_WIDEVINE_DEPENDENCIES = thunder-clientlibraries widevine

$(eval $(cmake-package))
