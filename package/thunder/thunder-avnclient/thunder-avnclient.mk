################################################################################
#
# thunder-avnclient
#
################################################################################

THUNDER_AVNCLIENT_VERSION = 5728bd779a35036e3a5614cb8dd30327acd5582f
THUNDER_AVNCLIENT_SITE_METHOD = git
THUNDER_AVNCLIENT_SITE = git@github.com:WebPlatformForEmbedded/WPEPluginAVNClient.git
THUNDER_AVNCLIENT_INSTALL_STAGING = YES
THUNDER_AVNCLIENT_DEPENDENCIES = thunder

THUNDER_AVNCLIENT_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_AVNCLIENT_VERSION}

$(eval $(cmake-package))

