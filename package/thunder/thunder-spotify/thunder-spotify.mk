################################################################################
#
# thunder-spotify
#
################################################################################
THUNDER_SPOTIFY_VERSION = cf5368e41273906b4297af483a5a244e441a4637
THUNDER_SPOTIFY_SITE_METHOD = git
THUNDER_SPOTIFY_SITE = git@github.com:WebPlatformForEmbedded/WPEPluginSpotify.git
THUNDER_SPOTIFY_INSTALL_STAGING = YES
THUNDER_SPOTIFY_DEPENDENCIES = thunder

THUNDER_SPOTIFY_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_SPOTIFY_VERSION}

ifeq ($(BR2_PACKAGE_THUNDER_DEBUG),y)
THUNDER_SPOTIFY_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
endif

define THUNDER_SPOTIFY_POST_TARGET_REMOVE_HEADERS
    rm -rf $(TARGET_DIR)/usr/include/WPEFramework
endef

ifneq ($(BR2_PACKAGE_THUNDER_INSTALL_HEADERS),y)
THUNDER_SPOTIFY_POST_INSTALL_TARGET_HOOKS += THUNDER_SPOTIFY_POST_TARGET_REMOVE_HEADERS
endif

$(eval $(cmake-package))
