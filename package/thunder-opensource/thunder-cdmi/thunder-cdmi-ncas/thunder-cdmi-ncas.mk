################################################################################
#
# thunder-cdmi-ncas
#
################################################################################

THUNDER_CDMI_NCAS_VERSION = 513efac2de49ee3451fd03d900f3084d2b73f7e4
THUNDER_CDMI_NCAS_SITE_METHOD = git
THUNDER_CDMI_NCAS_SITE = git@github.com:WebPlatformForEmbedded/OCDM-NCAS.git
THUNDER_CDMI_NCAS_INSTALL_STAGING = YES
THUNDER_CDMI_NCAS_DEPENDENCIES = thunder

$(eval $(cmake-package))
