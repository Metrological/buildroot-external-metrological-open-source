################################################################################
#
# thunder-cdmi-playready-vgdrm 
#
################################################################################

THUNDER_CDMI_PLAYREADY_VGDRM_VERSION = 8d40d8501ebe86726305f72163e4281d6438429a
THUNDER_CDMI_PLAYREADY_VGDRM_SITE_METHOD = git
THUNDER_CDMI_PLAYREADY_VGDRM_SITE = git@github.com:WebPlatformForEmbedded/OCDM-Playready-VGDRM.git
THUNDER_CDMI_PLAYREADY_VGDRM_INSTALL_STAGING = YES
THUNDER_CDMI_PLAYREADY_VGDRM_DEPENDENCIES = thunder vss-sdk

$(eval $(cmake-package))
