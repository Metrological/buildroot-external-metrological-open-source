################################################################################
#
# thunder-switchboard 
#
################################################################################

THUNDER_SWITCHBOARD_VERSION = de050705775c691d44efb26fe5bcdba2593e8bac
THUNDER_SWITCHBOARD_SITE_METHOD = git
THUNDER_SWITCHBOARD_SITE = git@github.com:Metrological/webbridge.git
THUNDER_SWITCHBOARD_INSTALL_STAGING = YES
THUNDER_SWITCHBOARD_DEPENDENCIES = thunder

THUNDER_SWITCHBOARD_CONF_OPTS += -DBUILD_REFERENCE=${THUNDER_SWITCHBOARD_VERSION}

$(eval $(cmake-package))

