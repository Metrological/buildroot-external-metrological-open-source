################################################################################
#
# thunder-playgiga
#
################################################################################

THUNDER_PLAYGIGA_VERSION = ec38f5164a927d6885361efb4d4e4365906d17b9
THUNDER_PLAYGIGA_SITE_METHOD = git
THUNDER_PLAYGIGA_SITE = git@github.com:WebPlatformForEmbedded/WPEPluginPlayGiga.git
THUNDER_PLAYGIGA_INSTALL_STAGING = YES
THUNDER_PLAYGIGA_DEPENDENCIES = thunder

THUNDER_PLAYGIGA_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_PLAYGIGA_VERSION}

$(eval $(cmake-package))

